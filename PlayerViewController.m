//
//  PlayerViewController.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#define PLAY_SINGLE 1001
#define PLAY_CIRCLE 1002
#define PLAY_RANDOM 1003

#import "PlayerViewController.h"
#import "ViewController.h"

@interface PlayerViewController ()
{
    UIImageView *blurEffectView;
    UIVisualEffectView *visualView;
    UIView *midView;
    UIImageView *coverImageView;
    UISlider *progressSlider;
    UILabel *currentTime;
    UILabel *remainTime;
    UIButton *leftButton;
    UIButton *nextButton;
    UIButton *playButton;
    UIButton *randomBtn;
    UIButton *circleBtn;
}
@end

@implementation PlayerViewController
@synthesize timer,row;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMusic) name:@"didChangeMusic" object:nil];
    
    [self initPlayer];
    [self initBlurEffectView];
    [self initCoverView];
    [self initControlView];
    [self initPlayTypeButton];
    [self refreshPlayer];
}

/**
 *  初始化播放器
 */
- (void)initPlayer {

    if ([PlayerManger shareInstance].currentIndex != row) {
        [PlayerManger shareInstance].currentIndex = row;
        [self playMusic:row];
    }
}

/**
 *  初始化底部视图 模糊特效
 */
- (void)initBlurEffectView {
    blurEffectView = [[UIImageView alloc] init];
    blurEffectView.frame = self.view.frame;
    blurEffectView.image = [PlayerManger shareInstance].musicInfo.artwork;
    [self.view addSubview:blurEffectView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.frame = self.view.frame;
    [blurEffectView addSubview:visualView];
    
    midView = [[UIView alloc] initWithFrame:self.view.frame];
    midView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:midView];
}

/**
 *  初始化歌曲专辑封面视图
 */
- (void)initCoverView {
    coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Width)];
    coverImageView.backgroundColor = [UIColor clearColor];
    coverImageView.image = [UIImage imageNamed:@"default_Ablum"];
    [midView addSubview:coverImageView];
}

/**
 *  初始化 控制器 视图
 */
- (void)initControlView {
    progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(coverImageView.frame) + 20, Screen_Width-80, 20)];
    progressSlider.minimumValue = 0.0;
    progressSlider.maximumValue = [PlayerManger shareInstance].player.duration;
    progressSlider.value = [PlayerManger shareInstance].player.currentTime * progressSlider.maximumValue / [PlayerManger shareInstance].player.duration;
    progressSlider.minimumTrackTintColor = [UIColor blackColor];
    progressSlider.maximumTrackTintColor = [UIColor grayColor];
    [progressSlider setThumbImage:[UIImage imageNamed:@"progress"] forState:UIControlStateNormal];
    [progressSlider trackRectForBounds:CGRectMake(0, 0, 20, 20)];
    [progressSlider addTarget:self action:@selector(changeProgress) forControlEvents:UIControlEventValueChanged];
    [midView addSubview:progressSlider];
    
    if ([PlayerManger shareInstance].playerTimer.isValid) {
        [[PlayerManger shareInstance].playerTimer invalidate];
    }
    [PlayerManger shareInstance].playerTimer = nil;
    [PlayerManger shareInstance].playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressValue:) userInfo:nil repeats:YES];
    
    currentTime = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(progressSlider.frame) + 30, 40, 20)];
    currentTime.font = [UIFont systemFontOfSize:12];
    remainTime.textAlignment = NSTextAlignmentLeft;
    currentTime.textColor = [UIColor blackColor];
    currentTime.text = [self setCurrentTimeLabel];
    [midView addSubview:currentTime];
    
    remainTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progressSlider.frame) - 40, CGRectGetMaxY(progressSlider.frame) + 30, 40, 20)];
    remainTime.font = [UIFont systemFontOfSize:12];
    remainTime.textAlignment = NSTextAlignmentRight;
    remainTime.textColor = [UIColor blackColor];
    remainTime.text = [self setRemainTimeLabel];
    [midView addSubview:remainTime];
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(40, CGRectGetMaxY(currentTime.frame) + 20, 30, 30)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"lastMusic"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
    [midView addSubview:leftButton];
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setFrame:CGRectMake((Screen_Width-40)/2, CGRectGetMaxY(currentTime.frame) + 15, 40, 40)];
    [playButton setBackgroundImage:[UIImage imageNamed:[[PlayerManger shareInstance].player isPlaying] ? @"pause" : @"play"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [midView addSubview:playButton];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(CGRectGetMaxX(progressSlider.frame) - 30, CGRectGetMaxY(currentTime.frame) + 20, 30, 30)];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nextMusic"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [midView addSubview:nextButton];
}

/**
 *  初始化播放模式控制按钮
 */
- (void)initPlayTypeButton {
    randomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    randomBtn.frame = CGRectMake(40, CGRectGetMaxY(leftButton.frame) + 30,  30, 20);
    randomBtn.tag = PLAY_RANDOM;
    randomBtn.layer.masksToBounds = YES;
    randomBtn.layer.cornerRadius = 3;
    [randomBtn setImage:[UIImage imageNamed:@"icon_play_random"] forState:UIControlStateNormal];
    [randomBtn setSelected:[PlayerManger shareInstance].playType == PlayRandom ? YES : NO ];
    [randomBtn addTarget:self action:@selector(playType:) forControlEvents:UIControlEventTouchUpInside];
    [midView addSubview:randomBtn];
    
    circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    circleBtn.frame = CGRectMake(CGRectGetMaxX(progressSlider.frame) - 30, CGRectGetMaxY(leftButton.frame), 30, 20);
    circleBtn.backgroundColor = [UIColor clearColor];
    circleBtn.tag = PLAY_CIRCLE;
    [circleBtn setImage:[UIImage imageNamed:@"icon_play_random"] forState:UIControlStateNormal];
//    [midView addSubview:circleBtn];
}

/**
 *  播放音乐
 *
 *  @param musicIndex 音乐曲目索引
 */
- (void)playMusic:(NSInteger)musicIndex {
    
    [[PlayerManger shareInstance] playWithIndex:musicIndex];
}

/**
 *  刷新视图显示
 */
- (void)refreshPlayer {
    
    progressSlider.maximumValue = [PlayerManger shareInstance].player.duration;
    blurEffectView.image = [PlayerManger shareInstance].musicInfo.artwork;
    self.title = [NSString stringWithFormat:@"%@",[PlayerManger shareInstance].musicInfo.title];
    coverImageView.image = [PlayerManger shareInstance].musicInfo.artwork;
    if (randomBtn.isSelected) {
        [randomBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    }
    else {
        [randomBtn setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - ButtonAction

/**
 *  拖动进度条，选取播放时间
 */
- (void)changeProgress {
    [[PlayerManger shareInstance] pauseMusic];
    [PlayerManger shareInstance].player.currentTime = progressSlider.value;
    [[PlayerManger shareInstance] playMusic];
}

/**
 *  监听进度条值的改变
 */
- (void)progressValue:(NSTimer *)time {
    
    progressSlider.value = [PlayerManger shareInstance].player.currentTime;
    
    if (progressSlider.value > [PlayerManger shareInstance].player.duration - 1) {
        [self next];
    }
    
    [self setCurrentTimeLabel];
    [self setRemainTimeLabel];
    
    if ([PlayerManger shareInstance].player.playing == YES) {
        [playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else {
        [playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}
/**
 *  设置当前时间显示Label
 */
- (NSString *)setCurrentTimeLabel {
    
    if ((int)[PlayerManger shareInstance].player.currentTime % 60 < 10) {
        currentTime.text = [NSString stringWithFormat:@"%0d:0%d",(int)[PlayerManger shareInstance].player.currentTime / 60, (int)[PlayerManger shareInstance].player.currentTime % 60];
    } else {
        currentTime.text = [NSString stringWithFormat:@"%d:%d",(int)[PlayerManger shareInstance].player.currentTime / 60, (int)[PlayerManger shareInstance].player.currentTime % 60];
    }
    return currentTime.text;
}
/**
 *  设置剩余时间显示Label
 */
- (NSString *)setRemainTimeLabel {
    
    if ((int)([PlayerManger shareInstance].player.duration - [PlayerManger shareInstance].player.currentTime) % 60 < 10) {
        remainTime.text = [NSString stringWithFormat:@"-%d:0%d",(int)([PlayerManger shareInstance].player.duration - [PlayerManger shareInstance].player.currentTime) / 60, (int)([PlayerManger shareInstance].player.duration - [PlayerManger shareInstance].player.currentTime) % 60];
    } else {
        remainTime.text = [NSString stringWithFormat:@"-%d:%d",(int)([PlayerManger shareInstance].player.duration - [PlayerManger shareInstance].player.currentTime) / 60, (int)([PlayerManger shareInstance].player.duration - [PlayerManger shareInstance].player.currentTime) % 60];
    }
    return remainTime.text;
}

/**
 *  播放
 */
- (void)play {
    
    if ([[PlayerManger shareInstance].player isPlaying]) {
        [[PlayerManger shareInstance] pauseMusic];
        [playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else {
        [[PlayerManger shareInstance] playMusic];
        [playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

/**
 *  上一曲
 */
- (void)last {
    [[PlayerManger shareInstance] lastMusic];
    [self refreshPlayer];
}

/**
 *  下一曲
 */
- (void)next {
    [[PlayerManger shareInstance] nextMusic];
    [self refreshPlayer];
}
/**
 *  <#Description#>
 */
- (void)didChangeMusic {
    [self refreshPlayer];
}

/**
 *  播放模式
 *
 *  @param button 点选模式按钮  PlayType
 */
- (void)playType:(UIButton *)button {
    if (button.tag == PLAY_RANDOM) {
        if (button.isSelected) {
            [button setSelected:NO];
            [button setBackgroundColor:[UIColor clearColor]];
            [PlayerManger shareInstance].playType = PlayCircle;
        }
        else {
            [button setSelected:YES];
            [button setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
            [PlayerManger shareInstance].playType = PlayRandom;
        }
    }
    else if (button.tag == PLAY_CIRCLE) {
        [PlayerManger shareInstance].playType = PlayCircle;
    }
}

@end
//
//  PlayerManger.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import "PlayerManger.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@implementation PlayerManger
@synthesize player,musicArray,currentIndex,closeTime,closeTimer,musicInfo,playType;
static id _instace;

+ (void)initialize
{
    // 音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 设置会话类型（播放类型、播放模式,会自动停止其他音乐的播放）
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 激活会话
    [session setActive:YES error:nil];
}

+ (PlayerManger *)shareInstance {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace=[[self alloc]init];
    });
    return _instace;
}

-(id)init
{
    static id obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj=[super init];
        if (obj != nil) {
            musicArray = [NSMutableArray arrayWithCapacity:50];
            currentIndex = -1;
        }
    });
    self=obj;
    
    return self;
}

- (void)playWithIndex:(NSInteger)musicIndex {
    if (player) {
        [self setPlayer:nil];
    }
    
    //用 fileURLWithPath  而不是 urlWithString ，否则有些歌曲无法播放
    NSURL *url = [NSURL fileURLWithPath:[Common getUrlString:musicIndex]];
    NSError *outError = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&outError];
    [player play];

    [self getMusicInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangeMusic" object:nil];
    [self setNowPlayingInfoCenter];
}

- (void)playMusic {
    [player play];
}

- (void)pauseMusic {
    [player pause];
}

- (void)stopMusic {
    [player stop];
}

- (void)lastMusic {
    
    if (currentIndex > 0) {
        currentIndex --;
    }
    else {
        currentIndex = musicArray.count-1;
    }
    [self playWithIndex:currentIndex];
}

- (void)nextMusic {
    
    switch (playType) {
        case PlayCircle:
            [self playCircle];
            break;
        case PlayRandom:
            [self playRandom];
            break;
        default:
            [self playCircle];
            break;
    }
}

- (void)playCircle {
    if (currentIndex < musicArray.count - 1) {
        currentIndex ++;
    }
    else {
        currentIndex = 0;
    }
    [self playWithIndex:currentIndex];
}

- (void)playRandom {
    currentIndex = (NSInteger)arc4random() % musicArray.count;
    [self playWithIndex:currentIndex];
}

/**
 *  获取歌曲对象
 */
-(void)getMusicInfo
{
    musicInfo = [musicArray objectAtIndex:currentIndex];
}

/**
 *  向系统发送正在播放音乐详情
 */
- (void)setNowPlayingInfoCenter {
    
    NSMutableDictionary *songInfoDic = [[NSMutableDictionary alloc] init];
    
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:musicInfo.artwork];
    [songInfoDic setObject:artWork forKey:MPMediaItemPropertyArtwork];
    [songInfoDic setObject:musicInfo.artist forKey:MPMediaItemPropertyArtist];
    [songInfoDic setObject:musicInfo.title forKey:MPMediaItemPropertyTitle];
    [songInfoDic setObject:musicInfo.albumName forKey:MPMediaItemPropertyAlbumTitle];
    [songInfoDic setObject:[NSString stringWithFormat:@"%f",player.currentTime] forKey:MPMediaItemPropertyBookmarkTime];
    [songInfoDic setObject:[NSString stringWithFormat:@"%f",player.duration] forKey:MPMediaItemPropertyPlaybackDuration];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfoDic];
    NSLog(@"nowPlayingInfo:%@",[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo);
}

@end

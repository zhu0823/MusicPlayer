//
//  PlayerManger.h
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MusicInfo.h"

typedef enum : NSUInteger {
    PlayCircle = 0,     // 顺序播放
    PlaySingle = 1,     // 单曲循环
    PlayRandom = 2,     // 随机播放
} PlayType;

@interface PlayerManger : UIViewController

/**
 *  播放器
 */
@property (nonatomic, strong) AVAudioPlayer *player;
/**
 *  所有音乐
 */
@property (nonatomic, strong) NSMutableArray *musicArray;
/**
 *  当前歌曲索引
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  定时关机时间
 */
@property (nonatomic, assign) NSInteger closeTime;
/**
 *  播放器定时器
 */
@property (nonatomic, strong) NSTimer *playerTimer;
/**
 *  关机定时器
 */
@property (nonatomic, strong) NSTimer *closeTimer;
/**
 *  歌曲列表索引  // 待完善
 */
@property (nonatomic, strong) NSArray *firstCharIndex;
/**
 *  歌曲信息
 */
@property (nonatomic, strong) MusicInfo *musicInfo;
/**
 *  播放模式
 */
@property (nonatomic, assign) PlayType playType;
/**
 *  持有单类
 *
 *  @return 单类对象
 */
+ (PlayerManger *)shareInstance;

/**
 *  创建player并开始播放
 *
 *  @prame 曲目索引
 */
- (void)playWithIndex:(NSInteger)musicIndex;

/**
 *  播放
 */
- (void)playMusic;

/**
 *  暂停
 */
- (void)pauseMusic;

/**
 *  停止
 */
- (void)stopMusic;

/**
 *  上一曲
 */
- (void)lastMusic;

/**
 *  下一曲
 */
- (void)nextMusic;

@end

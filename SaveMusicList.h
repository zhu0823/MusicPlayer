//
//  SaveMusicList.h
//  MusicPlayer
//
//  Created by 至尊 on 15/12/30.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MusicInfo.h"

@interface SaveMusicList : NSObject

+ (NSArray *)saveMusicList;

@end

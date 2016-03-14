//
//  Common.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import "Common.h"

@implementation Common
+ (NSString *)getUrlString:(NSInteger)musicIndex {
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    MusicInfo *musicInfo = [[PlayerManger shareInstance].musicArray objectAtIndex:musicIndex];
    
    return [[NSBundle bundleWithPath:documentDir] pathForResource:musicInfo.fileName ofType:musicInfo.type];
}

+ (NSString *)getCloseTime:(NSInteger)seconds {

    NSInteger minute = seconds / 60;
    NSInteger second = seconds % 60;
    
    NSString *minuteStr = [NSString stringWithFormat:@"%ld",minute];
    NSString *secondStr = [NSString stringWithFormat:@"%ld",second];
    
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld",minute];
    }
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%ld",second];
    }
    return [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
}
@end

//
//  Common.h
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerManger.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

#define RGBColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define Close_Time @"定时关机"

#define Close_Time_detail @"由于技术限制,开启定时关机后要保持当前页面,否则定时失效。"

@interface Common : NSObject

+ (NSString *)getUrlString:(NSInteger)musicIndex;

+ (NSString *)getCloseTime:(NSInteger)minute;

@end

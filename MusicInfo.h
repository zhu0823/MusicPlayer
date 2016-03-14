//
//  MusicInfo.h
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MusicInfo : NSObject <NSCoding>

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *firstCharacter;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *albumName;
@property (nonatomic, strong) UIImage *artwork;
@property (nonatomic, strong) NSString *type;

@end

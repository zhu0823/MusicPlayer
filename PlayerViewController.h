//
//  PlayerViewController.h
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerManger.h"
#import "MusicInfo.h"

@interface PlayerViewController : UIViewController

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger row;

@end

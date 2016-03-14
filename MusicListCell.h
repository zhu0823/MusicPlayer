//
//  MusicListCell.h
//  MusicPlayer
//
//  Created by 至尊 on 16/1/6.
//  Copyright © 2016年 至尊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *artWork;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *artist;
@property (strong, nonatomic) IBOutlet UIImageView *nowPlaying;

@end

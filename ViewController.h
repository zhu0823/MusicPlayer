//
//  ViewController.h
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *musicListTableView;

@end


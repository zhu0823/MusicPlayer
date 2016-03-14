//
//  SetViewController.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/14.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import "SetViewController.h"
#import "SetCloseTime.h"
#import "Common.h"
#import "SetCloseTimeViewController.h"
#import "AboutViewController.h"

@interface SetViewController ()
{
    UITableView *setTableView;
}
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(234, 234, 234, 1);
    self.title = @"设置";
    
    [self initSetTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [setTableView reloadData];
    if ([PlayerManger shareInstance].closeTime > 0) {
        [self runCloseTime];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[PlayerManger shareInstance].closeTimer invalidate];
    [PlayerManger shareInstance].closeTimer = nil;
}

- (void)initSetTableView {
    setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
    setTableView.backgroundColor = [UIColor clearColor];
    setTableView.dataSource = self;
    setTableView.delegate = self;
    [self.view addSubview:setTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self getSetCloseTimeCell:tableView indexPath:indexPath];
    }
    else if (indexPath.section == 1) {
        return [self getAboutSoftwareCell:tableView indexPath:indexPath];
    }
    else
        return nil;
}
/**
 *  定时关机cell
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (SetCloseTime *)getSetCloseTimeCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SetCloseTime";
    SetCloseTime *setCloseTimeCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (setCloseTimeCell == nil) {
        setCloseTimeCell = [[[NSBundle mainBundle] loadNibNamed:@"SetCloseTime" owner:self options:nil] lastObject];
    }
    setCloseTimeCell.title.text = @"定时关机";
    if ([PlayerManger shareInstance].closeTime > 0) {
        setCloseTimeCell.subTitle.hidden = NO;
        setCloseTimeCell.subTitle.text = [Common getCloseTime:[PlayerManger shareInstance].closeTime];
    }
    else {
        setCloseTimeCell.subTitle.hidden = YES;
    }
    return setCloseTimeCell;
}

- (UITableViewCell *)getAboutSoftwareCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AboutSoftwareCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"关于软件";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Screen_Width-20, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = Close_Time_detail;
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        [view addSubview:label];
        return view;
    };
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        SetCloseTimeViewController *setCloseTimeVC = [[SetCloseTimeViewController alloc] init];
        [self.navigationController pushViewController:setCloseTimeVC animated:YES];
    }
    else if (indexPath.section == 1) {
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (void)runCloseTime {
    
    if (![PlayerManger shareInstance].closeTimer) {
        
        [PlayerManger shareInstance].closeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableView) userInfo:nil repeats:YES];
    }
    else {
        [PlayerManger shareInstance].closeTimer.fireDate = [NSDate distantPast];
    }
}

- (void)reloadTableView {
    if ([PlayerManger shareInstance].closeTime == 0) {
        [[PlayerManger shareInstance].closeTimer invalidate];
        [PlayerManger shareInstance].closeTimer = nil;
        [[PlayerManger shareInstance] stopMusic];
    }
    else {
        [PlayerManger shareInstance].closeTime --;
        [setTableView reloadData];
    }
}
@end

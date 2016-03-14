//
//  SetCloseTimeViewController.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/14.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import "SetCloseTimeViewController.h"
#import "Common.h"

@interface SetCloseTimeViewController ()
{
    UIPickerView *datepicker;
    NSInteger second;
}
@end

@implementation SetCloseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定时关机";
    self.view.backgroundColor = [UIColor whiteColor];

    [self initPickView];
    [self initNavigationRightBarButton];
}

- (void)initPickView {
    datepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, 250)];
    datepicker.delegate = self;
    datepicker.dataSource = self;
    [self.view addSubview:datepicker];
}


- (void)initNavigationRightBarButton {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectTimeDone)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)selectTimeDone {
    if ([PlayerManger shareInstance].closeTimer.isValid) {
        [[PlayerManger shareInstance].closeTimer invalidate];
    }
    [PlayerManger shareInstance].closeTimer = nil;
    [PlayerManger shareInstance].closeTime = second;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 7;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld",row * 10];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    second = row * 10 * 60;
}

@end

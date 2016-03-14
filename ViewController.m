//
//  ViewController.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import "ViewController.h"
#import "Common.h"
#import "SetViewController.h"
#import "PlayerViewController.h"
#import "PlayerManger.h"
#import "SaveMusicList.h"
#import "MusicListCell.h"

@interface ViewController ()
{
    UIView *playingView;
    UIImageView *artwork;
    UILabel *title;
    UILabel *album;
    UIButton *pushButton;
    UIButton *playButton;
}
@end

@implementation ViewController

@synthesize musicListTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有歌曲";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMusic) name:@"didChangeMusic" object:nil];
    
    [self initMusicList];
    [self initNavigationLeftBarButton];
    [self initNavigationRightBarButton];
    [self initPlayingView];
    [self refreshMusicList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PlayerManger shareInstance].player) {
        playingView.hidden = NO;
        [musicListTableView setFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-60)];
        [self setPlayingView];
    }
    else {
        [musicListTableView setFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        playingView.hidden = YES;
    }
}

/**
 *  初始化音乐列表
 */
- (void)initMusicList {
    musicListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
    musicListTableView.backgroundColor = [UIColor whiteColor];
    musicListTableView.dataSource = self;
    musicListTableView.delegate = self;
    musicListTableView.hidden = YES;
    [self.view addSubview:musicListTableView];
}

/**
 *  初始化导航栏左边图标按钮
 */
- (void)initNavigationLeftBarButton {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshMusicList)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

/**
 *  初始化导航栏右边图标按钮
 */
- (void)initNavigationRightBarButton {
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 50, 50)];
    view.image = [UIImage imageNamed:@"set"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:view];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 *  初始化底部正在播放音乐视图
 */
- (void)initPlayingView {
    playingView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - 60, Screen_Width, 60)];
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 1)];
    topLine.backgroundColor = [UIColor grayColor];
    [playingView addSubview:topLine];
    
    artwork = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
    [playingView addSubview:artwork];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 210, 25)];
    title.font = [UIFont systemFontOfSize:14.0f];
    [playingView addSubview:title];
    
    album = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 210, 15)];
    album.font = [UIFont systemFontOfSize:10.0f];
    [playingView addSubview:album];
    
    pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame = CGRectMake(0, 0, Screen_Width-40, 60);
    pushButton.backgroundColor = [UIColor clearColor];
    [pushButton addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [playingView addSubview:pushButton];
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(Screen_Width -50, 15, 30, 30);
    [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [playingView addSubview:playButton];
    
    [self.view addSubview:playingView];
}

/**
 *  设置底部正在播放音乐视图信息
 */
- (void)setPlayingView {
    artwork.image = [PlayerManger shareInstance].musicInfo.artwork;
    title.text = [PlayerManger shareInstance].musicInfo.title;
    album.text = [NSString stringWithFormat:@"%@--%@",[PlayerManger shareInstance].musicInfo.artist,[PlayerManger shareInstance].musicInfo.albumName];
    if ([[PlayerManger shareInstance].player isPlaying]) {
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    else {
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

/**
 *  playerViewController 的 delegate 用于处于非活动状态刷新正在播放音乐视图信息
 */
- (void)didChangeMusic {
    [self setPlayingView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [PlayerManger shareInstance].musicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicInfo *musicInfo  = [[PlayerManger shareInstance].musicArray objectAtIndex:indexPath.row];
    static NSString *identifier = @"MusicListCell";
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MusicListCell" owner:self options:nil] lastObject];
    }
    cell.artWork.image = musicInfo.artwork;
    cell.title.text = musicInfo.title;
    cell.artist.text = musicInfo.artist;
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 30)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((Screen_Width-200)/2, 0, 200, 30)];
    label.text = [NSString stringWithFormat:@"%ld首歌曲",[PlayerManger shareInstance].musicArray.count];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [musicListTableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayerViewController *playerVC = [[PlayerViewController alloc] initWithNibName:nil bundle:nil];
    playerVC.row = indexPath.row;
    [self.navigationController pushViewController:playerVC animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self DeleteMusic:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark - ButtonAction

/**
 *  跳转设置界面
 */
- (void)setAction {
    SetViewController *setVC = [[SetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}
/**
 *  跳转到播放音乐主界面
 */
- (void)pushAction {
    PlayerViewController *playerVC = [[PlayerViewController alloc] init];
    playerVC.row = [PlayerManger shareInstance].currentIndex;
    [self.navigationController pushViewController:playerVC animated:YES];
}
/**
 *  底部播放、暂停播放按钮事件
 */
- (void)playAction {
    if ([[PlayerManger shareInstance].player isPlaying]) {
        [[PlayerManger shareInstance] pauseMusic];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else {
        [[PlayerManger shareInstance] playMusic];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}
/**
 *  刷新歌曲列表
 */
- (void)refreshMusicList {

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake((Screen_Width-80)/2, (Screen_Height-80)/2, 80, 80);
    indicator.backgroundColor = [UIColor grayColor];
    indicator.layer.cornerRadius = 5;
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [PlayerManger shareInstance].musicArray = [[SaveMusicList saveMusicList] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [musicListTableView reloadData];
            musicListTableView.hidden = NO;
            [indicator stopAnimating];
        });
    });
    

}

- (void)DeleteMusic:(NSIndexPath *)indexPath {
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:@"欧巴~真的不要人家了嘛" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleaction = [UIAlertAction actionWithTitle:@"怎么会呢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"给老子滚" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MusicInfo *musicInfo = [[PlayerManger shareInstance].musicArray objectAtIndex:indexPath.row];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //在这里获取应用程序Documents文件夹里的文件及文件夹列表
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [documentPaths objectAtIndex:0];
        NSString *file = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",musicInfo.fileName,musicInfo.type]];
        NSError *error = nil;
        [fileManager removeItemAtPath:file error:&error];
        if (error == nil) {
            
            [[PlayerManger shareInstance].musicArray removeObjectAtIndex:indexPath.row];
        }
        [musicListTableView reloadData];
    }];
    [alertCtr addAction:cancleaction];
    [alertCtr addAction:enterAction];
    [self presentViewController:alertCtr animated:YES completion:nil];
}

@end

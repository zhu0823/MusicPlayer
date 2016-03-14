//
//  AppDelegate.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/11.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import "AppDelegate.h"
#import "Common.h"
#import "ViewController.h"
#import "SaveMusicList.h"
#import "PlayerManger.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
        
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    
    [self.window setRootViewController:navigationController];
    return YES;
}

/**
 *  线控、控制中心 控制音乐播放
 *
 *  @param event 控制事件
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [[PlayerManger shareInstance] playMusic];
                break;
            case UIEventSubtypeRemoteControlPause:
                [[PlayerManger shareInstance] pauseMusic];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[PlayerManger shareInstance] nextMusic];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if ([[PlayerManger shareInstance].player isPlaying]) {
                    [[PlayerManger shareInstance] pauseMusic];
                }
                else {
                    [[PlayerManger shareInstance] playMusic];
                }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[PlayerManger shareInstance] lastMusic];
                break;
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

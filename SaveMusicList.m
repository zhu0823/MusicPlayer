//
//  SaveMusicList.m
//  MusicPlayer
//
//  Created by 至尊 on 15/12/30.
//  Copyright © 2015年 至尊. All rights reserved.
//

#import "SaveMusicList.h"

@implementation SaveMusicList

/**
 *  保存所有歌曲
 *
 *  @return 所有歌曲数组
 */
- (NSArray *)saveMusicList {
    
    NSMutableArray *musicArray = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    for (NSString *musicStr in fileList) {
        
        NSArray *array = [musicStr componentsSeparatedByString:@"."];
        NSMutableString *musicName = [[NSMutableString alloc] init];
        NSString *musicType = [NSString string];
        
        [musicName appendString:[array firstObject]];
        musicType = [array lastObject];
        if (array.count != 2) {
            
            for (int i = 1; i < array.count - 1; i ++) {
                
                [musicName appendFormat:@".%@",[array objectAtIndex:i]];
            }
        }
        NSString *urlString = [[NSBundle bundleWithPath:documentDir] pathForResource:musicName ofType:musicType];
        NSURL *fileUrl = [NSURL fileURLWithPath:urlString];
        MusicInfo *musicInfo = [self getMp3Information:fileUrl withFileName:musicName withType:musicType];
        [musicArray addObject:musicInfo];
        musicInfo = nil;
    }
    // 由小到大排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pinyin" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [musicArray sortUsingDescriptors:sortDescriptors];
    return musicArray;
}

/**
 *  获取歌曲详情
 *
 *  @param fileUrl  文件地址
 *  @param fileName 文件名
 *  @param type     文件类型
 *
 *  @return MusicInfo
 */
- (MusicInfo *)getMp3Information:(NSURL *)fileUrl withFileName:(NSString *)fileName withType:(NSString *)type {
    
    MusicInfo *musicInfo = [[MusicInfo alloc] init];

    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        
        for (AVMetadataItem *metadataitem in [mp3Asset metadataForFormat:format]) {
            
            if ([metadataitem.commonKey isEqualToString:@"artwork"]) {
                
                NSData *data = (NSData *)metadataitem.value;
                UIImage *image = [UIImage imageWithData:data];
                musicInfo.artwork = image;
            }
            else if([metadataitem.commonKey isEqualToString:@"title"])
            {
                NSString *title = (NSString *)metadataitem.value;
                musicInfo.title = title;
            }
            else if([metadataitem.commonKey isEqualToString:@"artist"])
            {
                NSString *artist = (NSString *)metadataitem.value;
                musicInfo.artist = artist;
            }
            else if([metadataitem.commonKey isEqualToString:@"albumName"])
            {
                NSString *albumName = (NSString *)metadataitem.value;
                musicInfo.albumName = albumName;
            }
        }
        
    }
    
    musicInfo.artwork = musicInfo.artwork ? musicInfo.artwork : [UIImage imageNamed:@"default_Ablum.jpg"];
    musicInfo.title = musicInfo.title ? musicInfo.title : @"未知歌曲";
    NSArray *array = [self getMusicPinyin:musicInfo.title];
    musicInfo.pinyin = [array firstObject];
    musicInfo.firstCharacter = [array lastObject];
    musicInfo.artist = musicInfo.artist ? musicInfo.artist : @"未知歌手";
    musicInfo.albumName = musicInfo.albumName ? musicInfo.albumName : @"未知专辑";
    musicInfo.fileName = fileName;
    musicInfo.type = type;
    return musicInfo;
}
/**
 *  音乐标题排序
 *
 *  @param title 排序前标题
 *
 *  @return 排序后标题
 */
- (NSArray *)getMusicPinyin:(NSString *)title {
    
    NSMutableString *ms = [[NSMutableString alloc] initWithString:title];
    NSMutableString *pinyin = [[NSMutableString alloc] init];
    NSString *firstCharacter = [NSString string];
    
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO) &&
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        NSArray *pinyinArray = [ms componentsSeparatedByString:@" "];
        for (NSString *str in pinyinArray) {
            if (str.length > 0) {
                [pinyin appendString:[[str substringToIndex:1] uppercaseString]];
            }
        }
        firstCharacter = [pinyin substringToIndex:1];
    }
    return [NSArray arrayWithObjects:pinyin, firstCharacter, nil];
}

@end

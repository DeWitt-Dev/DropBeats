//
//  DPMusicFolder.m
//  dropBeats
//
//  Created by Spencer Lewson on 1/2/14.
//  Copyright (c) 2014 Michael Dewitt. All rights reserved.
//

#import "DPMusicFolder.h"
#import "DPSong.h"

@implementation DPMusicFolder

static NSMutableArray *songs;

+ (DPSong*) getSongByTitle: (NSString*) title {
    for (DPSong* s in [self getSongs]) {
        if ([[s title] isEqualToString: title]) {
            return s;
        }
    }
    return nil;
}

+ (DPSong*) getSongByNumber: (NSInteger) level {
    for (DPSong* s in [self getSongs]) {
        if (s.level == level) {
            return s;
        }
    }
    return nil;
}

+(NSUInteger) numberOfSongs
{
    return [[self getSongs] count];
}
+ (void) addSong: (DPSong*) song {
    [[self getSongs] addObject: song];
}

+ (void) addSongJsonData: (NSMutableDictionary*) songData {
    //NSLog([songData description]);
    DPSong* song = [[DPSong alloc] initWithJsonData: songData];
    //[song printSong];
    [self addSong: song];
}

+ (NSMutableArray*) getSongs {
    if (!songs) {
        songs = [DPMusicFolder loadSongs];
    }
    return songs;
}

+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"DPMusicFolderData.plist"];
}

+ (NSMutableArray *)loadSongs
{
    NSMutableArray *array;
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        array = [unarchiver decodeObjectForKey:@"songs"];
        [unarchiver finishDecoding];
    } else {
        array = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
//    NSLog(@"loadSongs");
//    if ([array count] > 0) {
//      NSLog(@"%@", [array description]);
//        NSLog(@"---");
//        [[array objectAtIndex:0] printSong];
//        NSLog(@"---");
//    }
    
    return array;
}

+ (void)saveSongs
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[self getSongs] forKey:@"songs"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

@end

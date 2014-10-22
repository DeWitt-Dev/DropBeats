//
//  DPMusicFolder.h
//  dropBeats
//
//  Created by Spencer Lewson on 1/2/14.
//  Copyright (c) 2014 Michael Dewitt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPSong.h"

@interface DPMusicFolder : NSObject

+ (DPSong*) getSongByTitle: (NSString*) title;
+ (DPSong*) getSongByNumber: (NSInteger) level;

+(NSUInteger) numberOfSongs;

+ (void) addSong: (DPSong*) song;
+ (void) addSongJsonData: (NSMutableDictionary*) songData;

+ (void) saveSongs;
//+ (void) updateSongs;

@end

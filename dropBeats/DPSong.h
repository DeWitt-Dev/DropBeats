//
//  DPSong.h
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPNote.h"

@interface DPSong : NSObject

@property (nonatomic) float duration;

+ (DPSong*) getSong: (int) index andDuration: (float) duration;
+(int)numberOfSongs;

- (NSArray*) getNotes;

+ (instancetype) song;
//+ (instancetype) songFromNotes: (NSMutableArray*) notesArray;
- (void) addNote: (DPNote*) note;
- (DPNote*) getNote: (NSInteger) index;
-(void)clearNotes;

@end

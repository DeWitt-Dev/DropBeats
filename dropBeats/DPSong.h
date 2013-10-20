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

+ (instancetype) song;
+ (instancetype) songFromNotes: (NSMutableArray*) notesArray;
- (void) addNote: (DPNote*) note;
- (DPNote*) getNote: (NSInteger) index;
- (NSMutableArray*) getNotes;
- (NSInteger) duration;
- (DPSong*) getSampleSong: (NSInteger) song;


@end

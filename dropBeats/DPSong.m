//
//  DPSong.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPSong.h"
#import "DPNote.h"

@implementation DPSong

NSMutableArray* notes;

+ (instancetype) songFromNotes: (NSMutableArray*) notesArray
{
    [self song];
    notes = notesArray;
    
    return [self alloc];
}

+ (instancetype) song
{
    return [[self alloc] init];
}

- (id) init
{
    notes = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) addNote: (DPNote*) note
{
    [notes addObject:note];
}

- (DPNote*) getNote: (NSInteger) index
{
    return [notes objectAtIndex:index];
}

- (NSMutableArray*) getNotes
{
    return notes;
}

- (float) duration
{
    int index = [notes count] - 1;
    DPNote* note = [notes objectAtIndex:index];
    return 5.0;
}

- (DPSong*) getSampleSong: (NSInteger) song
{
    notes = song ? [self getSong] : [self getSong2];
    
    return self;
}

- (NSMutableArray*) getSong
{
    NSMutableArray* song = [[NSMutableArray alloc] initWithCapacity:10];
    
    [song addObject: [DPNote DPNoteWithTime:0.1 freq:0 type:kCymbol tolerance:0.1]];
    [song addObject: [DPNote DPNoteWithTime:0.3 freq:0 type:kCymbol tolerance:0.2]];
    [song addObject: [DPNote DPNoteWithTime:0.4 freq:0 type:kCymbol tolerance:0.4]];
    [song addObject: [DPNote DPNoteWithTime:0.7 freq:0 type:kCymbol tolerance:0.5]];
    [song addObject: [DPNote DPNoteWithTime:0.8 freq:0 type:kCymbol tolerance:0.6]];

    return song;
}

- (NSMutableArray*) getSong2
{
    NSMutableArray* song = [[NSMutableArray alloc] initWithCapacity:10];
    
    [song addObject: [DPNote DPNoteWithTime:0.1 freq:0 type:kCymbol tolerance:0.1]];
    [song addObject: [DPNote DPNoteWithTime:0.5 freq:1 type:kSnare tolerance:0.1]];
    [song addObject: [DPNote DPNoteWithTime:0.8 freq:2 type:kSnare tolerance:0.1]];
    
    return song;
}



@end

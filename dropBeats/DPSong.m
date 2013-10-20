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
    
    return self;
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

- (NSInteger) duration
{
    int index = [notes count] - 1;
    DPNote* note = [notes objectAtIndex:index];
    return [note time];
}

- (DPSong*) getSampleSong: (NSInteger) song
{
    notes = song ? [self getSong] : [self getSong2];
    
    return self;
}

- (NSMutableArray*) getSong
{
    NSMutableArray* song = [[NSMutableArray alloc] initWithCapacity:10];
    
    [song addObject:[[DPNote alloc] initWithTime:1 freq:0 type:kSnare]];
    [song addObject:[[DPNote alloc] initWithTime:4 freq:0 type:kBass]];
    [song addObject:[[DPNote alloc] initWithTime:6 freq:0 type:kGuitar]];
    [song addObject:[[DPNote alloc] initWithTime:8 freq:0 type:kCymbol]];
    [song addObject:[[DPNote alloc] initWithTime:13 freq:0 type:kSnare]];
    
    return song;
}

- (NSMutableArray*) getSong2
{
    NSMutableArray* song = [[NSMutableArray alloc] initWithCapacity:10];
    
    [song addObject:[[DPNote alloc] initWithTime:2 freq:0 type:kSnare]];
    [song addObject:[[DPNote alloc] initWithTime:4 freq:0 type:kBass]];
    [song addObject:[[DPNote alloc] initWithTime:7 freq:0 type:kGuitar]];
    [song addObject:[[DPNote alloc] initWithTime:10 freq:0 type:kCymbol]];
    [song addObject:[[DPNote alloc] initWithTime:12 freq:0 type:kSnare]];
    
    return song;
}



@end

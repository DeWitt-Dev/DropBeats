//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNote.h"

@implementation DPNote

+ (instancetype) DPNoteWithTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type tolerance: (float) tolerance;
{
    return [[self alloc] initWithTime: time freq:freq type:type tolerance:tolerance played: Nil];
}

+ (instancetype) DPNoteWithPlayed: (NSDate*) played freq: (FrequencyRange) freq type: (NoteType) type tolerance: (float) tolerance
{
    return [[self alloc] initWithTime:0.0 freq:freq type:type tolerance:tolerance played: played];
}

- (id) initWithTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type tolerance: (float) tolerance played:(NSDate *)played
{
    self = [super init];
    self.time = time;
    self.freq = freq;
    self.type = type;
    self.tolerance = tolerance;
    self.played = played;
    
    return self;
}

@end

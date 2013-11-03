//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNote.h"

@implementation DPNote

+ (instancetype) DPNoteAtTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type
{
    return [[self alloc] initAtTime: time freq:freq type:type];
}

- (id) initAtTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type
{
    self = [super init];
    self.time = time;
    self.freq = freq;
    self.type = type;
    
    return self;
}

@end

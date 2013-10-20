//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNote.h"

@implementation DPNote

+ (instancetype) DPNoteWithTime: (NSInteger) time freq: (NSInteger) freq type: (NoteType) type
{
    return [[self alloc] initWithTime: time freq: freq type: type];
}

- (id) initWithTime: (NSInteger) time freq: (NSInteger) freq type: (NoteType) type
{
    self = [super init];
    self.time = time;
    self.freq = freq;
    self.type = type;
    
    return self;
}

@end

//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNote.h"

@implementation DPNote

+ (instancetype) DPNoteWithTime: (float) time freq: (NSInteger) freq type: (NoteType) type tolerance: (float) tolerance
{
    return [[self alloc] initWithTime: time freq:freq type:type tolerance:tolerance];
}

- (id) initWithTime: (float) time freq: (NSInteger) freq type: (NoteType) type tolerance: (float) tolerance
{
    self = [super init];
    self.time = time;
    self.freq = freq;
    self.type = type;
    self.tolerance = tolerance;
    
    return self;
}

@end

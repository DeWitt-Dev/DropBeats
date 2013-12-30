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

-(BOOL)isEqualToNote:(DPNote*) note withTolerance: (float) tolerance
{
    if (self.type == note.type) {
        if (self.freq == note.freq) {

            float sTime = [self time];
            float uTime = [note time];
            
            float sTimeLow = sTime - tolerance/2.0;
            float sTimeHigh = sTime + tolerance/2.0;
            
            if (sTimeLow <= uTime && uTime <= sTimeHigh)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

@end

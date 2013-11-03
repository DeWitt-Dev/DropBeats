//
//  DPNote.h
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPNote : NSObject

typedef enum {
    kCymbol,
    kSnare,
    kBass,
    kGuitar,
    kStrike
} NoteType;

typedef enum {
    kLowFrequency,
    kMidFrequency,
    kHighFrequency
} FrequencyRange;

@property (nonatomic) float time;
@property (nonatomic) FrequencyRange freq;
@property (nonatomic) NoteType type;

+ (instancetype) DPNoteAtTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type;
- (id) initAtTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type;

@end

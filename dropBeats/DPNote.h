//
//  DPNote.h
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstrumentNode.h"

@interface DPNote : NSObject

typedef enum {
    kSnare,
    kCymbol,
    kBass,
    kGuitar,
    kStrike
} NoteType;

@property (nonatomic) float time;
@property (nonatomic) float tolerance;
@property (nonatomic) FrequencyRange freq;
@property (nonatomic) NoteType type;

+ (instancetype) DPNoteWithTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type tolerance: (float) tolerance;
- (id) initWithTime: (float) time freq: (FrequencyRange) freq type: (NoteType) type tolerance: (float) tolerance;


@end

//
//  DPNote.h
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPNote : NSObject <NSCoding>

typedef NS_ENUM(NSInteger, NoteType) {
    kRest,
    kCymbol,
    kSnare,
    kBass,
    kGuitar,
    kStrike
};

typedef enum {
    kLowFrequency,
    kMidFrequency,
    kHighFrequency
} FrequencyRange;

@property (nonatomic) NSInteger length;
@property (nonatomic) FrequencyRange freq;
@property (nonatomic) NoteType type;

- (id) initWithJsonData: (NSMutableDictionary*) note;
- (id) initWithType: (NoteType) type andFreq: (FrequencyRange) freq andLength: (NSInteger) length;

-(BOOL)isEqualToNote:(DPNote*) note;

- (void) printNote;

- (void) encodeWithCoder: (NSCoder *) encoder;
- (id) initWithCoder: (NSCoder *) decoder;

@end

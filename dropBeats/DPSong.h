//
//  DPSong.h
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPNote.h"
#import "DPMeasure.h"

@interface DPSong : NSObject <NSCoding>

typedef struct TimeSignatureStruct {
    NSInteger beatsPerMeasure;
    NSInteger beatValue;
} TimeSignature;

@property NSString *title;
@property NSInteger level;
@property NSInteger tempo;
@property (nonatomic) NSUInteger duration; //in seconds
@property TimeSignature signature;
@property NSMutableArray* measures;

- (id) initWithJsonData: (NSMutableDictionary*) song;

- (id)initWithTitle: (NSString*) title
           andLevel: (NSInteger) level
           andTempo: (NSInteger) tempo
       andSignature: (TimeSignature) signature
        andMeasures: (NSMutableArray*) measures;

- (void) printSong;

- (void) encodeWithCoder: (NSCoder *) encoder;
- (id) initWithCoder: (NSCoder *) decoder;

@end

//
//  InstrumentNode.h
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface InstrumentNode : SKSpriteNode
{
    #define MAX_SCALE 0.65
    #define MIN_SCALE 0.15
    #define kInstrumentNode @"movable"
}

typedef enum {
    kNone,
    kLowFrequency,
    kMidFrequency,
    kHighFrequency
} FrequencyRange;

@property (nonatomic) FrequencyRange frequency;

-(id)initWIthInstrumentIndex: (int) index;
+(void)loadActions;

-(void)playInstrument;

@end

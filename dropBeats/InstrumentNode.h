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
    #define MAX_SCALE 1.5
    #define MIN_SCALE 0.8
    #define kInstrumentNode @"movable"
}

typedef enum {
    kNone,
    kLowFrequency,
    kMidFrequency,
    kHighFrequency
} FrequencyRange;

@property (nonatomic) FrequencyRange frequency;
@property (nonatomic) NSInteger index;

-(id)initWithInstrumentIndex: (int) index andSize: (CGSize) size;
+(void)loadActions;
-(void)playInstrument;

@end

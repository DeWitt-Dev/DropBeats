//
//  InstrumentNode.h
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DPNote.h"

@interface InstrumentNode : SKSpriteNode
{
    #define MAX_SCALE 2.0
    #define MIN_SCALE 0.8
    #define kInstrumentNode @"movable"
}

@property (nonatomic) NSInteger index;
@property (nonatomic) DPNote* note; 

-(id)initWithInstrumentIndex: (int) index andSize: (CGSize) size;
+(void)loadActions;
-(void)playInstrument;

@end

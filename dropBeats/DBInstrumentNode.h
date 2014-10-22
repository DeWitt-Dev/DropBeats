//
//  InstrumentNode.h
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DPNote.h"

extern NSString *const kInstrumentNode;
extern NSString *const kInstrumentPrefix;

@interface DBInstrumentNode : SKSpriteNode
{
    #define NUMBER_OF_INSTRUMENTS 3
}

@property (nonatomic) DPNote* note;

-(id)initWithInstrumentIndex:(NSInteger)index andSize:(CGSize)size;

+(void)loadActions;
-(void)playInstrument;

@end

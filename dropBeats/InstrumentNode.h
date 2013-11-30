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
    #define kInstrumentNode @"instrumentNode"
    #define NUMBER_OF_INSTRUMENTS 3
}

@property (nonatomic) DPNote* note;
@property (nonatomic) NoteType instrumentNoteIndex;

-(id)initWithInstrumentIndex: (NSInteger) index andSize: (CGSize) size;
+(void)loadActions;
-(void)playInstrument;

@end

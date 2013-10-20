//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNoteNode.h"


#define HEIGHT 15

#define W_BASS 50
#define W_SNARE 40
#define W_CYMBOL 30
#define W_GUITAR 45
#define W_STRIKE 160
#define W_ERROR 20


@implementation DPNoteNode : SKSpriteNode

+ (instancetype) noteNodeWithNote: (DPNote*) note
{
    return [[self alloc] initWithNote:note];
}

- (id) initWithNote: (DPNote*) note
{
    self = [super initWithColor:[UIColor redColor] size: CGSizeZero];
    
    if (self)
    {
        self.note = note;
        [self setupNode];
    }
    
    return self;
}

- (void) setupNode
{
    NSInteger width = 0;
    NSInteger height = 0; 
    
    NSLog(@"setupNode");
    // Set with depending on type of instrument
    switch ([self.note type]) {
        case kBass:
            width = W_BASS;
            height = HEIGHT;
            break;
        case kSnare:
            width = W_SNARE;
            height = HEIGHT;
            break;
        case kCymbol:
            width = W_CYMBOL;
            height = HEIGHT;
            break;
        case kGuitar:
            width = W_GUITAR;
            height = HEIGHT;
            break;
        case kStrike:
            width = W_STRIKE;
            height = HEIGHT;
            height = 2;
            break;
        default:
            width = W_ERROR;
            height = HEIGHT;
            break;
    }
    
    CGSize size = CGSizeMake(width, height);
    self.size = size;
    self.anchorPoint = CGPointZero;
    self.name = @"notenode";

}

@end

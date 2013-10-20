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
    
    NSLog(@"setupNode");
    // Set with depending on type of instrument
    switch ([self.note type]) {
        case kBass:
            width = W_BASS;
            break;
        case kSnare:
            width = W_SNARE;
            break;
        case kCymbol:
            width = W_CYMBOL;
            break;
        case kGuitar:
            width = W_GUITAR;
            break;
        default:
            width = W_ERROR;
            break;
    }
    
    CGSize size = CGSizeMake(width, HEIGHT);
    self.size = size;
    self.anchorPoint = CGPointZero;

}

@end

//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNoteNode.h"


#define HEIGHT 25

#define W_LOW 100
#define W_MID 175
#define W_HIGH 250


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
    switch (self.note.freq)
    {
        case 0:
            width = W_LOW;
            break;
        case 1:
            width = W_MID;
            break;
        case 2:
            width = W_HIGH;
            break;
    }

    height = (int)((1.0 + [self.note tolerance]) * HEIGHT);
    
    CGSize size = CGSizeMake(width, height);
    self.size = size;
    self.anchorPoint = CGPointZero;
    self.name = @"notenode";

}

@end

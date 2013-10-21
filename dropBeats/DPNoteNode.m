//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNoteNode.h"


#define RESIZE_INTERVAL 0.2
#define BACKGROUND_ALPHA 0.6f

#define HEIGHT 25

#define W_LOW 250
#define W_MID 175
#define W_HIGH 100


@implementation DPNoteNode : SKSpriteNode

+ (instancetype) noteNodeWithNote: (DPNote*) note onSide:(Side) side animate: (BOOL) animate
{
    return [[self alloc] initWithNote:note onSide:side animate:animate];
}

- (id) initWithNote: (DPNote*) note onSide:(Side) side animate: (BOOL) animate
{
    UIColor* instrumentColor;
    switch (note.type) {
        case kSnare:
            instrumentColor = [UIColor blueColor];
            break;
        case kCymbol:
            instrumentColor = [UIColor yellowColor];
            break;
        case kBass:
            instrumentColor = [UIColor redColor];
            break;
            
        default:
            instrumentColor = [UIColor blackColor];
            break;
    }
    self = [super initWithColor:instrumentColor size: CGSizeZero];
    
    if (self)
    {
        self.side = side;
        self.note = note;
        self.animate = animate;
        [self setupNode];
    }
    
    return self;
}

- (void) setupNode
{
    NSInteger width = 0;
    NSInteger height = 0; 
    
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
    self.size = CGSizeMake(0, size.height);
    self.anchorPoint = CGPointMake(0, 0.5);
    self.name = @"notenode";
    self.alpha = BACKGROUND_ALPHA;
    
    if (self.animate) {
        if (self.side == SideLeft) {
            size = CGSizeMake(-size.width, size.height);
        }
        SKAction* zeroMorph = [SKAction resizeToWidth:0 duration:0.0f];
        SKAction* correctSizeW = [SKAction resizeToWidth:size.width duration:RESIZE_INTERVAL];
        SKAction* overSizeW = [SKAction resizeToWidth:size.width*1.2 duration:RESIZE_INTERVAL];
        SKAction* underSize = [SKAction resizeToWidth:size.width*0.9 duration:RESIZE_INTERVAL];
        
        
        SKAction* sequence = [SKAction sequence:@[zeroMorph, correctSizeW, overSizeW, underSize, correctSizeW]];
        
        [self runAction:sequence completion:^{
                             self.size = size;
                         }];
    }
    else{
        self.size = size;
    }
}

@end

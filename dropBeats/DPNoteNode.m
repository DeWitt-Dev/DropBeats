//
//  DPNote.m
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import "DPNoteNode.h"

@interface DPNoteNode(){
    #define RESIZE_INTERVAL 0.2
    #define BACKGROUND_ALPHA 0.6f

    #define HEIGHT_TOLERANCE_SCALE .08

    #define WLOW_F  0.8
    #define WMID_F  0.4
    #define WHIGH_F 0.15
}
@end

@implementation DPNoteNode : SKSpriteNode

+ (instancetype) noteNodeWithNote: (DPNote*) note time: (float) time difficulty: (Difficulty) difficulty onSide:(Side) side animate: (BOOL) animate
{
    return [[self alloc] initWithNote:note time:time difficulty:difficulty onSide:side animate:animate];
}

- (instancetype) initWithNote: (DPNote*) note time: (float) time difficulty: (Difficulty) difficulty onSide:(Side) side animate: (BOOL) animate
{
    
    if (self = [super init])
    {
        self.side = side;
        self.note = note;
        self.tolerance = difficulty;
        self.animate = animate;
        self.time = time;
        [self resetNodeColor];
    }
    
    return self;
}

-(UIColor*)resetNodeColor
{
    UIColor* instrumentColor;
    switch (self.note.type) {
        case kSnare:
            instrumentColor = [UIColor redColor];
            break;
        case kCymbol:
            instrumentColor = [UIColor yellowColor];
            break;
        case kBass:
            instrumentColor = [UIColor blueColor];
            break;
            
        default:
            instrumentColor = [UIColor blackColor];
            break;
    }
    
    self.color =  instrumentColor;

    return instrumentColor;
}

- (float)setupNoteNodeWithReferenceSize:(float)viewWidth
{
    viewWidth /= 2.0; //only drawing notes on half the view
    
    float width = 0;
    float height = 0;
    
    // Set with depending on type of instrument
    switch (self.note.freq)
    {
        case 0:
            width = viewWidth * WLOW_F;
            break;
        case 1: 
            width = viewWidth * WMID_F;
            break;
        case 2:
            width = viewWidth * WHIGH_F;
            break;
    }
    height = (int)((1.0 + self.tolerance) * (viewWidth * HEIGHT_TOLERANCE_SCALE));

    CGSize size = CGSizeMake(width, height); //final size
    if (self.side == SideLeft) {
        size = CGSizeMake(-size.width, size.height);
    }
    
    self.size = CGSizeMake(0, size.height);
    self.anchorPoint = CGPointMake(0, 0.5);
    self.name = @"notenode";
    self.alpha = BACKGROUND_ALPHA;
    
    if (self.animate) {
        
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
    
    return height;
}

@end

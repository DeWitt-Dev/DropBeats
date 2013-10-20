//
//  InstrumentNode.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "InstrumentNode.h"

@interface InstrumentNode()
@property (strong, nonatomic) NSString* imageID;
@end
@implementation InstrumentNode

static NSString * const kInstrumentPrefix = @"Box";

-(id)initWIthInstrumentIndex: (int) index
{
    self.imageID = [NSString stringWithFormat:@"%@%d",kInstrumentPrefix, index+1];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Assets"];
    SKTexture *texture = [atlas textureNamed:self.imageID];
    
    if (self = [super initWithTexture:texture]) {
        
        self.name = kInstrumentNode;
        self.frequency = kMidFrequency; 
        
        #warning temporary Implementation
        self.imageID = [NSString stringWithFormat:@"Instrument%d", index+1];
        
        [self updatePhysicsBody];
    }
    
    return self;
}


#pragma mark - Setters/getters
-(void)setXScale:(CGFloat)xScale
{
    if (xScale < MAX_SCALE && xScale > MIN_SCALE) {
        [super setXScale:xScale];
        [self frequencyChanged];
        [self updatePhysicsBody];
    }
}
-(void)setYScale:(CGFloat)yScale
{
    if (yScale < MAX_SCALE && yScale > MIN_SCALE) {
        
        if (yScale < MIN_SCALE) {
            [self removeFromParent];
        }
        else{
            [super setYScale:yScale];
            [self frequencyChanged];
            [self updatePhysicsBody];
        }
    }
}

-(void)setScale:(CGFloat)scale
{
    [super setScale:scale];
   
}

-(void)frequencyChanged
{
    float scaleRange = MAX_SCALE - MIN_SCALE;
    
    if (self.xScale > scaleRange * (2/3.0)) {
        self.frequency = kHighFrequency;
    }
    else if (self.xScale > scaleRange * (1/3.0)) {
        self.frequency = kMidFrequency;
    }
    else{
        self.frequency = kLowFrequency;
    }
    
    NSLog(@"Frequency %d", self.frequency);
}

-(void)playInstrument
{
    NSString* soundID = [NSString stringWithFormat:@"%@_%d.caf", self.imageID, self.frequency];

    [self removeAllActions];
    
    SKAction *action = [SKAction playSoundFileNamed:soundID waitForCompletion:YES];
    [self runAction:action];
}

//helper method to keep body aligned with Shape
-(void)updatePhysicsBody
{
    //handleing Physics body
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    
    self.physicsBody.restitution = 0.0;
}


@end

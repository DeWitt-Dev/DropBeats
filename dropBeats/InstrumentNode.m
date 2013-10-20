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

static NSString * const kInstrumentPrefix = @"Instrument";

-(id)initWithInstrumentIndex: (int) index andSize: (CGSize) size
{
    self.imageID = [NSString stringWithFormat:@"%@%d",kInstrumentPrefix, index+1];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Assets"];
    SKTexture *texture = [atlas textureNamed:self.imageID];
    
    if (self = [super initWithTexture:texture]) {
        
        self.name = kInstrumentNode;
        self.frequency = kMidFrequency;
        [self setScale:0.18];
        [self setSize:size];
        [self updatePhysicsBody];
    }
    
    return self;
}


#pragma mark - Setters/getters
-(void)setScale:(CGFloat)scale
{
    if (scale < MAX_SCALE && scale > MIN_SCALE) {
        [super setScale:scale];
        [self frequencyChanged];
        [self updatePhysicsBody];
    }
}

-(void)frequencyChanged
{
    float scaleRange = MAX_SCALE - MIN_SCALE;
    
    if (self.xScale > scaleRange * (2/3.0)) {
        self.frequency = kLowFrequency;
    }
    else if (self.xScale > scaleRange * (1/3.0)) {
        self.frequency = kMidFrequency;
    }
    else{
        self.frequency = kHighFrequency;
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
    CGSize contactSize = CGSizeMake(self.size.width, self.size.height/2);

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:contactSize];
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    
    self.physicsBody.restitution = 0.0;
}


@end

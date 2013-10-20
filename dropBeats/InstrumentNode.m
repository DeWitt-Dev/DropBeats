//
//  InstrumentNode.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "InstrumentNode.h"

@interface InstrumentNode()

#define DEFAULT_ANIMATION_FRAMES 10
#define ANIMATION_INTERVAL 0.008

@end

@implementation InstrumentNode

static NSString * const kInstrumentPrefix = @"Instrument";
static NSString* imageID;
static SKAction* lowFrequncySound;
static SKAction* midFrequncySound;
static SKAction* highFrequncySound;
static NSMutableArray *animationFrames;
static bool loaded;

-(id)initWithInstrumentIndex: (int) index andSize: (CGSize) size
{
    SKTexture *texture = animationFrames[0];
    
    if (self = [super initWithTexture:texture]) {
        
        self.name = kInstrumentNode;
        self.frequency = kMidFrequency;
        [self setSize:size];
        [self updatePhysicsBody];
    }
    
    return self;
}

+(void)loadActions
{
    imageID = [NSString stringWithFormat:@"%@%d",kInstrumentPrefix, 1];

    lowFrequncySound = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@_%d.caf", imageID, kLowFrequency] waitForCompletion:YES];
    midFrequncySound = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@_%d.caf", imageID, kMidFrequency] waitForCompletion:YES];
    highFrequncySound = [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@_%d.caf", imageID, kHighFrequency] waitForCompletion:YES];
    
    SKTextureAtlas *animationAtlas = [SKTextureAtlas atlasNamed: imageID];
    animationFrames = [[NSMutableArray alloc]initWithCapacity:DEFAULT_ANIMATION_FRAMES];

    int numImages = animationAtlas.textureNames.count; //divide by 2 for retina
    for (int i=0; i < numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"%@_%d", imageID, i];
        SKTexture *temp = [animationAtlas textureNamed:textureName];
        [animationFrames addObject:temp];
    }
    for (int i=2; i < numImages; i++) {
        [animationFrames addObject: animationFrames[numImages-i]];
    }
    
    loaded = YES;
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
    NSString* soundID = [NSString stringWithFormat:@"%@_%d.caf", imageID, self.frequency];

    [self removeAllActions];
    
    SKAction *soundAction = [SKAction playSoundFileNamed:soundID waitForCompletion:YES];
    [self runAction:soundAction];
    
    //This is our general runAction method to make our bear walk.
    SKAction *hitAction = [SKAction repeatAction:[SKAction animateWithTextures:animationFrames timePerFrame:ANIMATION_INTERVAL resize:NO restore:YES] count:1];
    [self runAction:hitAction];
    
    SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:-4.0f/180.0f * M_PI duration:0.1],
                                              [SKAction rotateByAngle:0.0 duration:0.1],
                                              [SKAction rotateByAngle:4.0f/180.0f * M_PI duration:0.1]]];
    [self runAction:[SKAction repeatAction:sequence count:2]];
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

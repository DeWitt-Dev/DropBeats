//
//  InstrumentNode.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "InstrumentNode.h"

@interface InstrumentNode()
{
    #define NUMBER_OF_INSTRUMENTS 3
    #define NUMBER_OF_SOUNDS 3
    
    #define DEFAULT_ANIMATION_FRAMES 10
    #define ANIMATION_INTERVAL 0.01
    #define WIGGLE_DURATION 0.04
    #define INSTRUMENT_WIGGLE 0.09
}

@property (nonatomic, strong) NSString* instrumentID;

@end

@implementation InstrumentNode

static NSString * const kInstrumentPrefix = @"Instrument";
static NSMutableDictionary * instrumentSounds;
static NSMutableDictionary* instrumentAnimations;

-(id)initWithInstrumentIndex: (int) index andSize: (CGSize) size
{
    self.instrumentID = [NSString stringWithFormat:@"%@%d",kInstrumentPrefix, index+1];
    SKTexture *texture = [instrumentAnimations objectForKey:self.instrumentID][0];
    
    if (self = [super initWithTexture:texture]) {
        
        self.name = kInstrumentNode;
        self.instrumentNoteIndex = index;
        [self setSize:size];
        [self updatePhysicsBody];
        
        //init note
        self.note.freq = kMidFrequency;
        self.note.type = index;
    }
    
    return self;
}

+(void)loadActions
{
    instrumentSounds = [[NSMutableDictionary alloc]init];
    instrumentAnimations = [[NSMutableDictionary alloc]init];
    
    for (int i = 0 ; i <= NUMBER_OF_INSTRUMENTS-1; i++) {
        NSString* imageIDKEY = [NSString stringWithFormat:@"%@%d",kInstrumentPrefix, (i+1)];
        
        NSMutableArray* sounds = [[NSMutableArray alloc]initWithCapacity:NUMBER_OF_SOUNDS];
        [sounds addObject: [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@_%d.caf", imageIDKEY, kLowFrequency] waitForCompletion:YES]];
        [sounds addObject: [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@_%d.caf", imageIDKEY, kMidFrequency] waitForCompletion:YES]];
        [sounds addObject:  [SKAction playSoundFileNamed:[NSString stringWithFormat:@"%@_%d.caf", imageIDKEY, kHighFrequency] waitForCompletion:YES]];
        [instrumentSounds setObject:sounds forKey:imageIDKEY];
        
        SKTextureAtlas *animationAtlas = [SKTextureAtlas atlasNamed: imageIDKEY];
        NSMutableArray* animationFrames = [[NSMutableArray alloc]initWithCapacity:DEFAULT_ANIMATION_FRAMES];
        
        NSInteger numImages = animationAtlas.textureNames.count; //divide by 2 for retina
        for (int j=0; j < numImages; j++) {
            NSString *textureName = [NSString stringWithFormat:@"%@_%d", imageIDKEY, j];
            SKTexture *temp = [animationAtlas textureNamed:textureName];
            [animationFrames addObject:temp];
        }
        for (int j=2; j < numImages; j++) {
            [animationFrames addObject: animationFrames[numImages-j]];
        }
        [instrumentAnimations setObject:animationFrames forKey:imageIDKEY];
    }
}

#pragma mark - Setters/getters
-(DPNote*)note
{
    if (!_note) {
        _note = [[DPNote alloc]init];
    }
    return _note;
}
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
    double scaleRange = MAX_SCALE - MIN_SCALE;
    
    if (self.xScale > scaleRange * (2/3.0) +MIN_SCALE) {
        self.note.freq = kLowFrequency;
    }
    else if (self.xScale > scaleRange * (1/3.0) +MIN_SCALE) {
        self.note.freq = kMidFrequency;
    }
    else{
        self.note.freq = kHighFrequency;
    }
}

- (BOOL) isNum: (float) num between: (float) first and: (float) second
{
    return num >= first && num <= second;
}

-(void)playInstrument
{
    [self removeAllActions];
    
    SKAction *soundAction = [instrumentSounds objectForKey:self.instrumentID][self.note.freq];
    [self runAction:soundAction];
    
    NSArray* animationFrames = [instrumentAnimations objectForKey:self.instrumentID];
    SKAction *hitAction = [SKAction repeatAction:[SKAction animateWithTextures:animationFrames timePerFrame:ANIMATION_INTERVAL resize:NO restore:YES] count:1];
    [self runAction:hitAction];
    
    SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:INSTRUMENT_WIGGLE duration:WIGGLE_DURATION],
                                              [SKAction rotateByAngle:-2*INSTRUMENT_WIGGLE duration:WIGGLE_DURATION],
                                              [SKAction rotateToAngle: self.zRotation duration:WIGGLE_DURATION]]];
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

//
//  DPMyScene.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPMyScene.h"
#import "DPNoteNode.h"
#import "DPNote.h"
#import "DPSong.h"
#import "DPStrike.h"
#import "DPStrikeNode.h"

@interface DPMyScene() <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>
{
    #define ZFLOOR 10
    #define MIN_COLLISIONIMPULSE 10
}
@property (nonatomic, strong) SKSpriteNode *selectedNode;

@property (strong, nonatomic) DPSong* song;
@property BOOL sceneCreated;
@property BOOL validTouch;
@property NSDate* timeDrop;
@property DPSong* played;

@end

@implementation DPMyScene

static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t floorCategory = 0x1 << 1;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    /* Setup your scene here */
    self.backgroundColor = [SKColor whiteColor]; //[SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    //Resister for Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameEnded:) name:@"gameEnded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(gameStarted:) name:@"gameStarted" object:nil];
}

-(void)didMoveToView:(SKView *)view
{
    if(!self.sceneCreated)
    {
        self.physicsWorld.gravity = CGVectorMake(0, -3);
        self.physicsWorld.contactDelegate = self;
        self.sceneCreated = YES;
        
        [self initGestures];
        
        //Background Notes
        [self drawDivider];
        [self displaySong: [[DPSong song] getSampleSong:0]];
    }
}
-(void)initGestures
{
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    
    UIRotationGestureRecognizer* rotationRecognizer = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handleRotation:)];
    rotationRecognizer.delegate = self;
    [self.view addGestureRecognizer:rotationRecognizer];
    
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    pinchRecognizer.delegate = self;
    [self.view addGestureRecognizer:pinchRecognizer];
}

-(DPGame*)game
{
    if (!_game) {
        _game = [[DPGame alloc]init];
    }
    return _game;
}

//-(void)initBallDrop
//{
//    self.scaleMode = SKSceneScaleModeAspectFill;
//    
//    SKAction *releaseBalls = [SKAction sequence:@[[SKAction performSelector:@selector(createBallNodeAtLocation:) onTarget:self], [SKAction waitForDuration:4]]];
//    [self runAction: [SKAction repeatActionForever:releaseBalls]]; //[SKAction repeatAction:releaseBalls count:self.ballCount]];
//}



#pragma mark - Background Music
- (void) drawDivider
{
    CGSize size = CGSizeMake(3, self.frame.size.height);
    SKSpriteNode* divider = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size: size];
    divider.anchorPoint = CGPointMake(0, 0);
    divider.position = CGPointMake(self.frame.size.width / 2, 0);
    divider.zPosition = ZFLOOR;
    [self addChild:divider];
}

- (void) displaySong: (DPSong*) song
{
    self.song = song;
    
    for (DPNote* dpnote in [song getNotes])
    {
        [self drawDPNote:dpnote onSide: 0];
    }
}

- (void) drawDPNote: (DPNote*) note onSide: (NSInteger) side
{
    NSLog(@"drawDPNote");
    DPNoteNode* node = [DPNoteNode noteNodeWithNote:note];

    float x = !side ? CGRectGetMidX(self.frame) - [node size].width : CGRectGetMidX(self.frame);
    int space = (self.frame.size.height / [self.song duration]);

    float y = self.frame.size.height * (1 -[[node note] time]);
    
    NSLog(@"x: %0.f, y: %0.f", x, y);
    
    [node setPosition: CGPointMake(x, y)];
    [self addChild:node];
}

#pragma mark - Collision Dection


- (void) drawDPStrike: (DPStrike*) strike atTime: (float) time
{
    NSLog(@"drawDPStrike");
    if (time <= 1.0) {
        NSLog(@"drawing");
        DPStrikeNode* node = [DPStrikeNode strike: strike];
        float x = 0 ? CGRectGetMidX(self.frame) - [node size].width : CGRectGetMidX(self.frame);
        float y = (1.0 - time) * self.frame.size.height;
        
        [node setPosition: CGPointMake(x, y)];
        [self addChild:node];
    }
    else
    {
        NSLog(@"hiding");
        [self endStrikes];
    }
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *ballNode;
    InstrumentNode *instrumentNode;
    
    if ([contact.bodyA.node isKindOfClass:[InstrumentNode class]]) {
        
        instrumentNode = (InstrumentNode *)contact.bodyA.node;
        ballNode = (SKSpriteNode *) contact.bodyB.node;
    }
    else if ([contact.bodyB.node isKindOfClass:[InstrumentNode class]])
    {
        instrumentNode = (InstrumentNode *)contact.bodyB.node;
        ballNode = (SKSpriteNode *) contact.bodyA.node;
    }

    if (contact.collisionImpulse >= MIN_COLLISIONIMPULSE) {
        [instrumentNode playInstrument];
    }

//    if ((contact.bodyA.categoryBitMask == floorCategory)
//        && (contact.bodyB.categoryBitMask == ballCategory))
//    {
//        CGPoint contactPoint = contact.contactPoint;
//        
//        float contact_y = contactPoint.y;
//        float target_y = instrumentNode.position.y;
//        float margin = ballNode.frame.size.height/2 - 25;
//        
//        if ((contact_y > (target_y - margin)) &&
//            (contact_y < (target_y + margin)))
//        {
//            NSLog(@"Collision");
//        }
//    }
   
    
    [self onStrikeFrom:kStrike];
    // TODO: set this correctly!
}

- (void) onStrikeFrom: (NoteType) type
{
    NSLog(@"onStrike");
    NSDate* now = [[NSDate alloc] init];
    DPStrike* strike = [DPStrike strikeAtTime:[[NSDate alloc] init] fromType:kStrike];
    
    NSTimeInterval nowInt = [[[NSDate alloc]init] timeIntervalSinceDate:self.timeDrop];
    float timePercent = nowInt / 10.0;
    
    [self drawDPStrike:strike atTime:timePercent];

}

- (void)didEndContact:(SKPhysicsContact *)contact
{
}

-(void) createBallNodeAtLocation: (CGPoint) location
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Assets"];
    SKSpriteNode *ball = [[SKSpriteNode alloc] initWithTexture:[atlas textureNamed:@"Ball"]];
    
    ball.name = @"ballNode";
    ball.position = CGPointMake(self.size.width/2, self.size.height);
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(ball.size.width/2)-8];
    ball.physicsBody.usesPreciseCollisionDetection = YES;
    ball.physicsBody.restitution = 0.9f; //energy conservation
    
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = floorCategory;
    ball.physicsBody.collisionBitMask = ballCategory | floorCategory;
    ball.zPosition = ZFLOOR +1; 
    
    self.timeDrop = [[NSDate alloc] init];
    self.played = [DPSong song];
    
    [self addChild:ball];
}

#pragma mark - Game notifications
-(void)gameStarted: (NSNotification*) notification
{
    if (![self.game isInProgress]) {
        [self createBallNodeAtLocation:CGPointZero];
    }
}
-(void)gameEnded: (NSNotification *) notification
{
    [self enumerateChildNodesWithName:@"ballNode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         [node removeFromParent];
     }];
}

-(void) createInstrument: (int) index AtLocation: (CGPoint) location
{
    SKSpriteNode *tonePad = [[InstrumentNode alloc]initWIthInstrumentIndex:index];
    
    tonePad.position = location;
    tonePad.physicsBody.categoryBitMask = floorCategory;
    tonePad.physicsBody.contactTestBitMask = ballCategory;
    tonePad.physicsBody.collisionBitMask = ballCategory | floorCategory;
    tonePad.zPosition = ZFLOOR +1;
    
    [self addChild:tonePad];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"ballNode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         if (node.position.y < 0){
             if ([self.game isInProgress]) {
                 [self createBallNodeAtLocation:CGPointZero];
                 [self endStrikes];
             }
            [node removeFromParent];
         }
    }];
}

- (void) endStrikes
{
    [self enumerateChildNodesWithName:@"strikenode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         [node removeFromParent];
     }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - Gesture Recognizers

#define WIGGLE 2.0
- (void)selectNodeForTouch:(CGPoint)touchLocation {
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    if (![touchedNode isKindOfClass:[InstrumentNode class]]) {
        return;
    }
    
	if(![self.selectedNode isEqual:touchedNode]) {
		[self.selectedNode removeAllActions];
        
        self.selectedNode = touchedNode;
        
		if([[touchedNode name] isEqualToString:kInstrumentNode]) {
			SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
													  [SKAction rotateByAngle:0.0 duration:0.1],
													  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
			[self.selectedNode runAction:[SKAction repeatAction:sequence count:WIGGLE]];
		}
	}
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer{
    CGPoint touchLocation = [recognizer locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self selectNodeForTouch:touchLocation];
        if([self.selectedNode containsPoint:touchLocation])
            self.validTouch = YES;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:self.view];
//        translation = [self.view convertPoint:translation fromView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y); // Must invert translation for SpriteKit
        
        CGPoint position = [self.selectedNode position];
        
        if (self.validTouch) {
            [self.selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
            [recognizer setTranslation:CGPointZero inView:recognizer.view];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        self.validTouch = NO;
        if (![[self.selectedNode name] isEqualToString:kInstrumentNode]) {
            float scrollDuration = 0.2;
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            CGPoint pos = [self.selectedNode position];
            CGPoint p = mult(velocity, scrollDuration);
            
            CGPoint newPos = CGPointMake(pos.x + p.x, pos.y + p.y);
            [self.selectedNode removeAllActions];
            
            SKAction *moveTo = [SKAction moveTo:newPos duration:scrollDuration];
            [moveTo setTimingMode:SKActionTimingEaseOut];
            [self.selectedNode runAction:moveTo];
        }
    }
}

-(void)handleRotation:(UIRotationGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
    }
    
    self.selectedNode.zRotation += -recognizer.rotation;
    recognizer.rotation = 0;
}

-(void)handlePinch: (UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
    }
    
    [self.selectedNode setScale: self.selectedNode.xScale * recognizer.scale];
    recognizer.scale = 1.0f;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//helper methods
float degToRad(float degree) {
	return degree / 180.0f * M_PI;
}
CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}

@end
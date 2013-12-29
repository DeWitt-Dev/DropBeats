//
//  DPMyScene.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPInstrumentScene.h"
#import "InstrumentNode.h"

@interface DPInstrumentScene() <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>
{
    #define GRAVITY -3.5
    #define BALL_RESTITUTION 1.0f
    #define MIN_COLLISIONIMPULSE 4
    #define DELETE_VELOCITY 1000
    
    #define BALL_SIZE CGSizeMake(35, 35)
    #define WIGGLE_REPEATS 2
    #define WIGGLE_AMPLITUDE 0.08
}

@property (nonatomic) CGSize startingInstrumentSize;
@property (nonatomic, strong) SKSpriteNode *selectedNode;
@property (nonatomic, strong) SKSpriteNode *ballNode;
@property (nonatomic, strong) SKSpriteNode *stanzaNode;
@property (nonatomic) CGPoint ballStart;

@end

@implementation DPInstrumentScene

static NSString * const kBallNode = @"BallNode";
static NSString * const kStanzaNode = @"StanzaNode";
static const uint32_t ballCategory = 0x1 << 0;
static const uint32_t floorCategory = 0x1 << 1;


+(void)loadEverythingYouCanWithCompletionHandeler: (DPSceneCompletionHandler) handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       [InstrumentNode loadActions];
                       
                       if (handler)
                       dispatch_sync(dispatch_get_main_queue(), handler);
                   });
}

-(id)initWithSize:(CGSize)size game: (DPGame*) game andInstrumentSize: (CGSize) instrumentSize {
    if (self = [super initWithSize:size game:game]) {
        
        self.startingInstrumentSize = instrumentSize;
//        [DPInstrumentScene loadEverythingYouCanWithCompletionHandeler:nil];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    if(!self.sceneCreated)
    {
        [super didMoveToView:view];
        
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0, GRAVITY);
        self.physicsWorld.contactDelegate = self;
        self.sceneCreated = YES;
        
        [self initGestures];
        [self drawStanza];
        [self createBall];
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

//-(void)initBallDrop
//{
//    self.scaleMode = SKSceneScaleModeAspectFill;
//    
//    SKAction *releaseBalls = [SKAction sequence:@[[SKAction performSelector:@selector(createBallNodeAtLocation:) onTarget:self], [SKAction waitForDuration:4]]];
//    [self runAction: [SKAction repeatActionForever:releaseBalls]]; //[SKAction repeatAction:releaseBalls count:self.ballCount]];
//}


- (void) drawStanza
{
    self.stanzaNode = [[SKSpriteNode alloc] initWithImageNamed:@"Stanza"];
    self.stanzaNode.size = CGSizeMake(self.view.frame.size.width*(2/3.0),self.stanzaNode.size.height);
    self.stanzaNode.anchorPoint = CGPointZero;
    self.stanzaNode.zPosition = ZFLOOR-1;
    self.stanzaNode.name = kStanzaNode;
    
    CGPoint position = CGPointMake((self.frame.size.width - self.stanzaNode.size.width)/2, .935 * self.frame.size.height);
    self.stanzaNode.position = position;
    
    [self addChild:self.stanzaNode];
    self.ballStart = CGPointMake(self.view.frame.size.width/2, self.stanzaNode.position.y+self.stanzaNode.size.height/2);
}

#pragma mark - Collision Dection
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
        
        float time = 1.0 + ([self.game.startDate timeIntervalSinceNow] / (self.game.song.duration));
                
        DPNote* note = [DPNote DPNoteAtTime:time
                                       freq:[instrumentNode.note freq]
                                           type:instrumentNode.instrumentNoteIndex];
        [self DPNotePlayed:note];
    }
}

-(void) createInstrument: (NSInteger) index AtLocation: (CGPoint) location
{
    SKSpriteNode *tonePad = [[InstrumentNode alloc]initWithInstrumentIndex:index andSize:self.startingInstrumentSize];
    
    tonePad.name = kInstrumentNode;
    tonePad.position = location;
    tonePad.physicsBody.categoryBitMask = floorCategory;
    tonePad.physicsBody.contactTestBitMask = ballCategory;
    tonePad.physicsBody.collisionBitMask = ballCategory | floorCategory;
    tonePad.zPosition = ZFLOOR + 1;
    
    [self addChild:tonePad];
}

-(void) createBall
{
    [self enumerateChildNodesWithName:kBallNode usingBlock:
     ^(SKNode *node,BOOL *stop) {
            [node removeFromParent]; //ensures only one ball at a time
     }];
    
    self.ballNode = [[SKSpriteNode alloc] initWithImageNamed:@"Ball"];
    self.ballNode.name = kBallNode;
    self.ballNode.size = BALL_SIZE;
    self.ballNode.position = self.ballStart;
    self.ballNode.zPosition = UINT32_MAX; //always on top
    
    [self addChild:self.ballNode];
}

-(void)dropBall
{
    self.ballNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(self.ballNode.size.width/2)-8];
    self.ballNode.physicsBody.usesPreciseCollisionDetection = YES;
    self.ballNode.physicsBody.restitution = BALL_RESTITUTION; //energy conservation
    self.ballNode.physicsBody.categoryBitMask = ballCategory;
    self.ballNode.physicsBody.contactTestBitMask = floorCategory;
    self.ballNode.physicsBody.collisionBitMask = ballCategory | floorCategory;
}

#pragma mark - Game notifications
-(void)gameReset: (NSNotification*) notification //when the ball leaves the screen
{
    [super gameReset:notification];
    [self createBall];
    [self dropBall];
}

-(void)gameEnded: (NSNotification *) notification
{
    [super gameEnded:notification];
    [self enumerateChildNodesWithName:kBallNode usingBlock:
     ^(SKNode *node,BOOL *stop) {
         [node removeFromParent];
         [self createBall];
     }];
}

-(void)clearGame
{
    [super clearGame];
    [self.game endGame];
    
    float edge = -500; //Arbitrary distance off screen
    [self enumerateChildNodesWithName:kInstrumentNode usingBlock:
     ^(SKNode *node,BOOL *stop) {
         
         float g = self.physicsWorld.gravity.dy;
         NSTimeInterval time = sqrt(abs((2*edge-node.position.y)/g)/150.0);
         SKAction* dropOffScreen = [SKAction moveToY:edge duration:time];
         SKAction* accelerate = [SKAction speedTo:(.5*g*g) duration:time/2];
         
         SKAction* sequence = [SKAction sequence:@[dropOffScreen, accelerate]];
         [self wiggleNode: node];
         [node runAction:sequence];
     }];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:kBallNode usingBlock:
     ^(SKNode *node,BOOL *stop) {
         if (node.position.y < 0){
            [node removeFromParent];
            [self createBall];
             if ([self.game isInProgress]) {
                 [self checkGameStatus];
             }
         }
    }];
    [self enumerateChildNodesWithName:kInstrumentNode usingBlock:
     ^(SKNode *node,BOOL *stop) {
         if (node.position.x < 0 || node.position.y < 0
             || node.position.x > self.view.bounds.size.width
             || node.position.y > self.view.bounds.size.height){
             [node removeFromParent];
         }
     }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - Gesture Recognizers

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint: touchLocation];
    
    if([touches count] < 2 && [[touchedNode name] isEqualToString:kInstrumentNode]) {
        [self wiggleNode:touchedNode];
    }
}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    self.selectedNode = nil;
    
    if ([touchedNode.name isEqualToString:kBallNode]
        || [touchedNode.name isEqualToString:kStanzaNode]) {
        if (self.game.isInProgress) {
            return;
        }
        self.selectedNode = self.ballNode;
    }
    else if([touchedNode isKindOfClass:[InstrumentNode class]]
       && ![self.selectedNode isEqual:touchedNode]) {
        
        self.selectedNode = touchedNode;
	}
}

-(void)wiggleNode: (SKNode*) node
{
    if (!self.hasActions) {
        float zRotation = node.zRotation;
        SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:WIGGLE_AMPLITUDE duration:0.1],
                                                  [SKAction rotateByAngle:-2*WIGGLE_AMPLITUDE duration:0.1],
                                                  [SKAction rotateToAngle:zRotation duration:0.1]]];
        [node runAction:[SKAction repeatAction:sequence count:WIGGLE_REPEATS]];
    }
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer{
    CGPoint touchLocation = [recognizer locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self selectNodeForTouch:touchLocation];
        
    }  else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        //allowing deletion of instruments
        if ([[self.selectedNode name] isEqualToString:kInstrumentNode]) {
            CGPoint velocity = [recognizer velocityInView:recognizer.view];
            
            if (abs(velocity.x) > DELETE_VELOCITY || abs(velocity.y) > DELETE_VELOCITY) {
                float scrollDuration = 1.0;
                
                [self.selectedNode removeAllActions];
                
                SKAction *moveTo = [SKAction moveByX:velocity.x y:-velocity.y duration:scrollDuration];
                [moveTo setTimingMode:SKActionTimingLinear];
                [self.selectedNode runAction:moveTo completion:^
                {
                    self.selectedNode = nil;
                }];
            }
        }
    }
    else{
        CGPoint translation = [recognizer translationInView:self.view];
        //        translation = [self.view convertPoint:translation fromView:recognizer.view];
        
        CGPoint position = [self.selectedNode position];
        
        if ([self.selectedNode.name isEqualToString:kBallNode]) {
            translation = CGPointMake(position.x + translation.x, position.y);
            translation.x = MAX(MIN(self.view.bounds.size.width - self.stanzaNode.size.width/4, translation.x), self.stanzaNode.size.width/4);
            [self.selectedNode setPosition:translation];
            self.ballStart = self.selectedNode.position;
        }
        else {
            
                [self.selectedNode setPosition:CGPointMake(position.x + translation.x, position.y - translation.y)];
        }
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
}

-(void)handleRotation:(UIRotationGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
        [self.selectedNode removeAllActions];
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
        [self.selectedNode removeAllActions];
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
CGPoint mult(const CGPoint v, const CGFloat s) {
	return CGPointMake(v.x*s, v.y*s);
}

@end
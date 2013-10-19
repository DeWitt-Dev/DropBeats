//
//  DPMyScene.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPMyScene.h"

@interface DPMyScene() <SKPhysicsContactDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) SKSpriteNode *selectedNode;

@property BOOL sceneCreated;
@property int ballCount;

@end

@implementation DPMyScene

static NSString * const kInstrumentNode = @"movable";
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
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
}

-(void)didMoveToView:(SKView *)view
{
    if(!self.sceneCreated)
    {
        self.ballCount = 3;
        self.physicsWorld.gravity = CGVectorMake(0, -2);
        self.physicsWorld.contactDelegate = self;
        
        [self createBallNodeAtLocation:CGPointZero];
//        [self initBallDrop];
        self.sceneCreated = YES;
        
        [self initGestures];
        
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

-(void)initBallDrop
{
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    SKAction *releaseBalls = [SKAction sequence:@[[SKAction performSelector:@selector(createBallNodeAtLocation:) onTarget:self], [SKAction waitForDuration:4]]];
    [self runAction: [SKAction repeatActionForever:releaseBalls]]; //[SKAction repeatAction:releaseBalls count:self.ballCount]];
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    if ((contact.bodyA.categoryBitMask == floorCategory)
        && (contact.bodyB.categoryBitMask == ballCategory))
    {
        CGPoint contactPoint = contact.contactPoint;
        
        float contact_y = contactPoint.y;
        float target_y = secondNode.position.y;
        float margin = secondNode.frame.size.height/2 - 25;
        
        if ((contact_y > (target_y - margin)) &&
            (contact_y < (target_y + margin)))
        {
            NSLog(@"Collision");
            [SKAction playSoundFileNamed:@"Cymbols1" waitForCompletion:YES];
        }
        
        [self runAction:[SKAction playSoundFileNamed:@"background-music-aac.caf" waitForCompletion:NO]];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    
}

-(void)createInstument: (NSUInteger) index
{
    [self createTonePad:index AtLocation: CGPointMake(300, 300)];
}

-(void) createBallNodeAtLocation: (CGPoint) location
{
    SKSpriteNode *ball = [[SKSpriteNode alloc]initWithImageNamed:@"Ball"];
    
    ball.name = @"ballNode";
    ball.position = CGPointMake(self.size.width/2, self.size.height);
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(ball.size.width/2)-7];
    ball.physicsBody.usesPreciseCollisionDetection = YES;
    ball.physicsBody.restitution = 0.7f;
    
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask = floorCategory;
    ball.physicsBody.collisionBitMask = ballCategory | floorCategory;
    
    [self addChild:ball];
}

-(void) createTonePad
{
    [self createBallNodeAtLocation:CGPointMake(100, 0)];
}

-(void) createTonePad: (NSUInteger) index AtLocation: (CGPoint) location
{
    SKSpriteNode *tonePad = [[SKSpriteNode alloc]initWithImageNamed: [NSString stringWithFormat:@"Box%d", index+1]]; //[[SKSpriteNode alloc]initWithColor:[UIColor blackColor] size:CGSizeMake(50, 5)];
    
    tonePad.name = kInstrumentNode;
    tonePad.position = location;
    
    tonePad.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tonePad.size];
    tonePad.physicsBody.usesPreciseCollisionDetection = YES;
    tonePad.physicsBody.affectedByGravity = NO;
    tonePad.physicsBody.dynamic = NO;
    tonePad.physicsBody.restitution = 0.0;
    
    tonePad.physicsBody.categoryBitMask = floorCategory;
    tonePad.physicsBody.contactTestBitMask = ballCategory;
    tonePad.physicsBody.collisionBitMask = ballCategory | floorCategory;
    
    [self addChild:tonePad];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"ballNode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         if (node.position.y < 0){
            [self createBallNodeAtLocation:CGPointZero];
            [node removeFromParent];
         }
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - Gesture Recognizers

#define WIGGLE 1.5
- (void)selectNodeForTouch:(CGPoint)touchLocation {
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
	if(![self.selectedNode isEqual:touchedNode] && [touchedNode containsPoint:touchLocation]) {
		[self.selectedNode removeAllActions];
        
		self.selectedNode = touchedNode;
		if([[touchedNode name] isEqualToString:kInstrumentNode]) {
			SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
													  [SKAction rotateByAngle:0.0 duration:0.1],
													  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
			[self.selectedNode runAction:[SKAction repeatAction:sequence count:WIGGLE]];
		}
	}
//    else{
//        self.selectedNode = nil;
//    }
}

-(void)handlePan:(UIPanGestureRecognizer*)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [self convertPointFromView:touchLocation];
        [self selectNodeForTouch:touchLocation];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = CGPointMake(translation.x, -translation.y); // Must invert translation for SpriteKit
        
        CGPoint position = [self.selectedNode position];
        [self.selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        
        [recognizer setTranslation:CGPointZero inView:recognizer.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
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
//        self.selectedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
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
//        self.selectedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        [self selectNodeForTouch:touchLocation];
    }
    
    self.selectedNode.xScale = recognizer.scale;
    self.selectedNode.yScale = recognizer.scale;
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        recognizer.scale = 1.0f;
    }
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
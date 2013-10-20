//
//  DPMyScene.h
//  dropBeats
//

//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "InstrumentNode.h"
#import "DPGame.h"

typedef void (^DPSceneCompletionHandler)(void);

@interface DPMyScene : SKScene

@property (strong, nonatomic) DPGame* game;


-(void) createBallNodeAtLocation: (CGPoint) location;
-(void) createInstrument: (int) index AtLocation: (CGPoint) location;

-(void)handlePan:(UIPanGestureRecognizer*)recognizer;

+(void)loadEverythingYouCanWithCompletionHandeler: (DPSceneCompletionHandler) handler;

@end

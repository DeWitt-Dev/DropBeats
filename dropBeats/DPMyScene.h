//
//  DPMyScene.h
//  dropBeats
//

//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "InstrumentNode.h"

@interface DPMyScene : SKScene

@property (nonatomic) BOOL play; 

-(void) createBallNodeAtLocation: (CGPoint) location;
-(void) createInstrument: (int) index AtLocation: (CGPoint) location;

-(void)handlePan:(UIPanGestureRecognizer*)recognizer;

@end

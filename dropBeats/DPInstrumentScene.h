//
//  DPMyScene.h
//  dropBeats
//

//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPTrackScene.h"
typedef void (^DPSceneCompletionHandler)(void);

@interface DPInstrumentScene : DPTrackScene

//designated initilizer
-(id)initWithSize:(CGSize)size game: (DPGame*) game andInstrumentSize: (CGSize) instrumentSize;
+(void)loadEverythingYouCanWithCompletionHandeler: (DPSceneCompletionHandler) handler;

-(void) createBall;
-(void) dropBall; 
-(void) createInstrument: (int) index AtLocation: (CGPoint) location;
-(void)clearGame;

-(void)handlePan:(UIPanGestureRecognizer*)recognizer; //recieved from collectionVeiw

@end

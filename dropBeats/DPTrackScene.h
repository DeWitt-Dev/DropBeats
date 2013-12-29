//
//  DPTrackView.h
//  dropBeats
//
//  Created by Michael Dewitt on 11/2/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DPGame.h"

@interface DPTrackScene : SKScene
{
    #define ALPHA_BACKGROUND 0.6f
    #define ZFLOOR 10
}

@property (strong, nonatomic) DPGame* game; //controlled by ViewController
@property (strong, nonatomic) DPSong* playedSong;
@property SKLabelNode* gameLabel;

@property BOOL sceneCreated;

//designated initilizer
-(id)initWithSize:(CGSize)size game: (DPGame*) game;

- (void)DPNotePlayed:(DPNote*) note;
- (void)checkGameStatus;
-(void)clearGame;

-(void)gameStarted: (NSNotification*) notification;
-(void)gameReset: (NSNotification*) notification;
-(void)gameEnded: (NSNotification *) notification;

@end

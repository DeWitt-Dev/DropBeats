//
//  DPGame.h
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPMusicFolder.h"

@class DPNoteNode;

typedef enum {
    kHard,
    kMedium,
    kEasy
} Difficulty;

//Notification Strings
static NSString* const gameStartNotification = @"gameStarted";
static NSString* const gameResettNotification = @"gameReset";
static NSString* const gameEndNotification = @"gameEnded";


@interface DPGame : NSObject


#define PERCENT_TO_WIN 0.75

@property (strong, nonatomic, readonly) DPSong* song;
@property NSInteger songNum;

@property (nonatomic) Difficulty difficulty;

@property (nonatomic, getter = isInProgress) BOOL inProgress;
@property (nonatomic, getter = isComplete) BOOL gameComplete; //Yes when game has been won
@property (strong, nonatomic) NSDate* startDate;

//designated init
-(id)initWithSongNumber:(NSInteger) songNum andDifficulty: (Difficulty) difficulty;
-(id)initWithSong:(DPSong*) song andDifficulty: (Difficulty) difficulty;

-(void)addNoteNode: (DPNoteNode*) node;
-(float)percentComplete;

-(void)startGame;
-(void)resetGame;
-(void)endGame;

@end

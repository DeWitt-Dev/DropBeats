//
//  DPGame.h
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPSong.h"

@interface DPGame : NSObject

#define PERCENT_TO_WIN 0.6

typedef enum {
    kHard,
    kMedium,
    kEasy
} Difficulty;

@property (strong, nonatomic) DPSong* song;
@property (nonatomic) Difficulty difficulty;

@property (nonatomic, getter = isInProgress) BOOL inProgress;
@property (nonatomic, getter = isComplete) BOOL gameComplete; //Yes when game has been won
@property (strong, nonatomic) NSDate* startDate;

//designated init
-(id)initWithSong:(DPSong*) song;
-(id)initWithSong:(DPSong*) song andDifficulty: (Difficulty) difficulty;

-(void)startGame;
-(void)resetGame;
-(void)endGame;

-(float)percentCompleteWith:(DPSong*) song;
@end

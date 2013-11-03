//
//  DPGame.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPGame.h"

@interface DPGame()
@end

@implementation DPGame

-(id)initWithSong:(DPSong*) song
{
    if (self = [super init]) {
        self.song = song;
        self.difficulty = kEasy;
    }
    return self;
}

-(id)initWithSong:(DPSong*) song andDifficulty: (Difficulty) difficulty
{
    if (self = [self initWithSong:song]) {
        self.difficulty = difficulty;
    }
    return self;
}

-(void)startGame
{
    self.startDate = [NSDate date];
    self.inProgress = YES;

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"gameStarted"
     object:nil ];
}

-(void)resetGame
{
    self.startDate = [NSDate date];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"gameReset"
     object:nil ];
    
    self.inProgress = YES;
}

-(void)endGame
{
    self.inProgress = NO;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"gameEnded"
     object:nil ];
}

-(float)percentCompleteWith:(DPSong*) usersSong;
{
    float percent = 0;

    if ([[self.song getNotes] count] == [[usersSong getNotes] count]) {
        for (int i = 0; i < [[self.song getNotes] count]; i++)
        {
            DPNote* songNote = [[self.song getNotes] objectAtIndex:i];
            DPNote* userNote = [[usersSong getNotes] objectAtIndex:i];
            
            if (songNote.type == userNote.type
                && songNote.freq == userNote.freq) {
             
                float sTime = [songNote time];
                float uTime = [userNote time];
                
                float sTimeLow = sTime - self.difficulty;
                float sTimeHigh = sTime + self.difficulty;
                
                if (sTimeLow <= uTime && uTime <= sTimeHigh)
                {
                    percent += 1.0/[[self.song getNotes]count];
                }
            }
        }
    }
    
    [usersSong clearNotes];
    
    return percent;
}
@end

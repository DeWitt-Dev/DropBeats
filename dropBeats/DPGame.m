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

-(float)percentCompleteWith:(DPSong*) song comparingToSong: (DPSong*) usersSong;
{
    float percent = 0;

    if ([[song getNotes] count] == [[usersSong getNotes] count]) {
        for (int i = 0; i < [[song getNotes] count]; i++)
        {
            DPNote* sNote = [[song getNotes] objectAtIndex:i];
            DPNote* uNote = [[song getNotes] objectAtIndex:i];
            
            float sTime = [sNote time];
            float uTime = [uNote time]; //[[uNote played] timeIntervalSinceDate:self.startDate] / [song duration];
            
            float sTimeLow = sTime - [sNote tolerance];
            float sTimeHigh = sTime + [sNote tolerance];
            
            if (sTimeLow <= uTime && uTime <= sTimeHigh && sNote.type == uNote.type)
            {
                percent += 1- 1/[[song getNotes]count];
            }
        }
    }
    
    [usersSong clearNotes];
    
    return percent;
}
@end

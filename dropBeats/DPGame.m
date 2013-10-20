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

-(void)startGame;
{
    self.startDate = [NSDate date];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"gameStarted"
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

@end

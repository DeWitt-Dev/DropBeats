//
//  DPGame.h
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPGame : NSObject

@property (nonatomic, getter = isInProgress) BOOL inProgress;
@property (strong, nonatomic) NSDate* startDate;

-(void)startGame;
-(void)endGame;

@end

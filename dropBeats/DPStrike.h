//
//  DPStrike.h
//  dropBeats
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNote.h"
#import "InstrumentNode.h"

@interface DPStrike : NSObject

@property (nonatomic) NSDate* time;
@property (nonatomic) DPNote* note;

+ (instancetype) strikeAtTime: (NSDate*) time withNote: (DPNote*) note;


@end

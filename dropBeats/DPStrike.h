//
//  DPStrike.h
//  dropBeats
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNote.h"

@interface DPStrike : NSObject

@property (nonatomic) NSDate* time;
@property (nonatomic) NoteType type;

+ (instancetype) strikeAtTime: (NSDate*) time fromType: (NoteType) type;


@end

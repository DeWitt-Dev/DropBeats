//
//  DPStrike.m
//  dropBeats
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPStrike.h"

@implementation DPStrike

+ (instancetype) strikeAtTime: (NSDate*) time fromType: (NoteType) type
{
    return [[self alloc] initWithTime: time fromType:type];
}

- (id) initWithTime: (NSDate*) time fromType: (NoteType) type
{
    self = [super init];
    self.time = time;
    self.type = type;
    
    return self;
}

@end

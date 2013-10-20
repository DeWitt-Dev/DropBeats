//
//  DPStrike.m
//  dropBeats
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPStrike.h"

@implementation DPStrike

+ (instancetype) strikeAtTime: (NSDate*) time withNote: (DPNote*) note
{
    return [[self alloc] initWithTime: time withNote:note];
}

- (id) initWithTime: (NSDate*) time withNote: (DPNote*) note
{
    self = [super init];
    self.time = time;
    self.note = note;
    
    return self;
}

@end

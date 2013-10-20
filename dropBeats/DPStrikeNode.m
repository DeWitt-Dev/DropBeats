//
//  DPStrikeNode.m
//  dropBeats
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPStrikeNode.h"

@implementation DPStrikeNode

+ (instancetype) strike: (DPStrike*) strike
{
    return [[self alloc] initWithStrike:strike];
}

- (id) initWithStrike: (DPStrike*) strike
{
    self = [super initWithColor:[UIColor redColor] size: CGSizeZero];
    
    if (self)
    {
        self.strike = strike;
        self.anchorPoint = CGPointZero;
        self.name = @"strikenode";
        CGSize size = CGSizeMake(160, 2);
        self.size = size;
    }
    
    return self;
}

@end

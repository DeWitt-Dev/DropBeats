//
//  DPStrikeNode.m
//  dropBeats
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPStrikeNode.h"

#define W_LOW 100
#define W_MID 175
#define W_HIGH 250

@implementation DPStrikeNode

+ (instancetype) strike: (DPStrike*) strike
{
    return [[self alloc] initWithStrike:strike];
}

- (id) initWithStrike: (DPStrike*) strike
{
    NSInteger height = 25;
    NSInteger width = 0;
    
    
    self = [super initWithColor:[UIColor redColor] size: CGSizeZero];
    
    NSLog(@"--- initWithStrike");
    if (self)
    {
        NSLog(@"-- switch:");
        switch ([[strike note] freq])
        {
            case kLowFrequency:
                NSLog(@"low freq");
                width = W_LOW;
                break;
            case kMidFrequency:
                NSLog(@"mid freq");
                width = W_MID;
                break;
            case kHighFrequency:
                NSLog(@"high freq");
                width = W_HIGH;
                break;
            case kNone:
            default:
                NSLog(@"no freq");
                width = 0;
        }
        
        switch ([[strike note] type]) {
            case kBass:
                self.color = [UIColor blueColor];
                break;
            case kSnare:
                self.color = [UIColor orangeColor];
                break;
            case kCymbol:
                self.color = [UIColor yellowColor];
                break;
            case kGuitar:
                self.color = [UIColor purpleColor];
                break;
        }
        

        self.strike = strike;
        self.anchorPoint = CGPointMake(0, self.frame.size.height/2);
        self.name = @"strikenode";
        CGSize size = CGSizeMake(width, height);
        self.size = size;
    }
    
    return self;
}

@end

//
//  DPStrikeNode.h
//  dropBeats
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DPStrike.h"

@interface DPStrikeNode : SKSpriteNode

@property (nonatomic) DPStrike* strike;

+ (instancetype) strike: (DPStrike*) strike;

@end

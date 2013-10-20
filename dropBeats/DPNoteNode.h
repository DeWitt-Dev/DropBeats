//
//  DPNote.h
//  BackDrop
//
//  Created by Spencer Lewson on 10/19/13.
//  Copyright (c) 2013 slewson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "DPNote.h"

@interface DPNoteNode : SKSpriteNode

@property (nonatomic) CGRect crd;
@property (nonatomic) DPNote* note;
@property (nonatomic) BOOL animate; 

+ (instancetype) noteNodeWithNote: (DPNote*) note;

@end

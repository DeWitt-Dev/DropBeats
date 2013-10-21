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

typedef enum{
    SideLeft,
    SideRight
}Side;

@property (nonatomic) CGRect crd;
@property (nonatomic) DPNote* note;
@property (nonatomic) Side side; 
@property (nonatomic) BOOL animate; 

+ (instancetype) noteNodeWithNote: (DPNote*) note onSide:(Side) side animate: (BOOL) animate;

@end

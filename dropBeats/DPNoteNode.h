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
@property (weak, nonatomic) DPNote* note;
@property (nonatomic) CGFloat tolerance;
@property (nonatomic) Side side;
@property (nonatomic) BOOL animate; 

+ (instancetype) noteNodeWithNote: (DPNote*) note tolerance: (CGFloat) tolerance onSide:(Side) side animate: (BOOL) animate;
- (void) drawNoteNodeWithReferenceSize: (float) viewWidth;
-(UIColor*)resetNodeColor;

@end

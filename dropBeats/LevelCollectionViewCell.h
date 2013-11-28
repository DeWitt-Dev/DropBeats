//
//  LevelCollectionViewCell.h
//  dropBeats
//
//  Created by Michael Dewitt on 11/8/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPTrackScene.h"

@interface LevelCollectionViewCell : UICollectionViewCell

-(void)prepareSceneWithGame: (DPGame*)game;
@property (strong, nonatomic, readonly) DPTrackScene* levelScene;

@end

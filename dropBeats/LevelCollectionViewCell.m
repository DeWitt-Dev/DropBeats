//
//  LevelCollectionViewCell.m
//  dropBeats
//
//  Created by Michael Dewitt on 11/8/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "LevelCollectionViewCell.h"

@interface LevelCollectionViewCell()

@property (strong, nonatomic) IBOutlet SKView *levelView;
@property (strong, nonatomic, readwrite) DPTrackScene* levelScene;

@end

@implementation LevelCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)prepareSceneWithGame: (DPGame*)game
{
    if (!self.levelScene || ![game isEqual: self.levelScene.game]) {
        self.levelScene = [[DPTrackScene alloc] initWithSize:self.bounds.size game:game];
        self.levelScene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.levelView presentScene:self.levelScene];
        }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

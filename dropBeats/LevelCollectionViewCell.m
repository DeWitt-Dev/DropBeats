//
//  LevelCollectionViewCell.m
//  dropBeats
//
//  Created by Michael Dewitt on 11/8/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "LevelCollectionViewCell.h"

@interface LevelCollectionViewCell()

@property (nonatomic, strong, readwrite) DPGame* game;
@property (strong, nonatomic) IBOutlet SKView *levelView;
@property (strong, nonatomic) SKScene* levelScene;

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

-(void)layoutSubviews
{
}

-(void)prepareSceneWithGame: (DPGame*)game
{
    if (!self.levelScene || ![game isEqual:self.game]) {
        self.levelScene = [[DPTrackScene alloc] initWithSize:self.bounds.size game:game];
        self.levelScene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [self.levelView presentScene:self.levelScene];
        
        self.game = game;
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

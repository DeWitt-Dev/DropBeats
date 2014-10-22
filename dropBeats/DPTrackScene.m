//
//  DPTrackView.m
//  dropBeats
//
//  Created by Michael Dewitt on 11/2/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPTrackScene.h"
#import "DPNoteNode.h"
#import "DPNote.h"
#import "DPSong.h"

@interface DPTrackScene()
{
    //Would be contants, but depends on device
    float VERTICAL_OFFSET_FACTOR;
    float SIZE_FACTOR;
}
@property SKSpriteNode* tick;

- (void) removeStrikes;
-(void) removeTick;
@end

static NSString* const kGameLabel = @"gameLabelNode";

@implementation DPTrackScene

-(id)initWithSize:(CGSize)size game: (DPGame*) game
{
    if (self = [super initWithSize:size]) {
        self.game = game;
        self.backgroundColor = [UIColor whiteColor];

        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    SIZE_FACTOR = IS_IPAD ? 0.85 : 0.75;
    VERTICAL_OFFSET_FACTOR = IS_IPAD ? 0.05 : 0.15;
    
    //Resister for Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameEnded:) name:gameEndNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameStarted:) name:gameStartNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameReset:) name:gameResettNotification object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didMoveToView:(SKView *)view
{
    if (!self.sceneCreated) {
        
        //Background Notes
        [self drawDivider];
        [self displayNoteNodes: self.game.song];
        
        self.sceneCreated = YES;
    }
}

- (void)displayNoteNodes:(DPSong*) song
{
    float songLength = song.duration;

    for (int mNum=0 ; mNum < [song.measures count]; mNum++)
    {
        DPMeasure* measure = song.measures[mNum];

        for (int noteNum=0; noteNum < song.signature.beatsPerMeasure; noteNum++) {
            
//            double delayInSeconds = 0.2f * ++mNum;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
//FIXME: No idea what's happening here. 
            DPNote* note = [measure.notes objectAtIndex:noteNum];
            
            if (note.type != kRest) {
                float time = (((mNum * song.signature.beatsPerMeasure) + noteNum)*60)/song.tempo;
                
                DPNoteNode* node =[DPNoteNode noteNodeWithNote:note time:time/songLength
                                                    difficulty:self.game.difficulty onSide:SideLeft animate:YES];
                [self placeNoteNode:node];
                }
//            });
        }
    }
}

#pragma mark - Background Track

- (void) drawDivider
{
    float adjustedHeight = SIZE_FACTOR * self.frame.size.height;
    CGSize size = CGSizeMake(3, adjustedHeight);
    
    UIColor* color = [[UIColor blackColor] colorWithAlphaComponent: BACKGROUND_ALPHA];
    SKSpriteNode* divider = [[SKSpriteNode alloc] initWithColor:color size: size];
    divider.alpha = BACKGROUND_ALPHA;
    
    divider.anchorPoint = CGPointMake(0, 0);
    divider.position = CGPointMake(self.frame.size.width /2, VERTICAL_OFFSET_FACTOR * self.frame.size.height);
    divider.zPosition = ZFLOOR;
    [self addChild:divider];
    
    //Add game Perctage Tracker
    self.gameLabel = [[SKLabelNode alloc]init];
    self.gameLabel.name = kGameLabel;
    self.gameLabel.fontColor = color;
    self.gameLabel.position = CGPointMake(self.frame.size.width /2, divider.position.y - 35);
    self.gameLabel.zPosition = ZFLOOR;
    
    [self addChild:self.gameLabel];
}

- (void) startTick
{
    [self drawTickWithCompletionHandler:^{}];
    float bottomOffset = VERTICAL_OFFSET_FACTOR * self.frame.size.height;
    
    CGPoint point2 = CGPointMake(self.frame.size.width/2, bottomOffset);
    SKAction* moveTo = [SKAction moveTo:point2 duration:self.game.song.duration];
    
    [moveTo setTimingMode:SKActionTimingLinear];
    [self.tick runAction:moveTo];
}

- (void) drawTickWithCompletionHandler:(void (^) (void)) completion
{
    float adjustedHeight = SIZE_FACTOR * self.frame.size.height;
    float bottomOffset = VERTICAL_OFFSET_FACTOR * self.frame.size.height;
    
    CGSize size = CGSizeMake(35, 5);
    
    UIColor* color = [[UIColor blackColor] colorWithAlphaComponent: BACKGROUND_ALPHA];
    self.tick.alpha = BACKGROUND_ALPHA;
    self.tick = [[SKSpriteNode alloc] initWithColor: color size: size];//CGSizeMake(0, size.height)];
    self.tick.position = CGPointMake(self.frame.size.width / 2, adjustedHeight + bottomOffset);
    self.tick.zPosition = ZFLOOR - 1;
    self.tick.name = @"ticknode";
    [self addChild: self.tick];
    
    
    float animationTime = 0.25f;
    self.tick.size = CGSizeMake(0, size.height);
    SKAction* correctSizeW = [SKAction resizeToWidth:size.width duration:animationTime];
    [self.tick runAction:correctSizeW completion:^{
        self.tick.size = size;
        dispatch_async(dispatch_get_main_queue(), completion);
    }];
}

- (void) removeStrikes
{
    [self enumerateChildNodesWithName:@"notenode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         DPNoteNode* noteNode = (DPNoteNode*)node;
         if (noteNode.side == SideRight) {
             [node removeFromParent];
         }
     }];
}

-(void) removeTick
{
    [self enumerateChildNodesWithName:@"ticknode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         [node removeFromParent];
     }];
}

#pragma mark - DPNoteNode

- (void)notePlayed:(DPNote*) note
{
    float time = -[self.game.startDate timeIntervalSinceNow] / self.game.song.duration;
    
    if (time <= 1.0) { //1.0 representing percentage of song, must be normalized
        
        DPNoteNode* node = [DPNoteNode noteNodeWithNote:note time:time difficulty:self.game.difficulty onSide:SideRight animate:YES];
        [self placeNoteNode:node];
    }
    else{
        [self removeTick];
    }
    
    //update label
    self.gameLabel.text = [NSString stringWithFormat: @"%10.0f%%", [self.game percentComplete]];
}

-(void)placeNoteNode:(DPNoteNode*) node //helper method for placing logic
{
    float x = (node.side == SideLeft) ? CGRectGetMidX(self.frame) - node.size.width : CGRectGetMidX(self.frame) + 3;

    float y;
    if ([self.game isInProgress]) {
        y = self.tick.position.y; //most acurate way to ensure tick displays at correct position
    }
    else {
        float dividerHeight = SIZE_FACTOR * self.frame.size.height;
        float bottomOffset = VERTICAL_OFFSET_FACTOR * self.frame.size.height;
        y = (1 - node.time) * dividerHeight + bottomOffset;
    }
    
    [self addChild:node];
    
    //Height adjustment
    float nodeHeight = [node setupNoteNodeWithReferenceSize:self.size.width];
    y -= nodeHeight/2;
    [node setPosition:CGPointMake(x, y)];

    //THIS IS CRUCIAL, game keeps track of nodes and notes for comparision
    [self.game addNoteNode:node];
}

#pragma mark - Game notifications

-(void)gameStarted: (NSNotification*) notification
{
    [self gameReset:nil];
    self.gameLabel.text = @"";
}

-(void)gameReset: (NSNotification*) notification //when the ball leaves the screen
{
    [self removeStrikes];
    [self removeTick];
    self.gameLabel.text = @"";

    [self startTick];
}

-(void)gameEnded: (NSNotification *) notification
{
    [self removeTick];
    self.gameLabel.text = @"";
}

#pragma mark - Game Status/ AlertView

-(void)checkGameStatus
{
    if (![self.game isComplete]) {
        [self.game resetGame];
    }
    else{
        self.gameLabel.text = [NSString stringWithFormat:@"%@%%! Next Level?", self.gameLabel.text];
        [self.view addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextLevel:)]];
    }
}

- (void)nextLevel: (UITapGestureRecognizer*)recognizer
{
    CGPoint touchLocation = [recognizer locationInView:self.view];
    touchLocation = [self convertPointFromView:touchLocation];
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint: touchLocation];
    
    if([[touchedNode name] isEqualToString:kGameLabel]) {
        
        if ([self.game isComplete]) {
            [self.game endGame];
            self.game = [[DPGame alloc]initWithSongNumber: ++self.game.songNum andDifficulty:self.game.difficulty];
            [self displayNoteNodes:self.game.song];
        }
        else{
            [self.game resetGame];
        }
    }
}

@end

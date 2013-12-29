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
    #define SIZE_FACTOR 0.85
    #define VERTICAL_OFFSET_FACTOR 0.05
}
@property SKSpriteNode* tick;
@end

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
    //Resister for Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameEnded:) name:@"gameEnded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameStarted:) name:@"gameStarted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameReset:) name:@"gameReset" object:nil];
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
        [self displaySong: self.game.song];
        
        self.playedSong = [[DPSong alloc]init];

        self.sceneCreated = YES;
    }
}

- (void) displaySong: (DPSong*) song
{
    self.game.song = song;
    
    int i = 0;
    for (DPNote* dpnote in [song getNotes])
    {
        double delayInSeconds = 0.1f * ++i;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self drawDPNote:dpnote onSide:SideLeft];
        });
    }
}

#pragma mark - Background Track
- (void) drawDivider
{
    float adjustedHeight = SIZE_FACTOR * self.frame.size.height;
    CGSize size = CGSizeMake(3, adjustedHeight);
    
    UIColor* color = [[UIColor blackColor] colorWithAlphaComponent: ALPHA_BACKGROUND];
    SKSpriteNode* divider = [[SKSpriteNode alloc] initWithColor:color size: size];
    divider.alpha = ALPHA_BACKGROUND;
    
    divider.anchorPoint = CGPointMake(0, 0);
    divider.position = CGPointMake(self.frame.size.width /2, 0.05 * self.frame.size.height);
    divider.zPosition = ZFLOOR;
    [self addChild:divider];
    
    //Add game Perctage Tracker
    self.gameLabel = [[SKLabelNode alloc]init];
    self.gameLabel.fontColor = color;
    self.gameLabel.position = CGPointMake(self.frame.size.width /2, 60);
    self.gameLabel.zPosition = ZFLOOR;
    
    [self addChild:self.gameLabel];
}

- (void) startTick
{
    [self drawTickWithCompletionHandler:^{}];
    //float adjustedHeight = 0.85 * self.frame.size.height;
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
    
    UIColor* color = [[UIColor blackColor] colorWithAlphaComponent: ALPHA_BACKGROUND];
    self.tick.alpha = ALPHA_BACKGROUND;
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

- (void)DPNotePlayed:(DPNote*) note
{
    [self.playedSong addNote:note];
    
    //update label
    float percentComplete = [self.game percentCompleteWith: self.playedSong];
    self.gameLabel.text = [NSString stringWithFormat: @"%10.0f%%", percentComplete];

    if (note.time <= 1.0) { //must be normalized
        
        //TODO: This logic should be handeled with drawDPNOT
        DPNoteNode* node = [DPNoteNode noteNodeWithNote:note tolerance: self.game.difficulty onSide:SideRight animate:YES];
                            
        //Placing logic
        //float x = 0 ? CGRectGetMidX(self.frame) - [node size].width : CGRectGetMidX(self.frame);
        float x = CGRectGetMidX(self.frame) + 3;
        float y = (note.time * (SIZE_FACTOR * self.frame.size.height)) + (VERTICAL_OFFSET_FACTOR * self.frame.size.height);
        
        if (y > self.view.bounds.size.height * 0.5f) {
            [node setPosition: CGPointMake(x, y)];
            [self addChild:node];
        }
    }
    else
    {
        [self endStrikes]; //After the song is over
    }
}

- (void) drawDPNote: (DPNote*) note onSide: (NSInteger) side
{
    float adjustedHeight = SIZE_FACTOR * self.frame.size.height;
    DPNoteNode* node = [DPNoteNode noteNodeWithNote:note tolerance:self.game.difficulty onSide: SideLeft animate:YES];
                        
    float x = !side ? CGRectGetMidX(self.frame) - [node size].width : CGRectGetMidX(self.frame);
    float y = adjustedHeight * (1 -[[node note] time]) + (VERTICAL_OFFSET_FACTOR* self.frame.size.height);
    
    [node setPosition: CGPointMake(x, y + (VERTICAL_OFFSET_FACTOR * self.frame.size.height))];
    [self addChild:node];
}

- (void) endStrikes
{
    [self enumerateChildNodesWithName:@"notenode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         DPNoteNode* noteNode = (DPNoteNode*)node;
         if (noteNode.side == SideRight) {
             [node removeFromParent];
         }
     }];
    
    [self enumerateChildNodesWithName:@"ticknode" usingBlock:
     ^(SKNode *node,BOOL *stop) {
         [node removeFromParent];
     }];
}

#pragma mark - Game notifications
-(void)gameStarted: (NSNotification*) notification
{
    [self gameReset:nil];
    self.gameLabel.text = @"-";
}

-(void)gameReset: (NSNotification*) notification //when the ball leaves the screen
{
    [self endStrikes];
    [self startTick];
}

-(void)gameEnded: (NSNotification *) notification
{
    [self endStrikes];
}

#pragma mark - Game Status/ AlertView
-(void)checkGameStatus
{
    if (!self.game.isComplete) {
        [self.playedSong clearNotes];
        [self.game resetGame];
    }
    else{
        self.gameLabel.text = [NSString stringWithFormat:@"%@%%! Next Level?", self.gameLabel.text];
        [self.view addGestureRecognizer: [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextLevel:)]];
    }
}

- (void)nextLevel: (UITapGestureRecognizer*)recognizer
{
//    if (recognizer) {
//        [self.game endGame];
//        [self clearGame];
//    }
//    else{
//        [self.game resetGame];
//    }
}
-(void)clearGame{
    [self.playedSong clearNotes];
}

@end

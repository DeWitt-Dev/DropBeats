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

@interface DPTrackScene()<UIAlertViewDelegate>
@property SKSpriteNode* tick;
@end

@implementation DPTrackScene

-(id)initWithSize:(CGSize)size game: (DPGame*) game
{
    if (self = [super initWithSize:size]) {
        self.game = game;
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

-(void)didMoveToView:(SKView *)view
{
    if (!self.sceneCreated) {
        
        self.backgroundColor = [UIColor whiteColor];
        //Background Notes
        [self drawDivider];
        [self drawTick];
        
        [self displaySong: self.game.song];
        self.sceneCreated = YES;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Background Music
- (void) drawDivider
{
    float adjustedHeight = 0.85 * self.frame.size.height;
    CGSize size = CGSizeMake(3, adjustedHeight);
    
    UIColor* color = [[UIColor blackColor] colorWithAlphaComponent: ALPHA_BACKGROUND];
    SKSpriteNode* divider = [[SKSpriteNode alloc] initWithColor:color size: size];
    divider.alpha = ALPHA_BACKGROUND;
    
    divider.anchorPoint = CGPointMake(0, 0);
    divider.position = CGPointMake(self.frame.size.width / 2, .05 * self.frame.size.height);
    divider.zPosition = ZFLOOR;
    [self addChild:divider];
}

- (void) drawTick
{
    float adjustedHeight = 0.85 * self.frame.size.height;
    float bottomOffset = 0.05 * self.frame.size.height;
    
    CGSize size = CGSizeMake(35, 5);
    
    UIColor* color = [[UIColor blackColor] colorWithAlphaComponent: ALPHA_BACKGROUND];
    self.tick.alpha = ALPHA_BACKGROUND;
    self.tick = [[SKSpriteNode alloc] initWithColor: color size: size];//CGSizeMake(0, size.height)];
    self.tick.position = CGPointMake(self.frame.size.width / 2, adjustedHeight + bottomOffset);
    self.tick.zPosition = ZFLOOR - 1;
    self.tick.name = @"ticknode";
    [self addChild: self.tick];
    
    
    //    float animationTime = 0.25f;
    //    SKAction* zeroMorph = [SKAction resizeToWidth:0 duration:0.0f];
    //    SKAction* correctSizeW = [SKAction resizeToWidth:size.width duration:animationTime];
    //
    //    SKAction* sequence = [SKAction sequence:@[zeroMorph, correctSizeW]];
    //
    //    [self runAction:sequence completion:^{
    //        self.tick.size = size;
    //    }];
}

- (void) startTick
{
    //float adjustedHeight = 0.85 * self.frame.size.height;
    float bottomOffset = 0.05 * self.frame.size.height;
    
    CGPoint point2 = CGPointMake(self.frame.size.width/2, bottomOffset);
    SKAction* moveTo = [SKAction moveTo:point2 duration:self.game.song.duration];
    
    [moveTo setTimingMode:SKActionTimingLinear];
    [self.tick runAction:moveTo];
}

- (void)DPNotePlayed:(DPNote*) note
{
    [self.playedSong addNote:note];

    if (note.time <= 1.0) { //must be normalized
        
        DPNoteNode* node = [DPNoteNode noteNodeWithNote:note tolerance: self.game.difficulty onSide:SideRight animate:YES];
                            
        //Placing logic
        //float x = 0 ? CGRectGetMidX(self.frame) - [node size].width : CGRectGetMidX(self.frame);
        float x = CGRectGetMidX(self.frame) + 3;
        float y = (note.time * (0.85 * self.frame.size.height)) + (.05 * self.frame.size.height);
        
        if (y > self.view.bounds.size.height*.05f) {
            [node setPosition: CGPointMake(x, y)];
            [self addChild:node];
        }
        
    }
    else
    {
        [self endStrikes]; //After the song is over
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
    
    self.playedSong = [[DPSong alloc]init];
}

- (void) drawDPNote: (DPNote*) note onSide: (NSInteger) side
{
    float adjustedHeight = .85 * self.frame.size.height;
    DPNoteNode* node = [DPNoteNode noteNodeWithNote:note tolerance:self.game.difficulty onSide: SideLeft animate:YES];
                        
    float x = !side ? CGRectGetMidX(self.frame) - [node size].width : CGRectGetMidX(self.frame);
    float y = adjustedHeight * (1 -[[node note] time]) + (.05 * self.frame.size.height);
    
    [node setPosition: CGPointMake(x, y + (0.05 * self.frame.size.height))];
    [self addChild:node];
}

-(void)checkGameStatus
{
    float percentComplete = [self.game percentCompleteWith: self.playedSong];
    if (PERCENT_TO_WIN > percentComplete) {
        [self.game resetGame];
    }
    else{
        NSString* message = [NSString stringWithFormat:@"Congatulations %d percent!\n Next Level?", (int)(percentComplete*100)];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message: message delegate:self cancelButtonTitle:@"Try Again?" otherButtonTitles:@"Next Level", nil];
        alert.delegate = self;
        [alert show];
    }
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
    [self drawTick];
}

#pragma mark - Game notifications
-(void)gameStarted: (NSNotification*) notification
{
    [self gameReset:nil];
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

#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        [self.game endGame];
        [self clearGame];
    }
    else{
        [self.game resetGame];
    }
}
-(void)clearGame{}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

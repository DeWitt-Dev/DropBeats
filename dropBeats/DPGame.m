//
//  DPGame.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPGame.h"
#import "DPNoteNode.h"

@interface DPGame()

//Using userNodes to compare to init song

@property (strong, nonatomic, readwrite) DPSong* song;
@property (strong, nonatomic) NSMutableArray* songNodes;
@property (strong, nonatomic) NSMutableArray* userNodes;

@property float tolerance;

@end

@implementation DPGame

-(id)initWithSongNumber:(NSInteger) songNum andDifficulty: (Difficulty) difficulty
{
    self.songNum = songNum;
    return [self initWithSong: [DPMusicFolder getSongByNumber: songNum] andDifficulty: difficulty];
}

-(id)initWithSong:(DPSong*) song andDifficulty: (Difficulty) difficulty;
{
    if (self = [super init]) {
        //[song printSong];
        self.song = song;
        self.difficulty = difficulty;
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    self.tolerance = (self.difficulty + 1.0)/ 10.0;
    self.songNodes = [[NSMutableArray alloc]initWithCapacity:10];
    self.userNodes = [[NSMutableArray alloc]initWithCapacity:10];
}

-(void)addNoteNode: (DPNoteNode*) node
{
    if (node.side == SideLeft) //song node
    {
        [self.songNodes addObject:node];
    }
    else if (node.side == SideRight) //user node
    {
        [self.userNodes addObject:node];
        
        [self compareNodes];
    }
}

-(void)compareNodes
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        NSUInteger count = [self.songNodes count] < [self.userNodes count] ?
        [self.songNodes count] : [self.userNodes count];
        
        if (count > 0) {
            DPNoteNode* songNode = [self.songNodes objectAtIndex:count - 1];
            DPNoteNode* userNode = [self.userNodes lastObject];
            
            if ([songNode.note isEqualToNote:userNode.note]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    songNode.color = [UIColor greenColor];
                    userNode.color = [UIColor greenColor];
                });
            }
        }
    });
}

-(float)percentComplete
{
    //FIXME: Assumes notes are in chronological order. This is not necessarily a good assumption but checking every note would make this an O2...

//    float fractionComplete = 0.0f;
//    NSUInteger count = [[self.song measures]count] < [[self.usersSong measures]count] ?
//    [[self.song measures]count] : [[self.usersSong measures]count];
//    
//    for (int i = 0; i < count; i++)
//    {
//        DPNote* songNote = [[self.song measures] objectAtIndex:i];
//        DPNote* userNote = [[self.usersSong getNotes] objectAtIndex:i];
//
//        if ([songNote isEqualToNote:userNote withTolerance:self.tolerance]){
//                fractionComplete += 1.0/[[self.song getNotes]count];
//            }
//    }
//    
//    self.gameComplete = fractionComplete >= PERCENT_TO_WIN ? YES : NO;
//    
//    return fractionComplete * 100.0;
    
    return 0;
}

#pragma mark - Game Notifications

-(void)startGame
{
    [self commonReset];
    self.inProgress = YES;

    [[NSNotificationCenter defaultCenter]
     postNotificationName: gameStartNotification
     object:nil];
}

-(void)resetGame
{
    [self commonReset];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName: gameResettNotification
     object:nil ];
    
    self.inProgress = YES;
}

-(void)commonReset
{
    self.gameComplete = NO;
    
    [self.userNodes removeAllObjects];
    
    self.startDate = [NSDate date];
    
    for (DPNoteNode* node in self.songNodes) {
        [node resetNodeColor]; 
    }
}

-(void)endGame
{
    self.inProgress = NO;
    [[NSNotificationCenter defaultCenter]
     postNotificationName: gameEndNotification
     object:nil ];
}
@end

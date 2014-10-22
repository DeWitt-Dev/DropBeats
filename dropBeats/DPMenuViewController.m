//
//  DPMenuViewController.m
//  dropBeats
//
//  Created by Michael Dewitt on 11/8/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPMenuViewController.h"
#import "DPGameViewController.h"
#import "DBLevelCollectionViewCell.h"
#import "DPGame.h"
#import "DPMusicFolder.h"
#import "DPUpdater.h"

@interface DPMenuViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *levelCollectionView;

@end

@implementation DPMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.levelCollectionView.backgroundColor = [UIColor clearColor];
    
    //Update song Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkUpdate:) name:kSongsUpdateNotification object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MENU: MEM Warning");
}

#pragma mark - MenuCollectionView
-(void)networkUpdate:(NSNotification*)notificaiton
{
    [self.levelCollectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [DPMusicFolder numberOfSongs]; //number of levels
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const identifier = @"LevelCell";
    DBLevelCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    DPGame* game = [[DPGame alloc]initWithSongNumber:(int) indexPath.row + 1 andDifficulty:kEasy];
    [cell prepareSceneWithGame:game];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBLevelCollectionViewCell* cell = (DBLevelCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"playSegue" sender: cell];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DPGameViewController class]]) {
            
        DPGameViewController *dpgvc = (DPGameViewController*)segue.destinationViewController;
        
        if ([sender isKindOfClass:[DBLevelCollectionViewCell class]]) {
            DPGame *displayedGame = ((DBLevelCollectionViewCell*)sender).levelScene.game;
            dpgvc.game =  [[DPGame alloc] initWithSong: displayedGame.song andDifficulty:displayedGame.difficulty]; //initilizing new game.
        }
    }
}

#pragma mark - unwind
-(IBAction)backToMenu:(UIStoryboardSegue* )segue
{
    UIViewController* uivc = segue.sourceViewController;
    [uivc dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  DPMenuViewController.m
//  dropBeats
//
//  Created by Michael Dewitt on 11/8/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPMenuViewController.h"
#import "DPGameViewController.h"
#import "LevelCollectionViewCell.h"
#import "DPGame.h"

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MenuCollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [DPSong numberOfSongs]; //number of levels
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LevelCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LevelCell" forIndexPath:indexPath];
    
    DPGame* game = [[DPGame alloc]initWithSong:[DPSong getSong:indexPath.row+1
                                                  andDuration:10]];
    
    [cell prepareSceneWithGame:game];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LevelCollectionViewCell* cell = (LevelCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"playSegue" sender: cell];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqualToString:@"playSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[DPGameViewController class]]) {
            
            DPGameViewController* dpgvc = (DPGameViewController*)segue.destinationViewController;
            
            if ([sender isKindOfClass:[LevelCollectionViewCell class]]) {
                dpgvc.game = ((LevelCollectionViewCell*)sender).game;

            }
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

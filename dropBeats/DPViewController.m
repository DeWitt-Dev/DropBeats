//
//  DPViewController.m
//  dropBeats
//
//  Created by mmdewitt on 10/19/13.
//  Copyright (c) 2013 Michael Dewitt. All rights reserved.
//

#import "DPViewController.h"
#import "DPMyScene.h"
#import "InstrumentCell.h"
@import AVFoundation;

@interface DPViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

#define ANIMATION_DURATION 0.5
@property (weak, nonatomic) IBOutlet SKView *skView;
@property (strong, nonatomic) DPMyScene * scene;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation DPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsDrawCount = YES;
    
    // Create and configure the scene.
    self.scene = [DPMyScene sceneWithSize:self.skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.skView presentScene:self.scene];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //Init audio
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"background-music-aac" withExtension:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
//    [self.backgroundMusicPlayer prepareToPlay];
//    [self.backgroundMusicPlayer play];
}

#pragma mark - CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InstrumentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InstrumentCell" forIndexPath:indexPath];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    switch (indexPath.row) {
        case 0:
            [cell.imageView setImage:[UIImage imageNamed:@"Box1"]];
            break;
        case 1:
            [cell.imageView setImage:[UIImage imageNamed:@"Box2"]];
            break;
        case 2:
            [cell.imageView setImage:[UIImage imageNamed:@"Box3"]];
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.scene createInstument:indexPath.row];
}

- (IBAction)hideShowBanner:(UIButton *)sender {
    
    if (!self.displayBanner) {
        
        //Hiding banner
        [UIView animateWithDuration:ANIMATION_DURATION animations:
         ^{
             CGRect frame = self.bannerView.frame;
             frame.origin.x = -self.bannerView.bounds.size.width + 50; // to display button
             self.bannerView.frame = frame;
             
         } completion:nil];
        
        [sender setTitle:@">" forState:UIControlStateNormal];
    }
    else{
        [UIView animateWithDuration:ANIMATION_DURATION animations:
         ^{
             CGRect frame = self.bannerView.frame;
             frame.origin.x = 0;
             self.bannerView.frame = frame;
             
         } completion:nil];
        
        [sender setTitle:@"<" forState:UIControlStateNormal];
    }
    self.displayBanner = !self.displayBanner;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

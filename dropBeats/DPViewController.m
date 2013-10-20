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

@interface DPViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

#define ANIMATION_DURATION 0.5
@property (weak, nonatomic) IBOutlet SKView *skView;
@property (strong, nonatomic) DPMyScene * scene;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *hideShowButton;

@end

@implementation DPViewController

static NSString * const kInstrumentPrefix = @"Box";

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

}

#pragma mark - CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InstrumentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InstrumentCell" forIndexPath:indexPath];
    
    if (cell.panGesture == nil) {
        cell.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragInstrument:)];
        [cell addGestureRecognizer:cell.panGesture];
    }
    
    NSString* imageId = [NSString stringWithFormat:@"%@%d", kInstrumentPrefix, indexPath.row+1];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage* image = [UIImage imageNamed:imageId];
    [cell.imageView setImage: image];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.scene createInstrument:indexPath.row AtLocation:CGPointMake(300, 300)];
}
- (void)dragInstrument:(UIPanGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateBegan) {
        NSIndexPath* pathForInstrument = [self.collectionView indexPathForCell: (InstrumentCell*)sender.view];
        CGPoint start = [sender locationInView:self.scene.view];
        start.y = self.view.frame.size.height - start.y; 
        [self.scene createInstrument:pathForInstrument.row AtLocation:start];
    }
    
    [self.scene handlePan:sender];
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
        [self.scene createBallNodeAtLocation:CGPointZero];
    }
    else{
        [UIView animateWithDuration:ANIMATION_DURATION animations:
         ^{
             CGRect frame = self.bannerView.frame;
             frame.origin.x = 0;
             self.bannerView.frame = frame;
             
         } completion:nil];
        
        [sender setTitle:@"<" forState:UIControlStateNormal];
        self.scene.play = NO;
    }
    self.displayBanner = !self.displayBanner;
}

- (IBAction)dragBanner:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:sender.view];
    CGRect frame = self.bannerView.frame;
    
    if (!self.displayBanner) {
        frame.origin.x = translation.x;
        self.bannerView.frame = frame;
    }
    else{
        frame.origin.x = translation.x -frame.size.width;
        self.bannerView.frame = frame;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (!self.displayBanner && -self.bannerView.frame.origin.x < self.collectionView.bounds.size.width/2 ) {
            self.displayBanner = YES;
        }
        else if (self.displayBanner && -self.bannerView.frame.origin.x > self.collectionView.bounds.size.width/2)
        {
            self.displayBanner = NO;
        }
        [self hideShowBanner:self.hideShowButton];
        [sender setTranslation:CGPointZero inView:sender.view];
    }
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

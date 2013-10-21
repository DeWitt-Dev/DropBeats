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
{
    #define ANIMATION_DURATION 0.5
    #define COLLECTIONVIEW_CELL_SIZE CGSizeMake(140,140)
    #define DEFAULT_LOCATION CGPointMake(300, 300)
}

@property (weak, nonatomic) IBOutlet SKView *skView;
@property (strong, nonatomic) DPMyScene * scene;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *hideShowButton;
@property (weak, nonatomic) IBOutlet UIButton *playPause;

@end

@implementation DPViewController

static NSString * const kInstrumentPrefix = @"Instrument";

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
//    self.skView.showsFPS = YES;
//    self.skView.showsNodeCount = YES;
//    self.skView.showsDrawCount = YES;
    
    // Create and configure the scene.
    self.scene = [DPMyScene sceneWithSize:self.skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    self.scene.startingInstrumentSize = COLLECTIONVIEW_CELL_SIZE; //self.collectionView.collectionViewLayout.z;
    
    //Resister for Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameStateChanged:) name:@"gameStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gameStateChanged:) name:@"gameEnded" object:nil];

    
    // Present the scene.
    [DPMyScene loadEverythingYouCanWithCompletionHandeler:^{
        // Present the scene.
        [self.skView presentScene:self.scene];
    } ];
}

#pragma mark - CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3; //number of instrustments 
}
-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InstrumentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InstrumentCell" forIndexPath:indexPath];
    
    if (cell.panGesture == nil) {
        cell.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragInstrument:)];
        [cell addGestureRecognizer:cell.panGesture];
    }
    
    NSString* imageID = [NSString stringWithFormat:@"%@%d", kInstrumentPrefix, indexPath.row+1];
    NSString *textureName = [NSString stringWithFormat:@"%@_0", imageID];

    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage* image = [UIImage imageNamed:textureName];
    [cell.imageView setImage: image];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.scene createInstrument:indexPath.row AtLocation: DEFAULT_LOCATION];
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

- (IBAction)hideShowBanner:(UIButton *)sender
{
    if (!self.displayBanner) {
        
        //Hiding banner
        [UIView animateWithDuration:ANIMATION_DURATION animations:
         ^{
             CGRect frame = self.bannerView.frame;
             frame.origin.x = -self.bannerView.bounds.size.width + 80; // to display button
             self.bannerView.frame = frame;
             
         } completion:nil];
        
        [sender setImage:[UIImage imageNamed:@"PullTab.png"] forState:UIControlStateNormal];
//        [self.scene.game startGame];
    }
    else{
        [UIView animateWithDuration:ANIMATION_DURATION animations:
         ^{
             CGRect frame = self.bannerView.frame;
             frame.origin.x = 0;
             self.bannerView.frame = frame;
             
         } completion:nil];
        
        [sender setImage:[UIImage imageNamed:@"PullTab_back.png"] forState:UIControlStateNormal];
        
        if ([self.scene.game isInProgress]) {
            [self.scene.game endGame];
        }
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
        
        if (!self.displayBanner && (-self.bannerView.frame.origin.x - [sender velocityInView:sender.view].x) < self.collectionView.bounds.size.width/2 ) {
            self.displayBanner = YES;
        }
        else if (self.displayBanner && -self.bannerView.frame.origin.x - [sender velocityInView:sender.view].x > self.collectionView.bounds.size.width/2)
        {
            self.displayBanner = NO;
        }
        [self hideShowBanner:self.hideShowButton];
        [sender setTranslation:CGPointZero inView:sender.view];
    }
}
- (IBAction)resetGame:(UIButton *)sender {
    [self.scene.game endGame];
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.0f;
    animation.toValue = @(2*M_PI);
    animation.duration = 0.5f;
    animation.repeatCount = 1;
    [sender.layer addAnimation:animation forKey:@"rotation"];

    [self.scene.game startGame];
}
- (IBAction)PlayPause:(UIButton *)sender {
    if (![self.scene.game isInProgress]) {
        [self.scene.game startGame];
        [sender setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
    }
    else{
        [self.scene.game endGame];
        [sender setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
    }
}

-(void)gameStateChanged: (NSNotification *) notification
{
    if ([self.scene.game isInProgress]) {
        [self.playPause setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];
        if (!self.displayBanner) {
            [self hideShowBanner:self.hideShowButton];
        }
    }
    else{
        [self.playPause setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];
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

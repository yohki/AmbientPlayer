//
//  APViewController.m
//  AmbientPlayer
//
//  Created by OHKI Yoshihito on 2012/09/05.
//  Copyright (c) 2012年 InteractionPlus. All rights reserved.
//

#import "APViewController.h"
#import "APCrossFadePlayer.h"

@interface APViewController ()

@property (nonatomic, strong) AVAudioSession* session;
@property (nonatomic, strong) APCrossFadePlayer *player;
@end

#define SYNTHESIZE(propertyName) @synthesize propertyName = _ ## propertyName


@implementation APViewController {
    ADBannerView *_bannerView;
}

SYNTHESIZE(session);
SYNTHESIZE(player);
@synthesize contentView = _contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _bannerView = [[ADBannerView alloc] init];
        _bannerView.delegate = self;
        CGRect banner_frame = _bannerView.frame;
        banner_frame.origin.y = 400;
        _bannerView.frame = banner_frame;
    }
    return self;
}

- (void)dealloc
{
    _bannerView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    //add iAd BannerView as subview
    [self.view addSubview:_bannerView];
    
    _session = [AVAudioSession sharedInstance];
    NSError* errRet = nil;
    [self.session setCategory: AVAudioSessionCategoryAmbient error: &errRet];
    [self.session setActive: YES error: &errRet];
    self.player = [APCrossFadePlayer new];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)playButtonClicked:(id)sender {
    if ([self.player isPlaying]) {
        [self.player stop];
    } else {
        [self.player playWithSoundName:@"sea"];
    }
}



@end

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


@implementation APViewController

SYNTHESIZE(session);
SYNTHESIZE(player);

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.session = [AVAudioSession sharedInstance];
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

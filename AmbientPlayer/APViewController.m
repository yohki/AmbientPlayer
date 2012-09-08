//
//  APViewController.m
//  AmbientPlayer
//
//  Created by OHKI Yoshihito on 2012/09/05.
//  Copyright (c) 2012年 InteractionPlus. All rights reserved.
//

#import "APViewController.h"

@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _session = [AVAudioSession sharedInstance];
    NSError* errRet = nil;
    [_session setCategory: AVAudioSessionCategoryAmbient error: &errRet];
    [_session setActive: YES error: &errRet];
    
    NSString* soundFilePath = [[NSBundle mainBundle] pathForResource:@"stream" ofType:@"m4a"];
    NSURL* url = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    
    _player =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&errRet];
    [_player prepareToPlay];
    [_player setVolume:1.0];
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
    [_player play];
}

@end

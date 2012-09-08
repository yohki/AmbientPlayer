//
//  APViewController.m
//  AmbientPlayer
//
//  Created by OHKI Yoshihito on 2012/09/05.
//  Copyright (c) 2012年 InteractionPlus. All rights reserved.
//

#import "APViewController.h"
#import "APCrossFadePlayer.h"
#import "APSoundEntry.h"

@interface APViewController ()

@property (nonatomic, strong) AVAudioSession* session;
@property (nonatomic, strong) APCrossFadePlayer *player;
@property (nonatomic, copy) NSArray *preset;
@end

#define SYNTHESIZE(propertyName) @synthesize propertyName = _ ## propertyName


@implementation APViewController {
    ADBannerView *_bannerView;
}

SYNTHESIZE(session);
SYNTHESIZE(player);
SYNTHESIZE(preset);

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initBanner];
        [self initPreset];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initBanner];
        [self initPreset];
    }
    return self;
}

-(void)initBanner {
    _bannerView = [[ADBannerView alloc] init];
    _bannerView.delegate = self;
    CGRect banner_frame = _bannerView.frame;
    banner_frame.origin.y = 350;
    _bannerView.frame = banner_frame;
}

-(void)initPreset {
    self.preset = [NSArray arrayWithObjects:
                   [[APSoundEntry alloc] initPresetWithTitle:@"Forest" withFileName:@"forest"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Ocean" withFileName:@"ocean"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Rain" withFileName:@"rain"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Sea" withFileName:@"sea"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Stream" withFileName:@"stream"],
                   nil];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Preset";
        case 1:
            return @"Custom";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            APSoundEntry *entry = [self.preset objectAtIndex:indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = entry.title;
            return cell;
        }
        case 1:
            // TODO
            return nil;
        default:
            NSAssert(NO, @"This line should not be reached");
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.preset.count;
        case 1:
            // TODO
            return 0;
        default:
            NSAssert(NO, @"This line should not be reached");
            return 0;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            APSoundEntry *entry = [self.preset objectAtIndex:indexPath.row];
            [self.player playWithSoundName:entry.fileName];
        }
        case 1:
            // TODO
            return;
        default:
            NSAssert(NO, @"This line should not be reached");
            return;
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

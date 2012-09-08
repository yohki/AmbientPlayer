//
//  APViewController.m
//  AmbientPlayer
//
//  Created by OHKI Yoshihito on 2012/09/05.
//  Copyright (c) 2012年 InteractionPlus. All rights reserved.
//

#import "APViewController.h"

#import "AudioToolbox/AudioToolbox.h"
#import "APCrossFadePlayer.h"
#import "APSoundEntry.h"

@interface APViewController ()

@property (nonatomic, strong) AVAudioSession* session;
@property (nonatomic, strong) APCrossFadePlayer *player;
@property (nonatomic, copy) NSArray *preset;
@property(nonatomic, strong) IBOutlet UIView *contentView;

@end

#define SYNTHESIZE(propertyName) @synthesize propertyName = _ ## propertyName


@implementation APViewController {
    ADBannerView *_bannerView;
}

SYNTHESIZE(session);
SYNTHESIZE(player);
SYNTHESIZE(preset);
SYNTHESIZE(contentView);

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
}

-(void)initPreset {
    self.preset = [NSArray arrayWithObjects:
                   [[APSoundEntry alloc] initPresetWithTitle:@"Forest" withFileName:@"forest" andImageFileName:@"forest"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Ocean" withFileName:@"ocean" andImageFileName:@"ocean"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Rain" withFileName:@"rain" andImageFileName:@"rain"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Sea" withFileName:@"sea" andImageFileName:@"sea"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Stream" withFileName:@"stream" andImageFileName:@"stream"],
                   [[APSoundEntry alloc] initPresetWithTitle:@"Crickets" withFileName:@"crickets" andImageFileName:@"crickets"],
                   nil];
}

- (void)dealloc
{
    _bannerView.delegate = nil;
}

- (void)layoutAnimated:(BOOL)animated
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _contentView.frame = contentFrame;
        [_contentView layoutIfNeeded];
        _bannerView.frame = bannerFrame;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    //add iAd BannerView as subview
    [self.view addSubview:_bannerView];
    
    _session = [AVAudioSession sharedInstance];
    NSError* errRet = nil;
    [self.session setCategory: AVAudioSessionCategoryPlayback error: &errRet];

    UInt32 allowMixing = true;
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideCategoryMixWithOthers,  // 1
                             sizeof (allowMixing),                                 // 2
                             &allowMixing                                          // 3
                             );
    [self.session setActive: YES error: &errRet];
    self.player = [APCrossFadePlayer new];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self layoutAnimated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    [self layoutAnimated:duration > 0.0];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutAnimated:YES];
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
            if (entry.imageFileName) {
                NSString *path = [[NSBundle mainBundle] pathForResource:entry.imageFileName ofType:@"jpg"];
                UIImage *img = [UIImage imageWithContentsOfFile:path];
                cell.imageView.image = img;
            }
            return cell;
        }
        case 1:
        {
            // TODO 今は、「追加」のセルだけを作っているけど、追加した音声も作るようにする
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if(!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = @"追加";
            return cell;
        }
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
            return 1;
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
            // TODO 「追加」のセルだった場合、録音用画面を呼び出すようにする
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

//
//  APViewController.h
//  AmbientPlayer
//
//  Created by OHKI Yoshihito on 2012/09/05.
//  Copyright (c) 2012年 InteractionPlus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>

@interface APViewController : UIViewController <ADBannerViewDelegate>{
    IBOutlet UIButton* _playButton;
}

@property(nonatomic, strong) IBOutlet UIView *contentView;

- (IBAction) playButtonClicked: (id)sender;

@end


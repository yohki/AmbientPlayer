//
//  APViewController.h
//  AmbientPlayer
//
//  Created by OHKI Yoshihito on 2012/09/05.
//  Copyright (c) 2012年 InteractionPlus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface APViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIButton* _playButton;
}

- (IBAction) playButtonClicked: (id)sender;

@end


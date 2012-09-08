//
//  APViewController.h
//  AmbientPlayer
//
//  Created by OHKI Yoshihito on 2012/09/05.
//  Copyright (c) 2012年 InteractionPlus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface APViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end


//
//  APSoundEntry.h
//  AmbientPlayer
//
//  Created by KAWACHI Takashi on 9/8/12.
//  Copyright (c) 2012 InteractionPlus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APSoundEntry : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *fileName;

-(id)initPresetWithTitle:(NSString *)title withFileName:(NSString *)fileName;
@end

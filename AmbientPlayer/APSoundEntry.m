//
//  APSoundEntry.m
//  AmbientPlayer
//
//  Created by KAWACHI Takashi on 9/8/12.
//  Copyright (c) 2012 InteractionPlus. All rights reserved.
//

#import "APSoundEntry.h"

#define SYNTHESIZE(propertyName) @synthesize propertyName = _ ## propertyName

@implementation APSoundEntry
SYNTHESIZE(title);
SYNTHESIZE(fileName);

-(id)initPresetWithTitle:(NSString *)title withFileName:(NSString *)fileName {
    self = [self init];
    if (self) {
        self.title = title;
        self.fileName = fileName;
    }
    return self;
}

@end

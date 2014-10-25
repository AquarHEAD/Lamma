//
//  LAMPlayingShow.h
//  Lamma
//
//  Created by AquarHEAD L. on 8/17/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "LAMShow.h"

@interface LAMPlayingShow : NSObject

@property (nonatomic, strong) LAMShow *playingShow;
@property (nonatomic, strong) AVPlayer *sharedPlayer;

+ (instancetype)sharedInstance;

@end

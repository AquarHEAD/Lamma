//
//  LAMPlayingShow.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/17/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMPlayingShow.h"

@implementation LAMPlayingShow

+ (instancetype)sharedInstance
{
    static LAMPlayingShow *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [LAMPlayingShow new];
    });
    return sharedInstance;
}

@end

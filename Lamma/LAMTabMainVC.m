//
//  LAMTabMainVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/16/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMTabMainVC.h"

@interface LAMTabMainVC ()

@end

@implementation LAMTabMainVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    if (!(username && token)) {
        [self performSegueWithIdentifier:@"openSignup" sender:self];
    }
}

@end

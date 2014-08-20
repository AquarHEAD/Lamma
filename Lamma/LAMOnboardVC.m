//
//  LAMOnboardVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/21/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMOnboardVC.h"
#import "LAMTabMainVC.h"

@interface LAMOnboardVC ()

@property (weak, nonatomic) IBOutlet UIButton *zaoButton;
@property (weak, nonatomic) IBOutlet UIButton *shuButton;
@property (weak, nonatomic) IBOutlet UIButton *qiButton;
@property (weak, nonatomic) IBOutlet UIButton *juButton;

@end

@implementation LAMOnboardVC

- (IBAction)clicked:(id)sender {
    NSUInteger index = 0;
    if ([sender isEqual:self.shuButton]) {
        index = 1;
    }
    else if ([sender isEqual:self.qiButton]) {
        index = 3;
    }
    else if ([sender isEqual:self.juButton]) {
        index = 4;
    }
    LAMTabMainVC *tabVC = (LAMTabMainVC *)self.presentingViewController;
    tabVC.selectedIndex = index;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

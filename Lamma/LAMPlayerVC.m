//
//  LAMPlayerVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/6/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMPlayerVC.h"
#import <AVFoundation/AVFoundation.h>

@interface LAMPlayerVC ()

@property (weak, nonatomic) IBOutlet UIWebView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation LAMPlayerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.show.title;
    self.detailView.backgroundColor = [UIColor clearColor];
    [self.detailView loadHTMLString:self.show.detail baseURL:nil];

    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.show.audio]];
}

- (IBAction)handleControlBtn:(id)sender {
    [self.player play];
}

@end

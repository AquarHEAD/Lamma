//
//  LAMPlayerVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/6/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMPlayerVC.h"
#import "LAMPlayingShow.h"
#import <AVFoundation/AVFoundation.h>

@interface LAMPlayerVC ()

@property (weak, nonatomic) IBOutlet UIWebView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic) BOOL isPlaying;

@end

@implementation LAMPlayerVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (![self.show isEqual:[LAMPlayingShow sharedInstance].playingShow]) {
        self.show = [LAMPlayingShow sharedInstance].playingShow;
        self.title = self.show.title;

        // setup player
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        if (self.show.status == LAMSHOWSTAT_DOWNLOADED) {
            self.playerItem = [AVPlayerItem playerItemWithURL:self.show.localFile];
        }
        else {
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.show.audio]];
        }
        [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.isPlaying = NO;
        self.currentTimeLabel.text = @"-:-";
        self.totalTimeLabel.text = @"-:-";
        self.playProgress.progress = 0.0f;
        __weak __typeof__(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            if (weakSelf.player.status == AVPlayerStatusReadyToPlay) {
                NSUInteger currentSeconds = CMTimeGetSeconds([weakSelf.player currentTime]);
                NSUInteger minutes = floor(currentSeconds / 60);
                NSUInteger seconds = floor(currentSeconds % 60);
                weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];

                NSUInteger totalSecond = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
                if (totalSecond != 0) {
                    weakSelf.playProgress.progress = (double)currentSeconds / totalSecond;
                }
                else {
                    weakSelf.playProgress.progress = 0.0f;
                }
            }
        }];

        // setup detailView
        self.detailView.backgroundColor = [UIColor clearColor];
        [self.detailView loadHTMLString:self.show.detail baseURL:nil];
        
        // setup button
        [self.controlButton setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateSelected];
    }
}

- (IBAction)handleControlBtn:(id)sender {
    if (!self.isPlaying) {
        [self.player play];
        [self.controlButton setSelected:YES];
    }
    else {
        [self.player pause];
        [self.controlButton setSelected:NO];
    }
    self.isPlaying = !self.isPlaying;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUInteger totalSecond = CMTimeGetSeconds(self.player.currentItem.duration);
    NSUInteger minutes = floor(totalSecond / 60);
    NSUInteger seconds = floor(totalSecond % 60);
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%lu:%lu", (unsigned long)minutes, (unsigned long)seconds];
}

@end

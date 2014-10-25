//
//  LAMShowCell.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/17/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMShowCell.h"

@implementation LAMShowCell

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        self.downloadProgressLabel.text = [NSString stringWithFormat:@"%.2f %%", progress.fractionCompleted * 100];
//        [(UITableView *)(self.superview.superview) reloadData];
        NSLog(@"Progress is %f", progress.fractionCompleted);
    }
}

@end

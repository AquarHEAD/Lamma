//
//  LAMHostListVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/16/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMHostListVC.h"

@interface LAMHostListVC ()

@end

@implementation LAMHostListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refControl = [UIRefreshControl new];
    [refControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refControl;
}

- (void)refresh:(id)sender
{
    if ([sender isEqual:self.refreshControl]) {
        NSLog(@"haha");
        [(UIRefreshControl *)sender endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSDictionary *hostImage = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hostImage = @{@"zhang": @"253-person",
                      @"li": @"253-person"};
    });

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.imageView.image =[UIImage imageNamed:hostImage[@"zhang"]];
    cell.textLabel.text = @"八月八日早知道";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toHostZao" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  LAMUserVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/17/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMUserVC.h"

@interface LAMUserVC ()

@property (weak, nonatomic) IBOutlet UITableViewCell *usernameCell;

@end

@implementation LAMUserVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.usernameCell.textLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    [self.tableView reloadData];
}

- (IBAction)logout:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [self performSegueWithIdentifier:@"openLogin" sender:self];
}

@end

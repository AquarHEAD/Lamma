//
//  LAMFavorVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/22/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMFavorVC.h"
#import "LAMShowCell.h"
#import "LAMShow.h"
#import "LAMPlayingShow.h"

@interface LAMFavorVC ()

@property (nonatomic, strong) NSArray *shows;

@end

@implementation LAMFavorVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NyaruDB *db = [NyaruDB instance];
    NyaruCollection *col = [db collection:@"shows"];
    NSMutableArray *temp = [NSMutableArray new];
    NSArray *favored = [[NSUserDefaults standardUserDefaults] arrayForKey:@"favor"];
    if (favored) {
        for (NSString *idstr in favored) {
            [temp addObject:[LAMShow initFromDictionary:[[col where:@"key" equal:idstr] fetch][0]]];
        }
        self.shows = [[temp sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]] copy];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.shows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LAMShow *thisShow = self.shows[indexPath.row];
    LAMShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowCell" forIndexPath:indexPath];
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithRed:145.0/255.0 green:152.0/255.0 blue:159.0/255.0 alpha:0.05];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.titleLabel.text = thisShow.title;
    cell.subLabel.text = thisShow.subtitle;

    cell.indicator.hidden = YES;
    if (thisShow.status == LAMSHOWSTAT_DOWNLOADED) {
        // show delete
        cell.downloadButton.hidden = YES;
        cell.trashButton.hidden = NO;
    }
    else {
        cell.downloadButton.hidden = NO;
        cell.trashButton.hidden = YES;
    }

    return cell;
}

- (IBAction)manButtonClicked:(id)sender {
    UIButton *manButton = (UIButton *)sender;
    LAMShowCell *thisCell = (LAMShowCell *)manButton.superview.superview;
    NSIndexPath *idx = [self.tableView indexPathForCell:thisCell];
    LAMShow *thisShow = self.shows[idx.row];
    if ([manButton isEqual:thisCell.downloadButton]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:thisShow.audio]];
        thisShow.downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return thisShow.localFile;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [[NSFileManager defaultManager] skipBackup:filePath];
            thisCell.indicator.hidden = YES;
            if (error) {
                thisShow.status = LAMSHOWSTAT_TODOWNLOAD;
                thisCell.downloadButton.hidden = NO;
                thisCell.trashButton.hidden = YES;
            }
            else {
                thisShow.status = LAMSHOWSTAT_DOWNLOADED;
                thisCell.downloadButton.hidden = YES;
                thisCell.trashButton.hidden = NO;
                NSLog(@"File downloaded to: %@", filePath);
            }
        }];
        thisShow.status = LAMSHOWSTAT_DOWNLOADING;
        thisCell.downloadButton.hidden = YES;
        thisCell.trashButton.hidden = YES;
        thisCell.indicator.hidden = NO;
        [thisShow.downloadTask resume];
    }
    else if ([manButton isEqual:thisCell.trashButton]){
        [[NSFileManager defaultManager] removeItemAtPath:[thisShow.localFile path] error:nil];
        thisShow.status = LAMSHOWSTAT_TODOWNLOAD;
        thisCell.downloadButton.hidden = NO;
        thisCell.trashButton.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[LAMPlayingShow sharedInstance].sharedPlayer pause];
    [LAMPlayingShow sharedInstance].playingShow = self.shows[indexPath.row];
    [self performSegueWithIdentifier:@"favorToPlayer" sender:self];
}

@end

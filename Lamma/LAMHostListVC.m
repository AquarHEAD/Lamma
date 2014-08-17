//
//  LAMHostListVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/16/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMHostListVC.h"
#import "LAMShow.h"
#import "LAMZaoVC.h"

@interface LAMHostListVC ()

@property (nonatomic, strong) NSArray *shows;
@property (nonatomic, strong) NSString *selectedHost;

@end

@implementation LAMHostListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refControl = [UIRefreshControl new];
    [refControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refControl;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
    if (username && token) {
        NyaruDB *db = [NyaruDB instance];
        NyaruCollection *col = [db collection:@"shows"];
        if ([[col where:@"type" equal:@"zao"] count] == 0) {
            [self refresh:self.refreshControl];
        }
        else {
            [self loadDatabase];
        }
    }
}

- (void)refresh:(id)sender
{
    if ([sender isEqual:self.refreshControl]) {
        [SVProgressHUD show];
        [SVProgressHUD setStatus:@"载入中..."];
        AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
        NSString *reqAddr = [NSString stringWithFormat:@"%@/shows", LAMSERVER];
        [man GET:reqAddr parameters:@{@"type": @"zao"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NyaruDB *db = [NyaruDB instance];
            NyaruCollection *col = [db collection:@"shows"];
            for (NSDictionary *dict in responseObject) {
                [col put:dict];
            }
            [col waitForWriting];
            [self loadDatabase];
            [SVProgressHUD showSuccessWithStatus:@"载入完成!"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"载入错误, 请重试"];
        }];
        [self.refreshControl endRefreshing];
    }
}

- (void)loadDatabase
{
    NSMutableArray *temp = [NSMutableArray new];
    NyaruDB *db = [NyaruDB instance];
    NyaruCollection *col = [db collection:@"shows"];
    NSArray *docs = [[col where:@"type" equal:@"zao"] fetch];
    for (NSDictionary *doc in docs) {
        [temp addObject:[LAMShow initFromDictionary:doc]];
    }
    self.shows = [temp copy];
    [self.tableView reloadData];
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
    static NSDictionary *hostImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hostImage = @{@"zhang": @"253-person",
                      @"li": @"221-recordplayer"};
    });

    LAMShow *thisShow = self.shows[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image =[UIImage imageNamed:hostImage[thisShow.host]];
    cell.textLabel.text = thisShow.title;
    cell.detailTextLabel.text = thisShow.subtitle;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];

    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor colorWithRed:145.0/255.0 green:152.0/255.0 blue:159.0/255.0 alpha:0.05];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LAMShow *selectedShow = self.shows[indexPath.row];
    self.selectedHost = selectedShow.host;
    [self performSegueWithIdentifier:@"toHostZao" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toHostZao"]) {
        LAMZaoVC *vc = segue.destinationViewController;
        vc.host = self.selectedHost;
    }
}


@end

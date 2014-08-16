//
//  LAMZaoVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/7/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMZaoVC.h"
#import "LAMShow.h"
#import "LAMPlayerVC.h"

@interface LAMZaoVC ()

@property (nonatomic, strong) NSArray *shows;
@property NSUInteger selectedIndex;

@end

@implementation LAMZaoVC

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
        /*
         [SVProgressHUD show];
         [SVProgressHUD setStatus:@"载入中..."];
         AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
         NSString *reqAddr = [NSString stringWithFormat:@"%@/%@/", LAMSERVER, @"zao"];
         [man GET:reqAddr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSMutableArray *temp = [NSMutableArray new];
         for (NSDictionary *dict in responseObject) {
         [temp addObject:[LAMShow initFromDictionary:dict]];
         }
         self.shows = [temp copy];
         [self.tableView reloadData];
         [SVProgressHUD showSuccessWithStatus:@"载入完成!"];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [SVProgressHUD showErrorWithStatus:@"载入错误, 请重试"];
         }];
         */
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

//    LAMShow *show = [self.shows objectAtIndex:indexPath.row];
//    if (indexPath.row % 2 == 1) {
//        cell.backgroundColor = [UIColor colorWithRed:145.0/255.0 green:152.0/255.0 blue:159.0/255.0 alpha:0.05];
//    }
//    else {
//        cell.backgroundColor = [UIColor whiteColor];
//    }
//    cell.textLabel.text = show.title;
    cell.textLabel.text = @"哈哈";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"toPlayer" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    LAMPlayerVC *vc = [segue destinationViewController];
//    vc.show = self.shows[self.selectedIndex];
}

@end

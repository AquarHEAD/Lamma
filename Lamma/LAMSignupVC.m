//
//  LAMSignupVC.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/16/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMSignupVC.h"

@interface LAMSignupVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *funcSeg;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSeg;
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *signupCells;
@property (weak, nonatomic) IBOutlet UITableViewCell *codeCell;

@end

@implementation LAMSignupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hideSectionsWithHiddenRows = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.usernameField becomeFirstResponder];
}

- (IBAction)getCode:(id)sender {
    [SVProgressHUD show];
    [SVProgressHUD setStatus:@"提交中..."];
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    NSString *reqAddr = [NSString stringWithFormat:@"%@/user/add_code/", LAMSERVER];
    [man GET:reqAddr parameters:@{@"phone": self.phoneField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"请查收包含验证码的短信!"];
        [self.codeField becomeFirstResponder];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD showErrorWithStatus:@"获取验证码错误, 请重试"];
    }];
}

- (IBAction)submit:(id)sender {
}

- (IBAction)funcSegChanged:(id)sender {
    if (self.funcSeg.selectedSegmentIndex == 0) {
        // signup
        [self cells:self.signupCells setHidden:NO];
        [self reloadDataAnimated:YES];
    }
    else {
        [self cells:self.signupCells setHidden:YES];
        [self reloadDataAnimated:YES];
    }
}

@end

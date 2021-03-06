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
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *signupCells;

@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (nonatomic) NSInteger secondLeft;

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
    // check if has logged in
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"username"] && [[NSUserDefaults standardUserDefaults] stringForKey:@"token"]) {
        [self performSegueWithIdentifier:@"toOnboard" sender:self];
    }
    else {
        [self.usernameField becomeFirstResponder];
    }
}

- (IBAction)getCode:(id)sender {
    if (self.phoneField.text.length == 11) {
        [SVProgressHUD show];
        [SVProgressHUD setStatus:@"提交中..."];
        AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
        NSString *reqAddr = [NSString stringWithFormat:@"%@/user/add_code/", LAMSERVER];
        [man GET:reqAddr parameters:@{@"phone": self.phoneField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.secondLeft = 30;
            self.codeButton.enabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCodeButton) userInfo:nil repeats:YES];
            [SVProgressHUD showSuccessWithStatus:@"请查收包含验证码的短信!"];
            [self.codeField becomeFirstResponder];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"获取验证码错误, 请重试"];
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [self.phoneField becomeFirstResponder];
    }
}

- (void)updateCodeButton {
    if (self.secondLeft > 0) {
        self.secondLeft -= 1;
        [self.codeButton setTitle:[NSString stringWithFormat:@"%ld 秒后重新获取", (long)self.secondLeft] forState:UIControlStateNormal];
    }
    else {
        [self.timer invalidate];
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (IBAction)submit:(id)sender {
    if (self.funcSeg.selectedSegmentIndex == 0) {
        // signup
        if (self.usernameField.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入用户名" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [self.usernameField becomeFirstResponder];
            return;
        }
        if (self.passwordField.text.length < 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入不少于4位的密码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [self.passwordField becomeFirstResponder];
            return;
        }
        if (self.phoneField.text.length != 11) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [self.phoneField becomeFirstResponder];
            return;
        }
        NSString *gender = @"N/A";
        if (self.codeField.text.length != 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的验证码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [self.codeField becomeFirstResponder];
            return;
        }

        NSDictionary *regParams = @{@"username": self.usernameField.text,
                                    @"password": self.passwordField.text,
                                    @"phone": self.phoneField.text,
                                    @"gender": gender,
                                    @"code": self.codeField.text};

        [SVProgressHUD show];
        [SVProgressHUD setStatus:@"提交中..."];
        AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
        NSString *reqAddr = [NSString stringWithFormat:@"%@/user/reg", LAMSERVER];
        [man GET:reqAddr parameters:regParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"result"] boolValue]) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功!"];
                self.funcSeg.selectedSegmentIndex = 1;
                [self.timer invalidate];
                [self funcSegChanged:self];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"注册失败..."];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"error"] message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"注册失败, 请重试"];
        }];
    }
    else {
        // login
        if (self.usernameField.text.length < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入用户名" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [self.usernameField becomeFirstResponder];
            return;
        }
        if (self.passwordField.text.length < 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [self.passwordField becomeFirstResponder];
            return;
        }
        NSDictionary *loginParams = @{@"username": self.usernameField.text,
                                    @"password": self.passwordField.text};
        [SVProgressHUD show];
        [SVProgressHUD setStatus:@"登录中..."];
        AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
        NSString *reqAddr = [NSString stringWithFormat:@"%@/user/login", LAMSERVER];
        [man GET:reqAddr parameters:loginParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"result"] boolValue]) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"username"] forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"token"] forKey:@"token"];
                [self performSegueWithIdentifier:@"toOnboard" sender:self];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"登录失败..."];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"error"] message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [SVProgressHUD showErrorWithStatus:@"登录失败, 请重试"];
        }];
    }
}

- (IBAction)funcSegChanged:(id)sender {
    if (self.funcSeg.selectedSegmentIndex == 0) {
        // signup
        [self cells:self.signupCells setHidden:NO];
        [self reloadDataAnimated:YES];
    }
    else {
        // login
        [self cells:self.signupCells setHidden:YES];
        [self reloadDataAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

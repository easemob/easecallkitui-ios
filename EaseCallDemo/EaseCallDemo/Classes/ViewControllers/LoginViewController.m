//
//  LoginViewController.m
//  EaseCallDemo
//
//  Created by 杜洁鹏 on 2021/2/19.
//

#import "LoginViewController.h"
#import <HyphenateLite/HyphenateLite.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)registerAction:(id)sender {
    [self.view endEditing:YES];
    [EMClient.sharedClient registerWithUsername:self.usernameField.text
                                       password:self.pwdField.text
                                     completion:^(NSString *aUsername, EMError *aError) {
        
    }];
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    [EMClient.sharedClient loginWithUsername:self.usernameField.text
                                       password:self.pwdField.text
                                     completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            [NSNotificationCenter.defaultCenter postNotificationName:@"IsLoggedIn" object:@(YES)];
        }
    }];
}

- (IBAction)tapBackgroundAction:(id)sender {
    [self.view endEditing:YES];
}


@end

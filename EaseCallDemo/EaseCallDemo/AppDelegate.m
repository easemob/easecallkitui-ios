//
//  AppDelegate.m
//  EaseCallDemo
//
//  Created by 杜洁鹏 on 2021/2/18.
//

#import "AppDelegate.h"

#import <HyphenateChat/HyphenateChat.h>
#import "UIStoryboard+Category.h"

//#define EASEMOB_APP_KEY @"easemob-demo#chatdemoui"
#define EASEMOB_APP_KEY @"easemob-demo#support"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loginTypeChanged:) name:@"IsLoggedIn"  object:nil];
    [self initHypheanteSDK];
    // 是否已登录
    if (EMClient.sharedClient.isLoggedIn) {
        self.window.rootViewController = [UIStoryboard loadViewControllerWithClassName:@"HomeViewController"];
    }else {
        self.window.rootViewController = [UIStoryboard loadViewControllerWithClassName:@"LoginViewController"];
    }
    return YES;
}


- (void)initHypheanteSDK {
    EMOptions *options = [EMOptions optionsWithAppkey:EASEMOB_APP_KEY];
    options.enableConsoleLog = YES;
    // 为了方便演示，设置自动同意好友申请。
    options.autoAcceptFriendInvitation = YES;
    [EMClient.sharedClient initializeSDKWithOptions:options];
}

- (void)loginTypeChanged:(NSNotification *)aNoti {
    BOOL isLoggedIn = [(NSNumber *)aNoti.object boolValue];
    if (isLoggedIn) {
        self.window.rootViewController = [UIStoryboard loadViewControllerWithClassName:@"HomeViewController"];
    }else {
        self.window.rootViewController = [UIStoryboard loadViewControllerWithClassName:@"LoginViewController"];
    }
}

@end


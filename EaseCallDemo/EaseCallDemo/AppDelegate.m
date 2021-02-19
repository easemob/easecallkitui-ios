//
//  AppDelegate.m
//  EaseCallDemo
//
//  Created by 杜洁鹏 on 2021/2/18.
//

#import "AppDelegate.h"
#import <EaseCallKit/EaseCallUIKit.h>
#import <Hyphenate/Hyphenate.h>
#import "AppDelegate+EaseCallKit.h"

@interface AppDelegate ()<EaseCallDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self initHypheanteSDK];
    EaseCallConfig* config = [[EaseCallConfig alloc] init];
    EaseCallUser* usr = [[EaseCallUser alloc] init];
    usr.nickName = @"自定义昵称";
    config.users = [@{@"du001":usr} mutableCopy];
    config.agoraAppId = @"15cb0d28b87b425ea613fc46f7c9f974";
    [[EaseCallManager sharedManager] initWithConfig:config delegate:self];
    return YES;
}

- (void)initHypheanteSDK {
    
}




- (void)callDidEnd:(NSString * _Nonnull)aChannelName
            reason:(EaseCallEndReason)aReason
              time:(int)aTm
              type:(EaseCallType)aType {
    
}

- (void)callDidOccurError:(EaseCallError * _Nonnull)aError {
    
}

- (void)callDidReceive:(EaseCallType)aType
               inviter:(NSString * _Nonnull)user
                   ext:(NSDictionary * _Nullable)aExt {
    
}

- (NSString * _Nullable)fetchTokenForAppId:(NSString * _Nonnull)aAppId
                               channelName:(NSString * _Nonnull)aChannelName
                                   account:(NSString * _Nonnull)aUserAccount {
    return nil;
}

- (void)multiCallDidInvitingWithCurVC:(UIViewController * _Nonnull)vc
                         excludeUsers:(NSArray<NSString *> * _Nullable)users
                                  ext:(NSDictionary * _Nullable)aExt {
    
}

@end

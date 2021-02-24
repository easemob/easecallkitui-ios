//
//  HomeViewController.m
//  EaseCallDemo
//
//  Created by 杜洁鹏 on 2021/2/19.
//

#import "HomeViewController.h"
#import <EaseCallKit/EaseCallUIKit.h>
#import <HyphenateChat/HyphenateChat.h>

#define AGORA_APP_ID @"15cb0d28b87b425ea613fc46f7c9f974"

@interface HomeViewController ()<EaseCallDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCallKitWithUid:EMClient.sharedClient.currentUsername];
}

- (void)setupCallKitWithUid:(NSString *)aUId{
    EaseCallUser* callUser = [[EaseCallUser alloc] init];
    callUser.nickName = @"du001的昵称";
    EaseCallConfig* config = [[EaseCallConfig alloc] init];
    config.users = [NSMutableDictionary dictionaryWithObject:callUser forKey:aUId];
    config.agoraAppId = AGORA_APP_ID;
    config.enableRTCTokenValidate = false;
    [[EaseCallManager sharedManager] initWithConfig:config delegate:self];
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

- (void)callDidRequestRTCTokenForAppId:(NSString * _Nonnull)aAppId
                           channelName:(NSString * _Nonnull)aChannelName
                               account:(NSString * _Nonnull)aUserAccount {
    
}

- (void)multiCallDidInvitingWithCurVC:(UIViewController * _Nonnull)vc
                         excludeUsers:(NSArray<NSString *> * _Nullable)users
                                  ext:(NSDictionary * _Nullable)aExt {
    
}

@end

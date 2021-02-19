//
//  AppDelegate+EaseCallKit.h
//  EaseCallDemo
//
//  Created by 杜洁鹏 on 2021/2/19.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (EaseCallKit)
- (void)initEaseCallKitWithUid:(NSString *)aUId
                      userInfo:(EaseCallUser *)aUser
                    agoraAppId:(NSString *)agoraAppId;
@end

NS_ASSUME_NONNULL_END

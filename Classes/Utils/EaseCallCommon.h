//
//  EaseCallCommon.h
//  EaseCallKit
//
//  Created by 杨剑 on 2025/6/25.
//

#import <Foundation/Foundation.h>
#import <HyphenateChat/HyphenateChat.h>
NS_ASSUME_NONNULL_BEGIN

@interface EaseCallCommon : NSObject




+ (void)printLog:(NSString *)string;
+ (void)printReceivedMessage:(EMChatMessage *)message;
+ (void)printSendMessage:(EMChatMessage *)message;



+ (NSString *)generateRandomString;

+ (NSString *)generateChannelNameWithFromUserid:(NSString *)fromUserid toUserid:(NSString *)toUserid;

@end

NS_ASSUME_NONNULL_END

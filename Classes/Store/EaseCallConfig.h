//
//  EaseCallConfig.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/9.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface EaseCallUser : NSObject
@property (nonatomic)  NSString* _Nullable  nickName;
@property (nonatomic)  NSURL* _Nullable  headImage;
@end

@interface EaseCallVideoConfig : NSObject

typedef NSString*_Nullable(^FetchTokenCallback)(NSString*channelName,NSString*appId);

@end
// 增加铃声、标题文本、环信ID与昵称的映射
@interface EaseCallConfig : NSObject
// 默认头像
@property (nonatomic)  NSURL*  defaultHeadImage;
// 呼叫超时时间
@property (nonatomic) UInt32 callTimeOut;
// 用户信息字典,key为环信ID，value为EaseCallUser
@property (nonatomic) NSMutableDictionary* users;
// 振铃文件
@property (nonatomic) NSURL* ringFileUrl;
// 声网appId
@property (nonatomic) NSString* agoraAppId;
@end

NS_ASSUME_NONNULL_END

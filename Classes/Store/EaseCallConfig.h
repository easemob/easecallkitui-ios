//
//  EaseCallConfig.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/9.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 用户的昵称、头像信息
 */
@interface EaseCallUser : NSObject
/*
 * nickName    用户昵称
 */
@property (nonatomic)  NSString* _Nullable  nickName;
/*
 * nickName    用户头像
 */
@property (nonatomic)  NSURL* _Nullable  headImage;
@end

// 增加铃声、标题文本、环信ID与昵称的映射
@interface EaseCallConfig : NSObject
/*
 * nickName    用户头像
 */
@property (nonatomic)  NSURL*  defaultHeadImage;
/*
 * callTimeOut    呼叫超时时间
 */
@property (nonatomic) UInt32 callTimeOut;
/*
 * users    用户信息字典,key为环信ID，value为EaseCallUser
 */
@property (nonatomic) NSMutableDictionary* users;
/*
 * ringFileUrl    振铃文件
 */
@property (nonatomic) NSURL* ringFileUrl;
/*
 * agoraAppId    声网appId
 */
@property (nonatomic) NSString* agoraAppId;
@end

NS_ASSUME_NONNULL_END

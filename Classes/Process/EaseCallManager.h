//
//  EaseCallManager.h
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/11/18.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseCallConfig.h"
#import "EaseCallDefine.h"
#import "EaseCallError.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

@protocol EaseCallDelegate <NSObject>
/**
 * 通话结束时触发该回调
 * @param aChannelName         通话的通道名称，用于在声网水晶球查询通话质量
 * @param aReason                    通话结束原因
 * @param aTm                             通话时长
 * @param aType    通话类型，EaseCallTypeAudio为语音通话，EaseCallTypeVideo为视频通话，EaseCallTypeMulti为多人通话
 */
- (void)callDidEnd:(NSString*_Nonnull)aChannelName reason:(EaseCallEndReason)aReason time:(int)aTm type:(EaseCallType)aType;
/**
 * 多人通话中，点击邀请按钮触发该回调
 * @param vc         当前通话页面的视图控制器
 * @param users                    当前会议中已存在的成员及已邀请的成员
 */
- (void)multiCallDidInvitingWithCurVC:(UIViewController*_Nonnull)vc excludeUsers:(NSArray<NSString*> *_Nullable)users;
/**
 * 被叫开始振铃时，触发该回调
 * @param aType         通话类型
 * @param user            主叫的环信Id
 */
- (void)callDidReceive:(EaseCallType)aType inviter:(NSString*_Nonnull)user;
/**
 * 通话过程发生异常时，触发该回调
 * @param aError         通话类型
 */
- (void)callDidOccurError:(EaseCallError*_Nonnull)aError;
@end

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallManager : NSObject
+ (instancetype)sharedManager;
/**
 * EaseCall模块初始化
 * @param aConfig         EaseCall的配置，包括用户昵称、头像、呼叫超时时间等
 * @param aDelegate    回调监听
 * @param aCompletionBlock 完成回调
 */
- (void)initWithConfig:(EaseCallConfig*)aConfig delegate:(id<EaseCallDelegate>)aDelegate;
/**
 * 邀请成员进行单人通话
 * @param uId         被邀请人的环信ID
 * @param aType    通话类型，EaseCallTypeAudio为语音通话，EaseCallTypeVideo为视频通话
 * @param aCompletionBlock 完成回调
 */
- (void)startSingleCallWithUId:(NSString*)uId type:(EaseCallType)aType completion:(void (^)(NSString* callId,EaseCallError*))aCompletionBlock;
/**
 * 邀请成员进行多人会议
 * @param aUsers         被邀请人的环信ID数组
 * @param aCompletionBlock 完成回调
 */
- (void)startInviteUsers:(NSArray<NSString*>*)aUsers  completion:(void (^)(NSString* callId,EaseCallError*))aCompletionBlock;
/**
 * 获取EaseCallKit的配置
 * @return  EaseCallKit的配置
 */
- (EaseCallConfig*)getEaseCallConfig;
@end

NS_ASSUME_NONNULL_END

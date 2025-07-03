//
//  EaseCallEventInfo.h
//  EaseCallKit
//
//  Created by 杨剑 on 2025/7/1.
//

#import <Foundation/Foundation.h>
#import <HyphenateChat/HyphenateChat.h>

#import "EaseCallDefine.h"





/**
 "invite"           发起方发送 -> 发起邀请
 "alert"            接收方发送 -> 收到邀请
 "confirmRing"      发起方发送 -> 发送确认双方消息有效性,可以理解为是一个校验整体流程无误的消息
 "answerCall"       接收方发送 -> 接收方同意邀请,会发出此消息,告知发起方同意,其中此消息携带字段 result
 "confirmCallee"    发起方发送 -> 已收到接收方同意邀请的消息,并告知接收方:"我已收到" 并携带了 接收方所发送的answerCall消息的result字段值
 */
typedef enum : int {
    EaseCallEventTypeNone = -1,
    EaseCallEventTypeInvite,
    EaseCallEventTypeAlert,
    EaseCallEventTypeConfirmRing,
    EaseCallEventTypeAnswerCall,
    EaseCallEventTypeConfirmCallee,
    EaseCallEventTypeCancelCall,
    EaseCallEventTypeVideoToAudio,
} EaseCallEventType;

/**
 result
 固定值:
 "accept" 同意
 "refuse" 拒绝
 "busy" 忙
 */
typedef enum : int {
    EaseCallFeedbackResultNone = -1,
    EaseCallFeedbackResultAccept,
    EaseCallFeedbackResultRefuse,
    EaseCallFeedbackResultBusy,
} EaseCallFeedbackResult;


/**
 result
 固定值:
 "accept" 同意
 "refuse" 拒绝
 "busy" 忙
 */
typedef enum : bool {
    EaseCallEventDirectionSend,
    EaseCallEventDirectionReceive,
} EaseCallEventDirection;

NS_ASSUME_NONNULL_BEGIN
/**
 注意!
 这里并非是指 cmd 消息,而是指 callkit 在收发消息时,携带的信令,必要字段
 这里是针对要传输的信令字段进行封装
 投递时会以 key value 格式传输,存放是在消息的ext中
 */
@interface EaseCallEventInfo : NSObject

+ (EaseCallEventType)callCmdActionFromString:(NSString *)value;
+ (NSString *)stringFromCallCmdAction:(EaseCallEventType)value;

+ (EaseCallFeedbackResult)callCmdResultFromString:(NSString *)value;
+ (NSString *)stringFromCallCmdResult:(EaseCallFeedbackResult)value;



@property(nonatomic)EaseCallEventType action;

@property(nonatomic)EaseCallType call_type;


/**
 callerDevice_id:
 callerDevId
 发起方!!!
 注意!在发起方叫callerDevId
 此字段获取时机为懒加载方式,使用的时候才会get获取,当获取的时候发现字段为空,则直接创建并存放在属性中(如果字段存在则不需要创建)
 字段的生成方式代码如下
         _curDevId = [NSString stringWithFormat:@"ios_%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString] ];
 */
@property(nonatomic,copy)NSString *callerDevice_id;

/**
 calleeDevice_id
 calleeDevId
 被呼叫方!!!
 此字段与前面提到的callerDevId具有相同意义,不过这并非发起方的设备id,而是接收方的设备id
 */
@property(nonatomic,copy)NSString *calleeDevice_id;




/**
 call_id:
 callId
 注意!
 channelid(或channel name)可以理解为声网的通道id,但是!!! callId并不是声网的通道id!!!
 此字段将贯穿始终,从一开始生成之后,单组音视频逻辑的所有消息中,都将包含callId,并且都为同一个值
 此字段为发起方临时生成字段,直接看代码,如下:
             weakself.modal.currentCall.callId = [[NSUUID UUID] UUIDString];
 */
@property(nonatomic,copy)NSString *call_id;

/**
 channel_name
 channelName
 此字段非常重要!这将会是要加入的声网通道name!!!
 此字段是在发起方首次发起时生成,实际上可以随机生成,但要保证使用时间段内的唯一性
 */
@property(nonatomic,copy)NSString *channel_name;

/**
 此字段作为对消息进行标识的字段,将消息标识为 EaseCallKit模块的消息 固定值 : "rtcCallWithAgora"
 */
//@property(nonatomic,copy)NSString *msgType;

@property(nonatomic)long long timestamp;

@property(nonatomic)EaseCallEventDirection direction;


/**
 转音频
 */
@property(nonatomic)bool toAudio;

/**
 isEffective
 status
 此字段出现在action为 confirmRing 的消息中,表示确定当前音视频整体流程是否有效,
 简单说来就是判断一些字段是否存在或一些字段是否具备一致性
 (避免多人相互发消息,刚好有第三人发了音视频相关消息,相当于入侵了要进行正常音视频对话逻辑的两个人,最终导致出现整体逻辑有问题)
 */
@property(nonatomic)bool isEffective;

@property(nonatomic)EaseCallFeedbackResult result;

@property(nonatomic,strong)NSDictionary *subExt;

+ (instancetype)infoWithAction:(EaseCallEventType)action;

+ (instancetype)infoWithMessage:(EMChatMessage *)message;

- (NSDictionary *)generateMessageExt;

@end

NS_ASSUME_NONNULL_END

//
//  EaseCallEventInfo.m
//  EaseCallKit
//
//  Created by 杨剑 on 2025/7/1.
//

#import "EaseCallEventInfo.h"

@interface EaseCallEventInfo ()
//@property(nonatomic,strong,class)NSString *callCmdInfoAction_list;// = @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee"];

@end

@implementation EaseCallEventInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.action = EaseCallEventTypeNone;
        self.result = EaseCallFeedbackResultNone;
        self.toAudio = false;
    }
    return self;
}

+ (instancetype)infoWithAction:(EaseCallEventType)action
                     call_type:(EaseCallType)call_type
                       call_id:(NSString *)call_id
                  channel_name:(NSString *)channel_name
                    starter_id:(NSString *)starter_id
                   receiver_id:(NSString *)receiver_id
                   isEffective:(bool)isEffective
                        result:(EaseCallFeedbackResult)result{
    EaseCallEventInfo *info = EaseCallEventInfo.new;
    info.direction = EaseCallEventDirectionSend;
    info.action = action;
    info.call_type = call_type;
    info.call_id = call_id;
    info.channel_name = channel_name;
    info.callerDevice_id = starter_id;
    info.calleeDevice_id = receiver_id;
    info.isEffective = isEffective;
    info.result = result;
    return info;
}

+ (instancetype)infoWithAction:(EaseCallEventType)action{
    EaseCallEventInfo *info = EaseCallEventInfo.new;
    info.direction = EaseCallEventDirectionSend;
    info.action = action;
    return info;
}

+ (instancetype)infoWithMessage:(EMChatMessage *)message{
    EaseCallEventInfo *info = EaseCallEventInfo.new;
    info.direction = EaseCallEventDirectionReceive;
    info.call_type = [message.ext[@"type"] intValue];
    info.action = [self callCmdActionFromString:message.ext[@"action"]];
    info.call_id = message.ext[@"callId"];
    info.channel_name = message.ext[@"channelName"];
    info.callerDevice_id = message.ext[@"callerDevId"];
    info.calleeDevice_id = message.ext[@"calleeDevId"];
    info.isEffective = [message.ext[@"status"] boolValue];
    info.timestamp = [message.ext[@"ts"] longLongValue];
    info.result = [self callCmdResultFromString:message.ext[@"result"]];
    info.toAudio = [message.ext[@"videoToVoice"] boolValue];
    return info;
}

+ (EaseCallEventType)callCmdActionFromString:(NSString *)value{
#define callCmdInfoAction_list @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee",@"cancelCall",@"videoToVoice",]
    for (int i = 0; i < callCmdInfoAction_list.count; i ++) {
        if ([value  isEqualToString:callCmdInfoAction_list[i]]){
            return i;
        }
    }
    return EaseCallEventTypeNone;
}

+ (NSString *)stringFromCallCmdAction:(EaseCallEventType)value{
    if (value == EaseCallEventTypeNone) {
        return @"";
    }
    return @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee",@"cancelCall",@"videoToVoice",][value];
}

+ (EaseCallFeedbackResult)callCmdResultFromString:(NSString *)value{
#define callCmdResult_list @[@"accept", @"refuse", @"busy",]
    for (int i = 0; i < callCmdResult_list.count; i ++) {
        if ([value  isEqualToString:callCmdResult_list[i]]){
            return i;
        }
    }
    return EaseCallFeedbackResultNone;
}

+ (NSString *)stringFromCallCmdResult:(EaseCallFeedbackResult)value{
    if (value == EaseCallFeedbackResultNone) {
        return @"";
    }
    return @[@"accept", @"refuse", @"busy",][value];
}

- (NSDictionary *)generateMessageExt{
    NSMutableDictionary *mExt = NSMutableDictionary.new;
    mExt[@"msgType"] = @"rtcCallWithAgora";//音视频信令消息的标识,固定位
    mExt[@"action"] = [EaseCallEventInfo stringFromCallCmdAction:self.action];
    mExt[@"ts"] = [NSNumber numberWithLongLong:([[NSDate date] timeIntervalSince1970] * 1000)];
    mExt[@"callId"] = self.call_id;
    if (self.action == EaseCallEventTypeInvite) {
        mExt[@"type"] = @(self.call_type);
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"channelName"] = self.channel_name;
    }else if (self.action == EaseCallEventTypeAlert) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
    }else if (self.action == EaseCallEventTypeConfirmRing) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
        mExt[@"status"] = @(self.isEffective);
    }else if (self.action == EaseCallEventTypeAnswerCall) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
        mExt[@"result"] = [EaseCallEventInfo stringFromCallCmdResult:self.result];
        if (self.toAudio) {
            mExt[@"videoToVoice"] = @(self.toAudio);
        }
    }else if (self.action == EaseCallEventTypeConfirmCallee) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
        mExt[@"result"] = [EaseCallEventInfo stringFromCallCmdResult:self.result];
    }else if (self.action == EaseCallEventTypeCancelCall) {
        mExt[@"callerDevId"] = self.callerDevice_id;
    }else if (self.action == EaseCallEventTypeVideoToAudio) {
    }else{
    }
    if(self.subExt && self.subExt.count) {
        [mExt setValue:self.subExt forKey:@"ext"];
    }
    return [NSDictionary dictionaryWithDictionary:mExt];
}

@end

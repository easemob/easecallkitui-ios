//
//  EaseCallEventInfo.m
//  EaseCallKit
//
//  Created by 杨剑 on 2025/7/1.
//

#import "EaseCallEventInfo.h"

@interface EaseCallEventInfo ()

@end

@implementation EaseCallEventInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.eventType = EaseCallEventTypeNone;
        self.result = EaseCallFeedbackResultNone;
        self.toAudio = false;
    }
    return self;
}

//+ (instancetype)infoWithAction:(EaseCallEventType)action
//                     call_type:(EaseCallType)call_type
//                       call_id:(NSString *)call_id
//                  channel_name:(NSString *)channel_name
//                    starter_id:(NSString *)starter_id
//                   receiver_id:(NSString *)receiver_id
//                   isEffective:(bool)isEffective
//                        result:(EaseCallFeedbackResult)result{
//    EaseCallEventInfo *info = EaseCallEventInfo.new;
//    info.direction = EaseCallEventDirectionSend;
//    info.eventType = action;
//    info.call_type = call_type;
//    info.call_id = call_id;
//    info.channel_name = channel_name;
//    info.callerDevice_id = starter_id;
//    info.calleeDevice_id = receiver_id;
//    info.isEffective = isEffective;
//    info.result = result;
//    return info;
//}

+ (instancetype)infoWithEventType:(EaseCallEventType)eventType{
    EaseCallEventInfo *info = EaseCallEventInfo.new;
    info.direction = EaseCallEventDirectionSend;
    info.eventType = eventType;
    return info;
}

+ (instancetype)infoWithMessage:(EMChatMessage *)message{
    EaseCallEventInfo *info = EaseCallEventInfo.new;
    info.direction = EaseCallEventDirectionReceive;
    info.eventType = [self callEventTypeFromString:message.ext[@"action"]];
    info.call_type = [message.ext[@"type"] intValue];
    info.call_id = message.ext[@"callId"];
    info.channel_name = message.ext[@"channelName"];
    info.callerDevice_id = message.ext[@"callerDevId"];
    info.calleeDevice_id = message.ext[@"calleeDevId"];
    info.isEffective = [message.ext[@"status"] boolValue];
    info.timestamp = [message.ext[@"ts"] longLongValue];
    info.result = [self callFeedbackResultFromString:message.ext[@"result"]];
    info.toAudio = [message.ext[@"videoToVoice"] boolValue];
    if ([message.ext[@"ext"] isKindOfClass:[NSDictionary class]]){
        info.subExt = message.ext[@"ext"];
    }
    if (!info.call_id.length){
        return nil;
    }
    return info;
}
//+ (EaseCallEventType)callEventTypeFromString:(NSString *)value;
//+ (NSString *)stringFromCallEventType:(EaseCallEventType)value;
//
//+ (EaseCallFeedbackResult)callFeedbackResultFromString:(NSString *)value;
//+ (NSString *)stringFromCallFeedbackResult:(EaseCallFeedbackResult)value;

+ (EaseCallEventType)callEventTypeFromString:(NSString *)value{
#define callCmdInfoAction_list @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee",@"cancelCall",@"videoToVoice",]
    for (int i = 0; i < callCmdInfoAction_list.count; i ++) {
        if ([value  isEqualToString:callCmdInfoAction_list[i]]){
            return i;
        }
    }
    return EaseCallEventTypeNone;
}

+ (NSString *)stringFromCallEventType:(EaseCallEventType)value{
    if (value == EaseCallEventTypeNone) {
        return @"";
    }
    return @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee",@"cancelCall",@"videoToVoice",][value];
}

+ (EaseCallFeedbackResult)callFeedbackResultFromString:(NSString *)value{
#define callCmdResult_list @[@"accept", @"refuse", @"busy",]
    for (int i = 0; i < callCmdResult_list.count; i ++) {
        if ([value  isEqualToString:callCmdResult_list[i]]){
            return i;
        }
    }
    return EaseCallFeedbackResultNone;
}

+ (NSString *)stringFromCallFeedbackResult:(EaseCallFeedbackResult)value{
    if (value == EaseCallFeedbackResultNone) {
        return @"";
    }
    return @[@"accept", @"refuse", @"busy",][value];
}

- (NSDictionary *)generateMessageExt{
    NSMutableDictionary *mExt = NSMutableDictionary.new;
    mExt[@"msgType"] = @"rtcCallWithAgora";//音视频信令消息的标识,固定位
    mExt[@"action"] = [EaseCallEventInfo stringFromCallEventType:self.eventType];
    mExt[@"ts"] = [NSNumber numberWithLongLong:([[NSDate date] timeIntervalSince1970] * 1000)];
    mExt[@"callId"] = self.call_id;
    if (self.eventType == EaseCallEventTypeInvite) {
        mExt[@"type"] = @(self.call_type);
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"channelName"] = self.channel_name;
    }else if (self.eventType == EaseCallEventTypeAlert) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
    }else if (self.eventType == EaseCallEventTypeConfirmRing) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
        mExt[@"status"] = @(self.isEffective);
    }else if (self.eventType == EaseCallEventTypeAnswerCall) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
        mExt[@"result"] = [EaseCallEventInfo stringFromCallFeedbackResult:self.result];
        if (self.toAudio) {
            mExt[@"videoToVoice"] = @(self.toAudio);
        }
    }else if (self.eventType == EaseCallEventTypeConfirmCallee) {
        mExt[@"callerDevId"] = self.callerDevice_id;
        mExt[@"calleeDevId"] = self.calleeDevice_id;
        mExt[@"result"] = [EaseCallEventInfo stringFromCallFeedbackResult:self.result];
    }else if (self.eventType == EaseCallEventTypeCancelCall) {
        mExt[@"callerDevId"] = self.callerDevice_id;
    }else if (self.eventType == EaseCallEventTypeVideoToAudio) {
    }else{
    }
    if(self.subExt && self.subExt.count) {
        [mExt setValue:self.subExt forKey:@"ext"];
    }
    return [NSDictionary dictionaryWithDictionary:mExt];
}

@end

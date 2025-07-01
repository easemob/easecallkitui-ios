//
//  EaseCallCmdInfo.m
//  EaseCallKit
//
//  Created by 杨剑 on 2025/7/1.
//

#import "EaseCallCmdInfo.h"

@interface EaseCallCmdInfo ()
//@property(nonatomic,strong,class)NSString *callCmdInfoAction_list;// = @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee"];

@end

@implementation EaseCallCmdInfo



+ (instancetype)infoWithAction:(EaseCallCmdAction)action
                     call_type:(EaseCallType)call_type
                       call_id:(NSString *)call_id
                  channel_name:(NSString *)channel_name
                    starter_id:(NSString *)starter_id
                   receiver_id:(NSString *)receiver_id
                   isEffective:(bool)isEffective
                        result:(EaseCallCmdResult)result{
    EaseCallCmdInfo *info = EaseCallCmdInfo.new;
    info.direction = EaseCallCmdMessageDirectionSend;
    info.action = action;
    info.call_type = call_type;
    info.call_id = call_id;
    info.channel_name = channel_name;
    info.starter_id = starter_id;
    info.receiver_id = receiver_id;
    info.isEffective = isEffective;
    info.result = result;
    return info;
}

+ (instancetype)infoWithAction:(EaseCallCmdAction)action{
    EaseCallCmdInfo *info = EaseCallCmdInfo.new;
    info.direction = EaseCallCmdMessageDirectionSend;
    info.action = action;
    return info;
}

+ (instancetype)infoWithMessage:(EMChatMessage *)message{
    EaseCallCmdInfo *info = EaseCallCmdInfo.new;
    info.direction = EaseCallCmdMessageDirectionReceive;
    info.call_type = [message.ext[@"type"] intValue];
    info.action = [self callCmdActionFromString:message.ext[@"action"]];
    info.call_id = message.ext[@"callId"];
    info.channel_name = message.ext[@"channelName"];
    info.starter_id = message.ext[@"callerDevId"];
    info.receiver_id = message.ext[@"calleeDevId"];
    info.isEffective = [message.ext[@"status"] boolValue];
    info.timestamp = [message.ext[@"ts"] longLongValue];
    info.result = [self callCmdResultFromString:message.ext[@"result"]];
    return info;
}

+ (EaseCallCmdAction)callCmdActionFromString:(NSString *)value{
#define callCmdInfoAction_list @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee",]
    for (int i = 0; i < callCmdInfoAction_list.count; i ++) {
        if ([value  isEqualToString:callCmdInfoAction_list[i]]){
            return i;
        }
    }
    return EaseCallCmdActionNone;
}

+ (NSString *)stringFromCallCmdAction:(EaseCallCmdAction)action{
    return @[@"invite", @"alert", @"confirmRing", @"answerCall", @"confirmCallee",][action];
}

+ (EaseCallCmdResult)callCmdResultFromString:(NSString *)value{
#define callCmdResult_list @[@"accept", @"refuse", @"busy",@"",]
    for (int i = 0; i < callCmdResult_list.count; i ++) {
        if ([value  isEqualToString:callCmdResult_list[i]]){
            return i;
        }
    }
    return EaseCallCmdResultNone;
}

+ (NSString *)stringFromCallCmdResult:(EaseCallCmdResult)result{
    return @[@"accept", @"refuse", @"busy",@"",][result];
}

- (NSDictionary *)generateMessageExt{
    NSMutableDictionary *mExt = NSMutableDictionary.new;
    mExt[@"msgType"] = @"rtcCallWithAgora";//音视频信令消息的标识,固定位
    mExt[@"action"] = [EaseCallCmdInfo stringFromCallCmdAction:self.action];
    mExt[@"ts"] = [NSNumber numberWithLongLong:([[NSDate date] timeIntervalSince1970] * 1000)];
    if (self.action == EaseCallCmdActionInvite) {
        mExt[@"type"] = @(self.call_type);
        mExt[@"callId"] = self.call_id;
        mExt[@"callerDevId"] = self.starter_id;
        mExt[@"channelName"] = self.channel_name;
    }else if (self.action == EaseCallCmdActionAlert) {
        mExt[@"callerDevId"] = self.starter_id;
        mExt[@"calleeDevId"] = self.receiver_id;
        mExt[@"callId"] = self.call_id;
    }else if (self.action == EaseCallCmdActionConfirmRing) {
        mExt[@"callerDevId"] = self.starter_id;
        mExt[@"calleeDevId"] = self.receiver_id;
        mExt[@"callId"] = self.call_id;
        mExt[@"status"] = @(self.isEffective);
    }else if (self.action == EaseCallCmdActionAnswerCall) {
        mExt[@"callerDevId"] = self.starter_id;
        mExt[@"calleeDevId"] = self.receiver_id;
        mExt[@"callId"] = self.call_id;
        mExt[@"result"] = [EaseCallCmdInfo stringFromCallCmdResult:self.result];
    }else if (self.action == EaseCallCmdActionAonfirmCallee) {
        mExt[@"callerDevId"] = self.starter_id;
        mExt[@"calleeDevId"] = self.receiver_id;
        mExt[@"callId"] = self.call_id;
        mExt[@"result"] = [EaseCallCmdInfo stringFromCallCmdResult:self.result];
    }else if (self.action == EaseCallCmdActionNone) {
    }
    return [NSDictionary dictionaryWithDictionary:mExt];
}

@end

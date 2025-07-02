//
//  EaseCallCommon.m
//  EaseCallKit
//
//  Created by 杨剑 on 2025/6/25.
//

#import "EaseCallCommon.h"
#import "EaseCallManager.h"
@implementation EaseCallCommon

+ (NSString *)generateRandomString{
    NSMutableString *randomString = NSMutableString.new;
    [randomString appendString:NSUUID.UUID.UUIDString];
//    long long timestamp = NSDate.new.timeIntervalSince1970 * 1000;
//    [randomString appendFormat:@"_%lld",timestamp % 864000];
    return randomString.copy;
}

+ (NSString *)generateChannelNameWithFromUserid:(NSString *)fromUserid toUserid:(NSString *)toUserid{
/**
 //如果有必要可以使用这种方式生成 声网通道名
 NSMutableString *channelName = NSMutableString.new;
 [channelName appendString:fromUserid];
 [channelName appendString:@"__TO__"];
 [channelName appendString:toUserid];
 long long timestamp = NSDate.new.timeIntervalSince1970 * 1000;
 [channelName appendFormat:@"_%lld",timestamp % 864000000];
 return channelName.copy;
 */
    return self.generateRandomString;
}

+ (void)printLog:(NSString *)string{
    if (!EaseCallManager.sharedManager.getEaseCallConfig.enableOutputLog){
        return;
    }
    NSString *final = [NSString stringWithFormat:@"EASE_CALL_KIT::%@",string];
    [EMClient.sharedClient log:final];
}


+ (NSString *)stringFromMap:(NSDictionary *)map{
    if (!map) {
        return @"{}";
    }
    if (!map.allKeys.count) {
        return @"{}";
    }
    // 设置输出选项
    NSJSONWritingOptions options = NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map
                                                       options:options
                                                         error:&error];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"map转换失败";
}

//+ (void)printReceivedMessage:(EMChatMessage *)message{
//    [self printMessage:message direction:EMMessageDirectionReceive];
//}
//
//+ (void)printSendMessage:(EMChatMessage *)message{
//    [self printMessage:message direction:EMMessageDirectionSend];
//}

+ (void)printMessage:(EMChatMessage *)message {
    if (!EaseCallManager.sharedManager.getEaseCallConfig.enableOutputLog){
        return;
    }
    NSMutableString *mString = NSMutableString.new;
    [mString appendString:@"打印消息\n=================================\n"];
    if (message.direction == EMMessageDirectionSend){
        [mString appendString:@"音视频模块消息 发送消息:\n"];
    }else{
        [mString appendString:@"音视频模块消息 收到消息:\n"];
    }
    
    
    EMMessageBodyType bodyType = message.body.type;
    if (bodyType == 1) {
        [mString appendString:@"消息内容类型为 文本 [txt]\n"];
        EMTextMessageBody *body = (EMTextMessageBody *)message.body;
        [mString appendFormat:@"text [%@]\n",body.text];
    }else if (bodyType == 2){
        [mString appendString:@"消息内容类型为 文件-图片 [image]\n"];
        [mString appendString:@"[音视频消息不涉及到此类型内容]\n"];
    }else if (bodyType == 3){
        [mString appendString:@"消息内容类型为 文件-视频 [video]\n"];
        [mString appendString:@"[音视频消息不涉及到此类型内容]\n"];
    }else if (bodyType == 4){
        [mString appendString:@"消息内容类型为 位置 [location]\n"];
        [mString appendString:@"[音视频消息不涉及到此类型内容]\n"];
    }else if (bodyType == 5){
        [mString appendString:@"消息内容类型为 文件-语音 [voice]\n"];
        [mString appendString:@"[音视频消息不涉及到此类型内容]\n"];
    }else if (bodyType == 6){
        [mString appendString:@"消息内容类型为 文件 [file]\n"];
        [mString appendString:@"[音视频消息不涉及到此类型内容]\n"];
    }else if (bodyType == 7){
        [mString appendString:@"消息内容类型为 指令 [CMD]\n"];
        EMCmdMessageBody *body = (EMCmdMessageBody *)message.body;
        [mString appendFormat:@"action [%@]\n",body.action];
        [mString appendFormat:@"isDeliverOnlineOnly [%d]\n",body.isDeliverOnlineOnly];
        
    }else if (bodyType == 8){
        [mString appendString:@"消息内容类型为 自定义 [custom]\n"];
        EMCustomMessageBody *body = (EMCustomMessageBody *)message.body;
        [mString appendFormat:@"event [%@]\n",body.event];
        [mString appendFormat:@"customExt \n%@\n",[EaseCallCommon stringFromMap:body.customExt]];
    }else if (bodyType == 8){
        [mString appendString:@"消息内容类型为 合并 [combine]\n"];
        [mString appendString:@"[音视频消息不涉及到此类型内容]\n"];
    }
    [mString appendString:@"消息的ext扩展内容:\n"];
    [mString appendFormat:@"消息的ext \n%@\n",[EaseCallCommon stringFromMap:message.ext]];
    [mString appendString:@"=================================\n"];
    [self printLog:mString];
}





@end

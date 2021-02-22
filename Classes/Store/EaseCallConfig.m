//
//  EaseCallConfig.m
//  EMiOSDemo
//
//  Created by lixiaoming on 2020/12/9.
//  Copyright © 2020 lixiaoming. All rights reserved.
//

#import "EaseCallConfig.h"

@implementation EaseCallUser
- (instancetype)init
{
    self = [super init];
    if(self) {
        NSBundle* bundle = [NSBundle bundleForClass:[self class]];
        NSString* path = [NSString stringWithFormat:@"EaseCall.bundle/icon"];
        NSURL* url = [bundle URLForResource:path withExtension:@"png"];
        self.headImage = url;
        self.nickName = @"";
    }
    return self;
}
@end

@interface EaseCallConfig ()
// 语音通话可以转视频通话
@property (nonatomic) BOOL canSwitchVoiceToVideo;
@end

@implementation EaseCallConfig
- (instancetype)init
{
    self = [super init];
    if(self) {
        [self _initParams];
    }
    return self;
}

- (void)_initParams
{
    _callTimeOut = 30;
    _enableRTCTokenValidate = NO;
    _users = [NSMutableDictionary dictionary];
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSString * ringFilePath = [bundle pathForResource:@"EaseCall.bundle/music" ofType:@"mp3"];
    //_ringFileUrl = [[NSBundle mainBundle] URLForResource:@"music" withExtension:@".mp3"];
    _ringFileUrl = [NSURL fileURLWithPath:ringFilePath];
    NSString* path = [NSString stringWithFormat:@"EaseCall.bundle/icon"];
    NSURL* url = [bundle URLForResource:path withExtension:@"png"];
    _defaultHeadImage = url;
    _agoraAppId = @"15cb0d28b87b425ea613fc46f7c9f974";
}

@end

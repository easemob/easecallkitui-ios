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
        NSString* path = [NSString stringWithFormat:@"EaseCall.bundle/icon"];
        NSURL* url = [[NSBundle mainBundle] URLForResource:path withExtension:@"png"];
        self.headImage = url;
        self.nickName = @"";
        self.uId = @"";
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
    _users = [NSMutableDictionary dictionary];
    NSString * ringFilePath = [[NSBundle mainBundle] pathForResource:@"EaseCall.bundle/music" ofType:@"mp3"];
    //_ringFileUrl = [[NSBundle mainBundle] URLForResource:@"music" withExtension:@".mp3"];
    _ringFileUrl = [NSURL fileURLWithPath:ringFilePath];
    NSString* path = [NSString stringWithFormat:@"EaseCall.bundle/icon"];
    NSURL* url = [[NSBundle mainBundle] URLForResource:path withExtension:@"png"];
    _defaultHeadImage = url;
}

@end

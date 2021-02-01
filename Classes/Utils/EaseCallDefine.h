//
//  EaseCallDefine.h
//  EaseIM
//
//  Created by lixiaoming on 2021/1/8.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#ifndef EaseCallDefine_h
#define EaseCallDefine_h
typedef NS_ENUM(NSInteger,EaseCallType) {
    EaseCallType1v1Audio,
    EaseCallType1v1Video,
    EaseCallTypeMulti
};

typedef NS_ENUM(NSInteger,EaseCallEndReason) {
    EaseCallEndReasonHangup,
    EaseCallEndReasonCancel,
    EaseCallEndReasonRemoteCancel,
    EaseCallEndReasonRefuse,
    EaseCallEndReasonBusy,
    EaseCallEndReasonNoResponse,
    EaseCallEndReasonRemoteNoResponse,
    EaseCallEndReasonHandleOnOtherDevice
};

typedef NS_ENUM(NSInteger,EaseCallErrorType) {
    EaseCallErrorTypeProcess,
    EaseCallErrorTypeRTC,
    EaseCallErrorTypeIM
};

typedef NS_ENUM(NSInteger,EaseCallProcessErrorCode) {
    EaseCallProcessErrorCodeInvalidParams = 100,
    EaseCallProcessErrorCodeBusy,
    EaseCallProcessErrorCodeFetchTokenFail,
};

#endif /* EaseCallDefine_h */

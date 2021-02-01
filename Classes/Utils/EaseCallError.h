//
//  EaseCallError.h
//  EaseIM
//
//  Created by lixiaoming on 2021/1/29.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseCallDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallError : NSObject
@property (nonatomic) EaseCallErrorType aErrorType;
@property (nonatomic) NSInteger errCode;
@property (nonatomic) NSString* errDescription;
+(instancetype)errorWithType:(EaseCallErrorType)aType code:(NSInteger)errCode description:(NSString*)aDescription;
@end

NS_ASSUME_NONNULL_END

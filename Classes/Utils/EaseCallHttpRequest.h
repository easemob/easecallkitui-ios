//
//  EaseCallHttpRequest.h
//  EaseIM
//
//  Created by lixiaoming on 2021/1/30.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EaseCallHttpRequest : NSObject
+ (NSString*)requestWithUrl:(NSString*)aUrl parameters:(NSDictionary*)aParameters token:(NSString*)aToken timeOutInterval:(NSInteger)aTimeOutSeconds failCallback:(void(^)(NSData*resBody))aFailBlock;
@end

NS_ASSUME_NONNULL_END

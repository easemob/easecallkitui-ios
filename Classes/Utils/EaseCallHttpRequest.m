//
//  EaseCallHttpRequest.m
//  EaseIM
//
//  Created by lixiaoming on 2021/1/30.
//  Copyright © 2021 lixiaoming. All rights reserved.
//

#import "EaseCallHttpRequest.h"

@implementation EaseCallHttpRequest
+ (NSString*)requestWithUrl:(NSString*)aUrl parameters:(NSDictionary*)aParameters token:(NSString*)aToken timeOutInterval:(NSInteger)aTimeOutSeconds failCallback:(void(^)(NSData*resBody))aFailBlock
{
    __block NSString*rtcToken = @"";
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];

    NSURL* url = [NSURL URLWithString:aUrl];
    NSMutableURLRequest* urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlReq setValue:[NSString stringWithFormat:@"Bearer %@",aToken] forHTTPHeaderField:@"Authorization"];
    urlReq.HTTPBody = [NSJSONSerialization dataWithJSONObject:aParameters options:0 error:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary* body = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",body);
        if(body) {
            NSNumber* resCode = [body objectForKey:@"resCode"];
            if(resCode && resCode.intValue == 200) {
                rtcToken = [body objectForKey:@"rtcToken"];
            }else{
                if(aFailBlock) {
                    aFailBlock(data);
                }
            }
        }
        
    }];
    
    //启动
    [task resume];
    dispatch_semaphore_wait(sem, aTimeOutSeconds);
    return rtcToken;
}
@end

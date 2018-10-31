//
//  HKBaseNetManager.m
//  sHome
//
//  Created by CY on 2017/11/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "HKBaseNetManager.h"

@implementation HKBaseNetManager

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
    return [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@, %@", task.currentRequest.URL.absoluteString, error);
        !completionHandler?:completionHandler(nil, error);
    }];
}

+ (id)DELETE:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id, NSError *))completionHandler {
    return [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:path parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", task.currentRequest.URL.absoluteString);
        !completionHandler?:completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@, %@", task.currentRequest.URL.absoluteString, error);
        !completionHandler?:completionHandler(nil, error);
    }];
}

@end

//
//  HKBaseNetManager.h
//  sHome
//
//  Created by CY on 2017/11/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKBaseNetManager : NSObject

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObj, NSError *error))completionHandler;

+ (id)DELETE:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObj, NSError *error))completionHandler;

@end

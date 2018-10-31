//
//  CYBaseNetManager.h
//  sHome
//
//  Created by CY on 2017/11/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface CYBaseNetManager : NSObject

+ (id)GET:(NSString *)path parameters:(NSDictionary *)parameters completionHandler:(void (^)(id responseObj, NSError *error))completionHandler;

@end

//
//  MPRequstFailedHelper.h
//  MobileProject 统一处理网络请求失败时的内容
//
//  Created by shaop on 16/8/16.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"

@interface MPRequstFailedHelper : NSObject

+(void)requstFailed:(YTKBaseRequest *)request;

@end

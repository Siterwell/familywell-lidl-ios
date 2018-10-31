//
//  ErrorCodeUtil.h
//  sHome
//
//  Created by shaop on 2017/3/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorModel.h"

@interface ErrorCodeUtil : NSObject
+ (NSString *)getErrorMessageWithError:(ErrorModel *)model withDeviceTid:(NSString *)devTid;
+ (NSString *)getMessageWithCode:(long) code;
@end

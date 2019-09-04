//
//  NSString+Utils.h
//  XWorld
//
//  Created by DingLin on 16/5/19.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
NSDate *YYNSDateFromString(__unsafe_unretained NSString *string);
//获取文本的长度
+(int)getStringLength:(NSString*)message;

//NSString-NSDateComponents
+(NSDateComponents*)toComponents:(NSString*)timeString;

- (BOOL)isContainsString:(NSString *)sFind;
@end

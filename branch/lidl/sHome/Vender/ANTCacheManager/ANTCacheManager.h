//
//  ANTCacheManager.h
//  antQueen
//
//  Created by yixiuge on 16/5/11.
//  Copyright © 2016年 yibyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANTCacheManager : NSObject


/**
 *  获取Manage实例（单例模式）
 *
 *  历史数据的分析工具类，添加本地通知或者其他的一些操作
 *
 *  @return 返回的实例对象
 */
+(ANTCacheManager*)shareManage;


+(NSData*)getCacheData:(NSString*)fileName_;


+(BOOL)cache:(NSData*)data fileName:(NSString*)fileName_;


+ (id)responseDicFromCache:(NSString*)fileName;

+ (BOOL)cacheJsonData:(NSDictionary*)dictonary fileName:(NSString*)fileName;

@end

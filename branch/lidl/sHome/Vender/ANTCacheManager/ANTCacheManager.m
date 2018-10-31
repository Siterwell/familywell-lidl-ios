//
//  ANTCacheManager.m
//  antQueen
//
//  Created by yixiuge on 16/5/11.
//  Copyright © 2016年 yibyi. All rights reserved.
//

#import "ANTCacheManager.h"
#import "NSString+SCAddition.h"
@implementation ANTCacheManager


static ANTCacheManager *manage = nil;

+(ANTCacheManager*)shareManage
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manage = [[self alloc] init];
    });
    return manage;
}

+(NSData*)getCacheData:(NSString*)fileName_
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName=[documentDirectory stringByAppendingPathComponent:[fileName_ MD5String]];
    
    NSData *writeData=[[NSData alloc]initWithContentsOfFile:fileName];
    
    if (writeData==nil) {
        return nil;
    }
    
    
    return writeData;
}

+ (id)responseDicFromCache:(NSString*)fileName {
    
    NSData  *cacheData  = [self getCacheData:fileName];
    
    if (cacheData) {
        NSDictionary  *dic = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingAllowFragments error:nil];
        if (dic) {
            return dic;
        }
    }

    return nil;
}

+ (BOOL)cacheJsonData:(NSDictionary*)dictonary fileName:(NSString*)fileName {
    
    NSData  *data = [NSJSONSerialization dataWithJSONObject:dictonary options:NSJSONWritingPrettyPrinted error:nil];
    
    BOOL  success = NO;
    
    if (data) {
        success = [self cache:data fileName:fileName];
    }
    return success;
}


+(BOOL)cache:(NSData*)data fileName:(NSString*)fileName_
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *fileName=[documentDirectory stringByAppendingPathComponent:[fileName_ MD5String]];
    
    return [data writeToFile:fileName atomically:YES];
}

@end

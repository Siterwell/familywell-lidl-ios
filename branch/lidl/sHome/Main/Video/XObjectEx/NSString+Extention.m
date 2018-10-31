//
//  NSString+Extention.m
//  XMFamily
//
//  Created by Megatron on 4/24/15.
//  Copyright (c) 2015 Megatron. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)

#pragma mark 获取缓存路径
+(NSString *)getLocalCacheDirectory{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return path;
}

#pragma mark - 配置文件保存的路径
+(NSString *)configFilePath {
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString* path = [pathArray objectAtIndex:0];
    NSString *configFilePath = [path stringByAppendingString:@"/Configs/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:configFilePath]) {
        [fileManager createDirectoryAtPath:configFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return configFilePath;
}

+ ToNSStr:(const char*)szStr{
    NSString* retStr;
    if (szStr) {
        retStr = [NSString stringWithUTF8String:szStr];
    }
    else {
        return @"";
    }
    
    if (retStr == nil || (retStr.length == 0 && strlen(szStr) > 0)) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* data = [NSData dataWithBytes:szStr length:strlen(szStr)];
        retStr = [[NSString alloc] initWithData:data encoding:enc];
    }
    if (retStr == nil) {
        retStr = @"";
    }
    return retStr;
}

+ (NSString*)GetSystemTimeString{
    NSDate* nowDate = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:nowDate];
    return dateString;
}

+ (NSString*)GetSystemTimeString2{
    NSDate* nowDate = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateString = [dateFormatter stringFromDate:nowDate];
    return dateString;
}

+ (char*)AutoCopyUTF8Str:(NSString*)string{ //unicode编码
    return (char*)[string UTF8String];
}

+ (char*)AutoCopyUTF8Str:(NSString*)string Unicode:(BOOL)unicode{
    //    if (unicode == YES) {
    //            NSString* encodedString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //            NSData* gb2312data = [encodedString dataUsingEncoding:NSUTF8StringEncoding];
    //            char userName[128] = {0};
    //            [gb2312data getBytes:userName length:sizeof(userName)];
    //            return userName;
    //    }else{
    return [NSString AutoCopyUTF8Str:string];
    //    }
}
+ (char*)AutoCopyUTF8Str:(NSString*)string Unicode:(BOOL)unicode GBKcode:(BOOL)gbkcode{
    return (char*)[string UTF8String];
    //    if ([self IsChinese:string]) {
    //#if ExperienceVersion
    //        return [GUI AutoCopyUTF8Str:string Unicode:unicode];
    //#else
    //        return [GUI getGBKWithString:string GBKcode:gbkcode];
    //#endif
    //    }
    //    else{
    //        return (char*)[string UTF8String];
    //    }
}
+ (char*)getGBKWithString:(NSString*)string GBKcode:(BOOL)gbkcode{
    if (gbkcode == YES) {
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        return (char*)[string cStringUsingEncoding:encoding];
    }
    else {
        return (char*)[string UTF8String];
    }
}

+ (BOOL)IsChinese:(NSString*)str{
    for (int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

+ (NSData*)UTF8StrToGBKData:(NSString*)strUTF8{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [strUTF8 dataUsingEncoding:encoding];
    return gb2312data;
}


+(void)CreateFilePath:(NSString *)fullPath{
    if (fullPath == nil) {
        return;
    }
    NSString *fileName = [fullPath lastPathComponent];
    if (fileName == nil) {
        return;
    }
    NSString *filePath = [fullPath substringWithRange:NSMakeRange(0, [fullPath length] - [fileName length])];
    if (fileName == nil) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSString*)GetDocumentPath:(NSString*)fileName{
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", [NSString GetDocumentPath], fileName];
    [NSString CreateFilePath:fullPath];
    return fullPath;
}

+ (NSString*)GetDocumentPath{
    NSArray* pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* path = [pathArray lastObject];
    if (path != nil) {
        path = [path stringByAppendingString:@"/"];
    } else {
        return @"";
    }
    return path;
}

+ (BOOL)IsIPAddress:(NSString*)strIP{
    if (strIP.length < 7 || strIP.length > 17) {
        return FALSE;
    }
    NSString* regexIP = @"^((0|(?:[1-9]\\d{0,1})|(?:1\\d{2})|(?:2[0-4]\\d)|(?:25[0-5]))\\.){3}((?:[1-9]\\d{0,1})|(?:1\\d{2})|(?:2[0-4]\\d)|(?:25[0-5]))$";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexIP];
    return [pred evaluateWithObject:strIP];
}

+ (BOOL)IsDevID:(NSString*)strID{
    if (strID.length < 5) {
        return FALSE;
    }
    NSString* regexID = @"^[0-9A-Za-z]";
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexID];
    return ![pred evaluateWithObject:strID];
}


+ (NSString*)setLocalizedString:(NSString*)key{
    NSString* language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (language == nil) {
        language = @"en";
    }
    NSString *value = nil;
    if ([language containsString:@"zh"]) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        if (path == nil) {
            path = [[NSBundle mainBundle] pathForResource:@"zh-Hans-CN" ofType:@"lproj"];
        }
        NSBundle* languageBundle = [NSBundle bundleWithPath:path];
        value = [languageBundle localizedStringForKey:key value:@"" table:nil];
    }
    else {
        value = NSLocalizedString(key, nil);
    }
    return (value == nil || [value length] == 0) ? key : value;
}
@end

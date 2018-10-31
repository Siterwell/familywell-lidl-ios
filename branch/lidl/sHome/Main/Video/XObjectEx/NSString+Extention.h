#import <Foundation/Foundation.h>

@interface NSString (Extention)

+(NSString *)getLocalCacheDirectory;
+(NSString *)configFilePath;
+(void)CreateFilePath:(NSString *)fullPath;

+ (NSString*)GetDocumentPath:(NSString*)fileName;
+ (NSString*)GetDocumentPath;
+ (NSString*)GetSystemTimeString;
+ (NSString*)GetSystemTimeString2;
+ (BOOL)IsIPAddress:(NSString*)strIP;
+ (BOOL)IsDevID:(NSString*)strID;
+ (NSString*)ToNSStr:(const char*)szStr;

//unicode:unicode编码，gbkcode:gb312编码
+ (char*)AutoCopyUTF8Str:(NSString*)string Unicode:(BOOL)unicode GBKcode:(BOOL)gbkcode;
+ (char*)AutoCopyUTF8Str:(NSString*)string;
+ (char*)AutoCopyUTF8Str:(NSString*)string Unicode:(BOOL)unicode;
+ (BOOL)IsChinese:(NSString*)str;
+ (NSData*)UTF8StrToGBKData:(NSString*)strUTF8;
+ (char*)getGBKWithString:(NSString*)string;

// language
+ (NSString*)setLocalizedString:(NSString*)key;
@end

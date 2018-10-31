//
//  GUI.h
//  XMeye
//
//  Created by hzjf on 14-9-11.
//  Copyright (c) 2014年 zhao yongjun. All rights reserved.
//

#import "SVProgressHUD.h"
#import "XValue.h"
#import <UIKit/UIKit.h>
#import "NSString+Extention.h"


#define jjjj NSLog(@"调试用");//调试用
#define ADD_NOTIFY(X) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(X:) name:@"" #X "" object:nil]
#define REMOVE_NOTIFY [[NSNotificationCenter defaultCenter] removeObserver:self]
#define DPLocalizedString(key, placeholder) [NSString setLocalizedString:key]
#define TS(x) DPLocalizedString(@x, @"")
#define SZSTR(x) (x == nil ? "" : [x UTF8String])
#define NSSTR(x) [NSString ToNSStr:x]
#define CSTR SZSTR
#define OCSTR NSSTR

#define STRNCPY(x, y)           \
    if (x != NULL && y != NULL) \
    strncpy(x, y, sizeof(x))
#define STRNSCPY(x, y)         \
    if (x != NULL && y != nil) \
    strncpy(x, [y UTF8String], sizeof(x))



@interface NSMessage : NSObject
@property (strong, nonatomic) NSObject* nsObj;
@property (strong, nonatomic) NSString* strParam;
@property (strong, nonatomic) id objId;
@property (readwrite, assign) void* obj;
@property (readwrite, assign) int param1;
@property (readwrite, assign) int param2;

+ (NSMessage*)New:(int)param1 initP2:(int)param2 initStr:(NSString*)str;
+ (NSMessage*)New:(void*)pObj initP1:(int)param1;
+ (NSMessage*)New:(int)param1;

@end

@interface GUI : NSObject
// 显示信息
+ (void)ShowInfo:(NSString*)str title:(NSString*)title;
+ (void)ShowInfo:(NSString*)str;
+ (void)ShowError:(NSString*)str title:(NSString*)title;
+ (void)ShowError:(NSString*)str;
+ (void)ShowNError:(int)errorno title:(NSString*)title;
+ (void)ShowNError:(int)errorno;
+ (void)ShowAlarm:(NSString*)str title:(NSString*)title;

+ (void)SendMessag:(NSString*)name p1:(int)param1;
+ (void)SendMessag:(NSString*)name p1:(int)param1 p2:(int)param2;
+ (void)SendMessag:(NSString*)name obj:(void*)obj p1:(int)param1;
+ (void)SendMessag:(NSString*)name obj:(void*)obj p1:(int)param1 p2:(int)param2;
+ (void)SendMessag:(NSString*)name msg:(NSMessage*)msg;

+ (NSString*)GetErrorStr:(int)errorno;

@end

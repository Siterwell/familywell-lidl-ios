//
//  GUI.cpp
//  XMeye
//
//  Created by hzjf on 14-9-11.
//  Copyright (c) 2014年 zhao yongjun. All rights reserved.
//

#import "FunSDK/FunSDk.h"
#import "GUI.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>

@implementation NSMessage

+ (NSMessage*)New:(int)param1 initP2:(int)param2 initStr:(NSString*)str
{
    NSMessage* pNew = [NSMessage alloc];
    [pNew setObj:nil];
    [pNew setParam1:param1];
    [pNew setParam2:param2];
    [pNew setStrParam:str];
    return pNew;
}

+ (NSMessage*)New:(void*)pObj initP1:(int)param1
{
    NSMessage* pNew = [NSMessage alloc];
    [pNew setObj:pObj];
    [pNew setParam1:param1];
    return pNew;
};

+ (NSMessage*)New:(int)param1
{
    return [NSMessage New:NULL initP1:param1];
}

@end

@implementation GUI
+ (NSString*)GetErrorStr:(int)errorno
{
    static int errs[] = {
        EE_DVR_PASSWORD_NOT_VALID,
        EE_DVR_LOGIN_USER_NOEXIST,
        
    };
    static char const* strErrs[] = { "login error",
        "password invalid",
        "user invalid",
    };
    int nCount = sizeof(errs) / sizeof(int);
    for (int i = 0; i < nCount; ++i) {
        if (errs[i] == errorno) {
            return DPLocalizedString([NSString stringWithUTF8String:strErrs[i]], @"");
        }
    }
    return [NSString stringWithFormat:@"%@:%d", TS("error"), errorno];
}

+ (void)ShowInfo:(NSString*)str title:(NSString*)title
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:str delegate:nil cancelButtonTitle:TS("OK") otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)ShowInfo:(NSString*)str
{
    [GUI ShowInfo:str title:nil];
}

+ (void)ShowError:(NSString*)str title:(NSString*)title
{
    NSString *showTitle = @"";
    if (title != nil && [title length] > 0) {
        showTitle = [NSString stringWithFormat:@"%@\r\n", title];
    }
    NSString *show = [NSString stringWithFormat:@"%@%@", showTitle, str];
    [SVProgressHUD dismissWithError:show afterDelay:2.5];
}

+ (void)ShowError:(NSString*)str
{
    NSString *showTitle = [NSString stringWithFormat:@">>>>>>>%@<<<<<<<", TS("Error")];
    [GUI ShowError:str title:showTitle];
}

+ (void)ShowNError:(int)errorno title:(NSString*)title
{
    [GUI ShowError:[GUI GetErrorStr:errorno] title:title];
}

+ (void)ShowNError:(int)errorno
{
    [GUI ShowError:[GUI GetErrorStr:errorno]];
}

+ (void)ShowAlarm:(NSString*)str title:(NSString*)title
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:DPLocalizedString(title, @"") message:DPLocalizedString(str, @"") delegate:nil cancelButtonTitle:TS("OK") otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)SendMessag:(NSString*)name p1:(int)param1
{
    [GUI SendMessag:name obj:NULL p1:param1 p2:0];
}

+ (void)SendMessag:(NSString*)name p1:(int)param1 p2:(int)param2
{
    [GUI SendMessag:name obj:NULL p1:param1 p2:param2];
}

+ (void)SendMessag:(NSString*)name obj:(void*)obj p1:(int)param1
{
    [GUI SendMessag:name obj:obj p1:param1 p2:0];
}

+ (void)SendMessag:(NSString*)name obj:(void*)obj p1:(int)param1 p2:(int)param2
{
    NSMessage* pNew = [NSMessage alloc];
    [pNew setObj:obj];
    [pNew setParam1:param1];
    [pNew setParam2:param2];
    [GUI SendMessag:name msg:pNew];
}

+ (void)SendMessag:(NSString*)name msg:(NSMessage*)msg{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:msg userInfo:nil];
}

@end

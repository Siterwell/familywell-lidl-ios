//
//  ShowError.m
//  未来家庭
//
//  Created by admin on 15/10/12.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SVProgressHUD.h"
#import "ShowError.h"
#define DPLocalizedString(key, placeholder) [NSString setLocalizedString:key]
static ShowError* instance;
static NSString* titleStr;
static NSString* errorstr;
@implementation ShowError
+ (id)getInstance
{
    if (instance == nil) {
        instance = [[ShowError alloc] init];
    }
    return instance;
}
- (id)init
{
    if (self) {
    }
    return self;
}
- (void)ShowNError:(int)errornum str:(const char*)errorStr message:(NSString*)message
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    if (errorStr == nil) {
        errorStr = "";
    }
    if (errorstr == nil || errorstr.length == 0) {
        errorstr = [NSString stringWithFormat:@"%@%d", @"error_code", errornum];
    }
    errorstr = [NSString stringWithUTF8String:(char*)errorStr];
    titleStr = errorstr;
    NSString* path = [[NSString alloc] initWithString:[[NSBundle mainBundle] pathForResource:@"Error" ofType:@"strings"]];
    NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString* messageStr = [NSString stringWithFormat:@"%d", errornum];
    NSString* value = [dic objectForKey:messageStr];
    errorstr = value;
    if (errorstr == nil || [errorstr isEqualToString:@""]) {
        errorstr = message;
        
        [self ShowNErrormessage:message];
    }
    else {
        value = NSLocalizedString(value, value);
        [self ShowNErrormessage:value];
    }
}
- (void)ShowNErrormessage:(NSString*)message
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error_message", @"") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Details", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    alert.delegate = self;
    alert.tag = 10001;
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    if (alertView.tag == 10001) {
        if (buttonIndex == 0) {            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error_message", @"") message:NSLocalizedString(titleStr, titlestr) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if (alertView.tag == 10002) {
    }
}
- (void)Showmessage:(NSString*)message
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error_message" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.delegate = self;
    alert.tag = 10003;
    [alert show];
}
- (void)ShowError:(NSString*)str title:(NSString*)title
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)ShowError:(NSString*)str
{
    [self ShowError:str title:@"Warning"];
}
@end

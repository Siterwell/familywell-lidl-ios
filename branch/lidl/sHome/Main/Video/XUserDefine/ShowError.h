//
//  ShowError.h
//  未来家庭
//
//  Created by admin on 15/10/12.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ShowError : NSObject<UIAlertViewDelegate>
+(id)getInstance;
-(void)ShowNError:(int) errornum  str:(const char *)errorStr message:(NSString*)message;
-(void)ShowError:(NSString *) str;
-(void)Showmessage:(NSString *)message;
@end

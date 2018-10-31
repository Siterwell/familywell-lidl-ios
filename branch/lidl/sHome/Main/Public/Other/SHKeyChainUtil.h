//
//  SHKeyChainUtil.h
//  sHome
//
//  Created by shaop on 2017/7/25.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAMKeychain.h"

@interface SHKeyChainUtil : NSObject

+ (NSArray *)accountArray;

+ (BOOL)saveAccount:(NSString *)account;

+ (BOOL)savePassword:(NSString *)passwrod account:(NSString *)account;

+ (NSString *)account;

+ (NSString *)passwordFromAccount:(NSString *)account;

+ (BOOL)deleteAccount;

+ (BOOL)deletePasswordFromAccount:(NSString *)account;

@end

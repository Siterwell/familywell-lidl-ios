//
//  SHKeyChainUtil.m
//  sHome
//
//  Created by shaop on 2017/7/25.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SHKeyChainUtil.h"

@implementation SHKeyChainUtil

NSString * const SHAccount = @"shAccount";

+ (NSArray *)accountArray{
    return [SAMKeychain accountsForService:@"SHome"];
}

+ (BOOL)saveAccount:(NSString *)account{
    NSUserDefaults *conifg = [NSUserDefaults standardUserDefaults];
    [conifg setObject:account forKey:SHAccount];
    [conifg synchronize];
    return true;
}

+ (BOOL)savePassword:(NSString *)passwrod account:(NSString *)account{
    NSLog(@"kpassword:%@account:%@",passwrod,account);
    return [SAMKeychain setPassword:passwrod forService:@"SHome" account:account];
}

+ (NSString *)account{
    NSUserDefaults *conifg = [NSUserDefaults standardUserDefaults];
    return [conifg objectForKey:SHAccount];
}

+ (NSString *)passwordFromAccount:(NSString *)account{
    NSLog(@"kaccount:%@",account);
    return [SAMKeychain passwordForService:@"SHome" account:account];
}

+ (BOOL)deleteAccount{
    NSUserDefaults *conifg = [NSUserDefaults standardUserDefaults];
    [conifg removeObjectForKey:SHAccount];
    return true;
}

+ (BOOL)deletePasswordFromAccount:(NSString *)account{
    return [SAMKeychain deletePasswordForService:@"SHome" account:account];
}

@end

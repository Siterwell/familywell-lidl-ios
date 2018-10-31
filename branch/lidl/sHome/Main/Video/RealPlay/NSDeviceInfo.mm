//
//  NSDeviceInfo.mm
//  FunSDKDemo
//
//  Created by zyj on 2017/2/23.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//
#import "NSDeviceInfo.h"
#import "NSUserDefaults+Extention.h"

@interface NSDeviceInfo ()
@property (nonatomic, copy) NSArray* chanNames;
@end

@implementation NSDeviceInfo
-(id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.chanNames = nil;
    self.nNetState = 0;
    return self;
}

#define CHN_SEP_KEY @"@#$%^|"
+(NSDeviceInfo *)NewDeviceInfo:(NSString *)sn andName:(NSString *)name{
    return [NSDeviceInfo NewDeviceInfo:sn andName:name andUserName:@"" andPassword:@""];
}

+(NSDeviceInfo *)NewDeviceInfo:(NSString *)sn andName:(NSString *)name andUserName:(NSString *)userName andPassword:(NSString *)password{
    NSDeviceInfo *pNew = [[NSDeviceInfo alloc] init];
    pNew.sn = sn;
    pNew.name = name;
    pNew.userName = userName;
    pNew.password = password;
    pNew.chanNames = [NSUserDefaults getObjectValue:[NSString stringWithFormat:@"SDK_%@_ChannelNames", sn]];
    
    return pNew;
}

+(NSDeviceInfo *)NewDeviceInfo:(NSString *)sn andName:(NSString *)name andUserName:(NSString *)userName andPassword:(NSString *)password andType:(int)type{
    NSDeviceInfo *pNew = [[NSDeviceInfo alloc] init];
    pNew.sn = sn;
    pNew.name = name;
    pNew.userName = userName;
    pNew.password = password;
    pNew.type = type;
    pNew.chanNames = [NSUserDefaults getObjectValue:[NSString stringWithFormat:@"SDK_%@_ChannelNames", sn]];
    
    return pNew;
}

-(NSArray *)GetChannelNames{
    return self.chanNames;
}

-(NSString *)GetChannelNameAt:(NSInteger)index{
    if (self.chanNames == nil || index < 0 || index >= [self.chanNames count]) {
        return @"";
    }
    return self.chanNames[index];
}

-(NSInteger)GetChannelCount{
    if(self.chanNames == nil)
    {
        return 0;
    }
    return [self.chanNames count];
}

-(void)SetChannelNames:(NSArray *)names{
    [NSUserDefaults setValue:[NSString stringWithFormat:@"SDK_%@_ChannelNames", self.sn] Value:names];
    self.chanNames = names;
}

@end


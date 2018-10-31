//
//  EncodeCapabilityData.h
//  XMEye
//
//  Created by Wangchaoqun on 16/1/12.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunSDK/netsdk.h"

@interface EncodeCapabilityData : NSObject

@property (nonatomic,strong) NSDictionary *soureData;         //元数据

@property (nonatomic,assign) CONFIG_EncodeAbility encodeCfg; //获取编码能力返回结构体

+ (EncodeCapabilityData*)shareInstance;

@end

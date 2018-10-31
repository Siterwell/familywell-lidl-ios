//
//  EncodeCapabilityData.m
//  XMEye
//
//  Created by Wangchaoqun on 16/1/12.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import "EncodeCapabilityData.h"
@interface EncodeCapabilityData()

@property (nonatomic,assign) int channelMaxSetSync;
@property (nonatomic,assign) int maxBitrate;
@property (nonatomic,assign) int maxEncodePower;
@property (nonatomic,strong) NSArray *imageSizePerChannels;
@property (nonatomic,strong) NSArray *exImageSizePerChannels;
@property (nonatomic,strong) NSArray *maxEncodePowerPerChannels;
@property (nonatomic,strong) NSArray *exImageSizePerChannelEx;
@property (nonatomic,strong) NSArray *encodeInfos;
@property (nonatomic,strong) NSArray *combEncodeInfos;
@end
@implementation EncodeCapabilityData
static EncodeCapabilityData *encodeCapabilityData = nil;

+ (EncodeCapabilityData*)shareInstance
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        encodeCapabilityData = [[self alloc]init];
    });
    return encodeCapabilityData;
}

- (int)channelMaxSetSync
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error1");
    return [self JsonValueToInt:self.soureData[@"ChannelMaxSetSync"]];
}

- (int)maxBitrate
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error2");
    return [self JsonValueToInt:self.soureData[@"MaxBitrate"]];
}

- (int)maxEncodePower
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error3");
    return [self JsonValueToInt:self.soureData[@"MaxEncodePower"]];
}

- (NSArray *)imageSizePerChannels
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error4");
    return self.soureData[@"ImageSizePerChannel"];
}

- (NSArray *)exImageSizePerChannels
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error5");
    return self.soureData[@"ExImageSizePerChannel"];
}

- (NSArray *)maxEncodePowerPerChannels
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error6");
    return self.soureData[@"MaxEncodePowerPerChannel"];
}

- (NSArray *)encodeInfos
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error7");
    return self.soureData[@"EncodeInfo"];
}

- (NSArray *)combEncodeInfos
{
    NSAssert(self.soureData != nil, @"alert self.soureData == nil error8");
    return self.soureData[@"CombEncodeInfo"];
}

- (NSArray *)exImageSizePerChannelEx
{
    return self.soureData[@"ExImageSizePerChannelEx"];
}

- (void)encodeCfgPoint:(CONFIG_EncodeAbility*)encodeCfg setExImageSizePerChannel:(NSArray*)array
{
    for (int i = 0; i < array.count; i++) {
        encodeCfg->ExImageSizePerChannel[i] = [self JsonValueToInt:array[i]];
    }
}


- (void)encodeCfgPoint:(CONFIG_EncodeAbility*)encodeCfg setExImageSizePerChannelEx:(NSArray*)array
{
    for (int i = 0;i < array.count;i++) {
        NSArray *indexArray = array[i];
        for (int j = 0; j < indexArray.count;j++) {
             encodeCfg->ExImageSizePerChannelEx[i][j]= [self JsonValueToInt:indexArray[j]];
        }
    }
}

- (void)encodeCfgPoint:(CONFIG_EncodeAbility*)encodeCfg setImageSizePerChannel:(NSArray*)array
{
    for (int i = 0; i < array.count;i++) {
        encodeCfg->ImageSizePerChannel[i] = [self JsonValueToInt:array[i]];
    }
}

- (void)encodeCfgPoint:(CONFIG_EncodeAbility*)encodeCfg setMaxEncodePowerChannels:(NSArray*)array
{
    for (int i = 0; i < array.count; i++) {
        encodeCfg->nMaxPowerPerChannel[i] = [self JsonValueToInt:array[i]];
    }
}

- (void)encodeCfgPoint:(CONFIG_EncodeAbility*)encodeCfg setCombEncodes:(NSArray*)array
{
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dictEncode = array[i];
        encodeCfg->vCombEncInfo[i].bEnable = [self JsonValueToInt:dictEncode[@"Enable"]];
        encodeCfg->vCombEncInfo[i].bHaveAudio = [self JsonValueToInt:dictEncode[@"HaveAudio"]];
        encodeCfg->vCombEncInfo[i].uiCompression = [self JsonValueToInt:dictEncode[@"CompressionMask"]];
        encodeCfg->vCombEncInfo[i].uiResolution = [self JsonValueToInt:dictEncode[@"ResolutionMask"]];
    }
}

- (void)encodeCfgPoint:(CONFIG_EncodeAbility*)encodeCfg setEncodeInfos:(NSArray*)array
{
    for (int i=0; i < [array count]; i++) {
        NSDictionary* dictEncode = array[i];
        encodeCfg->vEncodeInfo[i].bEnable = [self JsonValueToInt:dictEncode[@"Enable"]];
        encodeCfg->vEncodeInfo[i].bHaveAudio = [self JsonValueToInt:dictEncode[@"HaveAudio"]];
        encodeCfg->vEncodeInfo[i].uiCompression = [self JsonValueToInt:dictEncode[@"CompressionMask"]];
        encodeCfg->vEncodeInfo[i].uiResolution = [self JsonValueToInt:dictEncode[@"ResolutionMask"]];
    }
}

- (CONFIG_EncodeAbility)encodeCfg
{
    memset(&_encodeCfg, 0, sizeof(CONFIG_EncodeAbility));
    
    if (self.soureData != nil) {
        _encodeCfg.iChannelMaxSetSync = self.channelMaxSetSync;
        _encodeCfg.iMaxBps = self.maxBitrate;
        _encodeCfg.iMaxEncodePower = self.maxEncodePower;
        [self encodeCfgPoint:&_encodeCfg setImageSizePerChannel:self.imageSizePerChannels];
        [self encodeCfgPoint:&_encodeCfg setExImageSizePerChannel:self.exImageSizePerChannels];
        [self encodeCfgPoint:&_encodeCfg setMaxEncodePowerChannels:self.maxEncodePowerPerChannels];
        [self encodeCfgPoint:&_encodeCfg setExImageSizePerChannelEx:self.exImageSizePerChannelEx];
        [self encodeCfgPoint:&_encodeCfg setCombEncodes:self.combEncodeInfos];
        [self encodeCfgPoint:&_encodeCfg setEncodeInfos:self.encodeInfos];
    }
    
    return _encodeCfg;
}


#pragma mark -- Helpe Function
-(int)JsonValueToInt:(id) value
{
    int nIntValue = 0;
    if ( [value isKindOfClass:[NSString class]] ) {
        NSString* stringValue = value;
        if ( [stringValue containsString:@"0x"] ) {
            sscanf([stringValue UTF8String], "0x%x", &nIntValue);
        }
        else
        {
            nIntValue = [stringValue intValue];
        }
    }
    else if ( [value isKindOfClass:[NSNumber class]] )
    {
        nIntValue = [value intValue];
    }
    return nIntValue;
}

-(unsigned int)JsonValueToUInt:(id) value
{
    unsigned int nIntValue = 0;
    if ( [value isKindOfClass:[NSString class]] ) {
        NSString* stringValue = value;
        if ( [stringValue containsString:@"0x"] ) {
            sscanf([stringValue UTF8String], "0x%x", &nIntValue);
        }
        else
        {
            nIntValue = [stringValue intValue];
        }
    }
    else if ( [value isKindOfClass:[NSNumber class]] )
    {
        nIntValue = [value intValue];
    }
    return nIntValue;
}
@end

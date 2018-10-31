//
//  DeviceInfomation.m
//  XMeye
//
//  Created by hzjf on 14-1-15.
//  Copyright (c) 2014年 hzjf. All rights reserved.
//

#import "DeviceInfomation.h"

@implementation DeviceInfomation
@synthesize deviceIp = _ip;
@synthesize deviceSerialNo = _serialNo;
@synthesize loginType = _loginType;
@synthesize deviceType = _deviceType;
@synthesize deviceMac = _mac;
@synthesize deviceName = _name;
@synthesize devicePort = _port;
@synthesize loginName = _loginName;
@synthesize loginPsw = _loginPsw;
@synthesize loginID = _loginID;
@synthesize loginStatus = _loginStatus;
@synthesize videoChanNum = _videoChanNum;
@synthesize byChanNum = _byChanNum;
@synthesize digitalChanNum = _digtalChanNum;
@synthesize alarmChanNum = _alarmChanNum;
@synthesize deviceModel = _deviceModel;

-(id)init{
    self = [super init];
    if (self) {
        self.deviceSerialNo = @"";
        self.deviceMac = @"";
        self.deviceName = @"";
        self.devicePort = 34567;
        self.deviceIp = @"";
        self.loginName = @"admin";
        self.loginPsw = @"";
        self.loginID = 0;
        self.videoChanNum = 0;
        self.byChanNum = 0;
        self.digitalChanNum = 0;
        self.alarmChanNum = 0;
        self.deviceType = DeviceType_DVR;
        self.deviceModel = @"";
        self.loginType = DeviceLoginType_Address;
    }
    return self;
}

#pragma  mark - NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    DeviceInfomation *copy = [[[self class] alloc] init];
    copy.deviceSerialNo = [_serialNo copyWithZone:zone];
    copy.deviceMac = [_mac copyWithZone:zone];
    copy.deviceIp = [_ip  copyWithZone:zone];
    copy.deviceName = [_name copyWithZone:zone];
    copy.loginName = [_loginName copyWithZone:zone];
    copy.loginPsw = [_loginPsw copyWithZone:zone];
    copy.devicePort = _port;
    copy.loginType = _loginType;
    copy.deviceType = _deviceType;
    copy.deviceModel = [_model  copyWithZone:zone];
    copy.loginStatus = _loginStatus;
    copy.byChanNum = _byChanNum;
    copy.digitalChanNum = _digtalChanNum;
    copy.videoChanNum = _videoChanNum;
    copy.alarmChanNum = _alarmChanNum;
    copy.deviceModel = _deviceModel;
    return copy;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"DeviceName"];
    [aCoder encodeObject:_ip forKey:@"DeviceIP"];
    [aCoder encodeInt:_port forKey:@"DevicePort"];
    [aCoder encodeObject:_loginName forKey:@"LoginName"];
    [aCoder encodeObject:_loginPsw forKey:@"LoginPsw"];
    [aCoder encodeObject:_mac forKey:@"DeviceMac"];
    [aCoder encodeObject:_serialNo forKey:@"SerialNo"];
    [aCoder encodeInt:_deviceType forKey:@"DeviceType"];
    [aCoder encodeObject:_model forKey:@"DeviceModel"];
    [aCoder encodeInt:_loginType forKey:@"LoginType"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    _name = [aDecoder decodeObjectForKey:@"DeviceName"];
    _ip = [aDecoder decodeObjectForKey:@"DeviceIP"];
    _port = [aDecoder decodeIntForKey:@"DevicePort"];
    _loginName = [aDecoder decodeObjectForKey:@"LoginName"];
    _loginPsw = [aDecoder decodeObjectForKey:@"LoginPsw"];
    _mac = [aDecoder decodeObjectForKey:@"DeviceMac"];
    _serialNo = [aDecoder decodeObjectForKey:@"SerialNo"];
    _deviceType = [aDecoder decodeIntForKey:@"DeviceType"];
    _model = [aDecoder decodeObjectForKey:@"DeviceModel"];
    _loginType = [aDecoder decodeIntForKey:@"LoginType"];
    return self;
}

-(NSString *)description{
    return [[NSString alloc] initWithFormat:@"DeviceName:%@, DeviceIP:%@, DevicePort:%d,  DeviceMac:%@, SerialNo:%@, LoginName:%@, LoginPsw:%@, DeviceType:%d, DeviceModel:%@,LoginType:%d",_name,_ip,_port,_mac, _serialNo,_loginName,_loginPsw,_deviceType, _model, _loginType];
}

@end

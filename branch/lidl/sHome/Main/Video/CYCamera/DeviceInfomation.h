//
//  DeviceInfomation.h
//  XMeye
//*******************************设备信息类*********************************************
//  Created by hzjf on 14-1-15.
//  Copyright (c) 2014年 hzjf. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DeviceType
{
    DeviceType_Qiang = 0,
    DeviceType_DVR = 7,
    DeviceType_SMALLEYE = 6,
    DeviceType_DOORBELL = 21
};

enum DeviceLoginType
{
    DeviceLoginType_Address,
    DeviceLoginType_Cloud,
    DeviceLoginType_ActiveRegister,
    DeviceLoginType_Num
};

@interface DeviceInfomation : NSObject<NSCoding,NSCopying>
{
    NSString *_name;                      //设备名称
    NSString *_serialNo;                    //设备序列号
    NSString *_ip;                          //设备的IP
    int _port;                         //设备的WEB端口
    NSString *_mac;                         //mac地址
    enum DeviceType      _deviceType;       //设备类型
    NSString *_model;                       //设备型号
    enum DeviceLoginType      _loginType;   //登录类型
    NSString *_loginName;                   //设备的登录用户；
    NSString *_loginPsw;                   //设备的登录密码；
    long     _loginID;                    //设备的登录句柄
    int     _videoChanNum;            //设备的视频通道数量
    int     _byChanNum;                   //模拟通道数量
    int     _digtalChanNum;                  //数字通道数量
    int     _alarmChanNum;                  //报警通道数量
    int     _loginStatus;                   //设备的登陆状态
}

@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *deviceIp;
@property int devicePort;
@property (strong, nonatomic) NSString *loginName;
@property (strong, nonatomic) NSString *loginPsw;
@property (strong, nonatomic) NSString *deviceMac;
@property (strong, nonatomic) NSString *deviceSerialNo;
@property enum DeviceType deviceType;
@property (strong, nonatomic) NSString* deviceModel;
@property enum DeviceLoginType loginType;
@property long loginID;
@property int videoChanNum;
@property int byChanNum;
@property int digitalChanNum;
@property int alarmChanNum;
@property int loginStatus;

@end

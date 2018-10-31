//
//  DeviceListModel.h
//  sHome
//
//  Created by shaop on 2016/12/21.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@protocol DeviceDetail;

@interface DeviceListModel : JSONModel

@property(nonatomic , strong) NSString *deviceName;

@property(nonatomic , strong) NSString<Optional> *tokenType;

@property(nonatomic , strong) NSString *devTid;

@property(nonatomic , strong) NSString<Optional> *currentLoginTime;

@property(nonatomic , strong) NSString *ssid;

@property(nonatomic , strong) NSString *ctrlKey;

@property(nonatomic , strong) NSString *productPublicKey;

@property(nonatomic , strong) NSString *bindKey;

@property(nonatomic , strong) NSString *binVersion;

@property(nonatomic , strong) NSString *binType;

@property(nonatomic , strong) NSString *online;

@property(nonatomic , strong) NSString<Ignore> *myPhone;

@property (nonatomic) NSString<Optional> *connectHost;

@end


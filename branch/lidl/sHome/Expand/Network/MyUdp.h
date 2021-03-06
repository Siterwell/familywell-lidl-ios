//
//  MyUdp.h
//  TestUdp
//
//  Created by shap on 2017/3/30.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUdp : NSObject

+(instancetype)shared;
@property (nonatomic, assign) BOOL flag_en;
- (void)sendGetTokenEmptynNew:(NSString *)ipaddress withDeviceID:(NSString *)deviceId ;
- (void)sendSwitchServer:(NSString *)ipaddress withDeviceID:(NSString *)deviceId;
- (void)sendGetTokenWithDeviceID:(NSString *)deviceId ;
- (void)senData:(NSDictionary *)dics;
- (void)recvSwitchServerObj:(id)obj Callback:(void(^)(id obj, id data, NSError *error)) block;
- (void)recv:(id)filter obj:(id)obj callback:(void(^)(id obj, id data, NSError *error)) block;
- (void)recvTokenObj:(id)obj Callback:(void(^)(id obj, id data, NSError *error)) block;
@end

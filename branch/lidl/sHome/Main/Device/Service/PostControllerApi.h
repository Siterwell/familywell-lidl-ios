//
//  PostControllerApi.h
//  sHome
//
//  Created by shaop on 2017/1/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface PostControllerApi : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey DeviceId:(int)deviceId DeviceStatus:(NSString *)deviceStatus;
@end

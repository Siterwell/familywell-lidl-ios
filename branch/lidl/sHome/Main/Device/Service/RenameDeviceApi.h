//
//  RenameDeviceApi.h
//  sHome
//
//  Created by shap on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface RenameDeviceApi : BaseDriveApi
-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey DeviceId:(int)deviceId DeviceName:(NSString *)deviceName;
@end

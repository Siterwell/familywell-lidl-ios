//
//  MainDeviceApi.h
//  sHome
//
//  Created by shaop on 2017/1/18.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface MainDeviceApi : BaseDriveApi
-(id)initWithDrivce:(NSString *)drivce andCtrlKey:(NSString *)ctrlkey;
@end

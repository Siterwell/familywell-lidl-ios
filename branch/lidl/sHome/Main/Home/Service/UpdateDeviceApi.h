//
//  UpdateDeviceApi.h
//  sHome
//
//  Created by shap on 2017/4/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"
#import "GatewayVersionModel.h"

@interface UpdateDeviceApi : BaseDriveApi

-(id)initWithGatewayVersionModel:(GatewayVersionModel *)model;

@end

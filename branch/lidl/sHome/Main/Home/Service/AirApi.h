//
//  AirApi.h
//  sHome
//
//  Created by shaop on 2016/12/27.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "YTKRequest.h"
#import "AirModel.h"

@interface AirApi : YTKRequest
-(id)initWithLocation:(NSString *)location Authorization:(NSString *)token ProdPubKey:(NSString *)key;
@end

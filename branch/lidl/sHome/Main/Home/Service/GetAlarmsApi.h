//
//  GetAlarmsApi.h
//  sHome
//
//  Created by shaop on 2017/4/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "YTKBaseRequest.h"

@interface GetAlarmsApi : YTKBaseRequest

-(id)initWithDevTid:(NSString *)devTid Authorization:(NSString *)token ProdPubKey:(NSString *)key;

@end

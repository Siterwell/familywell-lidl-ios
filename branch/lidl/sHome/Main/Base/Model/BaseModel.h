//
//  BaseModel.h
//  Qibuer
//
//  Created by shaop on 2016/12/8.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BaseModel : JSONModel

@property (nonatomic , assign) int code;

@property (nonatomic , strong) NSString<Optional> *msg;

@end

//
//  ErrorModel.h
//  sHome
//
//  Created by 沈晓鹏 on 2017/7/13.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ErrorModel : JSONModel

@property (nonatomic, assign) long code;

@property (nonatomic , strong) NSString<Optional> *desc;

@property (nonatomic, strong) NSString<Ignore> *userinfo;

@end

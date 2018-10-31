//
//  LightStatusVC.h
//  sHome
//
//  Created by CY on 2018/4/4.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "BaseVC.h"

@interface LightStatusVC : BaseVC

@property (nonatomic , strong) RACSubject *delegate;

@property (nonatomic, copy) NSString *selectCode;

@end

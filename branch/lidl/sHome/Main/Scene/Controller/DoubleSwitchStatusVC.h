//
//  DoubleSwitchStatusVC.h
//  sHome
//
//  Created by CY on 2018/2/9.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "BaseVC.h"

@interface DoubleSwitchStatusVC : BaseVC

@property (nonatomic , strong) RACSubject *delegate;

@property (nonatomic, copy) NSString *selectCode;

@end

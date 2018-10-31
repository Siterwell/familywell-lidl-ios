//
//  DelayTimeVC.h
//  sHome
//
//  Created by shaop on 2017/1/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseVC.h"
#import "TimeModel.h"

@interface DelayTimeVC : BaseVC

@property (nonatomic , strong) RACSubject *delegate;

@property (nonatomic , copy) NSString *minute;

@property (nonatomic , copy) NSString *second;

@end

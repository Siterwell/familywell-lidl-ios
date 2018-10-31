//
//  SetTimeVC.h
//  sHome
//
//  Created by shaop on 2017/1/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseVC.h"
#import "TimeModel.h"

@interface SetTimeVC : BaseVC

@property (nonatomic , strong) RACSubject *delegate;

@property (nonatomic , copy) NSString *minute;

@property (nonatomic , copy) NSString *hour;

@property (nonatomic , copy) NSString *week;

@end

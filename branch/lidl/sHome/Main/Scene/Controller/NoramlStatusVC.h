//
//  NoramlStatusVC.h
//  sHome
//
//  Created by shaop on 2017/2/9.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseVC.h"

@interface NoramlStatusVC : BaseVC

@property (nonatomic , strong) RACSubject *delegate;

@property (nonatomic , copy) NSString *deviceName;

@property (nonatomic , copy) NSString *selectCode;

@end

//
//  HumitureStatusVC.h
//  sHome
//
//  Created by CY on 2018/2/3.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "BaseVC.h"

@interface HumitureStatusVC : BaseVC

@property (nonatomic , strong) RACSubject *delegate;

//@property (nonatomic, copy) NSString *deviceName;
//
@property (nonatomic, copy) NSString *selectCode;

@end

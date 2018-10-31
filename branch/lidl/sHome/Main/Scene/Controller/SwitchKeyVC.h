//
//  SwitchKeyVC.h
//  sHome
//
//  Created by shaop on 2017/2/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseVC.h"

@interface SwitchKeyVC : BaseVC
@property (nonatomic , assign) NSInteger keyNumber;
@property (nonatomic , strong) NSString *switchStatus;
@property (nonatomic , strong) NSString *switchId;

@property (nonatomic , strong) RACSubject *delegate;

@end

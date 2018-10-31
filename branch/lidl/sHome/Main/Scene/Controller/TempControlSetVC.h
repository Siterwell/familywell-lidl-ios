//
//  TempControlSetVC.h
//  sHome
//
//  Created by TracyHenry on 2018/9/6.
//  Copyright © 2018年 shaop. All rights reserved.
//

#ifndef TempControlSetVC_h
#define TempControlSetVC_h
#import "BaseVC.h"

@interface TempControlSetVC : BaseVC

@property (nonatomic , strong) RACSubject *delegate;

@property (nonatomic, copy) NSString *selectCode;

@end

#endif /* TempControlSetVC_h */

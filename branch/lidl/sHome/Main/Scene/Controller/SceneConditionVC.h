//
//  SceneConditionVC.h
//  sHome
//
//  Created by shaop on 2017/1/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneConditionVC : UITableViewController
@property (nonatomic , assign) NSInteger selectType;
@property (nonatomic , strong) RACSubject *delegate;
@end

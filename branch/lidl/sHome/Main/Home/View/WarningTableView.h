//
//  WarningTableView.h
//  sHome
//
//  Created by shap on 2016/12/15.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WarningModel.h"

@protocol WarningTableViewDelegate;

@interface WarningTableView : UITableView<UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, weak) id<WarningTableViewDelegate> mdelegate;

@property (nonatomic, strong) NSArray *mdataSource;

@property (nonatomic, strong) NSArray *mheaderDataSource;

@property (nonatomic, strong) NSArray<WarningModel *> *warningList;

@end

@protocol WarningTableViewDelegate <NSObject>
- (void)ActionForTable:(UITableView *)table;
@end

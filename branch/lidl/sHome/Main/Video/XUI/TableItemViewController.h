//
//  TableItemViewController.h
//  FunSDKDemo
//
//  Created by liuguifang on 16/5/5.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "NavigationViewController.h"

@protocol TableItemDelegate<NSObject>

@optional
-(UIViewController *)getViewController:(NSString *)tiltle;
@end

@interface TableItemViewController
  : NavigationViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableItems;
@property (nonatomic, strong) NSMutableArray* arrayItemsInfo;
@property (nonatomic, weak, nullable) id <TableItemDelegate> delegate;
@property (nonatomic) BOOL hasTopNavigationBar;
//添加项
- (void)addItem:(NSString*)title
                exInfo:(NSString*)info
                icon:(UIImage*)image
                controler:(UIViewController*)vc;
- (void)addItem:(NSString*)title;
- (void)addItem:(NSString*)title
                controler:(UIViewController*)vc;
- (void)addItem:(NSString*)title
                exInfo:(NSString*)info
                controler:(UIViewController*)vc;
//删除项
- (void)removeItem:(NSString*)title;

//项被选择
- (void)didSelectTableViewItem:(NSString*)title;

- (void)setDefaultImage:(UIImage *)defaultImage;

@end




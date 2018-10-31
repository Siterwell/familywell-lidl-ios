//
//  CCommbox.h
//  未来家庭
//
//  Created by zyj on 16/4/13.
//  Copyright © 2016年 zyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UICommbox : UIView <UITableViewDelegate,UITableViewDataSource> {
    UITableView *tv;        // 下拉列表
    NSArray *showArray;     // 下拉列表数据
    NSArray *strvalues;    // 下拉列表数据对应的实际字符串
    NSArray *intValues;    // 下拉列表数据对应的实际字符串
    UIButton *textField;    // 文本输入框
    BOOL showList;          // 是否弹出下拉列表
    CGFloat frameHeight;    // Frame的高度
    int     nSelectedIndex; // 选择的位置
}

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *showArray;
@property (nonatomic,retain) NSArray *strvalues;
@property (nonatomic,retain) NSArray *intValues;
@property (nonatomic,retain) UIButton *textField;
-(void)hideTableView;
-(void)Select:(int)nIndex;
-(void)SetFromIntValue:(int)nIndex;
-(void)SetFromStrValue:(NSString *)str;
-(NSString *)GetStrValue;
-(int)GetIntValue;

@end

//
//  SexViewPicker.h
//  btc
//
//  Created by ysamg on 16/3/30.
//  Copyright © 2016年 Kingants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexViewPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *sexPicker;
@property (nonatomic  ,strong) NSMutableArray *pickers;
@property (nonatomic  ,assign) NSInteger selectedRow;
@property (nonatomic  ,strong) NSString *optType;

@property   (nonatomic  ,strong) void (^confirmClicked)(NSString *optType,NSString *selectValue,NSInteger index);

- (void)showInView;
- (void)hiddenMyself;

@end

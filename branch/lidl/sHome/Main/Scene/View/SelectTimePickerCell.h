//
//  SelectTimePickerCell.h
//  sHome
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimePickerCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@property (nonatomic ,strong) NSMutableArray *hourArray;
@property (nonatomic ,strong) NSMutableArray *secondArray;

@property (nonatomic ,strong) NSString *H;
@property (nonatomic ,strong) NSString *M;

@end

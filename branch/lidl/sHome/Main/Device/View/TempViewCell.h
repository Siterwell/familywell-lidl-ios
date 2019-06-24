//
//  TempViewCell.h
//  familywell
//
//  Created by TracyHenry on 2018/9/10.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef TempViewCell_h
#define TempViewCell_h
@interface TempViewCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIPickerView *pickview;

@end

#endif /* PickViewCell_h */

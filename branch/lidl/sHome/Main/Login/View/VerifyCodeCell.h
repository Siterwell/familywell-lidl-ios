//
//  VerifyCodeCell.h
//  sHome
//
//  Created by TracyHenry on 2018/7/16.
//  Copyright © 2018年 shaop. All rights reserved.
//

#ifndef VerifyCodeCell_h
#define VerifyCodeCell_h

@protocol ClickCellDelegate <NSObject>

- (void)clickTerm:(UIButton *)button;

@end

@interface VerifyCodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *hidenBtn;
@property (assign, nonatomic) id<ClickCellDelegate> clickCellDelegate;

- (IBAction)showAlertAction:(id)sender;
@end



#endif /* VerifyCodeCell_h */

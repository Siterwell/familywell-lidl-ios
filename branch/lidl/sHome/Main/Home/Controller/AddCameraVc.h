//
//  AddCameraVc.h
//  sHome
//
//  Created by Apple on 2017/6/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCameraVc : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ssidName;
@property (weak, nonatomic) IBOutlet UITextField *wifiPwd;

@property (weak, nonatomic) IBOutlet UIButton *wifiBtn;

@property (nonatomic,assign) BOOL type_qiang;
@end

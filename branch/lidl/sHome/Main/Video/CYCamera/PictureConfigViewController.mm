//
//  PictureConfigViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/14.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "PictureConfigViewController.h"
#import "PictureConfigView.h"
#import "Camera_Param.h"

@interface PictureConfigViewController ()
{
    Camera_Param JCamera_Param;
}
@property (nonatomic, strong) PictureConfigView *pictureConfigView;

@end

@implementation PictureConfigViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"基本设置", nil);
    [self layoutSubviews];
    [self requestConfig];
}

-(void)layoutSubviews{
    self.pictureConfigView = [[PictureConfigView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height - 64)];
    self.pictureConfigView.picConfigTableView.rowHeight = 50;
//    [self.pictureConfigView.picFlipRightLeftSwitch addTarget:self action:@selector(imageFlip:) forControlEvents:UIControlEventValueChanged];
//    [self.pictureConfigView.picFlipUpDownSwitch addTarget:self action:@selector(imageUpDown:) forControlEvents:UIControlEventValueChanged];
    [self.pictureConfigView.lrBtn addTarget:self action:@selector(changeFlip:) forControlEvents:UIControlEventTouchUpInside];
    [self.pictureConfigView.udBtn addTarget:self action:@selector(changeUpDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pictureConfigView];
}

-(void)requestConfig{
    [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self requestGetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

#pragma mark controls's Method changge
-(void)imageFlip:(UISwitch *)swh{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureMirror = self.pictureConfigView.picFlipRightLeftSwitch.on;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

-(void)imageUpDown:(UISwitch *)swh{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureFlip = self.pictureConfigView.picFlipUpDownSwitch.on;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
//    self.pictureConfigView.picFlipRightLeftSwitch.on = JCamera_Param.PictureMirror.Value();
//    self.pictureConfigView.picFlipUpDownSwitch.on = JCamera_Param.PictureFlip.Value();
    self.pictureConfigView.lrBtn.selected = JCamera_Param.PictureMirror.Value();
    self.pictureConfigView.udBtn.selected = JCamera_Param.PictureFlip.Value();
}

- (void)changeFlip:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureMirror = self.pictureConfigView.lrBtn.selected;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

- (void)changeUpDown:(UIButton *)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    JCamera_Param.PictureFlip = self.pictureConfigView.udBtn.selected;
    [self requestSetConfigWithChannel:self.channelNum andJObject:&JCamera_Param];
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    [SVProgressHUD showSuccessWithStatus:TS("配置成功")];
}

@end

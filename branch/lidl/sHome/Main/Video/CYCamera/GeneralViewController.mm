//
//  GeneralViewController.m
//  sHome
//
//  Created by CY on 2018/4/12.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "GeneralViewController.h"
#import <LBXScanWrapper.h>
#import "XMSingleton.h"
#import "LEEAlert.h"
#import "NSString+ArryValue.h"
#import "NSArray+JSONString.h"
#import "VideoDataBase.h"
#import "NSSDKDevConfig.h"
#import "OPDefaultConfig.h"

@interface GeneralViewController () <UITableViewDelegate, UITableViewDataSource> {
    OPDefaultConfig opDefaultConfig;
}

@property (nonatomic) UIView *headerView;

@property (nonatomic) NSArray *titles;

@property (nonatomic) NSArray *details;

@property (nonatomic) NSString *mode;

@property (nonatomic) NSString *hardWare;

@property (nonatomic) NSString *status;

@property (nonatomic) UITableView *table;

@end

@implementation GeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(239, 239, 239, 1);
    
    self.titles = @[NSLocalizedString(@"序列号", nil), NSLocalizedString(@"设备型号", nil), NSLocalizedString(@"网络模式", nil), NSLocalizedString(@"云连接状态", nil), ];
//    self.details = @[[XMSingleton sharedXM].deviceSn, @"RM53H13_8188EU_S38", self.mode ? self.mode: @"", NSLocalizedString(@"已连接", nil)];
    
    FUN_DevGetConfig_Json(SELF, SZSTR([XMSingleton sharedXM].deviceSn), "SystemInfo", 0);
    FUN_DevGetConfig_Json(SELF, SZSTR([XMSingleton sharedXM].deviceSn), "Status.NatInfo", 0);
    
    [self setupGeneralUI];
}

- (void)setupGeneralUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 50;
    table.bounces = NO;
    table.separatorInset = UIEdgeInsetsZero;
    table.tableHeaderView = self.headerView;
    table.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(64);
//        make.height.equalTo(Main_Screen_Width/2 + 50*4+64);
    }];
    self.table = table;
    
    UIButton *restoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [restoreBtn setTitle:NSLocalizedString(@"恢复出厂设置", nil) forState:UIControlStateNormal];
    [restoreBtn setBackgroundColor:RGB(222, 13, 30)];
    restoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:restoreBtn];
    [restoreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(50);
    }];
    [restoreBtn addTarget:self action:@selector(restoreFactorySetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:RGB(222, 13, 30)];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(restoreBtn);
        make.bottom.equalTo(restoreBtn.mas_top).offset(-25);
    }];
    [deleteBtn addTarget:self action:@selector(deleteCamera) forControlEvents:UIControlEventTouchUpInside];
    
}

/**
 
 **/

- (void)restoreFactorySetting {
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = NSLocalizedString(@"提示", nil);
        label.textColor = RGB(28, 140, 249);
        label.font = [UIFont systemFontOfSize:15];
    })
    .LeeAddContent(^(UILabel *label) {
        label.textColor = RGB(28, 140, 249);
        label.text = NSLocalizedString(@"恢复出厂设置", nil);
        label.font = [UIFont systemFontOfSize:14.5];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"取消", nil);
        action.type = LEEActionTypeCancel;
        action.titleColor = [UIColor grayColor];
        action.font = [UIFont systemFontOfSize:14];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"确定", nil);
        action.titleColor = RGB(28, 140, 249);
        action.font = [UIFont systemFontOfSize:14];
        action.clickBlock = ^{
//            NSString *strCmd = [NSString stringWithFormat:@"{\"Name\": \"OPDefaultConfig\", \"OPDefaultConfig\": {\"General\":1,\"Encode\":1,\"Record\": 1,\"CommPtz\":1,\"NetServer\": 1,\"NetCommon\":1,\"Alarm\":1,\"Account\": 1,\"Preview\":1,\"CameraPARAM\":1}}"];
            NSString *strCmd = [NSString stringWithFormat:@"{\"Name\":\"OPDefaultConfig\", \"OPDefaultConfig\":{\"General\":1,\"Encode\":1,\"Record\":1,\"CommPtz\":1,\"NetServer\":1,\"NetCommon\":1,\"Alarm\":1,\"Account\":1,\"Preview\":1,\"CameraPARAM\":1}}"];
            opDefaultConfig.Parse([strCmd UTF8String]);
//            opDefaultConfig.SetName("OPDefaultConfig");
//            opDefaultConfig.General = 1;
//            opDefaultConfig.Encode = 1;
//            opDefaultConfig.Record = 1;
//            opDefaultConfig.CommPtz = 1;
//            opDefaultConfig.NetServer = 1;
//            opDefaultConfig.NetCommon = 1;
//            opDefaultConfig.Alarm = 1;
//            opDefaultConfig.Account = 1;
//            opDefaultConfig.Preview = 1;
//            opDefaultConfig.CameraPARAM = 1;
            [self requestSetConfigWithChannel:-1 andJObject:&opDefaultConfig];
            
            [MBProgressHUD showMessage:NSLocalizedString(@"resetting device, please do not power off", nil) ToView:self.view];
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showTimeoutFail) object:nil];
            [self performSelector:@selector(showTimeoutFail) withObject:nil afterDelay:90.0];
        };
    })
    .LeeShow();
}

- (void) showTimeoutFail {
    NSLog(@"[RYAN] GeneralViewController > showTimeoutFail");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:NSLocalizedString(@"配置失败", nil) ToView:GetWindow];
}

- (void)deleteCamera {
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = NSLocalizedString(@"提示", nil);
        label.textColor = RGB(28, 140, 249);
        label.font = [UIFont systemFontOfSize:15];
    })
    .LeeAddContent(^(UILabel *label) {
        label.textColor = RGB(28, 140, 249);
        label.text = NSLocalizedString(@"确定删除摄像机", nil);
        label.font = [UIFont systemFontOfSize:14.5];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"取消", nil);
        action.type = LEEActionTypeCancel;
        action.titleColor = [UIColor grayColor];
        action.font = [UIFont systemFontOfSize:14];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"确定", nil);
        action.titleColor = RGB(28, 140, 249);
        action.font = [UIFont systemFontOfSize:14];
        __weak typeof(self) weakSelf = self;
        action.clickBlock = ^{
            [weakSelf toDeleteTheCamera];
        };
    })
    .LeeShow();
}

- (void)toDeleteTheCamera {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSDictionary *responseObject = [config objectForKey:UserInfos];
    NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
    NSMutableArray *videos = nil;
    if (extraPropertiesDic[@"monitor"] != nil) {
        videos = [[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
    }
    if (videos != nil && [videos count] > 0) {
        for (int i = 0; i < [videos count]; i++) {
            NSDictionary *vInfosDic = [videos objectAtIndex:i];
            if ([vInfosDic[@"devid"] isEqualToString:[XMSingleton sharedXM].vInfo.devid]) {
                [videos removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    NSString *monitorStr = [videos JSONString];
    //修改昵称
    NSDictionary *monitorDic = @{@"monitor":monitorStr};
    NSDictionary *dic = @{
                          @"extraProperties" : monitorDic,
                          };
    [MBProgressHUD showLoadToView:GetWindow];
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile",(ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"])] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile",(ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"])] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setValue:responseObject forKey:UserInfos];
            [config synchronize];
            
            [[VideoDataBase sharedDataBase] deletVideoInfo:[XMSingleton sharedXM].vInfo.devid andUserName:[XMSingleton sharedXM].vInfo.userName];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            [MBProgressHUD showError:@"出错" ToView:GetWindow];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        [MBProgressHUD showError:@"出错" ToView:GetWindow];
    }];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, Main_Screen_Width/2)];
        _headerView.backgroundColor = RGB(243, 243, 243);
        
        CGFloat w = Main_Screen_Width/2 - 60;
        UIImage *qrCode = [LBXScanWrapper createQRWithString:[XMSingleton sharedXM].deviceSn size:CGSizeMake(w, w)];
        
        UIImageView *imgV = [[UIImageView alloc] initWithImage:qrCode];
        [_headerView addSubview:imgV];
        [imgV makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.height.equalTo(w);
        }];
    }
    return _headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.textColor = ThemeColor;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.5];
    cell.textLabel.text = self.titles[indexPath.row];
//    cell.detailTextLabel.text = self.details[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [XMSingleton sharedXM].deviceSn;
    }
    else if (indexPath.row == 1) {
        cell.detailTextLabel.text = self.hardWare;
    }
    else if (indexPath.row == 2) {
        cell.detailTextLabel.text = self.mode;
    }
    else if (indexPath.row == 3) {
        cell.detailTextLabel.text = self.status;
    }
    return cell;
}

- (void)OnFunSDKResult:(NSNumber*)pParam {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    NSLog(@"[RYAN] GeneralViewController > OnFunSDKResult > msg->szStr = %s", msg->szStr);
    
    if (strcmp(msg->szStr, "Status.NatInfo") == 0) {
        char *status = msg->pObject;
        NSString *sta = [NSString stringWithUTF8String:status];
        NSData *jsonData = [sta dataUsingEncoding:NSUTF8StringEncoding];
        if(jsonData!=nil){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *Status = dict[@"Status.NatInfo"][@"NatStatus"];
            if([Status isEqualToString:@"Conneted"]){
                   self.status = NSLocalizedString(@"已连接", nil);
            }else{
                   self.status = NSLocalizedString(@"未连接", nil);
            }
     
        }

        [self.table reloadData];
        return;
    } else if (strcmp(msg->szStr, "OPMachine") == 0) {
        NSLog(@"[RYAN] GeneralViewController > OnFunSDKResult > OPMachine complete");
        return;
    }
    int mode = msg->param2;
    switch (mode) {
        case 0:
            self.mode = @"P2P";
            break;
            
        case 1:
            self.mode = NSLocalizedString(@"转发模式", nil);
            break;
            
        case 2:
            self.mode = @"IP";
            break;
            
        case 5:
            self.mode = @"RPS";
            break;
    }
    char *type = msg->pObject;
    NSString *typeeee = [NSString stringWithUTF8String:type];
    
    NSData *jsonData = [typeeee dataUsingEncoding:NSUTF8StringEncoding];
    
    
    if(jsonData!=nil){
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSString *HardWare = dict[@"SystemInfo"][@"HardWare"];
        
        self.hardWare = HardWare;
    }

    [self.table reloadData];
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    NSLog(@"[RYAN] GeneralViewController > RefreshUIWithSetConfig > factory reset success");
    //录像满时
    if ([config.name isEqualToString:@JK_OPDefaultConfig]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"恢复出厂成功,请等待..", nil) duration:5.0];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showTimeoutFail) object:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self RestartDevice];
    }
}

#pragma mark - 设备重启
-(void)RestartDevice {
    NSLog(@"[RYAN] GeneralViewController > RestartDevice > begin");
    //获取通道
    char szParam[128] = {0};
    sprintf(szParam, "{\"Name\":\"OPMachine\",\"SessionID\":\"0x00000001\",\"OPMachine\":{\"Action\":\"Reboot\"}}");
    FUN_DevCmdGeneral(self.MsgHandle, SZSTR(self.deviceSN), 1450, "OPMachine", 0, 5000, szParam, 0);
    NSLog(@"[RYAN] RestartDevice > end");
}
@end

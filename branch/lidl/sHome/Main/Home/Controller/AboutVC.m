//
//  AboutVC.m
//  sHome
//
//  Created by shaop on 2016/12/18.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "AboutVC.h"
#import "AboutTableViewCell.h"
#import "DeviceListModel.h"
#import "GatewayVersionModel.h"
#import "UpdateDeviceApi.h"
#import "ErrorCodeUtil.h"
#import "JhDownProgressController.h"
@interface AboutVC ()
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) NSString *versionCode;
@property (strong, nonatomic) DeviceListModel *model;

@property (nonatomic, assign) BOOL update;
@property (nonatomic) GatewayVersionModel *verModel;
@property (strong,nonatomic) JhDownProgressController *vc;
@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 170)];
    self.tableView.tableHeaderView = view;
    
    UIImageView *imageview = [UIImageView new];
    imageview.image = [UIImage imageNamed:@"appLogo"];
    [view addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.width.equalTo(110);
        make.top.equalTo(view.mas_top).offset(30);
        make.centerX.equalTo(view);
    }];
        [self getGateWayInfo];
    
    _aboutLabel.text = NSLocalizedString(@"\tBASE智能安防系统主要由一个智能网关与各种智能设备组成，以云服务器、移动互联网、RF通信技术为数据链路的载体，实现远程智能终端对居家环境的远程监测与控制，系统支持多种情景模式和灵活的自定义情景执行规则，自动执行各种安防事故应急处理。智能设备目前已经有烟雾报警器、燃气报警器、一氧化碳报警器、水感报警器、门磁探测器、人体移动探测器、紧急呼叫按钮、智能插座和温湿度探测器等。近期，还会不断增加的智能设备有网络摄像头、智能锁、开关面板、插座面板、智能空气净化和电磁水阀等，敬请期待！", nil);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell" forIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = NSLocalizedString(@"当前版本", nil) ;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        cell.subLabel.text = [NSString stringWithFormat:@"%@",currentVersion];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if(indexPath.row == 1) {
        AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell" forIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = NSLocalizedString(@"固件版本", nil) ;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.subLabel.text = self.versionCode;
//        RAC(cell.subLabel, text) = RACObserve(self, versionCode);

        if(self.update == YES){
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_version_new"]];
            [image setFrame:CGRectMake(0, 0, 30, 15)];
            cell.accessoryView = image;
        }else{
            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
            [image setFrame:CGRectMake(0, 0, 0, 0)];
            cell.accessoryView = image;
        }
        
        return cell;
    } else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = NSLocalizedString(@"售后电话", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"+358 40 754 9295401";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = NSLocalizedString(@"隐私政策", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        return;
    }
    else if(indexPath.row == 1){
        if(self.update == YES){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示",nil)
                                                                           message:NSLocalizedString(@"Updates available, do you want to update?", nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
                [self showFireLoading];
                UpdateDeviceApi *api = [[UpdateDeviceApi alloc] initWithGatewayVersionModel:self.verModel];
                [api startWithWan:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
                } failure:^(id data, NSError *error) {
                }];
        
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"暂不升级",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            return;
        }
        
    } else if (indexPath.row == 2) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"+358 40 754 9295401"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else if (indexPath.row == 5) {
        [self performSegueWithIdentifier:@"toPrivacy" sender:nil];
    }
    
}

//获取网关信息
- (void)getGateWayInfo {
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);

    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device", https] parameters:@{@"page":@(0),@"size":@(5)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject;
        if (arr.count>0) {
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            self.model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            self.versionCode = self.model.binVersion;
            
            for (int i = 0; i<arr.count; i++) {
                if ([[arr[i] objectForKey:@"devTid"] isEqualToString:self.model.devTid]) {
                    [config setValue:arr[i] forKey:DeviceInfo];
                }
            }
            
            [config setValue:arr forKey:Devices];
            [config synchronize];
            
            [self checkFirmwareVersion];
            
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}

//检测固件版本
- (void)checkFirmwareVersion {
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    self.model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    self.versionCode = self.model.binVersion;
    
    NSDictionary *dic = @{
                          @"devTid":self.model.devTid,
                          @"productPublicKey":self.model.productPublicKey,
                          @"binType":self.model.binType,
                          @"binVer":self.model.binVersion,
                          };
    
    @weakify(self)
    NSString *https = (ApiMap==nil?@"https://console-openapi.hekr.me":ApiMap[@"console-openapi.hekr.me"]);
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/external/device/fw/ota/check", https] parameters:@[dic] progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        
        GatewayVersionModel *mmodel = [[GatewayVersionModel alloc] initWithDictionary:responseObject[0] error:nil];
        self.verModel = mmodel;
        if (mmodel.update == 1) {
            self.update = YES;
        }else {
            self.update = NO;
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}


-(void) closefirem{
    _vc.success = YES;
}


-(void)showFireLoading{
    @weakify(self)
    _vc=[[JhDownProgressController alloc] init];
    _vc.timer1 = 1.0f;
    _vc.timerApi = 5.0f;
    _vc.hintMessage = NSLocalizedString(@"正在升级", nil);
    _vc.finish = ^(BOOL success){
        if(!success){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"更新失败", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self)
                [self showFireLoading];
                
                UpdateDeviceApi *api = [[UpdateDeviceApi alloc] initWithGatewayVersionModel:self.verModel];
                [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
                } failure:^(id data, NSError *error) {
                }];
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }else{
            [MBProgressHUD showSuccess:NSLocalizedString(@"Firmware Update Successful", nil) ToView:GetWindow];
        }
        
    };
    _vc.getApi = ^{
        @strongify(self)
        
        NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device?devTid=%@&ctrlKey=%@", https,self.model.devTid,self.model.ctrlKey] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DeviceListModel *mmodel = [[DeviceListModel alloc] initWithDictionary:responseObject[0] error:nil];
            if (![mmodel.binVersion isEqualToString:self.model.binVersion]) {
                [self closefirem];
                [self getGateWayInfo];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    };
    GetWindow.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [GetWindow.rootViewController presentViewController:_vc animated:NO completion:^{
        
    }];
    
}


@end

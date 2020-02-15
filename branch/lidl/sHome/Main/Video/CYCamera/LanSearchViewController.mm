//
//  LanSearchViewController.m
//  FunSDKDemo
//
//  Created by lijingdong on 2018/3/21.
//  Copyright © 2018年 zyj. All rights reserved.
//

#import "LanSearchViewController.h"
#import <FunSDK/FunSDK.h>
#import "DeviceInfomation.h"
#import "SDKDataCenter.h"
#import "NSSDKDevConfig.h"
#import "SDKParser.h"
#import "NSDeviceInfo.h"
#import "NSArray+JSONString.h"
#import "NSString+ArryValue.h"
#import "VideoDataBase.h"
#import "ErrorCodeUtil.h"

@interface LanSearchViewController ()<UITableViewDelegate,UITableViewDataSource,NSSDKDevConfigDelegate>
@property (nonatomic,strong)UITableView *deviceListView;//设备列表
@property (nonatomic,strong)NSMutableArray *deviceInfoArr;//表格数据

@property (nonatomic,strong) NSMutableArray *stateArray;      // 设备对应的选中状态

@property (nonatomic, strong) NSSDKDevConfig *SDKDevConfig;
@property(nonatomic,copy) NSString * https;
@end

@implementation LanSearchViewController

- (UITableView *)devciceListView{
    if (!_deviceListView) {
        _deviceListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width, self.view.frame.size.height - 64)];
        _deviceListView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _deviceListView.delegate = self;
        _deviceListView.dataSource = self;
    }
    return _deviceListView;
}

-(NSMutableArray *)deviceInfoArr{
    if (!_deviceInfoArr) {
        _deviceInfoArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _deviceInfoArr;
}

-(NSMutableArray *)stateArray{
    if (!_stateArray) {
        _stateArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _stateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.https = (ApiMap==nil?@"https://user-openapi.hekreu.me":ApiMap[@"user-openapi.hekreu.me"]);
    self.title=NSLocalizedString(@"添加同一路由器上的摄像机", nil);
    [self getData];
    
    [self.view addSubview:self.devciceListView];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

- (void)getData{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍后...", nil)];
    
    self.SDKDevConfig = [[NSSDKDevConfig alloc]init];
    self.SDKDevConfig.delegate = self;
    
    [self.SDKDevConfig searchDevice];
    
//    FUN_DevSearchDevice(SELF, 4000, 0);
}

#pragma mark UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceInfoArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellReuseID = @"deviceDeleteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseID];
    }
    DeviceInfomation *deviceInfo = self.deviceInfoArr[indexPath.row];
    cell.textLabel.text = deviceInfo.deviceName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@",deviceInfo.deviceSerialNo,deviceInfo.deviceIp ];
    
    if(deviceInfo.deviceType == DeviceType_Qiang){
         [cell.imageView setImage:[UIImage imageNamed:@"qiangji"]];
    }else if(deviceInfo.deviceType == DeviceType_DVR){
         [cell.imageView setImage:[UIImage imageNamed:@"yaotouji"]];
    }else if(deviceInfo.deviceType == DeviceType_SMALLEYE){
         [cell.imageView setImage:[UIImage imageNamed:@"smalleye"]];
    }else if(deviceInfo.deviceType == DeviceType_DOORBELL){
         [cell.imageView setImage:[UIImage imageNamed:@"doorbell"]];
    }else{
           [cell.imageView setImage:[UIImage imageNamed:@"yaotouji"]];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//deleteDevice
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertController  *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确定要将此摄像机添加到此账户下吗", nil) preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self)weakSelf = self;
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
    {
        DeviceInfomation *deviceInfo = weakSelf.deviceInfoArr[indexPath.row];
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        NSDictionary *responseObject = [config objectForKey:UserInfos];
        
        NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
        
        NSMutableArray *videos = nil;
        
        if (extraPropertiesDic[@"monitor"] !=nil) {
            
            videos = [[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
        }else{
            videos = [[NSMutableArray alloc] init];
        }
        
        [videos addObject:@{@"devid":deviceInfo.deviceSerialNo,@"name":deviceInfo.deviceName}];
        
        //        VideoInfoModel *localVInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:sn];
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
        VideoInfoModel *localVInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:deviceInfo.deviceSerialNo andUserName:userName];
        
        if (localVInfo == nil||localVInfo.devid == nil||[localVInfo.devid isEqual:[NSNull class]]) {
            NSString *monitorStr = [videos JSONString];
            
            //修改昵称
            NSDictionary *monitorDic = @{@"monitor":monitorStr};
            NSDictionary *dic = @{
                                  @"extraProperties" : monitorDic,
                                  };
            
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile", self.https] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [MBProgressHUD showSuccess:NSLocalizedString(@"请稍后...", nil) ToView:self.view];
                
                [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", self.https] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                    [config setValue:responseObject forKey:UserInfos];
                    [config synchronize];
                    
                    NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
                    
                    if (extraPropertiesDic[@"monitor"] !=nil) {
                        
                        NSMutableArray *monitor = [(NSArray*)[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
                        
                        for (int i = 0; i < [monitor count]; i++) {
                            
                            NSDictionary *videoDic = (NSDictionary *)monitor[i];
                            VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                            vInfo.devid = videoDic[@"devid"];
                            vInfo.name = videoDic[@"name"];
                            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
                            vInfo.userName = userName;
                            [[VideoDataBase sharedDataBase] updateVideoInfo:vInfo];
                        }
                    }
                    
                    [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:self.view];
                    [self performSelector:@selector(popPreView) withObject:nil afterDelay:2];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [MBProgressHUD hideHUDForView:self.view];
                    NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                    ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
                    [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:self.view];
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
                [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:GetWindow];
            [self performSelector:@selector(popPreView) withObject:nil afterDelay:2];
        }
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:deleteAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)popPreView{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
#pragma mark - FunSDK 回调
-(void)OnSDKSearchDevice:(int)param2 Data:(SDK_CONFIG_NET_COMMON_V2 *)pData
{
    [SVProgressHUD dismiss];
    const int maxSearchedDeviceNum = 400;
    struct SDK_CONFIG_NET_COMMON_V2* netCommonBuf = pData;
    
    for (int i = 0; i < param2; i++) {
        //屏蔽掉地址非法的设备
        if (netCommonBuf[i].HostIP.l == 0 || netCommonBuf[i].TCPPort == 0) {
            continue;
        }
        
        DeviceInfomation* device = [[DeviceInfomation alloc] init];
        device.deviceIp  = [NSString stringWithFormat:@"%d.%d.%d.%d",netCommonBuf[i].HostIP.c[0],netCommonBuf[i].HostIP.c[1],netCommonBuf[i].HostIP.c[2],netCommonBuf[i].HostIP.c[3]];
        device.devicePort = netCommonBuf[i].TCPPort;
        device.deviceMac = [NSString stringWithUTF8String:netCommonBuf[i].sMac];
        device.deviceSerialNo = [NSString stringWithUTF8String:netCommonBuf[i].sSn];
        device.deviceType = DeviceType(netCommonBuf[i].DeviceType);
        device.deviceName = [NSString stringWithUTF8String:netCommonBuf[i].HostName];
        bool bFind = false;
        if (_deviceInfoArr.count > 0) {
            //屏蔽掉重复的设备
            for(DeviceInfomation* info in _deviceInfoArr)
            {
                if ([info.deviceIp isEqualToString:device.deviceIp])
                {
                    bFind = true;
                    break;
                }
                
            }
            if (bFind == false) {
                [_deviceInfoArr addObject:device];
            }
            
        }
        else
        {
            [_deviceInfoArr addObject:device];
        }
        [self.stateArray removeAllObjects];
        for (int i = 0;i < _deviceInfoArr.count ; i ++) {
            BOOL ifSelected = NO;
            [self.stateArray addObject:[NSNumber numberWithBool:ifSelected]];
        }
    }
    
    if (_deviceInfoArr.count>0)
    {
        [self.deviceListView reloadData];
    }
}

-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    switch (msg->id) {
        case     EMSG_SYS_ADD_DEVICE:{
            if (msg->param1 < 0) {
                if (msg->param1 == -99992) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:TS("Device_Exist") duration:1];
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:[SDKParser parseError:msg->param1] duration:3];
                    
                }
            }
            else{
                [SVProgressHUD dismiss];
                SDBDeviceInfo *pDevInfo = (SDBDeviceInfo *)msg->pObject;
                
                SDKDataCenter *pDC = [SDKDataCenter instance];
                NSDeviceInfo *pNSDev = [NSDeviceInfo   NewDeviceInfo:NSSTR(pDevInfo->Devmac)
                                                             andName:NSSTR(pDevInfo->Devname)
                                                         andUserName:NSSTR(pDevInfo->loginName)
                                                         andPassword:NSSTR(pDevInfo->loginPsw)
                                                             andType:pDevInfo->nType];
                pNSDev.type = pDevInfo->nType;//设备类型
                
                [pDC AddDevice:pNSDev ResetPassword:YES];
                
                
                [GUI SendMessag:@"NFOnAddDev" obj:pDevInfo p1:msg->param1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                });
            }
        }break;
        default:
            break;
    }
}

- (void)OnSDKSeachFile:(NSSDKDevConfig *)sender Files:(H264_DVR_FILE_DATA *)pFiles Result:(int)nResult {
    
}

- (void)OnSDKSeachFileByTime:(NSSDKDevConfig *)sender Files:(SDK_SearchByTimeInfo *)pFiles Result:(int)nResult {
    
}

- (void)getConfig:(DeviceConfig *)config result:(int)result {
    
}

- (void)setConfig:(DeviceConfig *)config result:(int)result {
    
}


@end

//
//  MrgVideoVc.m
//  sHome
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "MrgVideoVc.h"
#import "VideoDataBase.h"
#import "NSArray+JSONString.h"
#import "NSString+ArryValue.h"
#import "DevicePasswordChangeViewController.h"
#import "PictureConfigViewController.h"
#import "RecordConfigViewController.h"
#import "AlarmConfigViewController.h"

#import "DeviceConfig.h"
#import "SystemInfo.h"
#import "NSSDKDevConfig.h"
#import "RecordConfigVc.h"
#import "AlarmConfigVc.h"
#import "PictureConfigVc.h"
#import "SeniorConfigVc.h"

//#import "BaseMgrViewController.h"
#import "XMSingleton.h"
#import "HighConfigViewController.h"
#import "PictureConfigViewController.h"
#import "StorageConfigViewController.h"
//#import "GeneralConfigViewController.h"
#import "GeneralViewController.h"
#import "AddCameraVc.h"

#define SELF [self MsgHandle]
#define AS_HANDLE(x) (__bridge void*) x


@interface MrgVideoVc ()<NSSDKDevConfigDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
//@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic, strong) NSSDKDevConfig *SDKDevConfig;
@property (readonly, nonatomic) int hObj;
@property (nonatomic) NSArray *titleItems;
@property (nonatomic) NSArray *titleItems2;
@end

@implementation MrgVideoVc {
//    NSArray *itemsTitle;
//    SystemInfo JSystemInfo;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"配置", nil);
    self.view.backgroundColor = RGB(239, 239, 239);

    self.titleItems = @[NSLocalizedString(@"基本设置", nil), NSLocalizedString(@"密码管理", nil), NSLocalizedString(@"存储管理", nil), NSLocalizedString(@"高级设置", nil), NSLocalizedString(@"通用", nil)];

    self.titleItems2 = @[NSLocalizedString(@"基本设置", nil), NSLocalizedString(@"密码管理", nil), NSLocalizedString(@"存储管理", nil), NSLocalizedString(@"高级设置", nil),NSLocalizedString(@"无线设置", nil), NSLocalizedString(@"通用", nil)];
    [self setUpMgrUI];
}

- (void)setUpMgrUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.estimatedRowHeight = 0;
    table.rowHeight = 50;
    [table setSeparatorInset:UIEdgeInsetsZero];
    table.tableFooterView = [UIView new];
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!_type_qiang) return self.titleItems.count;
    else  return self.titleItems2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(!_type_qiang)
    cell.textLabel.text = self.titleItems[indexPath.row];
    else
    cell.textLabel.text = self.titleItems2[indexPath.row];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        PictureConfigViewController *vc = [[PictureConfigViewController alloc] init];
        vc.name = self.vInfo.name;
        vc.deviceSN = [XMSingleton sharedXM].deviceSn;
        vc.channelNum = [XMSingleton sharedXM].channelNum;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        DevicePasswordChangeViewController *pVC = [[DevicePasswordChangeViewController alloc]init];
        pVC.name = NSLocalizedString(@"密码管理", nil);
        pVC.deviceSN = [XMSingleton sharedXM].vInfo.devid;
        pVC.channelNum = [XMSingleton sharedXM].channelNum;;
        [self.navigationController pushViewController:pVC animated:YES];
    }
    else if (indexPath.row == 2) {
        StorageConfigViewController *pVC = [[StorageConfigViewController alloc]init];
        pVC.name = NSLocalizedString(@"存储管理", nil);
        pVC.deviceSN = [XMSingleton sharedXM].vInfo.devid;
        pVC.channelNum = [XMSingleton sharedXM].channelNum;
        [self.navigationController pushViewController:pVC animated:YES];
    }
    else if (indexPath.row == 3) {
        HighConfigViewController *vc = [[HighConfigViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        if(!_type_qiang){
            GeneralViewController *vc = [[GeneralViewController alloc] init];
            vc.title = NSLocalizedString(@"通用", nil);
            vc.deviceSN = [XMSingleton sharedXM].vInfo.devid;
            vc.channelNum = [XMSingleton sharedXM].channelNum;;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            if(indexPath.row == 4)
            {
                UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil];
                AddCameraVc *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddCameraVc"];
                vc.type_qiang = _type_qiang;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 5){
                GeneralViewController *vc = [[GeneralViewController alloc] init];
                vc.title = NSLocalizedString(@"通用", nil);
                vc.deviceSN = [XMSingleton sharedXM].vInfo.devid;
                vc.channelNum = [XMSingleton sharedXM].channelNum;;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }

           
    }
    
}



#pragma mark ------------------------------------------------------- 华丽的分割线
#pragma mark ------------------------------------------------------- 华丽的分割线

#pragma mark ------------------------------------------------------- 华丽的分割线
#pragma mark ------------------------------------------------------- 华丽的分割线

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.title = NSLocalizedString(@"摄像头管理", nil);
//
//
//    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
//    itemsTitle = @[NSLocalizedString(@"修改名称", nil), NSLocalizedString(@"同步时间", nil), NSLocalizedString(@"录像设置", nil), NSLocalizedString(@"删除设备", nil), NSLocalizedString(@"报警配置", nil), NSLocalizedString(@"图像配置", nil), NSLocalizedString(@"高级配置", nil), NSLocalizedString(@"密码修改", nil), NSLocalizedString(@"序列号", nil), NSLocalizedString(@"设备型号", nil), NSLocalizedString(@"网络模式", nil), NSLocalizedString(@"云连接状态",nil)];
//
//    //    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
//
//    self.SDKDevConfig = [[NSSDKDevConfig alloc]init];
//    self.SDKDevConfig.delegate = self;
//
//
////    DeviceConfig *config = [[DeviceConfig alloc]initWithJObject:&JSystemInfo];
////    config.devId = self.vInfo.devid;
////    config.channel = 0;
////    [self.SDKDevConfig requestGetConfig:config];
//
//
//    FUN_DevGetConfig_Json(SELF,"0f02e73ded0e9d2c","SystemInfo",0);
//
//}

//-(void)OnFunSDKResult:(NSNumber*)pParam{
//
//    NSInteger nAddr = [pParam integerValue];
//    MsgContent *msg = (MsgContent*)nAddr;
//
//    int a = 1;
//
//}

//-(void)viewDidDisappear:(BOOL)animated{
//    [self CloseHandle];
//}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return itemsTitle.count;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.row == 1||indexPath.row == 2||indexPath.row == 4||indexPath.row == 5||indexPath.row == 6||indexPath.row == 9||indexPath.row == 10||indexPath.row == 11) {
//        return [UITableViewCell new];
//    }
//
//    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"tableViewCell%zd",indexPath.row]];
//    cell.textLabel.text = itemsTitle[indexPath.row];
//    if (indexPath.row < 8) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//
//    switch (indexPath.row) {
//        case 0:{
//            cell.detailTextLabel.text = _vInfo.name;
//        }
//            break;
//
//        case 1:
//        {
//
//        }
//
//            break;
//
//        case 2:
//
//            break;
//
//        case 3:{
//
//        }
//            break;
//
//        case 4:
//
//            break;
//
//        case 5:
//
//            break;
//
//        case 6:
//
//            break;
//
//        case 7:
//            //修改密码
//            break;
//
//        case 8:
//            cell.detailTextLabel.text = _vInfo.devid;
//            break;
//
//        case 9:
//
//            break;
//
//        case 10:
//
//            break;
//
//        case 11:
////            cell.detailTextLabel.text = _vInfo.devid;
//            break;
//
//        default:
//            break;
//    }
//
//    return cell;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 1||indexPath.row == 2||indexPath.row == 4||indexPath.row == 5||indexPath.row == 6||indexPath.row == 9||indexPath.row == 10||indexPath.row == 11) {
//        return 0;
//    }
//    return 44;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 15.0f;
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    if (indexPath.row == 1||indexPath.row == 2||indexPath.row == 4||indexPath.row == 5||indexPath.row == 6||indexPath.row == 9||indexPath.row == 10||indexPath.row == 11) {
//        return;
//    }
//
//    switch (indexPath.row) {
//        case 0:{
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"修改名称", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
//            UITextField *txtName = [alert textFieldAtIndex:0];
//            txtName.placeholder = NSLocalizedString(@"请输入名称", nil);
//            alert.tag = 2;
//            [alert show];
//
//        }
//            break;
//
//        case 1:{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定同步时间吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            alert.tag = 3;
//            [alert show];
//        }
//            break;
//
//        case 2:{
//            //录像设置
//
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"VideoPlayStoryboard" bundle:nil];
//            // 从Storyboard上按照identifier获取指定的界面（VC），identifier必须是唯一的
//            RecordConfigVc *record = [storyboard instantiateViewControllerWithIdentifier:@"RecordConfigVc"];
//            record.deviceSN = self.vInfo.devid;
//            record.channelNum = 0;
//            [self.navigationController pushViewController:record animated:YES];
//        }
//
//            break;
//
//        case 3:{
//            //删除
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确定要删除吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
//            alert.tag = 1;
//            [alert show];
//        }
//            break;
//
//        case 4:
//            //报警配置
//        {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"VideoPlayStoryboard" bundle:nil];
//
//            AlarmConfigVc *alarm = [storyboard instantiateViewControllerWithIdentifier:@"AlarmConfigVc"];
//            alarm.deviceSN = self.vInfo.devid;
//            alarm.channelNum = 0;
//            [self.navigationController pushViewController:alarm animated:YES];
//
//        }
//            break;
//
//        case 5:
//            //图像配置
//        {
////            PictureConfigViewController *pVC = [[PictureConfigViewController alloc]init];
////            pVC.deviceSN = self.vInfo.devid;
////            pVC.channelNum = 0;
////            [self.navigationController pushViewController:pVC animated:YES];
//
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"VideoPlayStoryboard" bundle:nil];
//
//            PictureConfigVc *picture = [storyboard instantiateViewControllerWithIdentifier:@"PictureConfigVc"];
//            [self.navigationController pushViewController:picture animated:YES];
//        }
//
//            break;
//
//        case 6:
//            //高级配置
//        {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"VideoPlayStoryboard" bundle:nil];
//
//            SeniorConfigVc *picture = [storyboard instantiateViewControllerWithIdentifier:@"SeniorConfigVc"];
//            [self.navigationController pushViewController:picture animated:YES];
//        }
//
//
//            break;
//
//        case 7:
//            //密码修改
//        {
//            DevicePasswordChangeViewController *pVC = [[DevicePasswordChangeViewController alloc]init];
//            pVC.name = NSLocalizedString(@"密码修改", nil);
//            pVC.deviceSN = self.vInfo.devid;
//            pVC.channelNum = 0;
//            [self.navigationController pushViewController:pVC animated:YES];
//        }
//            break;
//
//
//        default:
//            break;
//    }
//
//    if (indexPath.row == 0) {
//
//
//    }else{
//
//
//    }
//
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (alertView.tag == 2) {
//
//        if (buttonIndex == 1) {
//
//            UITextField *txt = [alertView textFieldAtIndex:0];
//            self.vInfo.name = txt.text;
//
//            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//            NSDictionary *responseObject = [config objectForKey:UserInfos];
//
//            NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
//
//            NSArray *videos = nil;
//
//            if (extraPropertiesDic[@"monitor"] !=nil) {
//
//                videos = [extraPropertiesDic[@"monitor"] arrayValue];
//            }
//
//            NSMutableArray *videoMonitor = [[NSMutableArray alloc] init];
//
//            if (videos != nil&&[videos count]>0) {
//
//                for (int i = 0; i < [videos count]; i++) {
//
//                    NSDictionary *vInfosDic = [videos objectAtIndex:i];
//
//                    NSMutableDictionary *vidic = [NSMutableDictionary dictionaryWithObjectsAndKeys:vInfosDic[@"devid"],@"devid", nil];
//                    if ([vInfosDic[@"devid"] isEqualToString:self.vInfo.devid]) {
//                        [vidic setValue:txt.text forKey:@"name"];
//                    }else{
//                        [vidic setValue:vInfosDic[@"name"] forKey:@"name"];
//                    }
//
//                    [videoMonitor addObject:vidic];
//                }
//            }
//
//            NSString *monitorStr = [videoMonitor JSONString];
//
//            //修改昵称
//            NSDictionary *monitorDic = @{@"monitor":monitorStr};
//            NSDictionary *dic = @{
//                                  @"extraProperties" : monitorDic,
//                                  };
//
//            [MBProgressHUD showLoadToView:GetWindow];
//            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:@"http://user-openapi.hekreu.me/user/profile" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://user-openapi.hekreu.me/user/profile" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//                    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//                    [config setValue:responseObject forKey:UserInfos];
//                    [config synchronize];
//
//                    NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
//
//                    if (extraPropertiesDic[@"monitor"] !=nil) {
//
//                        NSMutableArray *monitor = [(NSArray*)[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
//
//                        for (int i = 0; i < [monitor count]; i++) {
//
//                            NSDictionary *videoDic = (NSDictionary *)monitor[i];
//                            VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
//                            vInfo.devid = videoDic[@"devid"];
//                            vInfo.name = videoDic[@"name"];
//                            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
//                            vInfo.userName = userName;
//                            [[VideoDataBase sharedDataBase] updateVideoInfo:vInfo];
//                        }
//                    }
//
//                    [self.navigationController popViewControllerAnimated:YES];
//
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//                    [MBProgressHUD showError:@"出错" ToView:GetWindow];
//
//                }];
//
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//                [MBProgressHUD showError:@"出错" ToView:GetWindow];
//            }];
//        }
//
//    }else if(alertView.tag == 1){
//        if (buttonIndex == 1) {
//            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//
//            NSDictionary *responseObject = [config objectForKey:UserInfos];
//
//            NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
//
//            NSMutableArray *videos = nil;
//
//            if (extraPropertiesDic[@"monitor"] !=nil) {
//
//                videos = [[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
//            }
//
//            if (videos != nil&&[videos count]>0) {
//
//                for (int i = 0; i < [videos count]; i++) {
//
//                    NSDictionary *vInfosDic = [videos objectAtIndex:i];
//
//
//                    if ([vInfosDic[@"devid"] isEqualToString:self.vInfo.devid]) {
//                        [videos removeObjectAtIndex:i];
//                        break;
//                    }
//                }
//            }
//
//            NSString *monitorStr = [videos JSONString];
//
//            //修改昵称
//            NSDictionary *monitorDic = @{@"monitor":monitorStr};
//            NSDictionary *dic = @{
//                                  @"extraProperties" : monitorDic,
//                                  };
//
//            [MBProgressHUD showLoadToView:GetWindow];
//            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:@"http://user-openapi.hekreu.me/user/profile" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://user-openapi.hekreu.me/user/profile" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//                    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//                    [config setValue:responseObject forKey:UserInfos];
//                    [config synchronize];
//
////                    [[VideoDataBase sharedDataBase] deletVideoInfo:self.vInfo.devid];
//                    [[VideoDataBase sharedDataBase] deletVideoInfo:self.vInfo.devid andUserName:self.vInfo.userName];
//
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//
//                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//                    [MBProgressHUD showError:@"出错" ToView:GetWindow];
//                }];
//
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                [MBProgressHUD hideHUDForView:GetWindow animated:YES];
//                [MBProgressHUD showError:@"出错" ToView:GetWindow];
//            }];
//        }
//    }else if(alertView.tag == 3){
//        if (buttonIndex == 1) {
//        }
//    }
//}

#pragma mark FunSDKCallBack
//-(void)getConfig:(DeviceConfig*)config result:(int)result{
//    [SVProgressHUD dismiss];
//
//
//    if ([config.name isEqualToString:@JK_SystemInfo]) {
//
//        const char* pCfgBuf = config.jObject->ToString();
//        config.jLastStrCfg = OCSTR(pCfgBuf);
//
//
//            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",config.jLastStrCfg] ToView:GetWindow];
//
////        NSLog(@"koyang=======%@",config.jLastStrCfg);
//
////        NSError *error;
////        NSData *data = [config.jLastStrCfg dataUsingEncoding:NSUTF8StringEncoding];
////        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//
//    }
//
////    SystemInfo *sInfo = (SystemInfo*)config.jObject;
//
//
//
//
////    NSString *siNFO = JSystemInfo.JObject.value();
//
//
//
//    if (result < 0) {
//
//        if (result == EE_DVR_PASSWORD_NOT_VALID) {//密码错误
//            //            NSDeviceInfo *dev = [DATACENTER GetDeviceBySN:self.deviceSN];
//            //            DeviceAddVC *pModifyDev = [[DeviceAddVC alloc] initWith:dev IsAdd:NO];
//            //            pModifyDev.name = TS("Modify Device Password");
//            //            [self presentViewController:pModifyDev animated:YES completion:nil];
//        }
//
//        if (result == EE_DVR_PASSWORD_NOT_VALID) {//密码错误
//            //            NSDeviceInfo *dev = [DATACENTER GetDeviceBySN:self.deviceSN];
//            //            DeviceAddVC *pModifyDev = [[DeviceAddVC alloc] initWith:dev IsAdd:NO];
//            //            pModifyDev.name = TS("Modify Device Password");
//            //            [self presentViewController:pModifyDev animated:YES completion:nil];
//        }
//
//    }else{
//        SystemInfo *sInfo = (SystemInfo*)config.jObject;
////        NSLog(@"koyang=====koyang ====");
//    }
//}

//-(void)setConfig:(DeviceConfig*)config result:(int)result{
//    [SVProgressHUD dismiss];
//    //    if (result < 0) {
//    //        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:result] duration:3];
//    //
//    //    }else{
//    //
//    //    }
//}

//-(int)MsgHandle{
//    if ( !_hObj ) {
//        _hObj = FUN_RegWnd((__bridge void*)self);
//    }
//    return _hObj;
//}

//obj不再使用时，请主动调用下CloseHandle
-(void)CloseHandle{
    FUN_UnRegWnd(_hObj);
    _hObj = 0;
}





@end

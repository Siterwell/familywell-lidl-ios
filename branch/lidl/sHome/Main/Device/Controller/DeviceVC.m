//
//  DeviceVC.m
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "DeviceVC.h"
#import "ItemData.h"
#import "BookShelfMainView.h"
#import "UINavigationBar+Awesome.h"
#import "setNewArr.h"
#import "ArrayTool.h"
#import "AddDeviceVC.h"
#import "BaseNC.h"
#import "DeviceDataBase.h"
#import "DeviceListModel.h"
//#import "DeviceMapHelp.h"
#import "ScynDeviceName.h"
#import "DeviceNameModel.h"
#import "BatterHelp.h"
//#import "MainDeviceApi.h"
#import "ScynDeviceApi.h"
#import "Encryptools.h"
#define kIPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)
@interface DeviceVC ()
@property (nonatomic, strong) NSMutableArray *modelSource;
@property (nonatomic, weak)   BookShelfMainView *bookShelfMainView;
@end

@implementation DeviceVC
{
    NSString *_runDevice;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"addDeviceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"updateDeviceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:@"pauseRecv" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countine) name:@"countineRecv" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopScynDevice) name:@"updateDeviceOver" object:nil];

    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(add) Title:NSLocalizedString(@"新增",nil) withTintColor:RGB(40, 184, 215)];
    
    self.title = NSLocalizedString(@"设备",nil);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 144)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //添加 分组组建
    BookShelfMainView *bookShelfView = [BookShelfMainView loadFromNib];
    bookShelfView.subVC = self;
    bookShelfView.delegate = [RACSubject subject];
    @weakify(self)
    [bookShelfView.delegate subscribeNext:^(id x) {
        //同步
        @strongify(self)
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        if(model==nil){
            [MBProgressHUD showError:NSLocalizedString(@"请选择网关", nil) ToView:self.view];
            [self.bookShelfMainView stopScycn];
        }else{
            //氦氪云接口获取设备状态
            [self deviceSycn];
        }
    }];
    [self.view addSubview:bookShelfView];
    self.bookShelfMainView = bookShelfView;
    WS(ws)
    [bookShelfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
        make.top.equalTo(44+(kIPhoneX?88:64));
        make.bottom.equalTo(ws.view.mas_bottom);
    }];
    
    [bookShelfView initWithData:self.modelSource];

    [self.bookShelfMainView.model addObserver:self forKeyPath:@"itemsDataArr" options:NSKeyValueObservingOptionNew context:nil];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    if (![[config objectForKey:DeviceSycStatus] isEqualToString:@"1"]) {
        [self.bookShelfMainView startScycn];
    }
    
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(-30);
        make.height.equalTo(12);
        make.width.equalTo(25);
        make.top.equalTo(12+(kIPhoneX?88:64));
    }];
    
    UILabel *redLb = [[UILabel alloc] init];
    redLb.textAlignment = NSTextAlignmentCenter;
    redLb.text = NSLocalizedString(@"触发", nil);
    redLb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:redLb];
    [redLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(20);
        make.left.equalTo(red.mas_right).offset(10);
        make.centerY.equalTo(red);
    }];
    
    UILabel *greenLb = [[UILabel alloc] init];
    greenLb.text = NSLocalizedString(@"正常", nil);
    greenLb.textAlignment = NSTextAlignmentCenter;
    greenLb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:greenLb];
    [greenLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(redLb);
        make.right.equalTo(red.mas_left).offset(-10);
    }];
    
    UIView *green = [[UIView alloc] init];
    green.backgroundColor = RGB(63, 195, 128);
    [self.view addSubview:green];
    [green mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(red);
        make.right.equalTo(greenLb.mas_left).offset(-10);
    }];
    
    UIView *gray = [[UIView alloc] init];
    gray.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:gray];
    [gray makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redLb.mas_right).offset(10);
        make.top.height.width.equalTo(red);
    }];

    UILabel *grayLb = [[UILabel alloc] init];
    grayLb.textAlignment = NSTextAlignmentCenter;
    grayLb.text = NSLocalizedString(@"离线", nil);
    grayLb.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:grayLb];
    [grayLb makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gray.mas_right).offset(10);
        make.centerY.equalTo(gray);
    }];

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopScynDevice{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self lodaData];
        [self.bookShelfMainView stopScycn];
    });
}

/**
 设备同步
 */
- (void)deviceSycn{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if (model == nil) {
        NSLog(@"[RYAN] deviceSycn > no avaible device");
        return;
    }
    
    
    NSMutableArray *array = [[DeviceDataBase sharedDataBase] selectDevice];
    
    int maxId = 0;
    for (ItemData *data in array) {
        if (data.devID && [data.devID intValue] > maxId) {
            maxId = [data.devID intValue];
        }
    }
    NSString *content = @"";
    
    content = [NSString stringWithFormat:@"%@",[BatterHelp gethexBybinary:(maxId*2 +2)]];
    int length = (int)content.length;
    for (int i = 0; i < 4 - length; i++) {
        content = [@"0" stringByAppendingString:content];
    }
    for (int i = 1 ; i<=maxId; i++) {
        bool hasDevice = NO;
        for (ItemData *data in array) {
            if (data.devID && [data.devID intValue] == i) {
                content = [content stringByAppendingString:data.crcCode];
                hasDevice = YES;
                break;
            }
        }
        if (!hasDevice) {
            content = [content stringByAppendingString:@"0000"];
        }
    }
    
    ScynDeviceApi *api = [[ScynDeviceApi alloc] initWithDrivce:model.devTid andCtrlKey:model.ctrlKey DeviceStatus:[[DeviceDataBase sharedDataBase] selectDevice]];
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        if (data) {
            NSNumber *msgId=data[@"msgId"];
            NSNumber *cmdId = data[@"params"][@"data"][@"cmdId"];
            DeviceListModel *model2 = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            NSString * devrev = [[data objectForKey:@"params"] objectForKey:@"devTid"];
            if(model2!=nil && [devrev isEqualToString:model2.devTid]){
            //TODO: 在这里init方法里面做限制
            DeviceModel *model = [[DeviceModel alloc] initWithDivicedictionary:data error:nil];
            if([cmdId intValue] == 119){
                    int newa = [Encryptools getDescryption:model.device_ID withMsgId:[msgId intValue]];
                    [model setDevice_ID:newa];
                }
            //数据库更新设备
            if ([model.device_name isEqualToString:@"DEL"]) {
                [[DeviceDataBase sharedDataBase] deletDevice:model.device_ID];
            }else if([model.device_status isEqualToString:@"OVER"]){
                //获取结束位置符号
                [config setObject:@"1" forKey:DeviceSycStatus];
                [config synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceOver" object:nil];
                    
            }else{
                [[DeviceDataBase sharedDataBase] updateDevice:model];
            }
        }
            

        }
        [self.bookShelfMainView stopScycn];
    } failure:^(id data, NSError *error) {
        [self.bookShelfMainView stopScycn];
    }];
    
}

/**
 KVO
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    [self save];
}

/**
 暂停接受消息
 */
- (void)pause{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addDeviceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDeviceSuccess" object:nil];
}

/**
 继续接受消息
 */
- (void)countine{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"addDeviceSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lodaData) name:@"updateDeviceSuccess" object:nil];
}

/**
 归档到本地数据
 */
- (void)save{
    [NSKeyedArchiver archiveRootObject:_bookShelfMainView.model.itemsDataArr toFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"]];
}

/**
 跳转到添加页面
 */
-(void)add{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    if (model == nil) {
        [MBProgressHUD showError:NSLocalizedString(@"请选择网关", nil) ToView:self.view];
        return;
    }
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
    AddDeviceVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddDeviceVC"];
    vc.type = @"add";
    BaseNC *nc = [[BaseNC alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nc animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    [self lodaData];
    [self scynDeviceName];
}

/**
 同步设备名字
 */
- (void)scynDeviceName{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    
    ScynDeviceName *api = [[ScynDeviceName alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey Device:[[DeviceDataBase sharedDataBase] selectDevice]];

    NSLog(@"[RYAN] scynDeviceName >> _runDevice = %@", _runDevice);
    NSLog(@"[RYAN] scynDeviceName >> model = %@", model);
    
    if (model==nil) {
        NSLog(@"[RYAN] scynDeviceName > no avaible device");
        return;
    }
    
    if (![_runDevice isEqualToString:model.devTid]) {
        NSLog(@"[RYAN] scynDeviceName > start sync name");
        
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            DeviceNameModel *model = [[DeviceNameModel alloc] initWithDivicedictionary:data error:nil];
            if (model.answer_content.length == 36) {
                NSString *device_id = [NSString stringWithFormat:@"%lu",strtoul([[model.answer_content substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16)];
                NSString *device_name = [model.answer_content substringWithRange:NSMakeRange(4, 32)];
                NSStringEncoding enc = NSUTF8StringEncoding;//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                
                NSData *data = [BatterHelp hexStringToData:device_name];
                NSString *result = [[NSString alloc] initWithData:data encoding:enc];
                result = [result stringByReplacingOccurrencesOfString:@"@" withString:@""];
                result = [result stringByReplacingOccurrencesOfString:@"$" withString:@""];
                
                [[DeviceDataBase sharedDataBase] addDeviceName:result ID:[device_id intValue]];
            }else {
                
            }
        } failure:^(id data, NSError *error) {
        }];
    }else{
        NSLog(@"[RYAN] scynDeviceName > do nothing");
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        } failure:^(id data, NSError *error) {
        }];
    }

    _runDevice = model.devTid;

}

/**
 载入数据
 */
-(void)lodaData{
    
    NSMutableArray *mainItems = [[DeviceDataBase sharedDataBase] selectDevice];
    
    if (!self.modelSource) {
        self.modelSource = [[NSMutableArray alloc]init];
    }
    
    self.modelSource  = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"]];
    
    self.modelSource = [ArrayTool addJudgeArr:self.modelSource UpdateArr:mainItems];
    self.modelSource = [ArrayTool deletJundgeArr:self.modelSource UpdateArr:mainItems];
    self.modelSource = [ArrayTool updateJundgeArr:self.modelSource UpdateArr:mainItems];
    
    [self.bookShelfMainView initWithData:self.modelSource];
    [self.bookShelfMainView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

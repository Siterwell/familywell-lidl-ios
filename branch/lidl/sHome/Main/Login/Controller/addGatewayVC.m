//
//  addGatewayVC.m
//  sHome
//
//  Created by shaop on 2016/12/21.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "addGatewayVC.h"
#import "addWifiVC.h"
#import "DeviceDataBase.h"
#import "SceneDataBase.h"
#import "SystemSceneDataBase.h"
#import "TimeScenedDataBase.h"
#import "AppDelegate.h"

@interface addGatewayVC ()
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imagView;
@property (strong, nonatomic) IBOutlet UIButton *titleBtn;

@end

@implementation addGatewayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleBtn.titleLabel.lineBreakMode = 0 ;
    
    self.nextBtn.layer.cornerRadius = 17.5f;
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];

    for (int i = 0; i < 10; i++) {
        UIImage *imageName = [UIImage imageNamed:[NSString stringWithFormat:@"config%d",i]];
        [frames addObject:imageName];
    }
    _imagView.animationImages = frames;
    _imagView.animationDuration = 11.0f;
    [_imagView startAnimating];
    
    if (!_isFromeSeeting) {
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(logout) Title:NSLocalizedString(@"登出", nil) withTintColor:RGB(40, 184, 215)];
    }
    
}

-(void)logout{
    //氦氪登出
    [[Hekr sharedInstance] logout];
    //删除NSUserDefaults数据
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    [config removeObjectForKey:DeviceInfo];
    [config removeObjectForKey:UserInfos];
    [config removeObjectForKey:selectSystemItem];
    //删除数据库数据
    [[DeviceDataBase sharedDataBase] deletDevice];
    [[SceneDataBase sharedDataBase] deletAllScene];
    [[SystemSceneDataBase sharedDataBase] deletAllSystemScene];
    [[TimeScenedDataBase sharedDataBase] deletAllTimerScene];
    //删除归档数据
    [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"] error:nil];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    addWifiVC *vc = segue.destinationViewController;
    vc.isFromeSeeting = _isFromeSeeting;
}

@end

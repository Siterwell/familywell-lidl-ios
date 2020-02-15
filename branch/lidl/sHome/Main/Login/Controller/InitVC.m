//
//  InitVC.m
//  sHome
//
//  Created by TracyHenry on 2018/5/23.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "InitVC.h"
#import "AppDelegate.h"
@interface InitVC()
@property (nonatomic,strong) UIImage * LogoImage;
@property (nonatomic,assign) NSInteger flag;
@end

@implementation InitVC

-(void)viewDidLoad {
    [self SetView];
    _flag = 0;
    if([Hekr sharedInstance].user==nil){
        UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppDelegate* appDelagete = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelagete.window.rootViewController = [uistoryboard instantiateInitialViewController];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(_flag == 0){
                UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AppDelegate* appDelagete = (AppDelegate*)[UIApplication sharedApplication].delegate;
                appDelagete.window.rootViewController = [uistoryboard instantiateInitialViewController];
            }
            
        });
        
           NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        NSString *username = [config objectForKey:@"UserName"];
        NSString *password = [config objectForKey:@"Password"];
        WS(ws);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[Hekr sharedInstance] setOnlineSite:@"hekreu.me"];
            if([Hekr sharedInstance].user && username.length != 0 && password.length != 0){
                 [[Hekr sharedInstance] login:username password:password callbcak:^(id user, NSError *error) {
                    if (!error) {
                        _flag = 1;
                        NSLog(@"重新登录成功");
                        UIStoryboard *uistoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        AppDelegate* appDelagete = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        appDelagete.window.rootViewController = [uistoryboard instantiateInitialViewController];
                    }else{
                        if (error.code == -1011) {
                            [[Hekr sharedInstance] logout];
                            NSLog(@"重新登录失败：密码错误");
                            [MBProgressHUD showError:NSLocalizedString(@"用户名密码错误", nil) ToView:ws.view];
                        }
                    }
                }];
            }
        });
    }


}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)SetView{
    //[self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = RGB(255, 255, 255);
    UIImageView *logoIMG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appLogo"]];
    [self.view addSubview:logoIMG];
    [logoIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(200);
        make.height.equalTo(200);
        make.centerY.equalTo(0);
    }];
}

@end

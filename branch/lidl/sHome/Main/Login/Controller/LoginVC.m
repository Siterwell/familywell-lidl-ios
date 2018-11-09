//
//  LoginVC.m
//  sHome
//
//  Created by shaop on 2016/12/20.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "LoginVC.h"
#import "UINavigationBar+Awesome.h"
#import "ANTCacheManager.h"

#define ACCOUNT_LIST @"Account_list"

@interface LoginVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *savePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *seePasswordBtn;

//@property (nonatomic, copy) NSString *https;

@property (nonatomic, strong)UITableView  *accountTableView;

@end

@implementation LoginVC
{
    NSMutableArray   *accountData;
    NSMutableArray   *displayData;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _bgView.layer.borderWidth = 0.6;
    _bgView.layer.borderColor = RGB(205, 205, 205).CGColor;
    _loginBtn.layer.cornerRadius = 17.5f;
    
    [_savePasswordBtn setImage:[UIImage imageNamed:@"jzmm_noselect"] forState:UIControlStateNormal];
    [_savePasswordBtn setImage:[UIImage imageNamed:@"jzmm_select"] forState:UIControlStateSelected];
    
    [_seePasswordBtn setImage:[UIImage imageNamed:@"close_eyes_icon"] forState:UIControlStateNormal];
    [_seePasswordBtn setImage:[UIImage imageNamed:@"eyes_icon"] forState:UIControlStateSelected];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *username = [config objectForKey:@"UserName"];
    NSString *password = [config objectForKey:@"Password"];
    NSNumber *rem = [config objectForKey:@"RememberLoginPasswd"];
    
    
    if ([rem integerValue] == 1) {
        _userNameTextField.text = username;
        _passwordTextField.text = password;
        [_savePasswordBtn setSelected:YES];
    }else{
        _userNameTextField.text = username;
        [_savePasswordBtn setSelected:NO];
    }
    
//   self.navigationItem.rightBarButtonItem =  [self itemWithTarget:self action:@selector(clickItem) Title:@"Language" withTintColor:RGB(40, 184, 215)];
    UIButton *lanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lanBtn setTitle:@"Language" forState:UIControlStateNormal];
    [lanBtn setTitleColor:RGB(40, 184, 215) forState:UIControlStateNormal];
    lanBtn.titleLabel.font = SYSTEMFONT(15);
    [lanBtn setFrame:CGRectMake(self.view.frame.size.width - 105, 44, 105, 44)];
    [lanBtn addTarget:self action:@selector(clickItem) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:lanBtn];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    _accountTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _bgView.frame.origin.y + 3*_userNameTextField.frame.size.height, self.view.frame.size.width, 0) style:UITableViewStylePlain];
    _accountTableView.delegate = self;
    _accountTableView.clipsToBounds  = YES;
    _accountTableView.dataSource = self;
    [self.view addSubview:_accountTableView];
    _accountTableView.rowHeight = 40;
    _accountTableView.tableFooterView = [UIView new];
    _accountTableView.hidden = YES;
    
    
    NSArray *accountArray = [ANTCacheManager responseDicFromCache:ACCOUNT_LIST];
    if (accountArray) {
        accountData = [[NSMutableArray alloc]initWithArray:accountArray];
    }
    
    _accountTableView.frame = CGRectMake(_accountTableView.frame.origin.x, _accountTableView.frame.origin.y, _accountTableView.frame.size.width, accountData.count * 40 == 0?80:accountData.count * 40>200?200:accountData.count * 40);
    
    _userNameTextField.delegate = self;
    
}

-(void)clickItem{
    [self performSegueWithIdentifier:@"toLanguage" sender:nil];
    _accountTableView.hidden = YES;
   
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.alpha = 1;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO];
    _accountTableView.hidden = YES;
    
}

//下拉历史登录用户
- (IBAction)showUsers:(id)sender {
    _accountTableView.hidden = !_accountTableView.hidden;
}

//记住密码
- (IBAction)savePasswordAction:(id)sender {
    UIButton *btn = sender;
    [btn setSelected:!btn.selected];
    _accountTableView.hidden = YES;
}

//登录事件
- (IBAction)loginAction:(id)sender {
    _accountTableView.hidden = YES;
    [MBProgressHUD showMessage:NSLocalizedString(@"加载中", nil) ToView:self.view];
    WS(ws)
    
    //TODO : [RYAN] Hekr login api is not encryted
    [[Hekr sharedInstance] login:_userNameTextField.text password:_passwordTextField.text callbcak:^(id user, NSError *error) {
        if (!error) {
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];

            [config setObject:self.userNameTextField.text forKey:@"UserName"];
            [config setObject:self.passwordTextField.text forKey:@"Password"];
            if (self.savePasswordBtn.selected) {
                [config setObject:@1 forKey:@"RememberLoginPasswd"];
            }else{
                [config setObject:@0 forKey:@"RememberLoginPasswd"];
            }
            [config synchronize];
            [ws save];
            [ws getDeviceList];

            [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"CurrentUserName"];
        }
        else{
            [MBProgressHUD hideHUDForView:ws.view animated:YES];

            if (error.code == -1011) {
                [MBProgressHUD showError:NSLocalizedString(@"用户名密码错误", nil) ToView:ws.view];
            }else{
                [MBProgressHUD showError:NSLocalizedString(@"网络错误", nil) ToView:ws.view];
            }

        }
    }];
    
    
    //++ [RYAN] implement user login POST via HTTPS
//    NSString* https = (ApiMap==nil?@"https://uaa-openapi.hekr.me":ApiMap[@"uaa-openapi.hekr.me"]);
//    NSDictionary *dic = @{
//                          @"username" : _userNameTextField.text,
//                          @"password" : _passwordTextField.text,
//                          @"clientType" : @"IOS",
//                          @"pid" : @"01850775038"
//                          };
//    [[[Hekr sharedInstance] sessionWithDefaultAuthorization]
//     POST:[NSString stringWithFormat:@"%@/login", https]
//     parameters:dic
//     progress:nil
//     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         printf("[RYAN] Login Successfully！");
//         NSString* access_token = responseObject[@"access_token"];
//         NSLog(@"[RYAN] Login >> access_token : %@", access_token);
//
//         NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//
//         [config setObject:self.userNameTextField.text forKey:@"UserName"];
//         [config setObject:self.passwordTextField.text forKey:@"Password"];
//         if (self.savePasswordBtn.selected) {
//             [config setObject:@1 forKey:@"RememberLoginPasswd"];
//         }else{
//             [config setObject:@0 forKey:@"RememberLoginPasswd"];
//         }
//         [config synchronize];
//         [ws save];
//         [ws getDeviceList];
//
//         [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"CurrentUserName"];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:ws.view animated:YES];
//
//        if (error.code == -1011) {
//            [MBProgressHUD showError:NSLocalizedString(@"用户名密码错误", nil) ToView:ws.view];
//        }else{
//            [MBProgressHUD showError:NSLocalizedString(@"网络错误", nil) ToView:ws.view];
//        }
//    }];
    //-- https
    
}

- (void)getDeviceList{
    WS(ws)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/device", (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"])] parameters:@{@"page":@(0),@"size":@(5)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:ws.view animated:YES];
        NSArray *arr = responseObject;
        
        NSMutableSet *dcs = [NSMutableSet set];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *connectHost = [[obj objectForKey:@"dcInfo"] objectForKey:@"connectHost"];
            [dcs addObject:connectHost == nil ? @"hub.hekr.me": connectHost];
        }];
        [[Hekr sharedInstance] setCloudControlWithGlobals:dcs.allObjects];
        
        if (arr != nil && arr.count>0) {
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setValue:arr forKey:Devices];
            
            if ([config objectForKey:@"LastDeviceInfo"] != nil && [_userNameTextField.text isEqualToString:@"USERNAMELOGOUT"]) {
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj[@"devTid"] isEqual:[config objectForKey:@"LastDeviceInfo"][@"devTid"]]) {
                        [config setValue:obj forKey:DeviceInfo];
                    }
                }];
            }
            else {
                [config setValue:arr[0] forKey:DeviceInfo];
            }
            
            [config synchronize];
            [ws bindGTId];
            
        }else{
            [self performSegueWithIdentifier:@"toAddGateway" sender:nil];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:ws.view animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"网络错误", nil) ToView:self.view];
    }];
}

- (void)bindGTId {
    MJWeakSelf
    NSString *lan;
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    if ([languageName containsString:@"zh"]) {
        lan = @"zh";
    } else if ([languageName containsString:@"de"]) {
        lan = @"de";
    } else if ([languageName containsString:@"fr"]) {
        lan = @"fr";
    } else if ([languageName containsString:@"es"]) {
        lan = @"es";
    }else {
        lan = @"en";
    }
    
    NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
    [config setValue:languageName forKey:CurrentLanguage];
    
    if ([config objectForKey:AppClientID]) {
        NSDictionary *dic = @{
                              @"clientId" : [config objectForKey:AppClientID],
                              @"pushPlatform" : @"GETUI",
                              @"locale" : lan
                              };
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/user/pushTagBind", (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"])] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"绑定成功！");

            //        [self save];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginUser" object:nil];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf bindGTId];
        }];
    }
}

//- (void)bindGTId{
//    NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
//    NSDictionary *dic = @{
//                          @"appTid" : HekrPid,
//                          @"clientId" : [config objectForKey:AppClientID],
//                          @"type" : @0
//                          };
//    WS(ws)
//
//    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://user-openapi.hekr.me/user/pushTagBind" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
//        if (ws.savePasswordBtn.selected) {
//            [config setObject:ws.userNameTextField.text forKey:@"UserName"];
//            [config setObject:ws.passwordTextField.text forKey:@"Password"];
//        }else{
//            [config removeObjectForKey:@"UserName"];
//            [config removeObjectForKey:@"Password"];
//        }
//        [config synchronize];
////        [self save];
//
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginUser" object:nil];
//
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title withTintColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:color];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect frame = btn.frame;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    frame.size = CGSizeMake(80, 20);
    btn.frame = frame;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (IBAction)seePassword:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.passwordTextField.secureTextEntry = !sender.selected;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _accountTableView.hidden = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _accountTableView.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _accountTableView.hidden = YES;
    self.passwordTextField.text = @"";
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *userDic = accountData[indexPath.row];
    
    static NSString  *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = RGB(211, 211, 211);
    cell.textLabel.text = userDic[@"userName"];
    
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 40, 40)];
    delBtn.tag = indexPath.row;
    [delBtn addTarget:self action:@selector(delLocalUser:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:delBtn];
    [delBtn setImage:[UIImage imageNamed:@"del_icon"] forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return accountData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *userDic = accountData[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _userNameTextField.text = userDic[@"userName"];
    _passwordTextField.text = userDic[@"pwd"];
    self.savePasswordBtn.selected = userDic[@"pwd"]!=nil&&![userDic[@"pwd"] isEqual:[NSNull null]]?YES:NO;
    _accountTableView.hidden = YES;
}

- (void)save {
    
    if (!accountData) {
        accountData  = [NSMutableArray new];
    }
    NSDictionary *dic = @{@"userName":_userNameTextField.text,@"pwd":self.savePasswordBtn.selected?_passwordTextField.text:@""};
    
    for (NSDictionary *dica in accountData) {
        
        if ([dica[@"userName"] isEqualToString:_userNameTextField.text]) {
            [accountData removeObject:dica];
            break;
        }
    }
    
    [accountData insertObject:dic atIndex:0];
    
    if ([ANTCacheManager cache:[NSJSONSerialization dataWithJSONObject:accountData options:NSJSONWritingPrettyPrinted error:nil] fileName:ACCOUNT_LIST]) {
        NSLog(@"____保存成功");
    }
}

- (void)delLocalUser:(id)sender{
    UIButton *delBtn = (UIButton*)sender;
    if (accountData.count > 0) {
        [accountData removeObjectAtIndex:delBtn.tag];
        [_accountTableView reloadData];
    }
    
    if ([ANTCacheManager cache:[NSJSONSerialization dataWithJSONObject:accountData options:NSJSONWritingPrettyPrinted error:nil] fileName:ACCOUNT_LIST]) {
        NSLog(@"____保存成功");
    }
    if (accountData.count == 0) {
        _accountTableView.hidden = YES;
    }else{
        [_accountTableView reloadData];
    }
}

@end

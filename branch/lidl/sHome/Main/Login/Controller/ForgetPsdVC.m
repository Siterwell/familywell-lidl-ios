//
//  ForgetPsdVC.m
//  sHome
//
//  Created by shaop on 2016/12/20.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "ForgetPsdVC.h"
#import "RegistCell.h"
#import "VerifyCodeCell.h"
#import "ErrorCodeUtil.h"
#import "CYAlertView.h"
#import "PatternUtil.h"

@interface ForgetPsdVC ()<ClickCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@property (weak, nonatomic) UITextField *user_textField;

@property (weak,nonatomic)UITextField *pass_textField;
@property (weak,nonatomic)UITextField *confirm_textField;
@property (weak,nonatomic)UITextField *verifycode_textField;

@property (nonatomic, copy) NSString *https;
@property (assign,nonatomic) BOOL phone_reset;
@end

@implementation ForgetPsdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.https = (ApiMap==nil?@"https://uaa-openapi.hekr.me":ApiMap[@"uaa-openapi.hekr.me"]);
    _clickBtn.layer.cornerRadius = 17.5f;

    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    
    if([languageName containsString:@"zh"]){
        _phone_reset = YES;
    }else{
        _phone_reset = NO;
    }
    
    if(_phone_reset){
     self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"邮箱找回", nil) withTintColor:[UIColor whiteColor]];
    }
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(finish) image:@"back_icon" highImage:nil withTintColor:[UIColor whiteColor]];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    


    if(indexPath.row == 1){
         VerifyCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"verifyCodeCell" forIndexPath:indexPath];
        self.verifycode_textField = cell.titleTextField;
        cell.clickCellDelegate = self;
        cell.hidenBtn.layer.cornerRadius = 5.5f;
        cell.titleTextField.placeholder = NSLocalizedString(@"请输入验证码", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RegistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forgetPsdCell" forIndexPath:indexPath];
        if(indexPath.row == 0){
            self.user_textField = cell.titleTextField;
            cell.hidenBtn.hidden = YES;
            if(_phone_reset){
             self.user_textField.placeholder = NSLocalizedString(@"请输入手机号", nil);
            self.user_textField.keyboardType = UIKeyboardTypeNumberPad;
            }else{
           self.user_textField.placeholder = NSLocalizedString(@"请输入邮箱地址", nil);
           self.user_textField.keyboardType = UIKeyboardTypeEmailAddress;
            }
        }else if(indexPath.row == 2){
            self.pass_textField = cell.titleTextField;
             cell.titleTextField.placeholder = NSLocalizedString(@"请输入密码", nil);
                    cell.titleTextField.secureTextEntry = YES;
        }else if(indexPath.row == 3){
            self.confirm_textField = cell.titleTextField;
             cell.titleTextField.placeholder = NSLocalizedString(@"请确认密码", nil);
                    cell.titleTextField.secureTextEntry = YES;
        }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
    }

    

}

- (IBAction)resetPassword:(id)sender {
    [self.view endEditing:YES];
    
    if([NSString isBlankString:self.user_textField.text] || [NSString isBlankString:self.pass_textField.text]
       || [NSString isBlankString:self.verifycode_textField.text] || [NSString isBlankString:self.confirm_textField.text]){
        [MBProgressHUD showError:NSLocalizedString(@"请输入完整信息", nil) ToView:self.view];
        return;
    }
    
    if (self.pass_textField.text.length < 10) {
        [MBProgressHUD showError:NSLocalizedString(@"The password must contain at least 10 characters and number!", nil) ToView:GetWindow];
        return;
    }
    if(![self.confirm_textField.text isEqualToString:self.pass_textField.text]){
        [MBProgressHUD showError:NSLocalizedString(@"密码输入不一致", nil) ToView:self.view];
        return;
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", PasswordPattern];
    if (![predicate evaluateWithObject:self.pass_textField.text]){
        [MBProgressHUD
         showError:NSLocalizedString(@"Passwords must contain at least three of uppercase letters, lowercase letters, numbers/special characters.", nil) ToView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:NSLocalizedString(@"请稍后...", nil) ToView:self.view];

    NSDictionary *param1 = @{
                             @"pid" :HekrPid,
                             @"phoneNumber": self.user_textField.text,
                             @"password" :self.pass_textField.text,
                             @"verifyCode" : self.verifycode_textField.text
                             };
    NSDictionary *param2 = @{
                             @"pid" :HekrPid,
                             @"email": self.user_textField.text,
                             @"password" :self.pass_textField.text,
                             @"verifyCode" : self.verifycode_textField.text
                             };
    NSString *url = (_phone_reset?@"%@/resetPassword?type=phone":@"%@/resetPassword?type=email_verify_code");
    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:url, self.https] parameters:(_phone_reset?param1:param2) progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSLog(@"%@",responseObject);
        [self autoLoginForUnbindPush:self.user_textField.text password:self.pass_textField.text];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
//        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
        UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[ErrorCodeUtil getMessageWithCode:model.code] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alertVc addAction:action1];
        [self presentViewController:alertVc animated:YES completion:nil];
    }];
}

-(void)autoLoginForUnbindPush:(NSString *)email password:(NSString *)password {
    //TODO : [RYAN] Hekr login api is not encryted
    [[Hekr sharedInstance] login:email password:password callbcak:^(id user, NSError *error) {
        if (!error) {
            NSLog(@"[RYAN] autoLoginForUnbindPush > success: %@",error);
            
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            
            [config setObject:email forKey:@"UserName"];
            [config setObject:password forKey:@"Password"];
            [config synchronize];
            
            [self unbindAllPush];
        }
        else{
            NSLog(@"[RYAN] autoLoginForUnbindPush > fail: %@",error);
            [self resetPasswordCompleted];
        }
    }];
}

- (void)unbindAllPush {
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:[NSString stringWithFormat:@"%@/user/unbindAllPushAlias", https] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"[RYAN] unbindAllPush > success");
        [self resetPasswordCompleted];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"[RYAN] unbindAllPush > failed");
        [self resetPasswordCompleted];
    }];
}

-(void)resetPasswordCompleted {
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showSuccess:NSLocalizedString(@"修改成功", nil) ToView:GetWindow];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clickItem{
    if(_phone_reset){
        _phone_reset = NO;
        self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"手机找回", nil) withTintColor:RGB(40, 184, 215)];
        self.user_textField.text = @"";
        self.verifycode_textField.text=@"";
        self.user_textField.placeholder = NSLocalizedString(@"请输入邮箱地址", nil);
        self.user_textField.keyboardType = UIKeyboardTypeEmailAddress;
    }else{
        _phone_reset = YES;
        self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"邮箱找回", nil) withTintColor:RGB(40, 184, 215)];
        self.user_textField.text = @"";
        self.verifycode_textField.text=@"";
        self.user_textField.placeholder = NSLocalizedString(@"请输入手机号", nil);
        self.user_textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    self.user_textField.text = @"";
    self.verifycode_textField.text = @"";
}

-(void)finish{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkCaptchaCode:(NSString *)code {
    
    NSDictionary *param = @{@"rid": ramdomcode,
                            @"code": code};
    
    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/images/checkCaptcha", self.https] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSString * token = responseObject[@"captchaToken"];
        [self getVerifyCode:token];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];

}

- (void)getVerifyCode:(NSString *)token {
    NSString * url = (_phone_reset?@"%@/sms/getVerifyCode?phoneNumber=%@&pid=%@&token=%@&type=resetPassword":@"%@/email/getVerifyCode?email=%@&pid=%@&token=%@&type=resetPassword");
        NSString * lan;
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
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:lan forHTTPHeaderField:@"Accept-Language"];
    [[Hekr sharedInstance] sessionWithDefaultAuthorization].requestSerializer = requestSerializer;
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:url, self.https,self.user_textField.text,HekrPid,token] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showMessage:NSLocalizedString(@"发送成功", nil) ToView:self.view RemainTime:1.1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
    }];
}

#pragma mark -delegate
-(void)clickTerm:(UIButton *)button{
    
    
    
    if (self.user_textField.text.length == 0) {
        if(_phone_reset)
        [MBProgressHUD showMessage:NSLocalizedString(@"请输入手机号", nil) ToView:self.view RemainTime:1.1f];
        else
        [MBProgressHUD showMessage:NSLocalizedString(@"请输入邮箱地址", nil) ToView:self.view RemainTime:1.1f];
        return;
    }
    [self.view endEditing:YES];
    CYAlertView *alert = [[CYAlertView alloc] initWithTarget:self Title:NSLocalizedString(@"请输入图形验证码", nil) Content:nil CancelButtonTitle:@"" DetermineButtonTitle:@"" toView:self.view.window];
    [alert cy_alertShow];
    [alert cy_clickCancelButton:^{
        
    } determineButton:^{
      [self checkCaptchaCode:alert.captchaTF.text];
    }];
}

@end

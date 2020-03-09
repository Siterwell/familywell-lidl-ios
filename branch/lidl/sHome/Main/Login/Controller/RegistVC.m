//
//  RegistVC.m
//  sHome
//
//  Created by shaop on 2016/12/20.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "RegistVC.h"
#import "YYLabel.h"
#import "RegistCell.h"
#import "VerifyCodeCell.h"
#import "ErrorCodeUtil.h"
#import "CYAlertView.h"
#import "NSString+CY.h"
#import "PatternUtil.h"

@interface RegistVC ()<ClickCellDelegate>
@property (strong, nonatomic)  UIButton *registBtn;
@property (strong, nonatomic)  UILabel *RuleLabel;

@property (weak, nonatomic) UITextField *user_textField;
@property (weak,nonatomic)UITextField *pass_textField;
@property (weak,nonatomic)UITextField *confirm_textField;
@property (weak,nonatomic)UITextField *verifycode_textField;
@property (assign,nonatomic) BOOL phone_reset;
@property (strong, nonatomic)  UIButton *tongBtn;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    
    if([languageName containsString:@"zh"]){
        _phone_reset = YES;
    }else{
        _phone_reset = NO;
    }
    
    if(_phone_reset){
        self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"邮箱注册", nil) withTintColor:RGB(40, 184, 215)];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    if (@available(iOS 13.0, *)) {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
     } else {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     }
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
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
    return 90;
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
        RegistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registCell" forIndexPath:indexPath];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView  *view = [[UIView alloc] init];

//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"同意服务条款", nil)];
//    text.yy_font = [UIFont systemFontOfSize:13];
//    text.yy_color = [UIColor darkGrayColor];
//
//
//    YYTextHighlight *highlight = [YYTextHighlight new];
//    [highlight setColor:RGB(198, 198, 198)];
//    [highlight setFont:[UIFont boldSystemFontOfSize:13]];
//    [highlight setUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle]];
//    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
//        [self performSegueWithIdentifier:@"toPrivacy" sender:nil];
//    };
//    [text yy_setColor:RGB(51, 51, 51) range:NSMakeRange(0, text.length)];
//    [text yy_setFont:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, text.length)];
//    [text yy_setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle] range:NSMakeRange(0, text.length)];
//    [text yy_setTextHighlight:highlight range:NSMakeRange(0, text.length)];
  
    self.RuleLabel = [UILabel new];
    self.RuleLabel.text = NSLocalizedString(@"同意服务条款", nil);
    self.RuleLabel.font = [UIFont systemFontOfSize:12];
    self.RuleLabel.textColor = RGB(51, 51, 51);
    self.RuleLabel.numberOfLines = 2;
    self.RuleLabel.backgroundColor = [UIColor clearColor];
    self.RuleLabel.textAlignment = NSTextAlignmentCenter;
    self.RuleLabel.userInteractionEnabled = YES;
    CGSize sizeNew = [self.RuleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.RuleLabel.font}];
    self.RuleLabel.frame = CGRectMake(0, 0, sizeNew.width, sizeNew.height);
    [view addSubview:self.RuleLabel];
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPrivacy:)];
    [self.RuleLabel addGestureRecognizer:tapGesture];
//    [tapGesture release];
    

    WS(ws)
    [self.RuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([UIScreen mainScreen].bounds.size.width * 0.8);
        make.height.equalTo(sizeNew.height);
        make.centerX.equalTo(view.centerX);
        make.top.equalTo(view.mas_top).offset(23);
        make.height.equalTo(@60);
    }];
    
    self.tongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tongBtn setImage:[UIImage imageNamed:@"jzmm_noselect"] forState:UIControlStateNormal];
    [self.tongBtn setImage:[UIImage imageNamed:@"jzmm_select"] forState:UIControlStateSelected];
    [self.tongBtn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.tongBtn];
    [self.tongBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(ws.RuleLabel.left);
        make.centerY.mas_equalTo(ws.RuleLabel.centerY);
        make.width.equalTo(30);
        make.height.equalTo(30);
    }];
    
    
    self.registBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.registBtn.layer.cornerRadius = 17.5f;
    self.registBtn.backgroundColor = RGB(40, 184, 215);
    
    [self.registBtn setTitle:NSLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.registBtn];
    
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(26);
        make.right.equalTo(view.mas_right).offset(-26);
        make.top.equalTo(ws.RuleLabel.mas_bottom).offset(23);
        make.height.equalTo(@35);
    }];
    self.registBtn.alpha = 0.5f;
    [self.registBtn setEnabled:NO];

    return view;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

-(void)regist{
//    NSLog(@"[RYAN] regist");
    
    [self.view endEditing:YES];
    
    if([NSString isBlankString:self.user_textField.text] || [NSString isBlankString:self.pass_textField.text]
       || [NSString isBlankString:self.verifycode_textField.text] || [NSString isBlankString:self.confirm_textField.text]){
        [MBProgressHUD showError:NSLocalizedString(@"请输入完整信息", nil) ToView:self.view];
        return;
    }
    
    //邮箱正则表达判断
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", EmailPattern];
    if (![predicate evaluateWithObject:_user_textField.text] && !_phone_reset){
            [MBProgressHUD showError:NSLocalizedString(@"邮箱格式错误", nil) ToView:self.view];
        return;
    }
    
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
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", PasswordPattern];
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
                             @"code" : self.verifycode_textField.text
                             };
    NSDictionary *param2 = @{
                             @"pid" :HekrPid,
                             @"email": self.user_textField.text,
                             @"password" :self.pass_textField.text,
                             @"code" : self.verifycode_textField.text
                             };
    NSString *url = (_phone_reset?@"%@/register?type=phone":@"%@/register?type=email_verify_code");
    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:url, (ApiMap==nil?@"https://uaa-openapi.hekreu.me":ApiMap[@"uaa-openapi.hekreu.me"])] parameters:(_phone_reset?param1:param2) progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        NSLog(@"%@",responseObject);
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:NSLocalizedString(@"注册成功", nil) ToView:GetWindow];
        [self.delegate sendNext:@{@"user":self.user_textField.text,@"psw":self.pass_textField.text}];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        
        UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:[ErrorCodeUtil getMessageWithCode:model.code] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVc addAction:action1];
        [self presentViewController:alertVc animated:YES completion:nil];
    }];
    


}

-(void)clickItem{
    if(_phone_reset){
        _phone_reset = NO;
        self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"手机注册", nil) withTintColor:RGB(40, 184, 215)];
        self.user_textField.text = @"";
        self.verifycode_textField.text=@"";
        self.user_textField.placeholder = NSLocalizedString(@"请输入邮箱地址", nil);
        self.user_textField.keyboardType = UIKeyboardTypeEmailAddress;
    }else{
        _phone_reset = YES;
        self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"邮箱注册", nil) withTintColor:RGB(40, 184, 215)];
        self.user_textField.text = @"";
        self.verifycode_textField.text=@"";
        self.user_textField.placeholder = NSLocalizedString(@"请输入手机号", nil);
        self.user_textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    self.user_textField.text = @"";
    self.verifycode_textField.text = @"";
}

- (void)checkCaptchaCode:(NSString *)code {
    
    NSDictionary *param = @{@"rid": ramdomcode,
                            @"code": code};
    
    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/images/checkCaptcha", (ApiMap==nil?@"https://uaa-openapi.hekreu.me":ApiMap[@"uaa-openapi.hekreu.me"])] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    NSString * url = (_phone_reset?@"%@/sms/getVerifyCode?phoneNumber=%@&pid=%@&token=%@&type=register":@"%@/email/getVerifyCode?email=%@&pid=%@&token=%@&type=register");
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:url, (ApiMap==nil?@"https://uaa-openapi.hekreu.me":ApiMap[@"uaa-openapi.hekreu.me"]),self.user_textField.text,HekrPid,token] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (void)toPrivacy:(UITapGestureRecognizer *)tapGesture {
    [self performSegueWithIdentifier:@"toPrivacy" sender:nil];
}

-(void)alertBtnClick:(id)sender{
    UIButton *btn = sender;
    if(!btn.selected){
        [self.registBtn setEnabled:YES];
           self.registBtn.alpha = 1.0f;
    }else{
         [self.registBtn setEnabled:NO];
           self.registBtn.alpha = 0.5f;
    }
    [btn setSelected:!btn.selected];
}

@end

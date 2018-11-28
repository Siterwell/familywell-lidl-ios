//
//  ChangePsdVC.m
//  sHome
//
//  Created by shaop on 2016/12/17.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "ChangePsdVC.h"
#import "ChangePsdCell.h"
#import "ErrorCodeUtil.h"
#import "PatternUtil.h"

@interface ChangePsdVC ()
@property (weak, nonatomic) UITextField *theOldPsd;
@property (weak, nonatomic) UITextField *theNewPsd;

@end

@implementation ChangePsdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(compelet) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
}

-(void)compelet{
    
    if (_theOldPsd.text.length == 0) {
        [MBProgressHUD showError:NSLocalizedString(@"无效的旧密码", nil) ToView:GetWindow];
        return;
    }
    if (_theNewPsd.text.length<10) {
        [MBProgressHUD showError:NSLocalizedString(@"The password must contain at least 10 characters and number!", nil) ToView:GetWindow];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", PasswordPattern];
    if (![predicate evaluateWithObject:_theNewPsd.text]){
        [MBProgressHUD
         showError:NSLocalizedString(@"Passwords must contain at least three of uppercase letters, lowercase letters, numbers/special characters.", nil) ToView:self.view];
        return;
    }
    
    
    [MBProgressHUD showMessage:NSLocalizedString(@"修改中", nil) ToView:GetWindow];
    NSString *https = (ApiMap==nil?@"https://uaa-openapi.hekr.me":ApiMap[@"uaa-openapi.hekr.me"]);

    @weakify(self)
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/changePassword", https] parameters:@{@"pid":HekrPid,@"newPassword":_theNewPsd.text,@"oldPassword":_theOldPsd.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        [MBProgressHUD showSuccess:NSLocalizedString(@"修改成功", nil) ToView:GetWindow];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangePsdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangePsdCell" forIndexPath:indexPath];
    if (indexPath.row == 1) {
        cell.textFile.placeholder = NSLocalizedString(@"请输入新密码（6-14位数字、字母）", nil);
        _theNewPsd = cell.textFile;
    }else{
        _theOldPsd = cell.textFile;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end

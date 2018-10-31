//
//  EditEmergentPhoneVC.m
//  sHome
//
//  Created by shaop on 2016/12/18.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "EditEmergentPhoneVC.h"
#import "editPhoneTableViewCell.h"
#import "DeviceListModel.h"
#import "ErrorCodeUtil.h"

@interface EditEmergentPhoneVC ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (copy, nonatomic) NSString *phone;
@end

@implementation EditEmergentPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(compelet) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    editPhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editEmergentPhoneCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RAC(self,phone) = cell.phoneTextFiled.rac_textSignal;

    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12];
    label.text = NSLocalizedString(@"可以是您或您亲近的人的手机号码。\n可以在单个设备详情页点击“紧急电话”进行拨打。", nil);
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(13);
        make.right.equalTo(view.mas_right).offset(-13);
        make.height.equalTo(50);
        make.top.equalTo(view.mas_top).offset(6);
    }];
    
    return view;
    
}

-(void)compelet{
    
    NSDictionary *dic = @{
                          @"description" : _phone,
                          };
    
    [MBProgressHUD showLoadToView:GetWindow];
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);

    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile", https] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", https] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setValue:responseObject forKey:UserInfos];
            [config synchronize];
            [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
            [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
    }];
    
    
}


@end

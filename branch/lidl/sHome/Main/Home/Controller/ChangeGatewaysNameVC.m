//
//  ChangeGatewaysNameVC.m
//  sHome
//
//  Created by shaop on 2017/3/9.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "ChangeGatewaysNameVC.h"
#import "ChangeUserNameCell.h"
#import "ErrorCodeUtil.h"

@interface ChangeGatewaysNameVC ()
@property (nonatomic, strong) NSString *name;
@end

@implementation ChangeGatewaysNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(compelet) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];

}

- (void)compelet{
    if ([_name isEqualToString:@""]||_name == nil) {
        [MBProgressHUD showError:NSLocalizedString(@"名称不能为空", nil) ToView:GetWindow];
        return;
    }
    NSDictionary *dic = @{
                          @"deviceName" : _name,
                          @"desc" : @"1",
                          @"ctrlKey" : self.model.ctrlKey
                          };
    
    [MBProgressHUD showLoadToView:GetWindow];
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PATCH:[NSString stringWithFormat:@"%@/device/%@", https, _model.devTid] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    ChangeUserNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changeGatewayCell" forIndexPath:indexPath];
    cell.textField.text = NSLocalizedString(self.model.deviceName, nil);
    RAC(self,name) = cell.textField.rac_textSignal;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title withTintColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:color];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect frame = btn.frame;
    frame.size = CGSizeMake(40, 20);
    btn.frame = frame;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end

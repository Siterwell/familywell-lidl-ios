//
//  ChangeUserNameVC.m
//  sHome
//
//  Created by shaop on 2016/12/17.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "ChangeUserNameVC.h"
#import "ChangeUserNameCell.h"
#import "UserInfoModel.h"

@interface ChangeUserNameVC ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) UITextField *textFile;
@end

@implementation ChangeUserNameVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(compelet) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
}

-(void)compelet{
    
    if ([_textFile.text isEqualToString:@""]) {
        [MBProgressHUD showError:NSLocalizedString(@"名称不能为空", nil) ToView:GetWindow];
        return;
    }
    NSDictionary *dic = @{
                          @"firstName" : _textFile.text,
                          };
    NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);

    [MBProgressHUD showLoadToView:GetWindow];
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile", https] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", https] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            [config setValue:responseObject forKey:UserInfos];
            [config synchronize];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:GetWindow animated:YES];
            [MBProgressHUD showError:NSLocalizedString(@"出错", nil) ToView:GetWindow];
            
            NSLog(@"%@",error.domain);
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        [MBProgressHUD showError:NSLocalizedString(@"出错", nil) ToView:GetWindow];
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
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeUserNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changeUsername" forIndexPath:indexPath];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    cell.textField.text = model.firstName;
    _textFile = cell.textField;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

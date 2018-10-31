//
//  EmergentPhoneVC.m
//  sHome
//
//  Created by shaop on 2016/12/17.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "EmergentPhoneVC.h"
#import "emergentPhoneCell.h"
#import "UserInfoModel.h"

@interface EmergentPhoneVC ()

@end

@implementation EmergentPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(edit) image:@"pen_icon" highImage:nil withTintColor:[UIColor blackColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
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
    emergentPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emergentCell" forIndexPath:indexPath];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    if (model.user_des) {
        cell.phoneLabel.text = model.user_des;
    }else{
        cell.phoneLabel.text = NSLocalizedString(@"未设置", nil);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:[config objectForKey:UserInfos] error:nil];
    if (model.user_des) {
//        if (@available(iOS 11.0, *)) {
//            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.user_des];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        } else {
//            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"拨打 %@", nil),model.user_des];
//            UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [self presentViewController:alertVc animated:YES completion:nil];
//            [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }]];
//            [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.user_des];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//            }]];
//        }
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",model.user_des];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void)edit{
    [self performSegueWithIdentifier:@"toEditEmergentPhone" sender:nil];
}

@end

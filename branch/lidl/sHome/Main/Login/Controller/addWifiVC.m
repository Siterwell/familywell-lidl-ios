//
//  addWifiVC.m
//  sHome
//
//  Created by shaop on 2016/12/21.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "addWifiVC.h"
#import "addWifiCell.h"
#import "HekrConfig.h"
#import "ESP_NetUtil.h"
#import "connectWifiVC.h"

#import <SystemConfiguration/CaptiveNetwork.h>

@interface addWifiVC ()
@property (strong, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIButton *remberPsdButton;
@property (weak, nonatomic) UITextField *psdTextFiled;
@end

@implementation addWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.connectBtn.layer.cornerRadius = 17.5f;

    
    [_remberPsdButton setImage:[UIImage imageNamed:@"jzmm_noselect"] forState:UIControlStateNormal];
    [_remberPsdButton setImage:[UIImage imageNamed:@"jzmm_select"] forState:UIControlStateSelected];
//    [_remberPsdButton setTitle:NSLocalizedString(@"记住密码", nil) forState:UIControlStateNormal];
    
    _remberPsdButton.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)remberAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)actionNext:(id)sender {
    if ([[HekrConfig getWifiName] containsString:@" "]) {
        [MBProgressHUD showError:NSLocalizedString(@"WIFI名不能含有空格",nil) ToView:self.view];
        return;
    }
    if ([HekrConfig getWifiName] == nil || [[HekrConfig getWifiName] isEqualToString:@""]) {
        [MBProgressHUD showError:NSLocalizedString(@"没有WIFI",nil) ToView:self.view];
        return;
    }
    if (_remberPsdButton.selected == YES) {
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        [config setObject:self.psdTextFiled.text forKey:[NSString stringWithFormat:@"st_wifi_%@",[HekrConfig getWifiName]]];
    }
    [self performSegueWithIdentifier:@"toConnectWifi" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    addWifiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addWifiCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.leftImageView.image = [UIImage imageNamed:@"wifi_icon"];
        cell.titleLabel.text =NSLocalizedString(@"当前网络",nil);
        cell.textField.placeholder = @"";
        cell.textField.text = [HekrConfig getWifiName];
        cell.textField.enabled = NO;
        cell.hidenBtn.hidden = YES;
    }
    else{
        cell.leftImageView.image = [UIImage imageNamed:@"password_icon"];
        cell.titleLabel.text = NSLocalizedString(@"密码",nil);
        cell.textField.secureTextEntry = YES;
        cell.textField.placeholder = NSLocalizedString(@"请输入WIFI密码",nil);
        NSUserDefaults *conifg = [NSUserDefaults standardUserDefaults];
        NSString *psd = [conifg objectForKey:[NSString stringWithFormat:@"st_wifi_%@",[HekrConfig getWifiName]]];
        if (psd) {
            cell.textField.text = psd;
        }
        _psdTextFiled = cell.textField;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toConnectWifi"]) {
        connectWifiVC *vc = segue.destinationViewController;
        vc.apSsid = [HekrConfig getWifiName];
        vc.apPwd = _psdTextFiled.text;
        vc.isFromeSeeting = _isFromeSeeting;
    }
}





@end

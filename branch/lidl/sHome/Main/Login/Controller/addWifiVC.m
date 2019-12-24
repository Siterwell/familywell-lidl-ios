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
#import "NetworkUnit.h"
#import "NSString+CY.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "AutoScrollLabel.h"
@interface addWifiVC ()
@property (strong, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIButton *remberPsdButton;
@property (weak, nonatomic) UITextField *psdTextFiled;
@property (weak, nonatomic) UITextField *ssidTextFiled;
@end

@implementation addWifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.connectBtn.layer.cornerRadius = 17.5f;

    
    [_remberPsdButton setImage:[UIImage imageNamed:@"jzmm_noselect"] forState:UIControlStateNormal];
    [_remberPsdButton setImage:[UIImage imageNamed:@"jzmm_select"] forState:UIControlStateSelected];
//    [_remberPsdButton setTitle:NSLocalizedString(@"记住密码", nil) forState:UIControlStateNormal];
    
    _remberPsdButton.selected = YES;
    NSDictionary *attrs1 = @{NSFontAttributeName : SYSTEMFONT(15)};
    CGSize size1=[NSLocalizedString(@"该设备只支持2.4GHz频率的路由器", nil) sizeWithAttributes:attrs1];
    
    UILabel *content1 = [[UILabel alloc] init];
    content1.textColor = [UIColor redColor];
    [self.view addSubview:content1];
    [content1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(size1.width>300?300:size1.width);
        make.height.equalTo(21);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(_remberPsdButton.mas_top).offset(-5);
    }];
    
    AutoScrollLabel * content11 = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(0, 0, size1.width>300?300:(size1.width+1), 21)];
    [content11 setTextAlign:TextAlignLeft];
    content11.font = SYSTEMFONT(15);
    content11.textColor = [UIColor redColor];
    [content1  addSubview:content11];
    [content11 setText:NSLocalizedString(@"该设备只支持2.4GHz频率的路由器", nil)];
    
    UIImageView *uiImageview = [[UIImageView alloc] init];
    [uiImageview setImage:[UIImage imageNamed:@"warn2.4"]];
    [self.view addSubview:uiImageview];
    [uiImageview makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content1.mas_left).offset(-5);
        make.centerY.equalTo(content1.mas_centerY);
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *ssid = [HekrConfig getWifiName];
    if (ssid == nil || [ssid isEqualToString:@""] || [ssid isEqualToString:@"WLAN"]) {
        [self editWIFiName];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)remberAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)actionNext:(id)sender {
//    if ([[HekrConfig getWifiName] containsString:@" "]) {
//        [MBProgressHUD showError:NSLocalizedString(@"WIFI名不能含有空格",nil) ToView:self.view];
//        return;
//    }
    if (_ssidTextFiled.text == nil || [_ssidTextFiled.text isEqualToString:@""] || [_ssidTextFiled.text isEqualToString:@"WLAN"]) {
        [MBProgressHUD showError:NSLocalizedString(@"没有WIFI",nil) ToView:self.view];
        return;
    }
    if (_remberPsdButton.selected == YES) {
        NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
        [config setObject:self.psdTextFiled.text forKey:[NSString stringWithFormat:@"st_wifi_%@",self.ssidTextFiled.text]];
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
        _ssidTextFiled = cell.textField;
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
        vc.apSsid = _ssidTextFiled.text;
        vc.apPwd = _psdTextFiled.text;
        vc.isFromeSeeting = _isFromeSeeting;
    }
}


-(void)editWIFiName{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"请编辑WIfI名称", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //alert.textFields.firstObject.text
        if([NSString isBlankString:alert.textFields.firstObject.text]){
            [MBProgressHUD showError:NSLocalizedString(@"请编辑WIfI名称", nil) ToView:GetWindow];
        }else{
            _ssidTextFiled.text = alert.textFields.firstObject.text;
        }
       
       
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end

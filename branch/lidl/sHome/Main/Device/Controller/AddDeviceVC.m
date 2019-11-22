//
//  AddDeviceVC.m
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "AddDeviceVC.h"
#import "YYLabel.h"
#import "AddDeviceApi.h"
#import "DeviceListModel.h"
#import "DeviceDataBase.h"
#import "AddDeviceCell.h"
#import "CancelAddingApi.h"
#import "Encryptools.h"
#import "ItemData.h"
#import "RenameDeviceApi.h"
#import "replaceDeviceApi.h"
#import "NSString+CY.h"
@interface AddDeviceVC ()<UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation AddDeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    if ([_type isEqualToString:@"add"]) {
        self.title = NSLocalizedString(@"添加设备",nil);
    }else{
        self.title = NSLocalizedString(@"替换设备",nil);
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss:) name:@"addDeviceSuccess" object:nil];

    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(btndismiss) Title:NSLocalizedString(@"取消&",nil) withTintColor:RGB(40, 184, 215)];
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if ([_type isEqualToString:@"add"]) {
        AddDeviceApi *api = [[AddDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey];
        @weakify(self);
        [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
            @strongify(self);
            NSNumber *msgId=data[@"msgId"];
            NSString *cmdid = [data[@"params"][@"data"][@"cmdId"] stringValue];
            int eqid =  [data[@"params"][@"data"][@"device_ID"] intValue];
            if([cmdid isEqualToString:@"119"]){
                eqid = [Encryptools getDescryption:eqid withMsgId:[msgId intValue]];
            }
            ItemData *item = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",eqid]];
            if (item && ([cmdid isEqualToString:@"19"]||[cmdid isEqualToString:@"119"] )) {
                [self show];
                
            }
        
        
        } failure:^(id data, NSError *error) {
            NSLog(@"%@",error);
        }];
    }else{
        if(![NSString isBlankString:_devID]){
            replaceDeviceApi *api2 = [[replaceDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey mDeviceID:_devID];
            @weakify(self);
            [api2 startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                @strongify(self);
                NSNumber *msgId=data[@"msgId"];
                NSString *cmdid = [data[@"params"][@"data"][@"cmdId"] stringValue];
                int eqid =  [data[@"params"][@"data"][@"device_ID"] intValue];
                if([cmdid isEqualToString:@"119"]){
                    eqid = [Encryptools getDescryption:eqid withMsgId:[msgId intValue]];
                }
                ItemData *item = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",eqid]];
                if (item  && [[NSString stringWithFormat:@"%d",eqid] isEqualToString:_devID] && ([cmdid isEqualToString:@"19"]||[cmdid isEqualToString:@"119"] )) {
                    [self show];
                }
                
        
            } failure:^(id data, NSError *error) {
                NSLog(@"%@",error);
            }];
        }

    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addDeviceSuccess" object:nil];
}

-(void)dismiss:(NSNotification *)noti {
    if ([_type isEqualToString:@"add"]) {
        [[DeviceDataBase sharedDataBase] deletDevice:[_type intValue]];
        NSString *name = noti.userInfo[@"device_name"];
        NSString *device_ID = noti.userInfo[@"device_ID"];
        //        NSString *custom = noti.userInfo[@"device_custom_name"];
        
        ItemData *item = [[DeviceDataBase sharedDataBase] selectDevice:device_ID];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:NSLocalizedString(@"请设置%@%@名称", nil), NSLocalizedString(item.title, nil),item.devID] preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            alert.textFields.firstObject.text
            NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
            DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            RenameDeviceApi *api = [[RenameDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[item.devID intValue] DeviceName:alert.textFields.firstObject.text];
            @weakify(self);
            [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
                @strongify(self);
                [[DeviceDataBase sharedDataBase] addDeviceName:alert.textFields.firstObject.text ID:[item.devID intValue]];
                
            } failure:^(id data, NSError *error) {
            }];
            
            [MBProgressHUD showSuccess:NSLocalizedString(@"添加成功",nil) ToView:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

-(void)btndismiss{
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    CancelAddingApi *api = [[CancelAddingApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey];
    [api startWithObject:nil CompletionBlockWithSuccess:^(id data, NSError *error) {
    } failure:^(id data, NSError *error) {
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)show{
    NSString *title = nil;
    if ([_type isEqualToString:@"add"]){
        title = NSLocalizedString(@"设备已添加", nil);
    }else{
        title = NSLocalizedString(@"替换设备成功", nil);
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = NSLocalizedString(@"请将需要添加的设备按钮快速连按3次", nil);
        return cell;
    }else if(indexPath.row == 1){
        AddDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDeviceCell" forIndexPath:indexPath];
        cell.mainImageView.image = [UIImage imageNamed:NSLocalizedString(@"adddevice_zh", nil)];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = NSLocalizedString(@"注意！网关绿灯闪烁时,长按网关按钮3秒以上将删除全部设备", nil);
        return cell;
    }
    
}




@end

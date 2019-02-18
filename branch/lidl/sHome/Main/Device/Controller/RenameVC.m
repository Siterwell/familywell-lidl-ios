//
//  RenameVC.m
//  sHome
//
//  Created by shap on 2017/2/23.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "RenameVC.h"
#import "RenameCell.h"
#import "UINavigationBar+Awesome.h"
#import "RenameDeviceApi.h"
#import "DeviceListModel.h"
#import "DeviceDataBase.h"

@interface RenameVC ()
@property (nonatomic ,strong) UITextField *textField;
@end

@implementation RenameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"重命名", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
}

- (void)rightItem{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    RenameDeviceApi *api = [[RenameDeviceApi alloc] initWithDevTid:model.devTid CtrlKey:model.ctrlKey DeviceId:[_deviceId intValue] DeviceName:_textField.text];
    @weakify(self);
    [api startWithObject:self CompletionBlockWithSuccess:^(id data, NSError *error) {
        @strongify(self);
        NSLog(@"[RYAN] RenameVC > success");
        [[DeviceDataBase sharedDataBase] addDeviceName:self.textField.text ID:[self.deviceId intValue]];
        [self dismiss];
    } failure:^(id data, NSError *error) {
        NSLog(@"[RYAN] RenameVC > failure");
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)dismiss{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
     RenameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"renameCell" forIndexPath:indexPath];
    _textField = cell.RenameTextField;
    _textField.placeholder = NSLocalizedString(@"请输入新的命名", nil) ;
    @weakify(self)
    [[_textField.rac_textSignal filter:^BOOL(id value) {
        @strongify(self);
        NSString *text = value;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        return text.length > 0;
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end

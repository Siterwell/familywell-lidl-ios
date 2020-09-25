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
    
    NSInteger count = [self textLength:self.textField.text];
    if(count>15){
        [MBProgressHUD showError:NSLocalizedString(@"设备名称过长",nil) ToView:self.view];
        return;
    }
    
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
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    if (@available(iOS 13.0, *)) {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
     } else {
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     }
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


#pragma mark -method
-(NSUInteger)textLength: (NSString *)text{

        NSUInteger asciiLength =0;



        for (NSUInteger i =0; i < text.length; i++) {

        unichar uc = [text characterAtIndex: i];

        // 判断是否是ascii编码

        asciiLength += isascii(uc) ?1 : 2;

        }
        NSUInteger unicodeLength = asciiLength;
         return unicodeLength;

}

@end

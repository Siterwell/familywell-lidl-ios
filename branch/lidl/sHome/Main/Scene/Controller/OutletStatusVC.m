//
//  OutletStatusVC.m
//  sHome
//
//  Created by shaop on 2017/2/9.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "OutletStatusVC.h"
#import "OutletStatusCell.h"

@interface OutletStatusVC ()

@end

@implementation OutletStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"插座", nil);
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
    
}

- (void)clickItem{
    if (self.delegate) {
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
//        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:2 inSection:0];

        OutletStatusCell *Cell1 = [self.tableView cellForRowAtIndexPath:indexPath1];
        OutletStatusCell *Cell2 = [self.tableView cellForRowAtIndexPath:indexPath2];
//        OutletStatusCell *Cell3 = [self.tableView cellForRowAtIndexPath:indexPath3];
        
        NSString *o = @"01";
        NSString *oo = @"01";
        NSString *ooo = @"FF";
        if (!Cell1.switchBtn.isOn) {
            o = @"00";
        }
        if (!Cell2.switchBtn.isOn) {

            oo = @"00";
        }
//        if (!Cell3.switchBtn.isOn) {
//            ooo = @"00";
//        }
        
        [self.delegate sendNext:[NSString stringWithFormat:@"01%@%@00",oo,ooo]];
//        [self.navigationController popViewControllerAnimated:YES];
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutletStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutletStatusCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.statusLabel.text = NSLocalizedString(@"开关", nil);
    }else if (indexPath.row == 1){
        cell.statusLabel.text = NSLocalizedString(@"使能", nil);
    }
//    else{
//        cell.statusLabel.text = @"使能";
//    }
    
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

//
//  ChooseSwitchVC.m
//  sHome
//
//  Created by shaop on 2016/12/19.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "ChooseSwitchVC.h"
#import "SwitchActionCell.h"
#import "DeviceDataBase.h"
#import "SwitchKeyVC.h"
#import "SwitchModel.h"

@interface ChooseSwitchVC ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *switchArray;
@property (strong, nonatomic) NSMutableArray *selectArray;
@end

@implementation ChooseSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"选择按钮设备", nil);
    _selectArray = [[NSMutableArray alloc] init];
    _switchArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *deviceArray = [[DeviceDataBase sharedDataBase] selectDevice];
    for (ItemData *data in deviceArray) {
        if (data.title.length == 4) {
            if ([[data.title substringWithRange:NSMakeRange(1, 3)] isEqualToString:@"扭按键"]) {
                [_switchArray addObject:data];
            }
        }
    }
//    ItemData *data = [[ItemData alloc] initWithTitle:@"3钮按键" Status:@"046455FF" DevID:@"11" Images:@"%@_btn_icon" Code:nil];
//    [_switchArray addObject:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SwitchCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = RGB(224, 224, 244).CGColor;
    cell.layer.borderWidth = 0.4f;
    
    NSString *image = [NSString stringWithFormat:@"kg0%ld_icon",indexPath.row + 1];
    cell.cellLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld钮按键", nil),indexPath.row + 1];
    cell.cellButton.enabled = NO;
    
    for (ItemData *data in _switchArray) {
        if ([data.title isEqualToString:cell.cellLabel.text]) {
            image = [NSString stringWithFormat:@"kg0%ld_hover_icon",indexPath.row + 1];
            cell.cellLabel.textColor = [UIColor darkGrayColor];
            cell.cellButton.enabled = YES;
        }
    }
    [cell.cellButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    cell.cellButton.tag = indexPath.row;
    [cell.cellButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){Main_Screen_Width/3,Main_Screen_Width/3};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    SwitchActionCell *cell = (SwitchActionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell.cellButton.enabled) {
        [self performSegueWithIdentifier:@"toKey" sender:indexPath];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = sender;
    
    SwitchKeyVC *vc = segue.destinationViewController;
    
    SwitchActionCell *cell = (SwitchActionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

    for (ItemData *data in _switchArray) {
        if ([data.title isEqualToString:cell.cellLabel.text]) {
            vc.switchStatus = data.status;
            vc.switchId = data.devID;
        }
    }
    vc.keyNumber = indexPath.row + 1;
    vc.delegate = [RACSubject subject];
    @weakify(self)
    [vc.delegate subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
        
        NSString *content = x;
        content = [content stringByAppendingString:@"00"];
        NSLog(@"%@",content);
        
        [self.delegate sendNext:content];
        [self.navigationController popViewControllerAnimated:YES];

        SwitchModel *model = [[SwitchModel alloc] init];
        model.switch_content = content;
        model.index = indexPath.row;
        //保存选择
        [self.selectArray addObject:model];
    }];
}

- (void)clickButton:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    [self performSegueWithIdentifier:@"toKey" sender:indexPath];
}


@end

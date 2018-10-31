//
//  ExecuteVC.m
//  sHome
//
//  Created by shaop on 2017/1/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "executeSceneItemVC.h"
#import "SceneListItemData.h"
#import "ItemData.h"
#import "ItemDataHelp.h"
#import "DeviceDataBase.h"
#import "slectSceneItemCell.h"
#import "DelayTimeVC.h"
#import "NoramlStatusVC.h"
#import "OutletStatusVC.h"

#import "DoubleSwitchStatusVC.h"
#import "LightStatusVC.h"
#import "TempControlSetVC.h"

@interface executeSceneItemVC ()
@property (nonatomic , strong) NSMutableArray *itemDatas;
@end

@implementation executeSceneItemVC

static NSString * const reuseIdentifier = @"slectSceneItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemDatas = [[NSMutableArray alloc] init];
    SceneListItemData *item1 = [[SceneListItemData alloc] init];
    item1.title = @"手机通知";
    item1.image = @"blue_phone_icon";
    [_itemDatas addObject:item1];
    
    SceneListItemData *item2 = [[SceneListItemData alloc] init];
    item2.title = @"延迟";
    item2.image = @"blue_ys_icon";
    item2.deviceId = @"-1";
    [_itemDatas addObject:item2];
    
    SceneListItemData *item3 = [[SceneListItemData alloc] init];
    item3.title = @"网关灯";
    item3.deviceId = @"0";
    item3.image = @"blue_wgjd_icon";
    [_itemDatas addObject:item3];
    
    NSMutableArray *deviceArray = [[DeviceDataBase sharedDataBase] selectDevice];
    for (ItemData *model in deviceArray) {
        //***********************在此设置支持的设备*************************
//        if ([model.title isEqualToString:@"智能插座"]) {
//            SceneListItemData *item = [ItemDataHelp ItemDataToSceneListItemData:model];
//            [_itemDatas addObject:item];
//        }
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableShowDevice" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSArray *array = dic[@"inDevice"];
        for (NSString *name in array) {
            if ([model.title isEqualToString:name]) {
                SceneListItemData *item = [ItemDataHelp ItemDataToSceneListItemData:model];
                [_itemDatas addObject:item];
            }
        }
    }
    
    
    //去除选择手机通知的情况
    for (int i = 0; i<_selectsItems.count; i++) {
        SceneListItemData *selectitem = _selectsItems[i];
        if ([selectitem.image isEqualToString:@"blue_phone_icon"]) {
            [_itemDatas removeObjectAtIndex:0];
            break;
        }
    }
    
    //去掉上一个选择的
    for (int j = 0; j<_itemDatas.count; j++) {
        SceneListItemData *item = _itemDatas[j];
        if (![item.image isEqualToString:@"blue_phone_icon"]) {
            if (_selectsItems.count > 0 ) {
                SceneListItemData *select = _selectsItems[_selectsItems.count-1];
                if ([item.image isEqualToString:select.image] && [item.deviceId isEqualToString:select.deviceId]) {
                    [_itemDatas removeObjectAtIndex:j];
                    break;
                }
            }
            
        }
    }

    
//    for (int i = 0; i<_selectsItems.count; i++) {
//
//        for (int j = 0; j<_itemDatas.count; j++) {
//            SceneListItemData *item = _itemDatas[j];
//            
//            if ([selectitem.image isEqualToString:@"blue_ys_icon"]) {
//                break;
//            }
//            if ([item.title isEqualToString:selectitem.title]) {
//                [_itemDatas removeObject:item];
//                break;
//            }
//        }
//    }
    
    self.title = NSLocalizedString(@"添加执行动作", nil);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemDatas.count;
}

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    slectSceneItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    SceneListItemData *item = _itemDatas[indexPath.row];
    if(item.custmTitle == nil){
        cell.titleLabel.text = NSLocalizedString(item.title, nil);
    }else{
        cell.titleLabel.text = item.custmTitle;
    }
    cell.imageView.image = [UIImage imageNamed:item.image];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SceneListItemData *item = _itemDatas[indexPath.row];

    if ([item.title isEqualToString:@"延迟"]) {
        [self performSegueWithIdentifier:@"toDelayTime" sender:indexPath];
    }
    else if([item.title isEqualToString:@"手机通知"]){
        if (self.delegate) {
            [self.delegate sendNext:item];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([item.title isEqualToString:@"双路开关"]) {
        DoubleSwitchStatusVC *vc = [[DoubleSwitchStatusVC alloc] init];
        SceneListItemData *item = _itemDatas[indexPath.row];
        vc.title = item.custmTitle;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.action = x;
            [self.delegate sendNext:item];
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([item.title isEqualToString:@"调光模块"]) {
        LightStatusVC *vc = [[LightStatusVC alloc] init];
        SceneListItemData *item = _itemDatas[indexPath.row];
        vc.title = item.custmTitle;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.action = x;
            [self.delegate sendNext:item];
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([item.title isEqualToString:@"温控器"]) {
        TempControlSetVC *vc = [[TempControlSetVC alloc] init];
        SceneListItemData *item = _itemDatas[indexPath.row];
        vc.title = item.custmTitle;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.action = x;
            [self.delegate sendNext:item];
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableClickDevice" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        
        NSArray *array = dic[@"inDevice"];
        for (NSString *name in array) {
            if ([item.title isEqualToString:name]) {
                [self performSegueWithIdentifier:@"toNormalStatus" sender:indexPath];
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSIndexPath *indexPath = sender;

    if ([segue.identifier isEqualToString:@"toDelayTime"]) {

        DelayTimeVC *vc = segue.destinationViewController;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            TimeModel *model = x;
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.minute = model.Minute;
            item.second = model.Seconde;
            item.title = [NSString stringWithFormat:@"%@:%@",item.minute,item.second];
            [self.delegate sendNext:item];
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
    }else if ([segue.identifier isEqualToString:@"toNormalStatus"]){
        
        NoramlStatusVC *vc = segue.destinationViewController;
        SceneListItemData *item = self.itemDatas[indexPath.row];
        vc.deviceName = item.title;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.action = x;
            [self.delegate sendNext:item];
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
    }else if ([segue.identifier isEqualToString:@"toOutletStatus"]){
        
        OutletStatusVC *vc = segue.destinationViewController;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.action = x;
            [self.delegate sendNext:item];
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
    }
}


@end

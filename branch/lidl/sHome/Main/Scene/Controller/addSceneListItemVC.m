//
//  addSceneListItemVC.m
//  sHome
//
//  Created by shaop on 2017/1/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "addSceneListItemVC.h"
#import "slectSceneItemCell.h"
#import "DeviceDataBase.h"
#import "ItemData.h"
#import "ItemDataHelp.h"
#import "SceneListItemData.h"
#import "SetTimeVC.h"
#import "NoramlStatusVC.h"

#import "HumitureStatusVC.h"

@interface addSceneListItemVC ()
@property (nonatomic , strong) NSMutableArray *itemDatas;
@end

@implementation addSceneListItemVC

static NSString * const reuseIdentifier = @"slectSceneItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _itemDatas = [[NSMutableArray alloc] init];
    SceneListItemData *item1 = [[SceneListItemData alloc] init];
    item1.title = @"定时";
    item1.image = @"blue_clock_icon";
    [_itemDatas addObject:item1];
    
    SceneListItemData *item2 = [[SceneListItemData alloc] init];
    item2.title = @"点击执行";
    item2.image = @"blue_hand_icon";
    [_itemDatas addObject:item2];
    
    
    NSMutableArray *deviceArray = [[DeviceDataBase sharedDataBase] selectDevice];
    for (ItemData *model in deviceArray) {
        
        //***********************在此设置支持的设备*************************
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableShowDevice" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        NSArray *array = dic[@"outDevice"];
        for (NSString *name in array) {
            
            if ([model.title isEqualToString:name]) {
                SceneListItemData *item = [ItemDataHelp ItemDataToSceneListItemData:model];
                [_itemDatas addObject:item];
                break;
            }
        }
    }
    
    //去除已经选择的
    for (int i = 0; i<_selectItems.count; i++) {
        SceneListItemData *selectitem = _selectItems[i];
        for (int j = 0; j<_itemDatas.count; j++) {
            SceneListItemData *item = _itemDatas[j];
            if ([selectitem.title containsString:@":"]) {
                    [_itemDatas removeObject:item];
                    break;
                }
            
            if ([item.title isEqualToString:selectitem.title]) {
                [_itemDatas removeObject:item];
                break;
            }
        }
    }
    
    self.title = NSLocalizedString(@"添加启动条件", nil);
    
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
    
    if ([item.title isEqualToString:@"定时"]) {
        [self performSegueWithIdentifier:@"toSetTime" sender:indexPath];
    }

    else if([item.title isEqualToString:@"点击执行"]){
        if (self.delegate) {
            [self.delegate sendNext:self.itemDatas[indexPath.row]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([item.title isEqualToString:@"气体探测器"]){
        item.action = @"00005500";
        if (self.delegate) {
            [self.delegate sendNext:item];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    else if ([item.title isEqualToString:@"按键"]) {
        item.action = @"ffff01ff";
        if (self.delegate) {
            [self.delegate sendNext:item];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    else if ([item.title isEqualToString:@"温湿度探测器"]) {
        HumitureStatusVC *vc = [[HumitureStatusVC alloc] init];
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
    else {
        
        NSString *namePath = [[NSBundle mainBundle] pathForResource:@"enableClickDevice" ofType:@"plist"];
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
        
        NSArray *array = dic[@"outDevice"];
        for (NSString *name in array) {
            if ([item.title isEqualToString:name]) {
                [self performSegueWithIdentifier:@"toNormalStatus" sender:indexPath];
                return;
            }
        }

        if (item.title.length > 3) {
            if ([[item.title substringWithRange:NSMakeRange(item.title.length-3, 3)] isEqualToString:@"报警器"]) {
                item.action = @"00005500";
                if (self.delegate) {
                    [self.delegate sendNext:item];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
            }
            else {
                [MBProgressHUD showError:@"设备暂不支持" ToView:self.view];
            }
        }
        else {
            [MBProgressHUD showError:@"设备暂不支持" ToView:self.view];
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = sender;

    if ([segue.identifier isEqualToString:@"toSetTime"]) {
        
        SetTimeVC *vc = segue.destinationViewController;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            TimeModel *model = x;
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.week = model.week;
            item.hour = model.Hour;
            item.minute = model.Minute;
            item.title = [NSString stringWithFormat:@"%@:%@",item.hour,item.minute];
            [self.delegate sendNext:item];
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
    }else if ([segue.identifier isEqualToString:@"toNormalStatus"]){
        NoramlStatusVC *vc = segue.destinationViewController;
        SceneListItemData *item = _itemDatas[indexPath.row];
        vc.deviceName = item.title;
        vc.delegate = [RACSubject subject];
        @weakify(self);
        [vc.delegate subscribeNext:^(id x) {
            @strongify(self);
            SceneListItemData *item = self.itemDatas[indexPath.row];
            item.action = x;
            [self.delegate sendNext:item];
            if ([item.title containsString:@"网关"]) {
                
            }
            UIViewController *viewCtl = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }];
    }
}

@end

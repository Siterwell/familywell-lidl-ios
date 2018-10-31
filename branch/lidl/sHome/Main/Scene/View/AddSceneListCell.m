//
//  AddSceneListCell.m
//  sHome
//
//  Created by shaop on 2016/12/20.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "AddSceneListCell.h"
#import "addSceneListItemCell.h"
#import "SceneListItemData.h"

@implementation AddSceneListCell
{
    NSArray *_array;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _subCollectionView.scrollEnabled = NO;
    }
    return self;
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemDatas.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    addSceneListItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addSceneListItem" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    cell.deleteButton.hidden = YES;
    
//    [cell.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//    cell.deleteButton.tag = indexPath.row;
    cell.tag = indexPath.row;
    if (indexPath.row < _itemDatas.count) {
        
        UILongPressGestureRecognizer *lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readyToDeleteItem:)];
        lpGes.minimumPressDuration = 0.8f;
        [cell addGestureRecognizer:lpGes];
        
        SceneListItemData *data = _itemDatas[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:data.image];
        
        if(data.custmTitle == nil){
            cell.titleLabel.text = NSLocalizedString(data.title, nil);
        }else{
            cell.titleLabel.text = data.custmTitle;
        }
    }else{
        NSArray<UIGestureRecognizer *> *gesArray = cell.gestureRecognizers;
        for (int i = 0; i < gesArray.count; i++) {
            [cell removeGestureRecognizer:gesArray[i]];
        }
        cell.imageView.image = [UIImage imageNamed:@"add_icon"];
        cell.titleLabel.text = NSLocalizedString(@"添加", nil);
    }
    return cell;
}

- (void)readyToDeleteItem:(UILongPressGestureRecognizer *)ges {

    AddSceneListCell *cell = (AddSceneListCell *)[ges view];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确定删除", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_delegate) {
            NSString *tag = [NSString stringWithFormat:@"%ld",(long)cell.tag];
            [_delegate sendNext:tag];
        }
    }]];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){Main_Screen_Width/3,Main_Screen_Width/4+10};
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
    
    if (indexPath.row == _itemDatas.count) {
        if (_cellType == AddSceneCellTypeOutPut) {
            [self.toListItemdelegate sendNext:_itemDatas];
        }else{
            [self.toExecutedelegate sendNext:_itemDatas];
        }
    }else{
        if (_cellType == AddSceneCellTypeOutPut) {
            [self.outClickItemdelegate sendNext:_itemDatas[indexPath.row]];
        }else{
            [self.inClickItemdelegate sendNext:indexPath];
        }
    }
    
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

//- (void)deleteAction:(UIButton *)sender{
//
//    if (_delegate) {
//        NSString *tag = [NSString stringWithFormat:@"%ld",(long)sender.tag];
//        [_delegate sendNext:tag];
//    }
//
//}

@end

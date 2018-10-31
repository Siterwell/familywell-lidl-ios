//
//  SwitchKeyVC.m
//  sHome
//
//  Created by shaop on 2017/2/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SwitchKeyVC.h"
#import "SwitchActionCell.h"
#import "BatterHelp.h"

@interface SwitchKeyVC ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) SwitchActionCell *lastCell;
@end

@implementation SwitchKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"选择按钮", nil);
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
    
}

-(void)clickItem{
    NSString *buttonCotent = @"00000000";
    for (int i = 0 ; i < _keyNumber; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        SwitchActionCell *cell = (SwitchActionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (!cell.selectImagView.isHidden) {
            int k = 8 - i - 1;
            NSMutableString *a = [[NSMutableString  alloc] initWithString:buttonCotent];
            [a replaceCharactersInRange:NSMakeRange(k, 1) withString:@"1"];
            buttonCotent = a;
        }
    }
    buttonCotent = [BatterHelp getDecimalBybinary:buttonCotent];
    if (buttonCotent.length == 1) {
        buttonCotent = [@"0" stringByAppendingString:buttonCotent];
    }
    NSMutableString *a = [[NSMutableString  alloc] initWithString:_switchStatus];
    [a replaceCharactersInRange:NSMakeRange(4, 2) withString:buttonCotent];
    buttonCotent = a;
    
    if (_switchId.length == 1) {
        _switchId = [@"000" stringByAppendingString:_switchId];
    }else if(_switchId.length == 2){
        _switchId = [@"00" stringByAppendingString:_switchId];
    }else if (_switchId.length == 3){
        _switchId = [@"0" stringByAppendingString:_switchId];
    }
    
    [self.delegate sendNext:[_switchId stringByAppendingString:buttonCotent]];
    
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
    return self.keyNumber;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SwitchCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = RGB(224, 224, 244).CGColor;
    cell.layer.borderWidth = 0.4f;
    cell.cellLabel.text = [NSString stringWithFormat:NSLocalizedString(@"按钮%ld", nil),indexPath.row + 1];
    cell.cellButton.tag = indexPath.row;
    cell.selectImagView.hidden = YES;
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
    if (_lastCell) {
        _lastCell.selectImagView.hidden = !_lastCell.selectImagView.hidden;
    }
    SwitchActionCell *cell = (SwitchActionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectImagView.hidden = !cell.selectImagView.hidden;
    _lastCell = cell;
}

- (void)clickButton:(UIButton *)sender{
    if (_lastCell) {
        _lastCell.selectImagView.hidden = !_lastCell.selectImagView.hidden;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    SwitchActionCell *cell = (SwitchActionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selectImagView.hidden = !cell.selectImagView.hidden;
    _lastCell = cell;

}


@end

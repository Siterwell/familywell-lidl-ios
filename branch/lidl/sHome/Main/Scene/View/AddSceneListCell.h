//
//  AddSceneListCell.h
//  sHome
//
//  Created by shaop on 2016/12/20.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, AddSceneCellType) {
    AddSceneCellTypeOutPut = 1,
    AddSceneCellTypeInPut  = 2
};
@interface AddSceneListCell : UITableViewCell<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *subCollectionView;

@property (assign, nonatomic) AddSceneCellType cellType;

@property (strong, nonatomic) NSMutableArray *itemDatas;

@property (strong, nonatomic) RACSubject *delegate;

@property (strong, nonatomic) RACSubject *toExecutedelegate;

@property (strong, nonatomic) RACSubject *toListItemdelegate;

@property (strong, nonatomic) RACSubject *outClickItemdelegate;

@property (strong, nonatomic) RACSubject *inClickItemdelegate;

@property (assign, nonatomic) BOOL isShowDelet;

@end

//
//  addSceneListItemVC.h
//  sHome
//
//  Created by shaop on 2017/1/22.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addSceneListItemVC : UICollectionViewController
@property (nonatomic , strong) RACSubject *delegate;
@property (nonatomic , strong) NSMutableArray *selectItems;
@end

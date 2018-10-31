//
//  ExecuteVC.h
//  sHome
//
//  Created by shaop on 2017/1/24.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface executeSceneItemVC : UICollectionViewController
@property (nonatomic , strong) RACSubject *delegate;
@property (nonatomic , strong) NSMutableArray *selectsItems;
@end

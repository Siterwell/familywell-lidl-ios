//
//  addSceneListVC.h
//  sHome
//
//  Created by shaop on 2016/12/20.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseTableVC.h"

@interface addSceneListVC : BaseTableVC
@property (nonatomic , copy) NSString *sceneId;
@property (nonatomic , copy) NSString *sceneTitle;
@property (nonatomic , strong) NSMutableArray *outItemDatas;
@property (nonatomic , strong) NSMutableArray *inItemDatas;
@property (nonatomic , assign) NSInteger selectType;

@property (nonatomic , weak) RACSubject *delegate;

@property (nonatomic) NSString *scene_content;

@end

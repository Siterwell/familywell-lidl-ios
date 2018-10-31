//
//  AddSceneVC.h
//  sHome
//
//  Created by shaop on 2016/12/18.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseVC.h"
#import "SystemSceneModel.h"

@interface AddSceneVC : BaseVC
@property (nonatomic , strong) NSMutableArray *selectArray;
@property (nonatomic , strong) NSString *systemSceneId;
@property (nonatomic , strong) RACSubject *delegate;
@property (nonatomic , strong) NSString *sceneTitle;
@property (strong, nonatomic)  NSString *color;
@property (nonatomic) NSString *answer_content;

@property (nonatomic) SystemSceneModel *systemModel;

@end

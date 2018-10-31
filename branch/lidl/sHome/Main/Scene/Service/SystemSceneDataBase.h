//
//  SystemSceneDataBase.h
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemSceneModel.h"

@interface SystemSceneDataBase : NSObject

+ (instancetype)sharedDataBase;

- (NSMutableArray *)selectScene;

- (void)updateScene:(SystemSceneModel *)model;

- (void)deletAllSystemScene;

- (BOOL)deletSystemScene:(NSString *)scene_group;

- (NSMutableArray *)selectScene:(NSString *)sceneid;

- (void)deleteSelectScene:(NSString *)sceneid;
@end

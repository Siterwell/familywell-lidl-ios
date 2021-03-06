//
//  SceneDataBase.h
//  sHome
//
//  Created by shaop on 2017/2/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SceneModel.h"

@interface SceneDataBase : NSObject

+ (instancetype)sharedDataBase;

- (void)updateScene:(SceneModel *)model;

- (SceneModel *)selectScene:(NSString *)sceneId;

- (SceneModel *)selectSceneByName:(NSString *)sceneName;

- (NSMutableArray *)selectScene;

- (NSMutableArray *)selectSceneWithAll361;

- (NSMutableArray *)selectScenewithoutDefault;

- (NSMutableArray *)selectScenewithoutDefaultwithoutGs361;

- (NSMutableArray *)selectScenewithGS361:(NSString *)eqid;

- (NSMutableArray *)selectScenewithDefault;

- (NSMutableArray *)selectSceneWithArray:(NSArray *)systemArray;

- (void)deletAllScene;

- (void)deletScene:(NSString *)sceneId;

@end

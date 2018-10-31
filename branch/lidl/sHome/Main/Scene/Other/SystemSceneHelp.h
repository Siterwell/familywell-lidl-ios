//
//  SystemSceneHelp.h
//  sHome
//
//  Created by shaop on 2017/2/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSceneHelp : NSObject

+ (NSString *)getSceneContent:(NSString *)name SceneId:(NSString *)sceneid ButtonCotent:(NSString *)buttoncontent sceneArray:(NSMutableArray *)selectArray color:(NSString *)color andButtonsDetail:(NSString *)buttonsDetail;

+ (NSString *)getSceneContent:(NSString *)name SceneId:(NSString *)sceneid ButtonCotent:(NSString *)buttoncontent sceneArray:(NSMutableArray *)selectArray color:(NSString *)color andButtonsDetail:(NSString *)buttonsDetail withoutScene_group:(NSString *)scene_group;

+ (BOOL)isAddSceneId:(NSString *)sceneId;

@end

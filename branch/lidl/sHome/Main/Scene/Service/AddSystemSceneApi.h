//
//  AddSystemSceneApi.h
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"

@interface AddSystemSceneApi : BaseDriveApi

-(id)initWithDevTid:(NSString *)devTid CtrlKey:(NSString *)ctrlKey SceneContent:(NSString *)content;

@end

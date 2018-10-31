//
//  SceneModel.h
//  sHome
//
//  Created by shaop on 2017/2/6.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "JSONModel+DeviceDic.h"

@interface SceneModel : JSONModel

@property (nonatomic, strong) NSString *scene_content;

@property (nonatomic, strong) NSString *scene_type;

@property (nonatomic, strong) NSString<Ignore> *scene_name;

@property (nonatomic, strong) NSString<Ignore> *scene_CRC;

@property (nonatomic, strong) NSString<Ignore> *scene_id;

@property (nonatomic, strong) NSString<Ignore> *isShouldClick;

@property (nonatomic, strong) NSMutableArray<Ignore> *scene_outdevice_array;

@property (nonatomic, strong) NSMutableArray<Ignore> *scene_indevice_array;

@property (nonatomic, strong) NSString<Ignore> *scene_select_type;

- (void)creatModel;

@end

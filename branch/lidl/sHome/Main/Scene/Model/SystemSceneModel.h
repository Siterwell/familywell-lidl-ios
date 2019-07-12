//
//  SystemSceneModel.h
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "JSONModel+DeviceDic.h"

@interface SystemSceneModel : JSONModel

@property (nonatomic, strong) NSString *answer_content;

@property (nonatomic, strong) NSString *sence_group;

@property (nonatomic, strong) NSString<Ignore> *scene_color;

@property (nonatomic, strong) NSString<Ignore> *scene_name;

@property (nonatomic, strong) NSString<Ignore> *scene_CRC;

@property (nonatomic, strong) NSMutableArray<Ignore> *scene_switch_array;

@property (nonatomic, strong) NSMutableArray<Ignore> *scene_list_array;

/** 新增 */
@property (nonatomic) NSString<Ignore> *dev584_count;

@property (nonatomic) NSMutableArray<Ignore> *dev584_ids;

@property (nonatomic) NSString<Ignore> *dev584_detail;

@property (nonatomic) NSMutableArray<Ignore> *dev584_ids_scs;

- (NSString *)getCRCFromContent;
- (void)creatModel;

-(NSMutableArray *) getSelectArray;

@end

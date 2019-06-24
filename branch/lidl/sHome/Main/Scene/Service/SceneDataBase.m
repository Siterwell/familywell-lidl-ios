//
//  SceneDataBase.m
//  sHome
//
//  Created by shaop on 2017/2/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SceneDataBase.h"
#import "BatterHelp.h"
#import <FMDB/FMDB.h>
#import "SceneListItemData.h"
#import "NSString+CY.h"
static SceneDataBase *_DBCtl = nil;

@interface SceneDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end
@implementation SceneDataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[SceneDataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    return _DBCtl;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl = [super allocWithZone:zone];
    }
    
    return _DBCtl;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"device.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];
    
    // 初始化数据表
    
    NSString *sceneSql = @"CREATE TABLE 'scene' ('scene_ID' INTEGER PRIMARY KEY NOT NULL ,'scene_name' VARCHAR(255),'scene_content' VARCHAR(255))";
    
    [_db executeUpdate:sceneSql];
    
    [_db close];
    
}

#pragma mark - 操作数据
- (void)updateScene:(SceneModel *)model{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene "];
    while ([res next]) {
        
        if ([res intForColumn:@"scene_ID"] == [model.scene_id intValue]) {
            [_db executeUpdate:@"UPDATE 'scene' SET scene_name = ?  WHERE scene_ID = ? ",model.scene_name,[NSNumber numberWithInt:[model.scene_id intValue]]];
            [_db executeUpdate:@"UPDATE 'scene' SET scene_content = ?  WHERE scene_ID = ? ",model.scene_content,[NSNumber numberWithInt:[model.scene_id intValue]]];
            NSLog(@">>>>修改情景成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSceneListSuccess" object:nil];
            [_db close];
            return;
        }
    }
    [_db executeUpdate:@"INSERT INTO scene(scene_ID,scene_name,scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:[model.scene_id intValue]],model.scene_name,model.scene_content];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addSceneListSuccess" object:nil];
    NSLog(@">>>>添加情景成功");
    
    [_db close];
    
}

- (SceneModel *)selectScene:(NSString *)sceneId{
    [_db open];
    
    SceneModel *model = [[SceneModel alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID = ? ORDER BY scene_ID",sceneId];
    while ([res next]) {
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        [model creatModel];
        break;
    }
    
    [_db close];
    return model;
}

- (SceneModel *)selectSceneByName:(NSString *)sceneName{
    [_db open];
    
    SceneModel *model = [[SceneModel alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_name = ?",sceneName];
    while ([res next]) {
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        [model creatModel];
        break;
    }
    
    [_db close];
    return model;
}


- (NSMutableArray *)selectScene{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene ORDER BY scene_ID"];
    while ([res next]) {
        [idArray removeAllObjects];
        SceneModel *model = [[SceneModel alloc] init];
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        model.scene_id = [res stringForColumn:@"scene_ID"];
        [model creatModel];
        BOOL flag = NO;
        if(model.scene_indevice_array.count==1 && model.scene_outdevice_array.count){
            SceneListItemData *scene = [model.scene_indevice_array objectAtIndex:0];
            SceneListItemData *scene2 = [model.scene_outdevice_array objectAtIndex:0];
            if([scene.title isEqualToString:@"温控器"] &&![NSString isBlankString:scene2.week]){
                flag = YES;
            }
        }
        
        if(!flag){
            [array enumerateObjectsUsingBlock:^(SceneModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [idArray addObject:obj.scene_id];
            }];
            if (![idArray containsObject:model.scene_id]) {
                [array addObject:model];
            }
        }
        
        
    }
    
    [_db close];
    return array;
}

- (NSMutableArray *)selectSceneWithAll361{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene ORDER BY scene_ID"];
    while ([res next]) {
        [idArray removeAllObjects];
        SceneModel *model = [[SceneModel alloc] init];
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        model.scene_id = [res stringForColumn:@"scene_ID"];
        [model creatModel];
        
        if(model.scene_indevice_array.count==1 && model.scene_outdevice_array.count){
            SceneListItemData *scene = [model.scene_indevice_array objectAtIndex:0];
            SceneListItemData *scene2 = [model.scene_outdevice_array objectAtIndex:0];
            if([scene.title isEqualToString:@"温控器"] &&![NSString isBlankString:scene2.week]){
                [array enumerateObjectsUsingBlock:^(SceneModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [idArray addObject:obj.scene_id];
                }];
                if (![idArray containsObject:model.scene_id]) {
                    [array addObject:model];
                }
            }
        }
        
    }
    
    [_db close];
    return array;
}


- (NSMutableArray *)selectScenewithoutDefault{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID < 129 ORDER BY scene_ID"];
    while ([res next]) {
        [idArray removeAllObjects];
        SceneModel *model = [[SceneModel alloc] init];
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        model.scene_id = [res stringForColumn:@"scene_ID"];
        [model creatModel];
        [array enumerateObjectsUsingBlock:^(SceneModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [idArray addObject:obj.scene_id];
        }];
        if (![idArray containsObject:model.scene_id]) {
            [array addObject:model];
        }
        
    }
    
    [_db close];
    return array;
}

- (NSMutableArray *)selectScenewithoutDefaultwithoutGs361{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID < 129 ORDER BY scene_ID"];
    while ([res next]) {
        [idArray removeAllObjects];
        SceneModel *model = [[SceneModel alloc] init];
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        model.scene_id = [res stringForColumn:@"scene_ID"];
        [model creatModel];
        BOOL flag = NO;
        if(model.scene_indevice_array.count==1 && model.scene_outdevice_array.count){
            SceneListItemData *scene = [model.scene_indevice_array objectAtIndex:0];
            SceneListItemData *scene2 = [model.scene_outdevice_array objectAtIndex:0];
            if([scene.title isEqualToString:@"温控器"] &&![NSString isBlankString:scene2.week]){
                flag = YES;
            }
        }
        
        if(!flag){
            [array enumerateObjectsUsingBlock:^(SceneModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [idArray addObject:obj.scene_id];
            }];
            if (![idArray containsObject:model.scene_id]) {
                [array addObject:model];
            }
        }

    }
    
    [_db close];
    return array;
}

- (NSMutableArray *)selectScenewithGS361:(NSString *)eqid{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID < 129 ORDER BY scene_ID"];
    while ([res next]) {
        [idArray removeAllObjects];
        SceneModel *model = [[SceneModel alloc] init];
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        [model creatModel];
        
       
        if(model.scene_indevice_array.count==1 && model.scene_outdevice_array.count){
            SceneListItemData *scene = [model.scene_indevice_array objectAtIndex:0];
            SceneListItemData *scene2 = [model.scene_outdevice_array objectAtIndex:0];
            if([scene.title isEqualToString:@"温控器"] && [scene.deviceId isEqualToString:eqid]&& ![NSString isBlankString:scene2.week]){
                [array enumerateObjectsUsingBlock:^(SceneModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [idArray addObject:obj.scene_id];
                }];
                if (![idArray containsObject:model.scene_id]) {
                    [array addObject:model];
                }
            }
        }
        
    }
    
    [_db close];
    return array;
}

- (NSMutableArray *)selectScenewithDefault{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID > 128 ORDER BY scene_ID"];
    while ([res next]) {
        [idArray removeAllObjects];
        SceneModel *model = [[SceneModel alloc] init];
        model.scene_type = @"1";
        model.scene_content = [res stringForColumn:@"scene_content"];
        model.scene_id = [res stringForColumn:@"scene_ID"];
        [model creatModel];
        [array enumerateObjectsUsingBlock:^(SceneModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [idArray addObject:obj.scene_id];
        }];
        if (![idArray containsObject:model.scene_id]) {
            [array addObject:model];
        }
        
    }
    
    [_db close];
    return array;
}

- (NSMutableArray *)selectSceneWithArray:(NSArray *)systemArray{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    for (SceneModel *selectModel in systemArray) {
        [idArray removeAllObjects];
        FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID = ?",selectModel.scene_id];
        while ([res next]) {
            SceneModel *model = [[SceneModel alloc] init];
            model.scene_type = @"1";
            model.scene_content = [res stringForColumn:@"scene_content"];
            model.scene_id = [res stringForColumn:@"scene_ID"];
            [model creatModel];
            NSLog(@"\n\n\n\n\n\n\n\n\n 情景id添加：%@\n\n\n\n\n\n\n\n",model.scene_id);
            [array enumerateObjectsUsingBlock:^(SceneModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [idArray addObject:obj.scene_id];
            }];
            if (![idArray containsObject:model.scene_id]) {
                [array addObject:model];
            }
//            [array addObject:model];
        }
    }

    [_db close];
    return array;
}

- (void)deletScene:(NSString *)sceneId{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM scene WHERE scene_ID = ? ",[NSNumber numberWithInt:[sceneId intValue]]];
    
    [_db close];
}

- (void)deletAllScene{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM scene"];
    
    [_db close];
}

- (void)checkSystemScene{
    [_db open];
    
    /*初始化默认情景，129为默认pir触发，130位默认门磁触发，131为老人看护情景*/
    FMResultSet *res2 = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID>128"];
    int count2 = 0;
    while ([res2 next]) {
        count2 ++;
    }
    if (count2 == 0) {
        [_db executeUpdate:@"INSERT INTO scene(scene_ID,scene_name,scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:129],@"",@"0"];
        [_db executeUpdate:@"INSERT INTO scene(scene_ID,scene_name,scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:130],@"",@"0"];
        [_db executeUpdate:@"INSERT INTO scene(scene_ID,scene_name,scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:131],@"",@"0"];
    }

    [_db close];
    
}

@end

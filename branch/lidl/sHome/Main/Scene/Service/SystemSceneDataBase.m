//
//  SystemSceneDataBase.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SystemSceneDataBase.h"
#import <FMDB/FMDB.h>

static SystemSceneDataBase *_DBCtl = nil;

@interface SystemSceneDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end

@implementation SystemSceneDataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[SystemSceneDataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    [_DBCtl checkSystemScene];
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
    
    NSString *sceneSql = @"CREATE TABLE 'sys_scene' ('sys_scene_ID' INTEGER PRIMARY KEY NOT NULL ,'sys_scene_name' VARCHAR(255),'sys_scene_content' VARCHAR(255))";
    
    [_db executeUpdate:sceneSql];
    
    [_db close];
}

#pragma mark - 操作数据
- (void)updateScene:(SystemSceneModel *)model{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM sys_scene"];
    
    while ([res next]) {
        
        if ([res intForColumn:@"sys_scene_ID"] == [model.sence_group intValue]) {
            [_db executeUpdate:@"UPDATE 'sys_scene' SET sys_scene_name = ?  WHERE sys_scene_ID = ? ",model.scene_name,[NSNumber numberWithInt:[model.sence_group intValue]]];
            [_db executeUpdate:@"UPDATE 'sys_scene' SET sys_scene_content = ?  WHERE sys_scene_ID = ? ",model.answer_content,[NSNumber numberWithInt:[model.sence_group intValue]]];
            [_db close];
            NSLog(@">>>>修改情景组成功");
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSystemSceneListSuccess" object:nil];
            return;
        }
    }
    
    [_db executeUpdate:@"INSERT INTO sys_scene(sys_scene_ID,sys_scene_name,sys_scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:[model.sence_group intValue]],model.scene_name,model.answer_content];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addSystemSceneListSuccess" object:nil];
    NSLog(@">>>>添加情景组成功");
    
    [_db close];
    
}

- (NSMutableArray *)selectScene{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM sys_scene"];
    
    while ([res next]) {
        SystemSceneModel *model = [[SystemSceneModel alloc] init];
        model.answer_content = [res stringForColumn:@"sys_scene_content"];
        model.sence_group = [res stringForColumn:@"sys_scene_ID"];
        if ([model.sence_group isEqualToString:@"0"] ||[model.sence_group isEqualToString:@"1"]||[model.sence_group isEqualToString:@"2"]) {
            NSString *sceneid = model.sence_group;
            [model creatModel];
            model.sence_group = sceneid;
        }else{
            [model creatModel];
        }
        [array addObject:model];
    }
    
    [_db close];
    return array;
}

- (NSMutableArray *)selectScene:(NSString *)sceneid{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM sys_scene WHERE sys_scene_ID = ?",[NSNumber numberWithInt:[sceneid intValue]]];
    
    while ([res next]) {
        SystemSceneModel *model = [[SystemSceneModel alloc] init];
        model.answer_content = [res stringForColumn:@"sys_scene_content"];
        model.sence_group = [res stringForColumn:@"sys_scene_ID"];
        if ([model.sence_group isEqualToString:@"0"] ||[model.sence_group isEqualToString:@"1"]||[model.sence_group isEqualToString:@"2"]) {
            NSString *sceneid = model.sence_group;
            [model creatModel];
            model.sence_group = sceneid;
        }else{
            [model creatModel];
        }
        [array addObject:model];
    }
    
    [_db close];
    return array;
}


- (void)deletAllSystemScene{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM sys_scene"];
    
    [_db close];
}

- (BOOL)deletSystemScene:(NSString *)scene_group{
    [_db open];
    int x = [scene_group intValue];
    BOOL delete = [_db executeUpdate:@"DELETE FROM sys_scene WHERE sys_scene_ID = ?", [NSNumber numberWithInt:x]];
    [_db close];
    return delete;
}

- (void)deleteSelectScene:(NSString *)sceneid{
    [_db open];
    
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM sys_scene"];
    
    while ([res next]) {
        SystemSceneModel *model = [[SystemSceneModel alloc] init];
        model.answer_content = [res stringForColumn:@"sys_scene_content"];
        model.sence_group = [res stringForColumn:@"sys_scene_ID"];
        if (model.answer_content.length >= 42) {
            NSString *seneceids = [model.answer_content substringFromIndex:42];
            int length = (int)seneceids.length/2;
            for (int i = 0; i<length; i++) {
                NSString *mid = [seneceids substringWithRange:NSMakeRange(i*2, 2)];
                mid = [NSString stringWithFormat:@"%lu",strtoul([mid UTF8String],0,16)];
                if ([mid isEqualToString:sceneid]) {
                    seneceids = [seneceids stringByReplacingCharactersInRange:NSMakeRange(i*2, 2) withString:@""];
                    model.answer_content = [NSString stringWithFormat:@"%@%@",[model.answer_content substringWithRange:NSMakeRange(0, 42)],seneceids];
                    
                    [_db executeUpdate:@"UPDATE 'sys_scene' SET sys_scene_content = ?  WHERE sys_scene_ID = ? ",model.answer_content,[NSNumber numberWithInt:[model.sence_group intValue]]];
                    break;
                }
            }
        }
        
        
    }
    
    [_db close];
}

- (void)checkSystemScene{
    [_db open];

    FMResultSet *res = [_db executeQuery:@"SELECT * FROM sys_scene"];
    int count = 0;
    while ([res next]) {
        count ++;
    }
    if (count == 0) {
        [_db executeUpdate:@"INSERT INTO sys_scene(sys_scene_ID,sys_scene_name,sys_scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:0],@"",@"002600400000000000000000000000000000240000F0"];
        [_db executeUpdate:@"INSERT INTO sys_scene(sys_scene_ID,sys_scene_name,sys_scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:1],@"",@"002601400000000000000000000000000000240000F1"];
        [_db executeUpdate:@"INSERT INTO sys_scene(sys_scene_ID,sys_scene_name,sys_scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:2],@"",@"002602400000000000000000000000000000240000F2"];
    }
    /*初始化默认情景，129为默认pir触发，130位默认门磁触发，131为老人看护情景*/
    FMResultSet *res2 = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID>128"];
    int count2 = 0;
    while ([res2 next]) {
        count2 ++;
    }
    if (count2 == 0) {
        [_db executeUpdate:@"INSERT INTO scene(scene_ID,scene_name,scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:129],@"",@"0"];
        [_db executeUpdate:@"INSERT INTO scene(scene_ID,scene_name,scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:130],@"",@"0"];
//        [_db executeUpdate:@"INSERT INTO scene(scene_ID,scene_name,scene_content)VALUES(?,?,?)",[NSNumber numberWithInt:131],@"",@"0"];
    }
    
    [_db close];

}

@end

//
//  WarnDataBase.m
//  sHome
//
//  Created by shaop on 2017/3/10.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "WarnDataBase.h"
#import <FMDB/FMDB.h>

static WarnDataBase *_DBCtl = nil;

@interface WarnDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end
@implementation WarnDataBase
+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[WarnDataBase alloc] init];
        
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
    
    NSString *sceneSql = @"CREATE TABLE 'warn' ('warn_ID' INTEGER PRIMARY KEY NOT NULL ,'device_name' VARCHAR(255),'device_id' VARCHAR(255) ,'warn_time' Date , 'scene' VARCHAR(255))";
    
    [_db executeUpdate:sceneSql];
    
    [_db close];
    
}

#pragma mark - 操作数据
- (void)updateScene:(WarnModel *)model{
    [_db open];
    
    [_db executeUpdate:@"INSERT INTO warn (device_name,device_id,warn_time,scene)VALUES(?,?,?,?)",model.deviceName,[NSNumber numberWithInt:[model.deviceId intValue]],model.time,model.senceId];
    NSLog(@">>>>>添加成功");
    [_db close];
    
}

//- (SceneModel *)selectScene:(NSString *)sceneId{
//    [_db open];
//    
//    SceneModel *model = [[SceneModel alloc] init];
//    
//    FMResultSet *res = [_db executeQuery:@"SELECT * FROM scene WHERE scene_ID = ?",sceneId];
//    while ([res next]) {
//        model.scene_type = @"1";
//        model.scene_content = [res stringForColumn:@"scene_content"];
//        [model creatModel];
//        break;
//    }
//    
//    [_db close];
//    return model;
//}

- (NSMutableArray *)selectScene{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM warn"];
    while ([res next]) {
//        SceneModel *model = [[SceneModel alloc] init];
//        model.scene_type = @"1";
//        model.scene_content = [res stringForColumn:@"scene_content"];
//        [model creatModel];
//        [array addObject:model];
    }
    
    [_db close];
    return array;
}

@end

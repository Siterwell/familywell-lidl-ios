//
//  TimeScenedDataBase.m
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "TimeScenedDataBase.h"
#import <FMDB/FMDB.h>

static TimeScenedDataBase *_DBCtl = nil;

@interface TimeScenedDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end


@implementation TimeScenedDataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[TimeScenedDataBase alloc] init];
        
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
    
    NSString *sceneSql = @"CREATE TABLE 'timer_scene' ('timer_ID' INTEGER PRIMARY KEY NOT NULL ,'time' VARCHAR(255),'timeHM' INTEGER)";
    
    [_db executeUpdate:sceneSql];
    
    [_db close];
}

#pragma mark - 操作数据
- (void)updateTimerScene:(TimeSceneModel *)model{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM timer_scene WHERE timer_ID = ?",[NSNumber numberWithInt:[model.timer_id intValue]]];
    
    while ([res next]) {
        
        if ([res intForColumn:@"timer_ID"] == ([model.timer_id intValue])) {
            [_db executeUpdate:@"UPDATE 'timer_scene' SET time = ?  WHERE timer_ID = ? ",model.time,[NSNumber numberWithInt:[model.timer_id intValue]]];
            [_db executeUpdate:@"UPDATE 'timer_scene' SET timeHM = ?  WHERE timer_ID = ? ",[NSNumber numberWithInt:[[NSString stringWithFormat:@"%@%@",model.timeWHMS.Hour,model.timeWHMS.Minute] intValue]],[NSNumber numberWithInt:[model.timer_id intValue]]];
            [_db close];
            NSLog(@">>>>修改定时情景成功");
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTimerSceneListSuccess" object:nil];
            return;
        }
    }
    
    [_db executeUpdate:@"INSERT INTO timer_scene(timer_ID,time,timeHM)VALUES(?,?,?)",[NSNumber numberWithInt:[model.timer_id intValue]],model.time,[NSNumber numberWithInt:[[NSString stringWithFormat:@"%@%@",model.timeWHMS.Hour,model.timeWHMS.Minute] intValue]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addTimerSceneListSuccess" object:nil];
    NSLog(@">>>>添加定时情景成功");
    
    [_db close];
    
}

- (NSMutableArray *)selectTimerSceneByTimerId:(NSString *)timerId{
    
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM timer_scene where timer_ID = ?",[NSNumber numberWithInt:[timerId intValue]]];
    
    while ([res next]) {
        TimeSceneModel *model = [[TimeSceneModel alloc] init];
        model.time = [res stringForColumn:@"time"];
        model.timer_id = [res stringForColumn:@"timer_ID"];
        [model creatModel];
        [array addObject:model];
    }
    
    [_db close];
    return array;
    
}

- (NSMutableArray *)selectTimerScene{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM timer_scene order by timeHM asc"];
    
    while ([res next]) {
        TimeSceneModel *model = [[TimeSceneModel alloc] init];
        model.time = [res stringForColumn:@"time"];
        model.timer_id = [res stringForColumn:@"timer_ID"];
        [model creatModel];
        [array addObject:model];
    }
    
    [_db close];
    return array;
}

- (NSMutableArray *)selectTimerSceneOrderById{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM timer_scene order by timer_ID"];
    
    while ([res next]) {
        TimeSceneModel *model = [[TimeSceneModel alloc] init];
        model.time = [res stringForColumn:@"time"];
        model.timer_id = [res stringForColumn:@"timer_ID"];
        [model creatModel];
        [array addObject:model];
    }
    
    [_db close];
    return array;
}

- (void)deletAllTimerScene{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM timer_scene"];
    
    [_db close];
}

- (BOOL)deletTimerScene:(NSString *)timerId{
    [_db open];
    int x = [timerId intValue];
    BOOL delete = [_db executeUpdate:@"DELETE FROM timer_scene WHERE timer_ID = ?", [NSNumber numberWithInt:x]];
    [_db close];
    return delete;
}


@end

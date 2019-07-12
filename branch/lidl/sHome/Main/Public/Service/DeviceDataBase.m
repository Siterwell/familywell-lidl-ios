//
//  DeviceDataBase.m
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "DeviceDataBase.h"
#import <FMDB/FMDB.h>

static DeviceDataBase *_DBCtl = nil;

@interface DeviceDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end

@implementation DeviceDataBase
+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DeviceDataBase alloc] init];
        
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
    
    NSString *deviceSql = @"CREATE TABLE 'device' ('device_ID' INTEGER PRIMARY KEY NOT NULL ,'device_name' VARCHAR(255),'device_status' VARCHAR(255),'device_custom_name' VARCHAR(255))";
    
    [_db executeUpdate:deviceSql];
    
    [_db close];
    
}

#pragma mark - 操作数据

- (void)updateDevice:(DeviceModel *)device{
    [_db open];
    
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM device "];
    while ([res next]) {
        
        if ([res intForColumn:@"device_ID"] == device.device_ID) {
            [_db executeUpdate:@"UPDATE 'device' SET device_name = ?  WHERE device_ID = ? ",device.device_name,[NSNumber numberWithInt:device.device_ID]];
            [_db executeUpdate:@"UPDATE 'device' SET device_status = ?  WHERE device_ID = ? ",device.device_status,[NSNumber numberWithInt:device.device_ID]];
            [_db close];
            NSLog(@">>>>修改成功");
            NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: device.device_ID] forKey:@"device_ID"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceSuccess" object:nil userInfo:myDictionary];
            return;
        }
    }
    [_db executeUpdate:@"INSERT INTO device(device_ID,device_name,device_status)VALUES(?,?,?)",[NSNumber numberWithInt:device.device_ID],device.device_name,device.device_status];
    if (device.device_name && [NSNumber numberWithInt:device.device_ID]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addDeviceSuccess" object:nil userInfo:@{@"device_name": device.device_name, @"device_ID": [NSNumber numberWithInt:device.device_ID] }];
        NSLog(@">>>>添加成功");
    }
    
    [_db close];
}


- (void)addDeviceName:(NSString *)device_name ID:(int)device_id{
    [_db open];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM device"];
    while ([res next]) {
        if ([res intForColumn:@"device_ID"] == device_id) {
            [_db executeUpdate:@"UPDATE 'device' SET device_custom_name = ?  WHERE device_ID = ? ",device_name,[NSNumber numberWithInt:device_id]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceSuccess" object:nil];
            break;
        }
    }
    [_db close];
}

- (void)deletDevice:(int)deviceID{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM device WHERE device_ID = ?",[NSNumber numberWithInt:deviceID]];
    
    [_db close];
    
}

- (NSMutableArray *)selectDevice{
    [_db open];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM device"];
    while ([res next]) {
        DeviceModel *model = [[DeviceModel alloc] init];
        model.device_ID = [res intForColumn:@"device_ID"];
        model.device_name = [res stringForColumn:@"device_name"];
        model.device_status = [res stringForColumn:@"device_status"];
        ItemData *data = [DeviceMapHelp ItemWithDeivce:model];
        NSString *custom_name = [res stringForColumn:@"device_custom_name"];
        if (custom_name && ![custom_name isEqualToString:@""]) {
            data.customTitle = custom_name;
        }
        if (data) {
            [array addObject:data];
        }
    }
    
    [_db close];
    return array;
}

- (ItemData *)selectDevice:(NSString *)deviceId{
    [_db open];
    ItemData *data;
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM device WHERE device_ID = ?",[NSNumber numberWithInt:[deviceId intValue]]];
    while ([res next]) {
        DeviceModel *model = [[DeviceModel alloc] init];
        model.device_ID = [res intForColumn:@"device_ID"];
        model.device_name = [res stringForColumn:@"device_name"];
        model.device_status = [res stringForColumn:@"device_status"];
        data = [DeviceMapHelp ItemWithDeivce:model];
        NSString *custom_name = [res stringForColumn:@"device_custom_name"];
        if (custom_name && ![custom_name isEqualToString:@""]) {
            data.customTitle = custom_name;
        }
        if (data) {
            break;
        }
    }
    
    [_db close];
    return data;
}

-(DeviceModel *)selectDeviceNew:(NSString *)deviceId{
    [_db open];
    DeviceModel *model;
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM device WHERE device_ID = ?",[NSNumber numberWithInt:[deviceId intValue]]];
    while ([res next]) {
        model = [[DeviceModel alloc] init];
        model.device_ID = [res intForColumn:@"device_ID"];
        model.device_name = [res stringForColumn:@"device_name"];
        model.device_status = [res stringForColumn:@"device_status"];
        if (model) {
            break;
        }
    }
    
    [_db close];
    return model;
}

- (NSString *)getGs361Autotemp:(NSString *)deviceId{
    [_db open];
    NSString *data;
    FMResultSet *res = [_db executeQuery:@"SELECT autotemp FROM device WHERE device_ID = ?",[NSNumber numberWithInt:[deviceId intValue]]];
    while ([res next]) {
        
        data = [res stringForColumn:@"autotemp"];
        break;
    }
    [_db close];
    return data;
}

- (NSString *)getGs361Handtemp:(NSString *)deviceId{
    [_db open];
    NSString *data;
    FMResultSet *res = [_db executeQuery:@"SELECT handtemp FROM device WHERE device_ID = ?",[NSNumber numberWithInt:[deviceId intValue]]];
    while ([res next]) {
        
        data = [res stringForColumn:@"handtemp"];
        break;
    }
    [_db close];
    return data;
}

- (NSString *)getGs361Fangtemp:(NSString *)deviceId{
    [_db open];
    NSString *data;
    FMResultSet *res = [_db executeQuery:@"SELECT fangtemp FROM device WHERE device_ID = ?",[NSNumber numberWithInt:[deviceId intValue]]];
    while ([res next]) {
        
        data = [res stringForColumn:@"fangtemp"];
        break;
    }
    [_db close];
    return data;
}

- (void)deletDevice{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM device"];
    
    [_db close];
}

- (void)UpdateGs361AutoTemp:(NSString *)temp withDevId:(NSString *)devID{
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'device' SET autotemp = ?  WHERE device_ID = ? ",temp,devID];
    
    [_db close];
}

- (void)UpdateGs361HandTemp:(NSString *)temp withDevId:(NSString *)devID{
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'device' SET handtemp = ?  WHERE device_ID = ? ",temp,devID];
    
    [_db close];
}

- (void)UpdateGs361FangTemp:(NSString *)temp withDevId:(NSString *)devID{
    [_db open];
    
    [_db executeUpdate:@"UPDATE 'device' SET fangtemp = ?  WHERE device_ID = ? ",temp,devID];
    
    [_db close];
}



@end


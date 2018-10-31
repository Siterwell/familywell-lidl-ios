//
//  VideoLocalDataBase.m
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "VideoLocalDataBase.h"
#import <FMDB/FMDB.h>

static VideoLocalDataBase *_DBCtl = nil;

@interface VideoLocalDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end


@implementation VideoLocalDataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[VideoLocalDataBase alloc] init];
        
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
    NSString *sceneSql = @"CREATE TABLE 'video_localinfo' ('tid' INTEGER PRIMARY KEY AUTOINCREMENT,'dev_id' VARCHAR(255),'file_path' VARCHAR(255),'file_name' VARCHAR(255),'updata_time' VARCHAR(255),'info_type' INTEGER,'vdieoimage_path' VARCHAR(255))";
    
    [_db executeUpdate:sceneSql];
    
    [_db close];
}

#pragma mark - 操作数据
- (void)updateVideoInfo:(VideoInfoModel *)model{
    [_db open];
    
    [_db executeUpdate:@"INSERT INTO video_localinfo(dev_ID,file_path,file_name,info_type,updata_time,vdieoimage_path)VALUES(?,?,?,?,?,?)",model.devid,model.filePath,model.fileName,[NSNumber numberWithInteger:model.infoType],model.updataTime,model.imagePath];
    NSLog(@">>>>成功添加视频信息");
    
    [_db close];
    
}

- (NSMutableArray *)selectVideoInfoByInfoType:(NSInteger)infoType andDevId:(NSString *)devId{
    
    [_db open];
    
    NSMutableArray *videos = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM video_localinfo where info_Type = ? and dev_ID = ?",[NSNumber numberWithInteger:infoType],devId];

    while ([res next]) {
        
        VideoInfoModel *model = [[VideoInfoModel alloc] init];
        model.devid = [res stringForColumn:@"dev_ID"];
        model.filePath = [res stringForColumn:@"file_path"];
        model.fileName = [res stringForColumn:@"file_name"];
        model.imagePath = [res stringForColumn:@"vdieoimage_path"];
        model.updataTime = [res stringForColumn:@"updata_time"];
        model.infoType = [[res stringForColumn:@"info_type"] integerValue];
        model.vId = [[res stringForColumn:@"tid"] integerValue];
        
        [videos addObject:model];
        
    }
    
    [_db close];
    
    return videos;
}

- (void)deletAllVideoInfo{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM video_localinfo"];
    
    [_db close];
}

- (BOOL)deletVideoInfo:(NSInteger)vId{
    [_db open];
    
    BOOL delete = [_db executeUpdate:@"DELETE FROM video_localinfo WHERE tid = ?", vId];
    [_db close];
    return delete;
}

@end

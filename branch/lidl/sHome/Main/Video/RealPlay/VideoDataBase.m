//
//  VideoDataBase.m
//  sHome
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "VideoDataBase.h"
#import <FMDB/FMDB.h>

static VideoDataBase *_DBCtl = nil;

@interface VideoDataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
}
@end


@implementation VideoDataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[VideoDataBase alloc] init];
        
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
    NSString *sceneSql = @"CREATE TABLE 'video_imginfo' ('dev_ID' VARCHAR(255) PRIMARY KEY NOT NULL ,'image_PATH' VARCHAR(255),'dev_name' VARCHAR(255),'user_name' VARCHAR(255))";
    
    [_db executeUpdate:sceneSql];
    
    [_db close];
}

#pragma mark - 操作数据
- (void)updateVideoInfo:(VideoInfoModel *)model{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM video_imginfo WHERE dev_ID = ? and user_name = ?",model.devid,model.userName];

    while ([res next]) {
     
        if ([[res stringForColumn:@"dev_ID"] isEqualToString:model.devid]) {
            [_db executeUpdate:@"UPDATE 'video_imginfo' SET image_PATH = ?  WHERE dev_ID = ? and user_name = ?",model.imagePath,model.devid,model.userName];
            [_db executeUpdate:@"UPDATE 'video_imginfo' SET dev_name = ?  WHERE dev_ID = ? and user_name = ?",model.name,model.devid,model.userName];
            [_db close];
            NSLog(@">>>>成功修改视频信息");
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVideoInfoSuccess" object:nil];
            return;
        }
    }
    
    [_db executeUpdate:@"INSERT INTO video_imginfo(dev_ID,image_PATH,dev_name,user_name)VALUES(?,?,?,?)",model.devid,model.imagePath,model.name,model.userName];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"addTimerSceneListSuccess" object:nil];
    NSLog(@">>>>成功添加视频信息");
    
    [_db close];
    
}

- (VideoInfoModel *)selectVideoInfoByDevid:(NSString *)devid andUserName:(NSString *)userName{
    [_db open];
    
    VideoInfoModel *model = [[VideoInfoModel alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM video_imginfo where dev_ID = ? and user_name = ?",devid,userName];
    
    while ([res next]) {
        
        model.devid = [res stringForColumn:@"dev_ID"];
        model.imagePath = [res stringForColumn:@"image_PATH"];
        model.name = [res stringForColumn:@"dev_name"];
        model.userName = [res stringForColumn:@"user_name"];
    }
    
    [_db close];
    return model;
}

- (NSMutableArray *)selectVideoInfo{
    
    [_db open];
    
    NSMutableArray *videos = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM video_imginfo"];

    while ([res next]) {
        
        VideoInfoModel *model = [[VideoInfoModel alloc] init];
        model.devid = [res stringForColumn:@"dev_ID"];
        model.imagePath = [res stringForColumn:@"image_PATH"];
        model.name = [res stringForColumn:@"dev_name"];
        model.userName = [res stringForColumn:@"user_name"];
        
        [videos addObject:model];
        
    }
    
    [_db close];
    
    return videos;
}

- (void)deletAllVideoInfo{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM video_imginfo"];
    
    [_db close];
}

- (BOOL)deletVideoInfo:(NSString *)devid andUserName:(NSString*)userName{
    [_db open];
    
    BOOL delete = [_db executeUpdate:@"DELETE FROM video_imginfo WHERE dev_ID = ? and user_name = ?", devid,userName];
    [_db close];
    return delete;
}

@end

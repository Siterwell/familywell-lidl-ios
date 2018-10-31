//
//  Config.m
//  XWorld
//
//  Created by DingLin on 16/5/29.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "Config.h"
#import "NSString+DTPaths.h"

/**********************************************************
                    录像，图片的路径组织：
                           |---Local(app上预览时的抓图)
                 |---Snap -|
                 |         |---Device（设备上存储的抓图）
                 |         |---Cache(图片的缩略图)
                 |
      |----Photos ---Thumbail-----Device（设备列表中的设备缩略图)
      |          |              |                            |--Local(app上回放时的手动录像的缩略图)
      |          |              |---Record----------------——-|
      |          |              |                            |
      |          |              |---Alarm(报警历史图片的小图)   |--Device(设备上存储的的录像的缩略图)
 doc -|          |---Alarm（大图)|---Snap---Device
      |
      |                           |--Local(app上回放时的手动录像)
      |             |---Record----|
      |             |             |
      |----Videos --|             |
                    |---其他       |--Device(设备上存储的的录像)
                                  |---Cache(录像的缩略图)
 ***********************************************************/

NSString *const kLoginModeType = @"loginModeType";
NSString * const kLoginUserAutoLogin = @"login_user_auto_login";
NSString * const kLoginUserRememberPWd = @"login_user_remember_PWd";
NSString * const kLoginUserDic = @"login_users";
NSString * const kLoginLastUser = @"login_last_user";
NSString * const kLoginLastUserPWD = @"login_last_user_PWD";
NSString * const KUserGravity = @"User_Gravity";
NSString * const KUserFisheyeModelDic = @"Fisheye_model_dic";
NSString * const KUserFisheyeModelDevId = @"Fisheye_model_devId";
NSString * const KUserFisheyeModel = @"Fisheye_model";
@implementation Config

#pragma mark - 配置文件保存的路径
+(NSString *)configFilePath {
    NSString *configFilePath = [[NSString cachesPath] stringByAppendingString:@"/Configs/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:configFilePath]) {
        [fileManager createDirectoryAtPath:configFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return configFilePath;
}

#pragma mark - 升级文件保存的路径
+(NSString *)upgradeFilePath {
    NSString *upgradeFilePath = [[NSString cachesPath] stringByAppendingString:@"/UpgrateFiles/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:upgradeFilePath]) {
        [fileManager createDirectoryAtPath:upgradeFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return upgradeFilePath;
}

#pragma mark - 临时文件保存的路径
+(NSString *)tempFilePath {
    NSString *tempFilePath = [[NSString cachesPath] stringByAppendingString:@"/TempFiles/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:tempFilePath]) {
        [fileManager createDirectoryAtPath:tempFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return tempFilePath;
}

#pragma mark - SSID信息保存的路径
+ (NSString *)SSIDInfoFile {
    NSString *SSIDinfoFile = [[Config configFilePath] stringByAppendingString:@"SSIDInfo.plist"];
    return SSIDinfoFile;
}

#pragma mark - 鱼眼模式保存的路径
+(NSString *)userfisheyemodelFile{
    NSString *SSIDinfoFile = [[Config configFilePath] stringByAppendingString:@"fisheyeModel.plist"];
    return SSIDinfoFile;
}

#pragma mark - 保存鱼眼模式
+(void)savefisheye:(NSString *)DevId model:(NSString *)fisheyeModel
{
    NSString *path = [Config userfisheyemodelFile];
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (!plist) {
        plist = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    NSMutableDictionary *userInfoDic = plist[KUserFisheyeModelDic];
    if (!userInfoDic) {
        userInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [plist setValue:userInfoDic forKey:KUserFisheyeModelDic];
    }
    NSMutableDictionary* dictUser = userInfoDic[DevId];
    if ( !dictUser ) {
        dictUser = [NSMutableDictionary dictionaryWithCapacity:1];
        userInfoDic[DevId] = dictUser;
    }
    dictUser[@"model"] = fisheyeModel;
    plist[KUserFisheyeModelDevId] = DevId;
    plist[KUserFisheyeModel] = fisheyeModel;
    [plist writeToFile:path atomically:YES];

}

#pragma mark - 读取鱼眼的模式
+(NSString *)fisheyeModel:(NSString *)DevId
{
    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *path = [Config userfisheyemodelFile];
    plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSMutableDictionary *userInfoDic = plist[KUserFisheyeModelDic];
    if (!userInfoDic) {
        return nil;
    }
    if (userInfoDic[DevId]) {
        NSDictionary* dicUser =  userInfoDic[DevId];
        return dicUser[@"model"];
    }
    return nil;

}

#pragma mark - 所有图片的保存总路径
+(NSString*)photosPath{
    NSString *photosPath = [[NSString documentsPath] stringByAppendingString:@"/Photos"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:photosPath]) {
        [fileManager createDirectoryAtPath:photosPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return photosPath;
}

#pragma mark - 所有抓图包括从设备下载保存总路径
+(NSString*)snapPath{
    NSString *snapPath = [[Config photosPath] stringByAppendingString:@"/Snap"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:snapPath]) {
        [fileManager createDirectoryAtPath:snapPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return snapPath;
}

#pragma mark - 所有app手动抓图的保存路径
+(NSString*)localSnapPath{
    NSString *localSnapPath = [[Config snapPath] stringByAppendingString:@"/Local"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:localSnapPath]) {
        [fileManager createDirectoryAtPath:localSnapPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return localSnapPath;
}

#pragma mark - 所有app手动抓图的缩略图保存路径
+(NSString*)snapCachePath{
    NSString *snapCachePath = [[Config snapPath] stringByAppendingString:@"/Cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:snapCachePath]) {
        [fileManager createDirectoryAtPath:snapCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return snapCachePath;
}

#pragma mark - 所有录像的缩略图保存路径
+(NSString*)recCachePath{
    NSString *recCachePath = [[Config recordPath] stringByAppendingString:@"/Cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:recCachePath]) {
        [fileManager createDirectoryAtPath:recCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recCachePath;
}

#pragma mark - 生成一个抓图文件名
+(NSString*)localSnapFile{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeFormatter];
    NSString *nowString = [dateFormatter stringFromDate:nowDate];
    nowString = [nowString stringByReplacingOccurrencesOfString:@":" withString:@"$"];
    NSString *localSnapFile = [[Config localSnapPath] stringByAppendingFormat:@"/%@.jpg",nowString];
    
    return localSnapFile;
}

#pragma mark - 生成一个鱼眼抓图文件名
+(NSString*)fisheyelocalSnapFile{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeFormatter];
    NSString *nowString = [dateFormatter stringFromDate:nowDate];
    nowString = [nowString stringByReplacingOccurrencesOfString:@":" withString:@"$"];
    NSString *localRecordFile = [[Config localSnapPath] stringByAppendingFormat:@"/%@.fyuv",nowString];
    
    return localRecordFile;
}
#pragma mark - 从设备下载的图片的保存路径
+(NSString*)deviceSnapPath{
    NSString *deviceSnapPath = [[Config snapPath] stringByAppendingString:@"/Device"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:deviceSnapPath]) {
        [fileManager createDirectoryAtPath:deviceSnapPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return deviceSnapPath;
}

#pragma mark - app中所有视频的保存路径
+(NSString*)videosPath{
    NSString *videosPath = [[NSString documentsPath] stringByAppendingString:@"/Videos"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:videosPath]) {
        [fileManager createDirectoryAtPath:videosPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return videosPath;
}

#pragma mark - app中所有录像的保存路径
+(NSString*)recordPath{
    NSString *recordPath = [[Config videosPath] stringByAppendingString:@"/Record"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:recordPath]) {
        [fileManager createDirectoryAtPath:recordPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recordPath;
}

#pragma mark - 本地手动录像的保存路径
+(NSString*)localRecordPath{
    NSString *localRecordPath = [[Config recordPath] stringByAppendingString:@"/Local"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:localRecordPath]) {
        [fileManager createDirectoryAtPath:localRecordPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return localRecordPath;
}

#pragma mark - 生成一个本地手动抓图的文件名
+(NSString*)localRecordFile{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeFormatter];
    NSString *nowString = [dateFormatter stringFromDate:nowDate];
    nowString = [nowString stringByReplacingOccurrencesOfString:@":" withString:@"$"];
    NSString *localRecordFile = [[Config localRecordPath] stringByAppendingFormat:@"/%@.mp4",nowString];
    
    return localRecordFile;
}

#pragma mark - 生成一个鱼眼本地手动抓图的文件名
+(NSString*)fisheyeLocalRecordFile{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:TimeFormatter];
    NSString *nowString = [dateFormatter stringFromDate:nowDate];
    nowString = [nowString stringByReplacingOccurrencesOfString:@":" withString:@"$"];
    NSString *localRecordFile = [[Config localRecordPath] stringByAppendingFormat:@"/%@.fvideo",nowString];
    
    return localRecordFile;
}
#pragma mark - 从设备下载的录像的保存路径
+(NSString*)devRecordPath{
    NSString *devRecordPath = [[Config recordPath] stringByAppendingString:@"/Device"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:devRecordPath]) {
        [fileManager createDirectoryAtPath:devRecordPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return devRecordPath;
}

#pragma mark - 报警图片（报警订阅中的历史图片）
+(NSString*)alarmPhotoPath{
    NSString *alarmPhotoPath = [[Config photosPath] stringByAppendingString:@"/Alarm/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:alarmPhotoPath]) {
        [fileManager createDirectoryAtPath:alarmPhotoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return alarmPhotoPath;
}

#pragma mark - 生成一个报警历史图片的原图文件名
+(NSString *)alarmPicFile:(NSString *)alarmId{
    NSString *alarmPicFile = [[Config alarmPhotoPath] stringByAppendingFormat:@"%@-o.jpg", alarmId];
    
    return alarmPicFile;
}

#pragma mark - 缩略图路径，包括设备的缩略图，app手动录像的缩略图，设备上图片，录像的缩略图.以及报警历史的缩略图
+(NSString*)thumbnailPath{
    NSString *thumbnailPath = [[Config photosPath] stringByAppendingString:@"/Thumbnail"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:thumbnailPath]) {
        [fileManager createDirectoryAtPath:thumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return thumbnailPath;
}

#pragma mark - 设备列表中的设备缩略图
+(NSString*)devThumbnailPath{
    NSString *devThumbnailPath = [[Config thumbnailPath] stringByAppendingString:@"/Device"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:devThumbnailPath]) {
        [fileManager createDirectoryAtPath:devThumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return devThumbnailPath;
}

#pragma mark - 生成一个设备缩略图文件名
+(NSString*)devThumbnailFile:(NSString*)devId{
    NSString *devThumbnailFile = [[Config devThumbnailPath] stringByAppendingFormat:@"/%@.jpg",devId];
    return devThumbnailFile;
}

#pragma mark - 录像缩略图路径
+(NSString*)recordThumbnailPath{
    NSString *recordThumbnailPath = [[Config thumbnailPath] stringByAppendingString:@"/Record"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:recordThumbnailPath]) {
        [fileManager createDirectoryAtPath:recordThumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return recordThumbnailPath;
}

#pragma mark - 本地手动录像的缩略图路径
+(NSString*)localRecThumbnailPath{
    NSString *localRecThumbnailPath = [[Config recordThumbnailPath] stringByAppendingString:@"/Local"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:localRecThumbnailPath]) {
        [fileManager createDirectoryAtPath:localRecThumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return localRecThumbnailPath;
}

#pragma mark - 设备录像的缩略图路径
+(NSString*)devRecThumbnailPath{
    NSString *devRecThumbnailPath = [[Config recordThumbnailPath] stringByAppendingString:@"/Device"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:devRecThumbnailPath]) {
        [fileManager createDirectoryAtPath:devRecThumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return devRecThumbnailPath;
}

#pragma mark - 抓图缩略图路径
+(NSString*)snapThumbnailPath{
    NSString *snapThumbnailPath = [[Config thumbnailPath] stringByAppendingString:@"/Snap"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:snapThumbnailPath]) {
        [fileManager createDirectoryAtPath:snapThumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return snapThumbnailPath;
}

#pragma mark - 设备抓图缩略图路径
+(NSString*)devSnapThumbnailPath{
    NSString *devSnapThumbnailPath = [[Config snapThumbnailPath] stringByAppendingString:@"/Device"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:devSnapThumbnailPath]) {
        [fileManager createDirectoryAtPath:devSnapThumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return devSnapThumbnailPath;
}

#pragma mark - 报警历史缩略图路径
+(NSString*)alarmThumbnailPath{
    NSString *alarmThumbnailPath = [[Config thumbnailPath] stringByAppendingString:@"/Alarm/"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:alarmThumbnailPath]) {
        [fileManager createDirectoryAtPath:alarmThumbnailPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return alarmThumbnailPath;
}

#pragma mark - 生成一个报警历史图片的缩略图文件名
+(NSString*)alarmThumbnailFile:(NSString*)alarmId{
    NSString *alarmThumbnailFile = [[Config alarmThumbnailPath] stringByAppendingFormat:@"/%@-t.jpg", alarmId];
    
    return alarmThumbnailFile;
}

#pragma mark - 计算单个文件的大小
+(float) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 计算文件夹大小
+(float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [Config fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0);
}

#pragma mark - 计算缓存大小单位KB
+(float)cacheSize{
//    NSString* docPath = [NSString documentsPath];
//    NSString* cachePath = [NSString cachesPath];
//    NSString* tempPath = [NSString temporaryPath];
//    
//    return [Config folderSizeAtPath:docPath]+[Config folderSizeAtPath:cachePath]+[Config folderSizeAtPath:tempPath];
    //报警大图、缩略图
    NSString* thumbnailPath = [Config thumbnailPath];
    NSString* alarmPhotoPath = [Config alarmPhotoPath];
    
    return [Config folderSizeAtPath:thumbnailPath]+[Config folderSizeAtPath:alarmPhotoPath];
}

#pragma mark - 清除缓存
+(void)cleanCache{
//    NSString* docPath = [NSString documentsPath];
//    NSString* cachePath = [NSString cachesPath];
//    NSString* tempPath = [NSString temporaryPath];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:docPath error:nil];
//    [fileManager removeItemAtPath:cachePath error:nil];
//    [fileManager removeItemAtPath:tempPath error:nil];

    //清除缓存删除报警大图、缩略图
    NSString* thumbnailPath = [Config thumbnailPath];
    NSString* alarmPhotoPath = [Config alarmPhotoPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:thumbnailPath error:nil];
    [fileManager removeItemAtPath:alarmPhotoPath error:nil];
}

#pragma mark - 获取缩略图
+(NSString *)thumbnailPathOffile: (NSString *)file {
    NSString *thumbnailPath = @"";
    if ([file containsString:@".fyuv"]) {
        NSString *thumbnail = [[file stringByReplacingOccurrencesOfString:@".fyuv" withString:@".jpg"] lastPathComponent];
        thumbnailPath = [NSString stringWithFormat:@"%@/%@", [Config snapCachePath], thumbnail];
        //todo:如果缩略图不存在，那么创建一张缩略图
    } else if([file containsString:@".fvideo"]){
        NSString *thumbnail = [[file stringByReplacingOccurrencesOfString:@".fvideo" withString:@".jpg"] lastPathComponent];
        thumbnailPath = [NSString stringWithFormat:@"%@/%@", [Config recCachePath], thumbnail];
        //todo:如果缩略图不存在，那么创建一张缩略图
    } else if([file containsString:@".mp4"]){
        NSString *thumbnail = [[file stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"] lastPathComponent];
        thumbnailPath = [NSString stringWithFormat:@"%@/%@", [Config recCachePath], thumbnail];
        //todo:如果缩略图不存在，那么创建一张缩略图
    }
    
    return thumbnailPath;
    
}

@end

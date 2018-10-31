//
//  Config.h
//  XWorld
//
//  Created by DingLin on 16/5/29.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import <Foundation/Foundation.h>

//日期格式
#define DateFormatter @"yyyy-MM-dd"
//时间格式
#define TimeFormatter @"yyyy-MM-dd HH:mm:ss"
#define TimeFormatter2 @"yyyy-MM-dd_HH:mm:ss"



typedef NS_ENUM(NSUInteger, LoginModeType)
{
    LoginModeUser,
    LoginModeGuest,
};


@interface Config : NSObject

#pragma mark - 配置文件保存的路径
+(NSString *)configFilePath;

#pragma mark - 升级文件保存的路径
+(NSString *)upgradeFilePath;

#pragma mark - 临时文件保存的路径
+(NSString *)tempFilePath;

#pragma mark - SSID信息保存的路径
+(NSString *)SSIDInfoFile;

#pragma mark - 用户信息保存的路径
+(NSString *)userInfoFile;

#pragma mark - 鱼眼模式保存的路径
+(NSString *)userfisheyemodelFile;

#pragma mark - 保存登录模式
+(void)saveLoginMode:(LoginModeType)loginModeType;

#pragma mark - 读取登录模式
+(LoginModeType)loginMode;

#pragma mark - 读取最后的用户密码
+(NSDictionary *)lastUserNameAndUserPWD;

#pragma mark - 加入一个用户密码
+ (void)addUserName:(NSString *)userName andUserPWD:(NSString *)userPWD;

#pragma mark - 读取一个用户的密码
+(NSString *)userPWD:(NSString *)userName;

#pragma mark- 保存鱼眼的模式
+(void)savefisheye:(NSString*)DevId model:(NSString *)fisheyeModel;

#pragma mark - 读取鱼眼设备的模式
+(NSString *)fisheyeModel:(NSString *)DevId;


#pragma mark - 加入一个SSID密码
+ (void)addSSID:(NSString *)SSID SSIDPassword:(NSString *)SSIDPWD;

#pragma mark - 本地临时登录的设备信息保存文件
+(NSString *)localDeviceFile;

#pragma mark - 所有图片的保存总路径
+(NSString*)photosPath;

#pragma mark - 所有抓图包括从设备下载保存总路径
+(NSString*)snapPath;

#pragma mark - 所有app手动抓图的保存路径
+(NSString*)localSnapPath;

#pragma mark - 生成一个抓图文件名
+(NSString*)localSnapFile;

#pragma mark -生成一个鱼眼抓图文件名
+(NSString*)fisheyelocalSnapFile;

#pragma mark - 从设备下载的图片的保存路径
+(NSString*)deviceSnapPath;

#pragma mark - app中所有视频的保存路径
+(NSString*)videosPath;

#pragma mark - app中所有录像的保存路径
+(NSString*)recordPath;

#pragma mark - 本地手动录像的保存路径
+(NSString*)localRecordPath;

#pragma mark - 生成一个本地手动抓图的文件名
+(NSString*)localRecordFile;

#pragma mark - 生成一个鱼眼本地手动抓图的文件名
+(NSString*)fisheyeLocalRecordFile;

#pragma mark - 从设备下载的录像的保存路径
+(NSString*)devRecordPath;

#pragma mark - 报警图片（报警订阅中的历史图片）
+(NSString*)alarmPhotoPath;

#pragma mark - 生成一个报警历史图片的缩略图文件名
+(NSString *)alarmPicFile:(NSString *)alarmId;

#pragma mark - 缩略图路径，包括设备的缩略图，app手动录像的缩略图，设备上图片，录像的缩略图.以及报警历史的缩略图
+(NSString*)thumbnailPath;

#pragma mark - 设备列表中的设备缩略图
+(NSString*)devThumbnailPath;

#pragma mark - 生成一个设备缩略图文件名
+(NSString*)devThumbnailFile:(NSString*)devId;

#pragma mark - 录像缩略图路径
+(NSString*)recordThumbnailPath;

#pragma mark - 本地手动录像的缩略图路径
+(NSString*)localRecThumbnailPath;

#pragma mark - 设备录像的缩略图路径
+(NSString*)devRecThumbnailPath;

#pragma mark - 抓图缩略图路径
+(NSString*)snapThumbnailPath;

#pragma mark - 设备抓图缩略图路径
+(NSString*)devSnapThumbnailPath;

#pragma mark - 报警历史缩略图路径
+(NSString*)alarmThumbnailPath;

#pragma mark - 生成一个报警历史图片的缩略图文件名
+(NSString*)alarmThumbnailFile:(NSString*)alarmId;

#pragma mark - 计算单个文件的大小
+(float) fileSizeAtPath:(NSString*) filePath;

#pragma mark - 计算文件夹大小单位KB
+(float)folderSizeAtPath:(NSString*) folderPath;

#pragma mark - 计算缓存大小
+(float)cacheSize;

#pragma mark - 清除缓存
+(void)cleanCache;

#pragma mark - 所有app手动抓图的缩略图保存路径
+(NSString*)snapCachePath;

#pragma mark - 所有录像的缩略图保存路径
+(NSString*)recCachePath;

#pragma mark - 获取缩略图
+(NSString *)thumbnailPathOffile: (NSString *)file;
@end

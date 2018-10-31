//
//  NSSDKAPConfigModel.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/20.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "NSSDKObject.h"

@protocol NSSDKAPConfigModelDelegate <NSObject>

-(void)APDevice:(NSString*)name DevSn:(NSString*)sn deviceType:(int)type configResult:(int)result;

@end

@interface NSSDKAPConfigModel : NSSDKObject
@property (nonatomic,weak) id<NSSDKAPConfigModelDelegate> apConfigDelegate;

+(NSSDKAPConfigModel *)sharedInstance;

//开始快速配置
-(int)starAPConfigWithSSID:(NSString *)SSID password:(NSString *)password;
//停止快速配置
-(int)stopConfig;

@end

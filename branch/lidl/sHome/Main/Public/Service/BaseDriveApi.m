//
//  BaseDriveApi.m
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseDriveApi.h"
#import "HekrApi.h"
#import "MyUdp.h"
#import "DeviceListModel.h"

@implementation BaseDriveApi

- (id)requestArgumentCommand {
    return nil;
}

- (id)requestArgumentFilter {
    return nil;
}

- (id)requestArgumentDevice{
    return nil;
}

-(id)requestArgumentFilterEncrypt{
    return nil;
}

-(void)startWithObject:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    if (![[config objectForKey:AppStatus] isEqualToString:IntranetAppStatus]) {
        //外网
        [[Hekr sharedInstance] recv:[self requestArgumentFilter] obj:obj callback:^(id obj, id data, NSError *error) {
            if (data) {
                success(data , error);
            }
        }];
        [[Hekr sharedInstance] recv:[self requestArgumentFilterEncrypt] obj:obj callback:^(id obj, id data, NSError *error) {
            if (data) {
                success(data , error);
            }
        }];
        NSLog(@">>>>>>%@",[self requestArgumentCommand]);
//        [[Hekr sharedInstance] send:[self requestArgumentCommand] to:[self requestArgumentDevice] callback:^(id respond,NSError* error){
//            if (error) {
//                if (error.code != -1) {
//                    failure(respond , error);
//                }
//            } else {
//                success(respond, error);
//            }
////            if (respond) {
////                success(respond, error);
////            }
//        }];
        //发送websocket指令要指定connectHost
//        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
        NSString *connectHost = [[[config objectForKey:DeviceInfo] objectForKey:@"dcInfo"] objectForKey:@"connectHost"];
        [[Hekr sharedInstance] sendNet:[self requestArgumentCommand] toHost:connectHost timeout:20.0f callback:^(id data, NSError *err) {
//            typeof(self) sself = wself;
            DDLogVerbose(@" recv response:%@",data);
            NSNumber * d = data[@"code"];
            if(data && [d intValue] == 200){
                success(data, err);
            }else{
                if (err.code != -1) {
                    failure(data, err);
                }
            }
        }];
        
    }else{
        //内网
        [[MyUdp shared] recv:[self requestArgumentFilter] obj:obj callback:^(id obj, id data, NSError *error) {
            if (data) {
                NSLog(@"%@",data);
                success(data , error);
            }
            if (error) {
                failure(data, error);
            }
        }];
        
            [[MyUdp shared] recv:[self requestArgumentFilterEncrypt] obj:obj callback:^(id obj, id data, NSError *error) {
                if (data) {
                    NSLog(@"%@",data);
                    success(data , error);
                }
                if (error) {
                    failure(data, error);
                }
            }];
            
            [[MyUdp shared] senData:[self requestArgumentCommand]];
        }
    }

-(void)startWithWan:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure{
    //外网
    [[Hekr sharedInstance] recv:[self requestArgumentFilter] obj:obj callback:^(id obj, id data, NSError *error) {
        if (data) {
            success(data , error);
        }
    }];
    [[Hekr sharedInstance] recv:[self requestArgumentFilterEncrypt] obj:obj callback:^(id obj, id data, NSError *error) {
        if (data) {
            success(data , error);
        }
    }];
    NSLog(@">>>>>>%@",[self requestArgumentCommand]);
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSString *connectHost = [[[config objectForKey:DeviceInfo] objectForKey:@"dcInfo"] objectForKey:@"connectHost"];
    [[Hekr sharedInstance] sendNet:[self requestArgumentCommand] toHost:connectHost timeout:20.0f callback:^(id data, NSError *err) {
        //            typeof(self) sself = wself;
        DDLogVerbose(@" recv response:%@",data);
        NSNumber * d = data[@"code"];
        if(data && [d intValue] == 200){
            success(data, err);
        }else{
            if (err.code != -1) {
                failure(data, err);
            }
        }
    }];
}

- (void)startUdpObj:(id)obj CompletionBlockWithSuccess:(void (^)(id, NSError *))success failure:(void (^)(id, NSError *))failure {
    [[MyUdp shared] recv:[self requestArgumentFilter] obj:obj callback:^(id obj, id data, NSError *error) {
        if (data) {
            NSLog(@"%@",data);
            success(data , error);
        }
    }];
    
    [[MyUdp shared] senData:[self requestArgumentCommand]];
}


-(void)startWLanWithObject:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure{
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
    if(model==nil){
        //加载信息
        [MBProgressHUD showError:NSLocalizedString(@"请选择网关", nil) ToView:GetWindow];
    }else{
            //外网
            [[Hekr sharedInstance] recv:[self requestArgumentFilter] obj:obj callback:^(id obj, id data, NSError *error) {
                if (data) {
                    success(data , error);
                }
            }];
            [[Hekr sharedInstance] recv:[self requestArgumentFilterEncrypt] obj:obj callback:^(id obj, id data, NSError *error) {
                if (data) {
                    success(data , error);
                }
            }];
            NSLog(@">>>>>>%@",[self requestArgumentCommand]);
            //        [[Hekr sharedInstance] send:[self requestArgumentCommand] to:[self requestArgumentDevice] callback:^(id respond,NSError* error){
            //            if (error) {
            //                if (error.code != -1) {
            //                    failure(respond , error);
            //                }
            //            } else {
            //                success(respond, error);
            //            }
            ////            if (respond) {
            ////                success(respond, error);
            ////            }
            //        }];
            //发送websocket指令要指定connectHost
            //        DeviceListModel *model = [[DeviceListModel alloc] initWithDictionary:[config objectForKey:DeviceInfo] error:nil];
            NSString *connectHost = [[[config objectForKey:DeviceInfo] objectForKey:@"dcInfo"] objectForKey:@"connectHost"];
            [[Hekr sharedInstance] sendNet:[self requestArgumentCommand] toHost:connectHost timeout:20.0f callback:^(id data, NSError *err) {
                //            typeof(self) sself = wself;
                DDLogVerbose(@" recv response:%@",data);
                NSNumber * d = data[@"code"];
                if(data && [d intValue] == 200){
                    success(data, err);
                }else{
                    if (err.code != -1) {
                        failure(data, err);
                    }
                }
            }];
            
        
    }
    
    
}


-(void)dealloc{
    NSLog(@">>>>api dealloc");
}

@end

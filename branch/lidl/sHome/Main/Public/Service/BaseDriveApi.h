//
//  BaseDriveApi.h
//  sHome
//
//  Created by shaop on 2016/12/13.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDriveApi : NSObject

- (id)requestArgumentDevice;

- (id)requestArgumentCommand;

- (id)requestArgumentFilter;

-(id)requestArgumentFilterEncrypt;

-(void)startWithObject:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure;

-(void)startWithWan:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure;

- (void)startUdpObj:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure;

-(void)startWLanWithObject:(id)obj CompletionBlockWithSuccess:(void(^)(id data,NSError* error))success failure:(void(^)(id data,NSError* error))failure;
@end

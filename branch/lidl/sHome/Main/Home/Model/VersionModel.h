//
//  VersionModel.h
//  sHome
//
//  Created by shaop on 2017/4/8.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol VersionResult;

@interface VersionModel : JSONModel

@property (nonatomic, strong) NSArray<VersionResult> *results;

@end

@interface VersionResult : JSONModel

@property (nonatomic, strong) NSString *version;

@property (nonatomic, strong) NSString *trackViewUrl;

@end


//
//  JSONModel+DeviceDic.m
//  sHome
//
//  Created by shaop on 2017/1/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "JSONModel+DeviceDic.h"

@implementation JSONModel(DeviceDic)

-(id)initWithDivicedictionary:(NSDictionary *)dic error:(NSError **)error{
    dic = [dic objectForKey:@"params"];
    dic = [dic objectForKey:@"data"];
    if (self = [self initWithDictionary:dic error:error]) {
        
    }
    return self;
}

@end

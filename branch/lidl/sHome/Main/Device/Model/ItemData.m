//
//  ItemData.m
//  ShelfCollectionView
//
//  Created by king.wu on 8/18/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import "ItemData.h"
#import "BatterHelp.h"

@interface ItemData()
@property (nonatomic, strong, readwrite)NSString *title;
@property (nonatomic, strong, readwrite)NSString *image;
@property (nonatomic, strong, readwrite)NSString *status;
@property (nonatomic, strong, readwrite)NSString *devID;
@property (nonatomic, strong, readwrite)NSString *statuCode;
@property (nonatomic, strong, readwrite)NSString *crcCode;
@property (nonatomic, strong, readwrite)NSString *crcCustomTitle;
@end

@implementation ItemData
- (instancetype)initWithTitle:(NSString *)title Status:(NSString *)status DevID:(NSString *)devID Images:(NSString *)images Code:(NSString *)code{
    self = [super init];
    if (self){
        self.title = title;
        self.customTitle = @"";
        self.status = status;
        self.devID = devID;
        self.statuCode = code;
        if (images) {
            self.image = [NSString stringWithFormat:images,self.status];
        }
        self.crcCode = [BatterHelp getDeviceCRCCode:code];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder

{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        // 查看成员变量
        const char *name = ivar_getName(ivar);
        // 归档
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [encoder encodeObject:value forKey:key];
    }
    free(ivars);
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应的成员变量
            Ivar ivar = ivars[i];
            // 查看成员变量
            const char *name = ivar_getName(ivar);
            // 归档
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            // 设置到成员变量身上
            [self setValue:value forKey:key];
            
        }
        free(ivars);
    } 
    return self;
}
@end


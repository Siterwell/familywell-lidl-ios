//
//  SystemSceneModel.m
//  sHome
//
//  Created by shaop on 2017/2/15.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SystemSceneModel.h"
#import "SceneDataBase.h"
#import "BatterHelp.h"
#import "SceneListItemData.h"
#import "NSString+CY.h"

@implementation SystemSceneModel

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    
    if (self = [super initWithDictionary:dict error:err]) {
        if (self.answer_content.length >= 32) {
            self.dev584_count = [self getDev584_countFromContent];
            self.scene_name = [self getNameFromConeten];
            self.scene_list_array = [self getSelectArray];
            self.scene_CRC = [self getCRCFromContent];
            self.scene_color = [self getSceneColor];
            self.dev584_detail = [self.answer_content substringWithRange:NSMakeRange(42, 14 * [BatterHelp numberHexString:self.dev584_count].intValue)];
            self.dev584_ids = [NSMutableArray array];
            self.dev584_ids_scs = [NSMutableArray array];
            for (int i = 0; i < [BatterHelp numberHexString:self.dev584_count].intValue; i++) {
                [self.dev584_ids addObject:[self.dev584_detail substringWithRange:NSMakeRange(14*i , 4)]];
                [self.dev584_ids_scs addObject:[self.dev584_detail substringWithRange:NSMakeRange(14*i, 6)]];
            }
        }else {
            self.scene_list_array = [self getSelectArray];
        }
    }
    return self;
}

- (void)creatModel{
    if (self.answer_content.length >= 32) {
        self.dev584_count = [self getDev584_countFromContent];
        self.scene_name = [self getNameFromConeten];
        self.scene_list_array = [self getSelectArray];
        self.scene_CRC = [self getCRCFromContent];
        self.scene_color = [self getSceneColor];
        self.dev584_detail = [self.answer_content substringWithRange:NSMakeRange(42, 14 * [BatterHelp numberHexString:self.dev584_count].intValue)];
        self.dev584_ids = [NSMutableArray array];
        self.dev584_ids_scs = [NSMutableArray array];
        for (int i = 0; i < [BatterHelp numberHexString:self.dev584_count].intValue; i++) {
            [self.dev584_ids addObject:[self.dev584_detail substringWithRange:NSMakeRange(14*i , 4)]];
            [self.dev584_ids_scs addObject:[self.dev584_detail substringWithRange:NSMakeRange(14*i, 6)]];
        }
    }else{
       self.scene_list_array = [self getSelectArray];
    }
}

- (NSString *)getDev584_countFromContent {
    NSString *count = [self.answer_content substringWithRange:NSMakeRange(38, 2)];
    count = [NSString stringWithFormat:@"%lu",strtoul([[count substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
    return count;
}

- (NSString *)getNameFromConeten{
    NSStringEncoding enc = NSUTF8StringEncoding;//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *nameString = [self.answer_content substringWithRange:NSMakeRange(6, 32)];
    NSData *data = [self hexStringToData:nameString];
    NSString *result = [[NSString alloc] initWithData:data encoding:enc];
    result = [result stringByReplacingOccurrencesOfString:@"@" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@"$" withString:@""];
    return result;
}

- (NSString *)getIdFromConeten{
    NSString *mid = [self.answer_content substringWithRange:NSMakeRange(4, 2)];
    
    mid = [NSString stringWithFormat:@"%lu",strtoul([[mid substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
    
    return mid;
}

-(NSMutableArray *) getSelectArray{
    
    if(self.answer_content.length > 42){
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int scount = [BatterHelp numberHexString:[self.answer_content substringWithRange:NSMakeRange(40, 2)]].intValue;
    int dcount = [BatterHelp numberHexString:[self.answer_content substringWithRange:NSMakeRange(38, 2)]].intValue;
    for (int i = 0; i < scount; i++) {
        if (42+dcount*14+i*2+2 <= self.answer_content.length) {
            NSString *scene_id = [self.answer_content substringWithRange:NSMakeRange(6+32+4+(dcount*14)+(i*2), 2)];
            scene_id = [NSString stringWithFormat:@"%lu",strtoul([[scene_id substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
            
            SceneModel *model = [[SceneDataBase sharedDataBase] selectScene:scene_id];
            BOOL flag = NO;
            if(model.scene_indevice_array.count==1 && model.scene_outdevice_array.count){
                SceneListItemData *scene = [model.scene_indevice_array objectAtIndex:0];
                SceneListItemData *scene2 = [model.scene_outdevice_array objectAtIndex:0];
                if([scene.title isEqualToString:@"温控器"] &&![NSString isBlankString:scene2.week]){
                    flag = YES;
                }
            }
            
            if (model.scene_id && !flag) {
                model.scene_id = scene_id;
                [array addObject:model];
            }
        }
    }
        
        if(self.answer_content.length == (42+dcount*14+scount*2+4)){
            NSNumber * ds = [BatterHelp numberHexString:[self.answer_content substringWithRange:NSMakeRange(self.answer_content.length-2, 2)]];
            Byte dsa = [ds intValue];
            if((dsa&0x01)!=0){
                SceneModel *model = [[SceneModel alloc] init];
                model.scene_id = @"129";
                [array addObject:model];
            }
            if((dsa&0x02)!=0){
                SceneModel *model = [[SceneModel alloc] init];
                model.scene_id =  @"130";
                [array addObject:model];
            }
            
            if((dsa&0x04)!=0){
                SceneModel *model = [[SceneModel alloc] init];
                model.scene_id =  @"131";
                [array addObject:model];
            }
        }
    return array;
    }
    else {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        return array;
    }
    


}

- (NSString *)getCRCFromContent{
    int totalLengrh = (int)strtoul([[self.answer_content substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16);
    unsigned char byte[totalLengrh];
    byte[0] = (unsigned char)strtoul([[self.answer_content substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    byte[1] = (unsigned char)strtoul([[self.answer_content substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
    byte[2] = (unsigned char)strtoul([[self.answer_content substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
    
    int j=3;
    
    NSString *name = [self.answer_content substringWithRange:NSMakeRange(6, 32)];
    for(int i=0; i<[name length]; i++)
    {
        byte[j] = [name characterAtIndex:i];
        j++;
    }
    
    NSString *status = [self.answer_content substringWithRange:NSMakeRange(38, self.answer_content.length - 38)];
    for (int i = 0; i < status.length/2; i++) {
        byte[j] = (unsigned char)strtoul([[status substringWithRange:NSMakeRange(i*2, 2)] UTF8String],0,16);
        j++;
    }
    
    NSString *content = [BatterHelp getCRCCode:byte lenght:totalLengrh];
    
    return content;
}


- (NSData *)hexStringToData:(NSString *)hexString {
    int j=0;
    Byte bytes[16];
    ///3ds key的Byte 数组， 128位
    for(int i=0; i<[hexString length]; i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:16];
    
    return newData;
}

- (NSString *)getSceneColor{
    NSString *color = [self.answer_content substringWithRange:NSMakeRange(self.answer_content.length-4, 2)];
    NSString *colors = @"F0F1F2F3F4F5F6F7F8";
    if ([colors rangeOfString:color].location != NSNotFound) {
        return color;
    }else{
        return nil;
    }
//    NSNumber *count = [BatterHelp numberHexString:[self.answer_content substringWithRange:NSMakeRange(38, 4)]];
//
//    int lenth = [count intValue]*2;
//
//    if (self.answer_content!=nil&&(38 + 4 + lenth) < [self.answer_content length]) {
//
//        NSString *color = [self.answer_content substringWithRange:NSMakeRange(38 + 4 + lenth, 2)];
//
//        NSString *colors = @"F0F1F2F3F4F5F6F7F8";
//        if ([colors rangeOfString:color].location != NSNotFound) {
//            return color;
//        }else{
//            return nil;
//        }
//    }else{
//        return nil;
//    }
}


@end

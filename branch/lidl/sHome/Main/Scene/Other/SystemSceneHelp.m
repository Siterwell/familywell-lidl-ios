//
//  SystemSceneHelp.m
//  sHome
//
//  Created by shaop on 2017/2/14.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SystemSceneHelp.h"
#import "BatterHelp.h"
#import "SceneModel.h"
#import "SystemSceneDataBase.h"
#import "SceneDataBase.h"
#import "SystemSceneModel.h"

@implementation SystemSceneHelp
+ (NSString *)getSceneContent:(NSString *)name SceneId:(NSString *)sceneid ButtonCotent:(NSString *)buttoncontent sceneArray:(NSMutableArray *)selectArray color:(NSString *)color andButtonsDetail:(NSString *)buttonsDetail {
    
    NSString *content = @"";
    int contentLength = 2;
    
    NSString *colorID;

    //自定义编号
    if (!sceneid) {
        NSMutableArray *array = [[SystemSceneDataBase sharedDataBase] selectScene];
//        SystemSceneModel *model = [array objectAtIndex:array.count-1];
//        NSString *scene_id = [NSString stringWithFormat:@"%d",[model.sence_group intValue] + 1];
//        while (YES) {
//            if (![self isAddSceneId:scene_id]) {
//                scene_id = [NSString stringWithFormat:@"%d",[scene_id intValue] + 1];
//            }else{
//                break;
//            }
//        }
        int maxId = 3;
        
        for (SystemSceneModel *model in array) {

            if ([model.sence_group intValue] > maxId) {
                maxId = [model.sence_group intValue];
            }
        }
        
        NSString *scene_id = [NSString stringWithFormat:@"%d",maxId + 1];
        
        for (int i = 3 ; i <= maxId; i ++ ) {
            if ([[SystemSceneDataBase sharedDataBase] selectScene:[NSString stringWithFormat:@"%d",i]].count == 0) {
                scene_id = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }
        
        content = [BatterHelp gethexBybinary:[scene_id intValue]];
    }else{
        content = [BatterHelp gethexBybinary:[sceneid intValue]];
    }
    if (content.length == 1) {
        content = [@"0" stringByAppendingString:content];
    }
    colorID = content;
    contentLength += 1;
    
    //情景名称
    if(name == nil) {
        name = @"";
    }
    NSString *nameString = @"";
    NSStringEncoding enc = NSUTF8StringEncoding;//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [name dataUsingEncoding:enc];
    
    NSInteger countf = 15 - namedata.length;
    for(int i = 0 ; i < countf ; i++){
        nameString = [nameString stringByAppendingString:@"@"];
    }
    name = [NSString stringWithFormat:@"%@%@%@",nameString,name,@"$"];
    namedata = [name dataUsingEncoding:enc];
    name = [self convertDataToHexStr:namedata];
    content = [content stringByAppendingString:name];
    contentLength += 32;
    
    //情景开关个数
    if ([buttoncontent isEqualToString:@""]) {
        content = [content stringByAppendingString:@"00"];
        contentLength += 1;
    } else {
        content = [content stringByAppendingString:buttoncontent.length == 2 ? buttoncontent : [@"0" stringByAppendingString:buttoncontent]];
        contentLength += 1;
    }
    int ds = 0;
    for (SceneModel *model  in selectArray) {
        if([model.scene_id integerValue] < 129){
            ds ++;
        }
    }
    
  NSMutableArray *allgs361scenes = [[SceneDataBase sharedDataBase] selectSceneWithAll361];
    ds = (ds + (int)allgs361scenes.count);
    //情景个数
    NSString *sceneNumber = [BatterHelp gethexBybinary:ds];
    if (sceneNumber.length == 1) {
        sceneNumber = [@"0" stringByAppendingString:sceneNumber];
    }
    content = [content stringByAppendingString:sceneNumber];
    contentLength += 1;
    
    //多按钮具体
    if (![buttoncontent isEqualToString:@""]) {
        content = [content stringByAppendingString:buttonsDetail];
        contentLength += buttonsDetail.length/2;
    }
    Byte scene_content = 0x80;
    //情景编号
    for (SceneModel *model  in selectArray) {
        if([model.scene_id integerValue] < 129){
        NSString *index = [BatterHelp gethexBybinary:[model.scene_id integerValue]];
        if (index.length == 1) {
            index = [@"0" stringByAppendingString:index];
        }
        content = [content stringByAppendingString:index];
        contentLength += 1;
        }else{
            if([model.scene_id integerValue]==129){
                scene_content |= 0x01;
            }else if([model.scene_id integerValue]==130){
                scene_content |= 0x02;
            }else if([model.scene_id integerValue]==131){
                scene_content |= 0x04;
            }
        }

    }
    
 
    //情景编号
    for (SceneModel *model  in allgs361scenes) {
        NSString *index = [BatterHelp gethexBybinary:[model.scene_id integerValue]];
        if (index.length == 1) {
            index = [@"0" stringByAppendingString:index];
        }
        content = [content stringByAppendingString:index];
        contentLength += 1;
    }
    
    //情景灯颜色色值
    if (!color) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@"F%d",[sceneid intValue]]];
    }else if (![color isEqualToString:@"00"]) {
        content = [content stringByAppendingString:color];
    }else{
        content = [content stringByAppendingString:[NSString stringWithFormat:@"F%d",[colorID intValue]]];
    }
    contentLength += 1;

   //默认情景数据；
   content = [content stringByAppendingString:[BatterHelp gethexBybinary:scene_content]];
    
    contentLength += 1;
    //设置长度
    NSString *topString = [BatterHelp gethexBybinary:contentLength];
    if (topString.length < 4) {
        for (int i = 0; i < 4 - [BatterHelp gethexBybinary:contentLength].length; i++) {
            topString = [@"0" stringByAppendingString:topString];
        }
    }
    
    content = [topString stringByAppendingString:content];
    
    //CRCCRCRCRCRCRCRCRCRC
    
    int totalLengrh = (int)strtoul([[content substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16);
    unsigned char byte[totalLengrh];
    byte[0] = (unsigned char)strtoul([[content substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    byte[1] = (unsigned char)strtoul([[content substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
    byte[2] = (unsigned char)strtoul([[content substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
    
    int j=3;
    
    NSString *name111 = [content substringWithRange:NSMakeRange(6, 32)];
    for(int i=0; i<[name111 length]; i++)
    {
        byte[j] = [name111 characterAtIndex:i];
        j++;
    }
    
    NSString *status = [content substringWithRange:NSMakeRange(38, content.length - 38)];
    for (int i = 0; i < status.length/2; i++) {
        byte[j] = (unsigned char)strtoul([[status substringWithRange:NSMakeRange(i*2, 2)] UTF8String],0,16);
        j++;
    }
    
    NSString *crc = [BatterHelp getCRCCode:byte lenght:totalLengrh];
    
    content = [content stringByAppendingString:crc];

    return content;
}


+ (NSString *)getSceneContent:(NSString *)name SceneId:(NSString *)sceneid ButtonCotent:(NSString *)buttoncontent sceneArray:(NSMutableArray *)selectArray color:(NSString *)color andButtonsDetail:(NSString *)buttonsDetail withoutScene_group:(NSString *)scene_group {
    
    NSString *content = @"";
    int contentLength = 2;
    
    NSString *colorID;
    
    //自定义编号
    if (!sceneid) {
        NSMutableArray *array = [[SystemSceneDataBase sharedDataBase] selectScene];
        //        SystemSceneModel *model = [array objectAtIndex:array.count-1];
        //        NSString *scene_id = [NSString stringWithFormat:@"%d",[model.sence_group intValue] + 1];
        //        while (YES) {
        //            if (![self isAddSceneId:scene_id]) {
        //                scene_id = [NSString stringWithFormat:@"%d",[scene_id intValue] + 1];
        //            }else{
        //                break;
        //            }
        //        }
        int maxId = 3;
        
        for (SystemSceneModel *model in array) {
            
            if ([model.sence_group intValue] > maxId) {
                maxId = [model.sence_group intValue];
            }
        }
        
        NSString *scene_id = [NSString stringWithFormat:@"%d",maxId + 1];
        
        for (int i = 3 ; i <= maxId; i ++ ) {
            if ([[SystemSceneDataBase sharedDataBase] selectScene:[NSString stringWithFormat:@"%d",i]].count == 0) {
                scene_id = [NSString stringWithFormat:@"%d",i];
                break;
            }
        }
        
        content = [BatterHelp gethexBybinary:[scene_id intValue]];
    }else{
        content = [BatterHelp gethexBybinary:[sceneid intValue]];
    }
    if (content.length == 1) {
        content = [@"0" stringByAppendingString:content];
    }
    colorID = content;
    contentLength += 1;
    
    //情景名称
    NSString *nameString = @"";
    if(name == nil) {
        name = @"";
    }
    NSStringEncoding enc = NSUTF8StringEncoding;//CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [name dataUsingEncoding:enc];
    
    NSInteger countf = 15 - namedata.length;
    for(int i = 0 ; i < countf ; i++){
        nameString = [nameString stringByAppendingString:@"@"];
    }
    name = [NSString stringWithFormat:@"%@%@%@",nameString,name,@"$"];
    namedata = [name dataUsingEncoding:enc];
    name = [self convertDataToHexStr:namedata];
    content = [content stringByAppendingString:name];
    contentLength += 32;
    
    //情景开关个数
    if ([buttoncontent isEqualToString:@""]) {
        content = [content stringByAppendingString:@"00"];
        contentLength += 1;
    } else {
        content = [content stringByAppendingString:buttoncontent.length == 2 ? buttoncontent : [@"0" stringByAppendingString:buttoncontent]];
        contentLength += 1;
    }
    int ds = 0;
    for (SceneModel *model  in selectArray) {
        if([model.scene_id integerValue] < 129 && ![model.scene_id isEqualToString:scene_group]){
            ds ++;
        }
    }
    //情景个数
    NSString *sceneNumber = [BatterHelp gethexBybinary:ds];
    if (sceneNumber.length == 1) {
        sceneNumber = [@"0" stringByAppendingString:sceneNumber];
    }
    content = [content stringByAppendingString:sceneNumber];
    contentLength += 1;
    
    //多按钮具体
    if (![buttoncontent isEqualToString:@""]) {
        content = [content stringByAppendingString:buttonsDetail];
        contentLength += buttonsDetail.length/2;
    }
    Byte scene_content = 0x80;
    //情景编号
    for (SceneModel *model  in selectArray) {
        if([model.scene_id integerValue] < 129 && ![model.scene_id isEqualToString:scene_group]){
            NSString *index = [BatterHelp gethexBybinary:[model.scene_id integerValue]];
            if (index.length == 1) {
                index = [@"0" stringByAppendingString:index];
            }
            content = [content stringByAppendingString:index];
            contentLength += 1;
        }else{
            if([model.scene_id integerValue]==129){
                scene_content |= 0x01;
            }else if([model.scene_id integerValue]==130){
                scene_content |= 0x02;
            }else if([model.scene_id integerValue]==131){
                scene_content |= 0x04;
            }
        }
        
    }
    
    //情景灯颜色色值
    if (!color) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@"F%d",[sceneid intValue]]];
    }else if (![color isEqualToString:@"00"]) {
        content = [content stringByAppendingString:color];
    }else{
        content = [content stringByAppendingString:[NSString stringWithFormat:@"F%d",[colorID intValue]]];
    }
    contentLength += 1;
    
    //默认情景数据；
    content = [content stringByAppendingString:[BatterHelp gethexBybinary:scene_content]];
    
    contentLength += 1;
    //设置长度
    NSString *topString = [BatterHelp gethexBybinary:contentLength];
    if (topString.length < 4) {
        for (int i = 0; i < 4 - [BatterHelp gethexBybinary:contentLength].length; i++) {
            topString = [@"0" stringByAppendingString:topString];
        }
    }
    
    content = [topString stringByAppendingString:content];
    
    //CRCCRCRCRCRCRCRCRCRC
    
    int totalLengrh = (int)strtoul([[content substringWithRange:NSMakeRange(0, 4)] UTF8String],0,16);
    unsigned char byte[totalLengrh];
    byte[0] = (unsigned char)strtoul([[content substringWithRange:NSMakeRange(0, 2)] UTF8String],0,16);
    byte[1] = (unsigned char)strtoul([[content substringWithRange:NSMakeRange(2, 2)] UTF8String],0,16);
    byte[2] = (unsigned char)strtoul([[content substringWithRange:NSMakeRange(4, 2)] UTF8String],0,16);
    
    int j=3;
    
    NSString *name111 = [content substringWithRange:NSMakeRange(6, 32)];
    for(int i=0; i<[name111 length]; i++)
    {
        byte[j] = [name111 characterAtIndex:i];
        j++;
    }
    
    NSString *status = [content substringWithRange:NSMakeRange(38, content.length - 38)];
    for (int i = 0; i < status.length/2; i++) {
        byte[j] = (unsigned char)strtoul([[status substringWithRange:NSMakeRange(i*2, 2)] UTF8String],0,16);
        j++;
    }
    
    NSString *crc = [BatterHelp getCRCCode:byte lenght:totalLengrh];
    
    content = [content stringByAppendingString:crc];
    
    return content;
}


+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}





+ (BOOL)isAddSceneId:(NSString *)sceneId{
    NSMutableArray *array = [[SystemSceneDataBase sharedDataBase] selectScene];
    for (SystemSceneModel *model in array) {
        if ([model.sence_group isEqualToString:sceneId]) {
            return NO;
        }
    }
    return YES;
}
@end

//
//  Encryptools.h
//  sHome
//
//  Created by TracyHenry on 2018/8/15.
//  Copyright © 2018年 shaop. All rights reserved.
//

#ifndef Encryptools_h
#define Encryptools_h
#import <Foundation/Foundation.h>
#import "BatterHelp.h"
@interface Encryptools:NSObject
+(int)getDescryption:(int)input withMsgId:(int)msgid;

+(NSString *)getAllDescryption:(char*) input;

+(NSData *)getAllEncryption:(NSString *)input;

+(NSString *)converFromAllWithJson:(NSString *)input;
@end

#endif /* Encryptools_h */

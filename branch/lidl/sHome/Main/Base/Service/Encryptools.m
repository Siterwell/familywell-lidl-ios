//
//  Encryptools.m
//  sHome
//
//  Created by TracyHenry on 2018/8/15.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "Encryptools.h"

@implementation Encryptools

+(int)getDescryption:(int)input withMsgId:(int)msgid{
    
    int a = input ^ 0x1234;
    a= a ^ msgid;
    a = ~a;
    int output = 65536 + a ;
    Byte ds = (Byte)output;
    return ds;
}

+(NSString *)getAllDescryption:(char*) input{
    int random = input[0];
    NSString *buffer = @"";
    NSLog(@"buff：%ld",strlen(input));
    for(int i=1;i<512;i++){
        int  a1 = input[i];
        int a = random ^ 0x23 ^ a1;
        
        NSString *v = a<16?([@"0" stringByAppendingString:[BatterHelp gethexBybinary:a]]):([BatterHelp gethexBybinary:a]);
        buffer = [buffer stringByAppendingString:v];
    }
    return buffer;
}

+(NSData *)getAllEncryption:(NSString *)input{
        
        int x= [self getRandomNumber:0 to:255];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *namedata = [input dataUsingEncoding:enc];
    NSString *en = [self convertDataToHexStr:namedata];
    
    Byte result[[en length]/2+1];
        result[0] =  x;
        for(int i=0;i<en.length/2;i++){
            NSString * a = [en substringWithRange:NSMakeRange(2*i, 2)];
            int aaa = [[BatterHelp numberHexString:a] intValue];
            int b1 = (x)^(0x23)^(aaa);
            result[i+1]=b1;
        }
    
        NSData *newData = [[NSData alloc] initWithBytes:result length:([en length]/2+1)];
        return newData;
    
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

+(NSString *)converFromAllWithJson:(NSString *)input{
    int number_of_up = 0;
    BOOL flag = NO;
    for(int i=0;i<input.length;i++){

        NSString *ss = [input substringWithRange:NSMakeRange(i, 1)];
        if([ss isEqualToString:@"{"]){
            number_of_up++;
        }else if([ss isEqualToString:@"}"]){
            flag = YES;
            number_of_up--;
        }
        
        if(flag==YES && number_of_up==0){
            
            NSString *last = [input substringToIndex:(i+1)];
            
            return last;
        }
    }
    
    return @"";
}

+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from +1)));
}
@end

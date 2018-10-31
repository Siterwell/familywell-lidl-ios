//
//  NSString+CY.m
//  CYLOLBox
//
//  Created by CY on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSString+CY.h"

@implementation NSString (CY)

- (NSURL *)cy_URL {
    return [NSURL URLWithString:self];
}

+  (BOOL) isBlankString:(NSString *)string {

        if (string == nil || string == NULL) {

        return YES;

         }
           if ([string isKindOfClass:[NSNull class]]) {

         return YES;

        }

        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {

        return YES;

        }

        return NO;

}

@end

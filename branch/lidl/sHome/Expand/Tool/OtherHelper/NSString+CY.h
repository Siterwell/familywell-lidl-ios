//
//  NSString+CY.h
//  CYLOLBox
//
//  Created by CY on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+CY.h"
@interface NSString (CY)

- (NSURL *)cy_URL;
+  (BOOL) isBlankString:(NSString *)string;
@end

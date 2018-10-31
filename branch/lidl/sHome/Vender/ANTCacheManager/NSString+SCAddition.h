//
//  NSString+SCAddition.h
//  SCFramework
//
//  Created by Angzn on 3/5/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (SCAddition)

+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;

+ (NSString *)replaceNullValue:(NSString *)str;

+  (NSString*)getWeekStr:(int)num;

- (BOOL)isNotEmpty;

- (NSString *)trimWhitespaceAndNewline;

- (BOOL)containsCharacterSet:(NSCharacterSet *)set;

- (BOOL)containsString:(NSString *)string;

- (int)wordsCount;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSURL *)URL;
- (NSURL *)fileURL;

- (NSString *)MD5String;

- (BOOL)isNumber;
- (BOOL)isEnglishWords;
- (BOOL)isChineseWords;

- (BOOL)isEmail;
- (BOOL)isURL;
- (BOOL)isPhoneNumber;
- (BOOL)isMobilePhoneNumber;
- (BOOL)isIdentifyCardNumber;

- (BOOL)isValidPassword;
- (BOOL)isValidName;

- (NSDate *)dateWithFormat:(NSString *)format;

//- (NSDictionary *)paramValue;

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width maxHeight:(CGFloat)height;

- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

+ (NSString*)dateStringWithFormat:(NSString*)format withTimeInterval:(NSTimeInterval)time;


+ (NSMutableAttributedString*)withStr:(NSString*)resource minStr:(NSString*)str withFont:(CGFloat)font;

+ (CGFloat)getWidthWithAttributeStr:(NSAttributedString*)str constrainedToHeight:(CGFloat)height;

+ (CGFloat)getHeightWithAttributeStr:(NSAttributedString*)str constrainedWidth:(CGFloat)width;

+ (CGFloat)getHeightWithAttributeStr:(NSAttributedString*)str constrainedWidth:(CGFloat)width maxHeight:(CGFloat)height;

+ (NSString *)prettyDateWithReference:(NSDate *)reference;

+(NSString*) decode_emoti:(NSString*)str;

+(NSString*) encode_emoti:(NSString*)str;

+(BOOL)stringContainsEmoji:(NSString *)string;


+ (NSString*)dictionaryToJson:(NSDictionary *)dic;


@end

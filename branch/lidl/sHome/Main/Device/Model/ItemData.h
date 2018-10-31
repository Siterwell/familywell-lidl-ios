//
//  ItemData.h
//  ShelfCollectionView
//
//  Created by king.wu on 8/18/16.
//  Copyright © 2016 king.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemData : NSObject

@property (nonatomic, strong, readonly)NSString *title;
@property (nonatomic, strong, readonly)NSString *image;
@property (nonatomic, strong, readonly)NSString *status;
@property (nonatomic, strong, readonly)NSString *devID;
@property (nonatomic, strong, readonly)NSString *statuCode;
@property (nonatomic, strong, readonly)NSString *crcCode;
@property (nonatomic, strong, readonly)NSString *crcCustomTitle;
@property (nonatomic, strong, readwrite)NSString *customTitle;
@property (nonatomic) NSString *desc;

- (instancetype)initWithTitle:(NSString *)title Status:(NSString *)status DevID:(NSString *)devID Images:(NSString *)images Code:(NSString *)code;
@end

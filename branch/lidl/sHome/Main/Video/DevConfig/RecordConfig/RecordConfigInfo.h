//
//  RecordConfigInfo.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/29.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <Foundation/Foundation.h>
enum RecodeStreamType{
    RecodeStreamType_Main,
    RecodeStreamType_Sub
};

@interface RecordConfigInfo : NSObject
@property (nonatomic, assign) enum RecodeStreamType recordType;
@property (nonatomic, assign) int perRecord;
@property (nonatomic, assign) int recordLength;
@end

//
//  VideoLiveViewController.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/3.
//  Copyright © 2017年 riceFun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "VideoInfoModel.h"

@interface VideoLiveViewController : BaseVC

@property (nonatomic,strong) VideoInfoModel *vInfo;

@property (nonatomic) NSArray *videoArray;

@property (nonatomic) NSInteger selectIndex;

@end

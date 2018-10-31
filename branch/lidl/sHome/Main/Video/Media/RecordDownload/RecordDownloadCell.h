//
//  RecordDownloadCell.h
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/21.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CellDownloadStatus{
    CellDownloadStateNot,  //还未下载 正常状态  Download 默认颜色
    CellDownLoadWait,      //等待下载 Wait yellow 黄色
    CellDownloadStateDownloading,// 正在下载 Stop / 绿色
    CellDownloadStateCompleted, //下载完成   Down 橙色
}CellDownloadStatus;

@interface RecordDownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *decLbl;
@property (weak, nonatomic) IBOutlet UIImageView *recordThumbnail;//缩略图
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//日期
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//下载进度
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;//下载状态（开始，停止，异常）
@property (weak, nonatomic) IBOutlet UILabel *recordCapacityLabel;//录像大小label
@property (weak, nonatomic) IBOutlet UILabel *downProgressLabel;//百分比下载进度label
@property (nonatomic, assign) CellDownloadStatus cellStatus;//cell状态

@property (nonatomic, copy) void(^changeStatusBtnActionBlock)(CellDownloadStatus);//处理下载任务的block

- (void)setCellTextColor:(BOOL)setColorFlg;

@end

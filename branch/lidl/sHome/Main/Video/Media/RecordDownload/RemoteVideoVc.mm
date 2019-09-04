//
//  RecordDownloadViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/21.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "RemoteVideoVc.h"
#import "RecordDownloadCell.h"
#import "FunSDK/FunSDK.h"
#import "FRDatePickerView.h"
#import "NSString+Utils.h"
#import "Config.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "NSSDKDevConfig.h"
#import "Helper.h"
#import "VideoShowWindow.h"
#import "NSSDKMediaPlayer.h"
#import "SDKDataCenter.h"
#import "SelectDateViewVc.h"
#import "RecordVideoByTimeCell.h"
#import "SDKParser.h"

#import "NSString+Exsmaple.h"
#import "CustomAlertView.h"
#import "VideoOperationView.h"
#import "VideoDataBase.h"
#import "VideoLocalDataBase.h"
#import "VideoListCell.h"
#import "SliderProgressView.h"
#import "XMRulerView.h"
#import "RecordInfo.h"
#import "JhDownProgressController.h"
#import "LocalImgVdieoVc.h"
#define _K_SCREEN_WIDTH ([[UIScreen mainScreen ] bounds ].size.width)
#define kAlertWidth (245  * _K_SCREEN_WIDTH/320)

@interface RemoteVideoVc ()<NSSDKDevConfigDelegate,SDKMediaPlayerDelegate,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,assign) int currentHandle;
//@property (nonatomic, strong) NSDate *selectedDate;//选中的日期

@property (nonatomic, strong) NSSDKDevConfig *SDKDevConfig;//用于搜索录像信息

@property (nonatomic,assign) H264_DVR_FILE_DATA *pFiles;//回调数据数组

@property (nonatomic, copy) NSString *devSN;//设备序列号
@property (nonatomic, assign) int channelNum;//通道号

//controls
@property (nonatomic,strong) UIView *videoPlayView;//VideoPlayView
@property (nonatomic,strong) VideoShowWindow *videoShowWindow;//播放视图and 鱼眼VC
@property (nonatomic,strong) NSSDKMediaPlayer *player;

@property (nonatomic,assign) int nFileCount;
@property (nonatomic,strong) NSDate *fileDate;
@property (nonatomic,assign) int nSelectedIndex;
@property (nonatomic,assign) BOOL bFirst;
@property (nonatomic,strong) NSIndexPath *oldIndexPath;

@property (nonatomic,assign) BOOL playByTimeing;
@property (nonatomic,assign) H264_DVR_FILE_DATA *playByTimeEnd;

//@property (nonatomic,strong) UITableView *fileListTB;//视频列表

@property (nonatomic,assign) BOOL doTransform;

@property (nonatomic) VideoOperationView *operationView;

@property (nonatomic) UITapGestureRecognizer *tapGesture;

@property (nonatomic) BOOL isShow;

@property (nonatomic) NSTimer *videoTimer;

@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) SliderProgressView *sliderView;

@property (nonatomic) UILabel *videoTimeLabel;

@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;
@property (nonatomic, assign) int second;

@property (nonatomic) UILabel *waitingLb;
@property (strong,nonatomic) JhDownProgressController *vc;

@property (nonatomic,copy) NSString *filepath_down;
@property (nonatomic,copy) NSString *imagepath_down;
@end

@implementation RemoteVideoVc

#pragma mark lazyload
-(NSSDKDevConfig *)SDKDevConfig{
    if (!_SDKDevConfig) {
        _SDKDevConfig = [[NSSDKDevConfig alloc]init];
        _SDKDevConfig.device = self.devSN;
        _SDKDevConfig.channel = self.channelNum;
        _SDKDevConfig.delegate = self;
    }
    return _SDKDevConfig;
}

- (UILabel *)waitingLb {
    if (!_waitingLb) {
        _waitingLb = [[UILabel alloc] init];
        _waitingLb.textColor = [UIColor whiteColor];
        _waitingLb.backgroundColor = RGBA(0, 0, 0, 0.5);
        _waitingLb.text = NSLocalizedString(@"缓冲中...", nil);
        _waitingLb.textAlignment = NSTextAlignmentCenter;
        [self.videoShowWindow.showWindow addSubview:_waitingLb];
        [_waitingLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(120);
            make.height.equalTo(60);
        }];
    }
    return _waitingLb;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMenu)];
    }
    return _tapGesture;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        CGFloat w = (SCREEN_WIDTH - 45)/3.0;
        CGFloat h = w*79/108;
        layout.itemSize = CGSizeMake(w, h);
        NSLog(@"集合视图崩溃查询：%@", CGRectMake(0, SCREEN_WIDTH*9/16+44+64+30, SCREEN_WIDTH, h+20));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH*9/16+44+64+30, SCREEN_WIDTH, h+20) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[VideoListCell class] forCellWithReuseIdentifier:@"VideoListCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (SliderProgressView *)sliderView {
    if (!_sliderView) {
        
        _sliderView = [[SliderProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+7, SCREEN_WIDTH, 70)];
//        _sliderView.typeArray = array;
        _sliderView.delegate = self;
        _sliderView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_sliderView];
    }
    return _sliderView;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.sliderView) {
//        [self.player stop];
//        if (self.videoTimer) {
//            [self.videoTimer invalidate];
//            self.videoTimer = nil;
//        }
        
//        bool judge = NO;
//        NSString *str = [NSString stringWithFormat:@"%.2f",scrollView.contentOffset.x];
//        self.title = str;

        int h = scrollView.contentOffset.x / 60;
        int m = (int)scrollView.contentOffset.x % 60;

        NSString *hour = h < 10 ? [NSString stringWithFormat:@"0%d", h] : [NSString stringWithFormat:@"%d", h];
        NSString *minute = m < 10 ? [NSString stringWithFormat:@"0%d", m] : [NSString stringWithFormat:@"%d", m];
        NSString *selectTime = [NSString stringWithFormat:@"%@:%@", hour, minute];

        for (int i = 0; i < self.nFileCount; i++) {
            int forHour = self.pFiles[i].stBeginTime.hour;
            int forMin = self.pFiles[i].stBeginTime.minute;
            NSString *forHourStr = forHour < 10 ? [NSString stringWithFormat:@"0%d", forHour] : [NSString stringWithFormat:@"%d", forHour];
            NSString *forMinStr = forMin < 10 ? [NSString stringWithFormat:@"0%d", forMin] : [NSString stringWithFormat:@"%d", forMin];
            NSString *forTime = [NSString stringWithFormat:@"%@:%@", forHourStr, forMinStr];

            if ([forTime isEqualToString:selectTime]) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                _nSelectedIndex = i;

//                [self PlayByIndex:_nSelectedIndex];
//                [self.operationView.playBtn setSelected:NO];
                
                return;
            }
            
            int lastHour = self.pFiles[self.nFileCount-1].stBeginTime.hour;
            int lastMin = self.pFiles[self.nFileCount-1].stBeginTime.minute;
            CGFloat offset = lastHour * 60 + lastMin;
            if (scrollView.contentOffset.x >= offset) {
                [self.sliderView setContentOffset:CGPointMake(offset, 0) animated:YES];
                _nSelectedIndex = self.nFileCount - 1;

                return;
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.sliderView) {
        [self PlayByIndex:_nSelectedIndex];
        [self.operationView.playBtn setSelected:NO];
    }
}

- (void)showOrHideMenu {
    if (self.isShow == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.operationView setFrame:CGRectMake(25, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, 44, self.view.frame.size.width)];
        } completion:^(BOOL finished) {
            self.isShow = YES;
        }];
        
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [self.operationView setFrame:CGRectMake(-44, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, 44, self.view.frame.size.width)];
        } completion:^(BOOL finished) {
            self.isShow = NO;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    self.title = NSLocalizedString(@"远程视频", nil);
    
    self.player = [[NSSDKMediaPlayer alloc] init];
    self.player.playType = RecordPlay;
    [self.player setSound:100];
    self.player.delegate = self;
    
    self.devSN = [[SDKDataCenter instance] OptDeviceSN];
    self.channelNum = [[SDKDataCenter instance] OptChannelNum];
    
    self.isShow = YES;
    [self layOutSubviews];

    [self SearchFiles];     //获取设备里录像文件列表
}

- (void)viewWillAppear:(BOOL)animated{
    self.playByTimeing = NO;
    [self.view.window endEditing:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self.fileDate];
    self.title = dateString;    
}

- (void)viewDidDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    if(self.player!=nil){
        [self.player stop];
    }
    [self.videoTimer invalidate];
    _videoTimer = nil;
}

-(void)layOutSubviews{
    //顶部播放
    //VideoPlayView
    self.videoShowWindow = [[VideoShowWindow alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, self.view.frame.size.width, self.view.frame.size.width*9/16)];
    self.videoShowWindow.parentVC = self;
    self.player.fishDelegate = self.videoShowWindow;
    [self.view addSubview:self.videoShowWindow.showWindow];
    
    //获取当前日期
    self.fileDate = [NSDate date];
    
    //视频列表
    __weak typeof(self) weakSelf = self;
    _operationView = [[VideoOperationView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.videoShowWindow.showWindow.frame), SCREEN_WIDTH, 44)];
    _operationView.playBtnClickBlock = ^{
        
        if (self.player != nil) {
            if (self.player.playState == ENSMEDIA_STATE_PLAY) {
                [weakSelf.player pause:YES];
                
                [weakSelf.videoTimer invalidate];
                _videoTimer = nil;
                
            } else if (self.player.playState == ENSMEDIA_STATE_PAUSE) {
                [weakSelf PlayByIndex:weakSelf.nSelectedIndex];
            }
        }
    };
    _operationView.soundBtnClickBlock = ^{
//        [weakSelf.videoTimer invalidate];
//        _videoTimer = nil;
        
        if (self.player != nil) {
            if (self.player.nSound != 0) {
                [weakSelf.player setSound:0];
            } else {
                [weakSelf.player setSound:100];
            }
        }
    };
    _operationView.captureBtnClickBlock = ^{
        [weakSelf.player snapImage:[NSString getJPGFilePath:weakSelf.devSN Channel:weakSelf.channelNum]];
    };
    _operationView.fullBtnClickBlock = ^{
        [weakSelf fullScreenRecord];
    };
    [self.view addSubview:_operationView];
    
    UILabel *redline = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,self.sliderView.frame.origin.y-3.5, 1, 70+7)];
    redline.backgroundColor = [UIColor redColor];
    [self.view addSubview:redline];
    
    
    //日期选择
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"calendar_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(selectDate)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIView *blue = [[UIView alloc] init];
    blue.backgroundColor = RGB(5, 128, 255);
    [self.view addSubview:blue];
    [blue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(12);
        make.width.height.equalTo(12);
        make.bottom.equalTo(-15);
    }];
    
    UILabel *normal = [[UILabel alloc] init];
    normal.text = NSLocalizedString(@"普通录像", nil);
    normal.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:normal];
    [normal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blue.mas_right).offset(8);
        make.centerY.equalTo(blue);
    }];
    
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = RGB(215, 50, 143);
    [self.view addSubview:red];
    [red mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(blue.mas_top).offset(-10);
        make.centerX.width.height.equalTo(blue);
    }];
    
    UILabel *alarm = [[UILabel alloc] init];
    alarm.text = NSLocalizedString(@"报警录像", nil);
    alarm.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:alarm];
    [alarm makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(red.mas_right).offset(8);
        make.centerY.equalTo(red);
    }];
    
    
    self.videoTimeLabel = [[UILabel alloc] init];
//    self.videoTimeLabel.backgroundColor = [UIColor greenColor];
    self.videoTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.videoTimeLabel];
    [self.videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(normal.mas_right).offset(8);
        make.centerY.equalTo(blue);
        make.height.equalTo(alarm);
        make.width.equalTo(100);
    }];
    
}

- (void)fullScreenRecord {
    if (self.videoShowWindow.screenFullState == ShowWindowScreenNoFull) {
        [UIView animateWithDuration:0.5 animations:^{
            self.videoShowWindow.showWindow.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.videoShowWindow.showWindow.bounds = CGRectMake(0, 0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.superview.bounds));
            self.videoShowWindow.showWindow.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
            [self.view bringSubviewToFront:self.videoShowWindow.showWindow];
            [self.view bringSubviewToFront:self.operationView];    
            self.navigationController.navigationBar.hidden = YES;
            self.operationView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.operationView.frame = CGRectMake(25, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, 44, self.view.frame.size.width);
            [self.operationView.fullBtn setImage:[UIImage imageNamed:@"narrow_icon"] forState:UIControlStateNormal];
            
        } completion:^(BOOL finished) {
            self.videoShowWindow.screenFullState = ShowWindowScreenFull;
            [self.videoShowWindow.showWindow addGestureRecognizer: self.tapGesture];
        }];
        
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.videoShowWindow.showWindow.transform = CGAffineTransformIdentity;
            self.operationView.transform = CGAffineTransformIdentity;
            [self.videoShowWindow.showWindow setFrame:CGRectMake(0, TOP_HEIGHT, self.view.frame.size.width, self.view.frame.size.width*9/16)];
            [self.operationView setFrame:CGRectMake(0, CGRectGetMaxY(self.videoShowWindow.showWindow.frame), SCREEN_WIDTH, 44)];
            self.navigationController.navigationBar.hidden = NO;
            [self.operationView.fullBtn setImage:[UIImage imageNamed:@"enlarge_icon"] forState:UIControlStateNormal];
            
        } completion:^(BOOL finished) {
            self.videoShowWindow.screenFullState = ShowWindowScreenNoFull;
            [self.videoShowWindow.showWindow removeGestureRecognizer:self.tapGesture];
        }];
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.playByTimeing) {
        return 1;
    }
    return self.nFileCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoListCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    if (self.pFiles && indexPath.row < self.nFileCount) {
        H264_DVR_FILE_DATA *pFile = &self.pFiles[indexPath.row];
        cell.timeString = [NSString stringWithFormat:@"%02d:%02d:%02d",
                               pFile->stBeginTime.hour,
                               pFile->stBeginTime.minute,
                               pFile->stBeginTime.second];
    }
    
    UILongPressGestureRecognizer *lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(readyToDownloadItem:)];
    lpGes.minimumPressDuration = 0.8f;
    [cell addGestureRecognizer:lpGes];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.videoTimer invalidate];
    self.videoTimer = nil;
    
    if (!self.playByTimeing) {
        if (self.pFiles && indexPath.row < self.nFileCount) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍后...", nil)];
            _nSelectedIndex = indexPath.row;
            [self PlayByIndex:_nSelectedIndex];
            [self.operationView.playBtn setSelected:NO];
        }
        
    }else{
        [self PlayByTime:_playByTimeEnd->stBeginTime.hour Minute:_playByTimeEnd->stBeginTime.minute Seconde:_playByTimeEnd->stBeginTime.second endHour:_playByTimeEnd->stEndTime.hour endMinute:_playByTimeEnd->stEndTime.minute endSeconde:_playByTimeEnd->stEndTime.second];
    }
}

- (void)selectDate{
    SelectDateViewVc *selectView = [[SelectDateViewVc alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectView];
    [self presentViewController:nav animated:YES completion:nil];
    __weak __typeof(self)weakSelf = self;
    selectView.selectCalendarBlock = ^(NSString *date){
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
        weakSelf.fileDate = [dateFormat dateFromString:date];
        
        if (!weakSelf.playByTimeing) {
            [weakSelf SearchFiles];
        }else{
            [weakSelf SearchFileByTime];
        }
    };
}

-(void)SearchFiles{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍后...", nil)];
    self.playByTimeing = NO;
    H264_DVR_FINDINFO info = {0};
    
    NSInteger year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0, nanosecond = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar getEra:nil year:&year month:&month day:&day fromDate:self.fileDate];
    
    info.startTime.dwYear = info.endTime.dwYear = year;
    info.startTime.dwMonth = info.endTime.dwMonth = month;
    info.startTime.dwDay = info.endTime.dwDay = day;
    info.startTime.dwHour = 0;
    info.endTime.dwHour = 23;
    info.startTime.dwMinute = 0;
    info.endTime.dwMinute = 59;
    info.startTime.dwSecond = 0;
    info.endTime.dwSecond = 59;
    
    [self.SDKDevConfig FindFile:&info MaxCount:1728];
    
}

- (void)SearchFileByTime{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍后...", nil)];
    self.playByTimeing = YES;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self.fileDate];
    
    int endHour = (int) [dateComponent hour];
    int endMM = (int) [dateComponent minute];
    int endSS = (int) [dateComponent second];
    
    if ([self compareOneDay:[NSDate new] withAnotherDay:self.fileDate] > 0) {
        endHour = 23;
        endMM = 59;
        endSS = 59;
    }
    
    _playByTimeEnd = new H264_DVR_FILE_DATA[1];
    
    _playByTimeEnd->stBeginTime.hour = 0;
    _playByTimeEnd->stBeginTime.minute = 0;
    _playByTimeEnd->stBeginTime.second = 0;
    
    _playByTimeEnd->stEndTime.hour = endHour;
    _playByTimeEnd->stEndTime.minute = endMM;
    _playByTimeEnd->stEndTime.second = 0;
    
    [self PlayByTime:0 Minute:0 Seconde:0 endHour:endHour endMinute:endMM endSeconde:endSS];
    
//    [self.fileListTB reloadData];
    [self.collectionView reloadData];
    
}

- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
}


#pragma mark TableViewdelegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.playByTimeing) {
        return 1;
    }
    return self.nFileCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.playByTimeing) {
        static NSString *reuseID = @"ByTimeCell";
        RecordVideoByTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"RecordVideoByTimeCell" owner:nil options:nil] firstObject];//使用xib这么写
        }
        cell.byTimeLbl.text = [NSString stringWithFormat:@"%02d:%02d:%02d-%02d:%02d:%02d",
                               _playByTimeEnd->stBeginTime.hour,
                               _playByTimeEnd->stBeginTime.minute,
                               _playByTimeEnd->stBeginTime.second,
                               _playByTimeEnd->stEndTime.hour,
                               _playByTimeEnd->stEndTime.minute,
                               _playByTimeEnd->stEndTime.second];
        cell.byTimeLbl.textColor = ThemeColor;
        return cell;
        
    }else{
        static NSString *reuseID = @"riceFun";
        RecordDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell= [[[NSBundle mainBundle]loadNibNamed:@"RecordDownloadCell" owner:nil options:nil] firstObject];//使用xib这么写
        }
        if (self.pFiles && indexPath.row < self.nFileCount) {
            H264_DVR_FILE_DATA *pFile = &self.pFiles[indexPath.row];
            cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d-%02d:%02d:%02d",
                                   pFile->stBeginTime.hour,
                                   pFile->stBeginTime.minute,
                                   pFile->stBeginTime.second,
                                   pFile->stEndTime.hour,
                                   pFile->stEndTime.minute,
                                   pFile->stEndTime.second];
        }
        cell.recordThumbnail.backgroundColor = [UIColor grayColor];
        if (self.oldIndexPath == indexPath) {
            [cell setCellTextColor:YES];
        }else{
            [cell setCellTextColor:NO];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.playByTimeing) {
        
        if (self.pFiles && indexPath.row < self.nFileCount) {
            [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍后...", nil)];
            _nSelectedIndex = indexPath.row;
            [self PlayByIndex:_nSelectedIndex];
        }
        
        if (_oldIndexPath != nil) {
            RecordDownloadCell *cell = [tableView cellForRowAtIndexPath:_oldIndexPath];
            [cell setCellTextColor:NO];
        }
        
        RecordDownloadCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setCellTextColor:YES];
        _oldIndexPath = indexPath;
    }else{
        [self PlayByTime:_playByTimeEnd->stBeginTime.hour Minute:_playByTimeEnd->stBeginTime.minute Seconde:_playByTimeEnd->stBeginTime.second endHour:_playByTimeEnd->stEndTime.hour endMinute:_playByTimeEnd->stEndTime.minute endSeconde:_playByTimeEnd->stEndTime.second];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)PlayByIndex:(int)index{
    if (index < 0 || index >= self.nFileCount) {
        return;
    }
    _nSelectedIndex = index;
    [self PlayByTime:self.pFiles[index].stBeginTime.hour
              Minute:self.pFiles[index].stBeginTime.minute
             Seconde:self.pFiles[index].stBeginTime.second endHour:self.pFiles[index].stEndTime.hour endMinute:self.pFiles[index].stEndTime.minute endSeconde:self.pFiles[index].stEndTime.second ];
}

-(void)PlayByTime:(int)hour Minute:(int)minute Seconde:(int)seconde endHour:(int)eHour endMinute:(int)eMinute endSeconde:(int)eSeconde{
//    [MBProgressHUD hideHUDForView:self.view];
//    [MBProgressHUD showMessage:@"缓冲中" ToView:self.view RemainTime:7.f];
    
    for (VideoListCell *cell in self.collectionView.visibleCells) {
        [cell.cover setImage:[UIImage imageNamed:@"lbt_02"]];
    }
    VideoListCell *cell = (VideoListCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_nSelectedIndex inSection:0]];
    [cell.cover setImage:[UIImage imageNamed:@"lbt_01"]];
    
    self.waitingLb.hidden = NO;
    if ([self.devSN length] == 0) {
        return;
    }
    
    NSInteger year = 0, month = 0, day = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar getEra:nil year:&year month:&month day:&day fromDate:self.fileDate];
    
    H264_DVR_FINDINFO info = {0};
    info.startTime.dwYear = info.endTime.dwYear = year;
    info.startTime.dwMonth = info.endTime.dwMonth = month;
    info.startTime.dwDay = info.endTime.dwDay = day;
    info.startTime.dwHour = hour;
    info.startTime.dwMinute = minute;
    info.startTime.dwSecond = seconde;
    info.endTime.dwHour = eHour;
    info.endTime.dwMinute = eMinute;
    info.endTime.dwSecond = eSeconde;
    info.nChannelN0 = self.channelNum;
    [self.player play:self.devSN
               andWnd:[self.videoShowWindow getAndShowWindow]
         PlayTimeInfo:&info
               andSeq:self.nSelectedIndex];
}


#pragma mark lazyload
-(void)OnPlay:(NSSDKMediaPlayer *)sender Result:(int)result Param1:(int)Param1{
    if (self.videoTimer) {
        [self.videoTimer invalidate];
        _videoTimer = nil;
    }
    int hour = self.pFiles[_nSelectedIndex].stBeginTime.hour;
    int minute = self.pFiles[_nSelectedIndex].stBeginTime.minute;
    int timeLength = hour*60 + minute;
    [self.sliderView setContentOffset:CGPointMake(timeLength, 0) animated:YES];
    
    if (result < 0) {
//        [MBProgressHUD hideHUDForView:self.view];
//        [SVProgressHUD dismiss];
        self.waitingLb.hidden = YES;
       [SVProgressHUD showErrorWithStatus: [SDKParser parseError:result] duration:3];
    } else {
        self.waitingLb.hidden = YES;
        [MBProgressHUD hideHUDForView:self.view];
        [self.player setSound:100];
        [SVProgressHUD dismiss];
        self.hour = self.pFiles[_nSelectedIndex].stBeginTime.hour;
        self.minute = self.pFiles[_nSelectedIndex].stBeginTime.minute;
        self.second = self.pFiles[_nSelectedIndex].stBeginTime.second;
        
        NSString *h = self.hour < 10 ? [NSString stringWithFormat:@"0%d", self.hour] : [NSString stringWithFormat:@"%d", self.hour];
        NSString *m = self.minute < 10 ? [NSString stringWithFormat:@"0%d", self.minute] : [NSString stringWithFormat:@"%d", self.minute];
        NSString *s = self.second < 10 ? [NSString stringWithFormat:@"0%d", self.second] : [NSString stringWithFormat:@"%d", self.second];
        self.videoTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@", h, m, s];

//
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(changeVideoTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.videoTimer = timer;
//            self.videoTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(changeVideoTime) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop] addTimer:self.videoTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)changeVideoTime {
    if (self.second < 59) {
        self.second += 1;
    }else if (self.second == 59) {
        self.second = 0;
        
        if (self.minute < 59) {
            self.minute += 1;
        } else if (self.minute == 59){
            self.minute = 0;
            self.hour += 1;
        }
    }
    
    NSString *h = self.hour < 10 ? [NSString stringWithFormat:@"0%d", self.hour] : [NSString stringWithFormat:@"%d", self.hour];
    NSString *m = self.minute < 10 ? [NSString stringWithFormat:@"0%d", self.minute] : [NSString stringWithFormat:@"%d", self.minute];
    NSString *s = self.second < 10 ? [NSString stringWithFormat:@"0%d", self.second] : [NSString stringWithFormat:@"%d", self.second];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@", h, m, s];
     });
//    self.videoTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@", h, m, s];
    
}

-(void)OnPause:(NSSDKMediaPlayer *)sender Result:(int)result CurState:(int)state{
}

-(void)OnPlayEnd:(NSSDKMediaPlayer *)sender{
}

-(void)OnPlayInfo:(NSSDKMediaPlayer *)sender StrInfo:(const char *)szStr Param1:(int)Param1 Param2:(int)Param2{
    
}

//string -> date
-(NSDate *)dateFromDateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

// date -> string
-(NSString *)dateStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
//- (void)OnSDKSeachFile:(NSSDKDevConfig *)sender Files:(H264_DVR_FILE_DATA *)pFiles Result:(int)nResult {
//    [SVProgressHUD dismiss];
//}
-(void)OnSDKSeachFile:(NSSDKDevConfig *)sender Files:(H264_DVR_FILE_DATA *)pFiles Result:(int)nResult{
    [SVProgressHUD dismiss];

    self.nFileCount = 0;
    self.nSelectedIndex = -1;
    if (self.pFiles != NULL) {
        delete [] self.pFiles;
        self.pFiles = NULL;
    }
    if (nResult > 0) {
        self.pFiles = new H264_DVR_FILE_DATA[nResult];
        self.nFileCount = nResult;
        self.nSelectedIndex = nResult - 1;
        memcpy(self.pFiles, pFiles, sizeof(H264_DVR_FILE_DATA) * nResult);
    }
    [self.collectionView reloadData];

    if (nResult < 0 && nResult != EE_MENTSDK_NOFILEFOUND) {
        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:nResult] duration:3];
    }
    else if (nResult > 0) {
        _oldIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self PlayByIndex:0];
    }
    else if (nResult == EE_MENTSDK_NOFILEFOUND) {
        [SVProgressHUD showErrorWithStatus: NSLocalizedString(@"视频不存在", nil) duration:3];
    }
    else {
        [SVProgressHUD dismiss];
    }

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.nFileCount; i++) {
        int startHour = self.pFiles[i].stBeginTime.hour;
        int startMin = self.pFiles[i].stBeginTime.minute;
        int startSec = self.pFiles[i].stBeginTime.second;

        int endMin = self.pFiles[i].stEndTime.minute;
        int endHour = self.pFiles[i].stEndTime.hour;
        int endSec = self.pFiles[i].stEndTime.second;

        NSString *str = [NSString stringWithFormat:@"%s", self.pFiles[i].sFileName];
        NSArray *strArray = [str componentsSeparatedByString:@"["];
        NSString *type = [strArray[1] substringWithRange:NSMakeRange(0, 1)];

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:type forKey:@"type"];
        [dict setValue:@(startHour) forKey:@"startHour"];
        [dict setValue:@(startMin) forKey:@"startMin"];
        [dict setValue:@(startSec) forKey:@"startSec"];
        
        [dict setValue:@(endHour) forKey:@"endHour"];
        [dict setValue:@(endMin) forKey:@"endMin"];
        [dict setValue:@(endSec) forKey:@"endSec"];

        [array addObject:dict];
    }
    self.sliderView.typeArray = array;
    [self.sliderView setContentOffset:CGPointMake(0, 0) animated:NO];
    if ([self.collectionView numberOfItemsInSection:0] > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

-(void)OnSDKSeachFileByTime:(NSSDKDevConfig *)sender Files:(SDK_SearchByTimeInfo *)pFiles Result:(int)nResult{
    
    [SVProgressHUD dismiss];
    
    self.nFileCount = 0;
    self.nSelectedIndex = -1;
    if (self.pFiles != NULL) {
//        delete [] self.pFiles;
//        self.pFiles = NULL;
    }

    [self.collectionView reloadData];
    
    if (nResult < 0 && nResult != EE_MENTSDK_NOFILEFOUND) {
        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:nResult] duration:3];
    }
}

- (void)OnSDKSearchDevice:(int)param2 Data:(SDK_CONFIG_NET_COMMON_V2 *)pData {
    
}


- (void)getConfig:(DeviceConfig *)config result:(int)result {
    
}


- (void)setConfig:(DeviceConfig *)config result:(int)result {
    
}


//保存到系统相册  回调
- (void)videopath:(NSString*)videopath didFinishSavingVideoWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorWithStatus:TS("save_f")];
    } else {
        [SVProgressHUD showSuccessWithStatus:TS("Successfully_savedto_photoalbum") duration:3.0];
    }
}

- (void)OnSnapImage:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath {
    if (filePath!=nil) {
        
        if (![filePath hasSuffix:@"currentImage.jpg"]) {
            
            UIView *imgBgView = [[UIView alloc] init];
            
            UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:filePath];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAlertWidth - 20, (kAlertWidth - 20)*9/16)];
            
            [imgView setImage:imgFromUrl3];
            
            [imgBgView addSubview:imgView];
            imgBgView.backgroundColor = [UIColor whiteColor];
            
            [CustomAlertView popViewWithTitle:NSLocalizedString(@"预览", nil) contentText:imgBgView contentFrame:CGRectMake(20, 10, kAlertWidth - 20, (kAlertWidth - 20)*9/16) bottomView:nil bottomFrame:CGRectZero transform:_doTransform leftButtonTitle:NSLocalizedString(@"删除", nil)  rightButtonTitle:NSLocalizedString(@"保存", nil) leftBlock:^{
                //删除本地图片
                if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
                {
                    [[NSFileManager defaultManager]  removeItemAtPath:filePath error:nil];
                }
            } rightBlock:^{
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
                
                //                                  VideoInfoModel *imgInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:self.deviceSn];
                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
                VideoInfoModel *imgInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:self.devSN andUserName:userName];
                
                VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                vInfo.filePath = filePath;
                vInfo.fileName = [filePath substringFromIndex:([filePath length] - 38)];
                vInfo.updataTime = strDate;
                vInfo.devid = self.devSN;
                vInfo.infoType = 1;
                
                if (imgInfo!=nil) {
                    vInfo.imagePath = imgInfo.imagePath;
                }
                
                [[VideoLocalDataBase sharedDataBase] updateVideoInfo:vInfo];
                
                [self loadImageFinished:imgFromUrl3];
            } dismissBlock:^{
                
            }];
        } else {
            //保存到沙盒中
            //            self.vInfo.imagePath = filePath;
            //            [[VideoDataBase sharedDataBase] updateVideoInfo:[x].vInfo];
        }
    }
}

- (void)OnSnapThumbnail:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath {
    
}


- (void)OnStartRecord:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath {
    
}


- (void)OnStopRecord:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath {
    
}


- (void)loadImageFinished:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo { }


- (void)readyToDownloadItem:(UILongPressGestureRecognizer *)ges {
    
    VideoListCell *cell = (VideoListCell *)[ges view];
    int index = (int)cell.tag;
    H264_DVR_FILE_DATA *pFile = &self.pFiles[index];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确定下载到手机", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self downloadThumbImage:pFile];
        [self downloadFile:pFile];
        [self showFireLoading];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -delegate
-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
#pragma mark 开始下载录像回调
        case EMSG_ON_FILE_DOWNLOAD: {// 开始下载
            
        }
            break;
#pragma mark 录像下载的进度
        case EMSG_ON_FILE_DLD_POS:  {//下载的进度
            
        }
            break;
#pragma mark 录像下载完成
        case EMSG_ON_FILE_DLD_COMPLETE: { //下载完成
            if ( msg->param1 >= 0) {
                if(_filepath_down!=nil&&_imagepath_down!=nil){
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
                    
                    
                    if(_vc!=nil){
                        _vc.success = YES;
                    }
                    VideoInfoModel *model = [[VideoInfoModel alloc] init];
                    model.devid = self.devSN;
                    model.imagePath = _imagepath_down;
                    
                    model.filePath = _filepath_down;
                    model.fileName = [_filepath_down substringFromIndex:(_filepath_down.length - 39)];
                    
                    
                    model.updataTime = strDate;
                    model.infoType = 2;
                    NSLog(@"视频路径:%@",model.filePath);
                    NSLog(@"视频名称:%@",model.fileName);
                    [[VideoLocalDataBase sharedDataBase] updateVideoInfo:model];
                }
                _filepath_down = nil;
                _imagepath_down = nil;
            }

        }
            break;
#pragma mark -开始下载缩略图
        case EMSG_DOWN_RECODE_BPIC_START:{
            if ( msg->param1 < 0) {
                //失败
            }else{
                //开始下载
            }
        }             break;
#pragma mark -下载缩略图
        case EMSG_DOWN_RECODE_BPIC_FILE:{
            if ( msg->param1 < 0) {
                //失败
            }else{
            }
        }
            break;
#pragma mark - 缩略图下载完成
        case EMSG_DOWN_RECODE_BPIC_COMPLETE:{
            if ( msg->param1 < 0) {
                //失败
            }else{
                
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark 开始下载录像缩略图
- (void)downloadThumbImage:(H264_DVR_FILE_DATA*)record {
    //获取通道
    
    
    //下载路径
    NSString *directoryPath = @"/Library/Caches/Images/";
    NSString *timeString = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",record->stBeginTime.year,record->stBeginTime.month,record->stBeginTime.day,record->stBeginTime.hour,record->stBeginTime.minute,record->stBeginTime.second];
    NSString *pictureFilePath  = [directoryPath stringByAppendingFormat:@"%@%@.jpg",self.deviceSN,timeString];
    _imagepath_down = pictureFilePath;
    int downLoadThunmbnilTime = [self getRecordTimeWith:record];
    NSString *path_sandox = NSHomeDirectory();
    NSString *dd = [path_sandox stringByAppendingString:pictureFilePath];
    FUN_DownloadRecordBImage(self.MsgHandle, CSTR(self.devSN), 0, downLoadThunmbnilTime, CSTR(dd), 0, 0);
}

#pragma mark - 开始下载录像
- (void)downloadFile:(H264_DVR_FILE_DATA*)record {
    
    //初始化请求结构体
    H264_DVR_FILE_DATA info;
    memset(&info, 0, sizeof(info));
    info.size  = (int)record->size;
    //开始时间
    SDK_SYSTEM_TIME timeBegin = record->stBeginTime;
    memcpy(&info.stBeginTime,  (char *)&timeBegin, sizeof(SDK_SYSTEM_TIME));
    //结束时间
    SDK_SYSTEM_TIME timeEnd = record->stEndTime;
    memcpy(&info.stEndTime, (char*)&timeEnd,sizeof(SDK_SYSTEM_TIME));
    //通道号
    strncpy(info.sFileName, record->sFileName, sizeof(info.sFileName));
    info.ch = (int)record->ch;
    
    //存储路径
    NSString *directoryPath = @"/Library/Caches/Videos/";
    NSString *timeString = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",record->stBeginTime.year,record->stBeginTime.month,record->stBeginTime.day,record->stBeginTime.hour,record->stBeginTime.minute,record->stBeginTime.second];
    //后缀   如果是鱼眼设备，需要特殊保存，然后用鱼眼播放器进行播放，参考鱼眼视频剪切和本地播放
    //    if (self.isFish) {
    //        movieFilePath = [directoryPath stringByAppendingFormat:@"/%@.fvideo",timeString];
    //    }
    NSString *movieFilePath  = [directoryPath stringByAppendingFormat:@"%@%@.mp4",self.devSN,timeString];
    //开始下载
    _filepath_down = movieFilePath;
    NSString *path_sandox = NSHomeDirectory();
    NSString *dd = [path_sandox stringByAppendingString:movieFilePath];
    FUN_DevDowonLoadByFile(self.MsgHandle, SZSTR(self.devSN), &info, SZSTR(dd));
}

-(int)getRecordTimeWith:(H264_DVR_FILE_DATA *)record{
    //开始时间
    SDK_SYSTEM_TIME timeBegin = record->stBeginTime;
    SDK_SYSTEM_TIME nTime;
    nTime.year = timeBegin.year;
    nTime.month = timeBegin.month;
    nTime.wday = timeBegin.wday;
    nTime.day = timeBegin.day;
    nTime.hour = timeBegin.hour;
    nTime.minute = timeBegin.minute;
    nTime.second = timeBegin.second;
    nTime.isdst = timeBegin.isdst;
    
    time_t ToTime_t(SDK_SYSTEM_TIME *time);
    
    return (int)ToTime_t(&nTime);
}


-(void) closefirem{
    _vc.success = YES;
}


-(void)showFireLoading{
    @weakify(self)
    _vc=[[JhDownProgressController alloc] init];
    _vc.timer1 = 1.0f;
    _vc.timerApi = 5.0f;
    _vc.hintMessage = NSLocalizedString(@"正在下载", nil);
    _vc.finish = ^(BOOL success){
        if(!success){
            _filepath_down = nil;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"下载失败", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self)
                [self showFireLoading];
                
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }else{
            _filepath_down = nil;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"下载成功", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"查看", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self)
                LocalImgVdieoVc *local = [[LocalImgVdieoVc alloc] init];
                local.devsn = self.devSN;
                local.ivFlag = 1;
                [self.navigationController pushViewController:local animated:YES];
                
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        
    };

    GetWindow.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    _vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [GetWindow.rootViewController presentViewController:_vc animated:NO completion:^{
        
    }];
    
}

@end

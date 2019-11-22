//
//  RemoteVideoVc.m
//  sHome
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "RemoteImageVc.h"
#import "LocalVideoVcCell.h"
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
#import "NavigationViewController.h"
#import "SDKParser.h"

// 弱引用
#define MJWeakSelf __weak typeof(self) weakSelf = self;

@interface RemoteImageVc ()<NSSDKDevConfigDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) int currentHandle;
@property (nonatomic, strong) NSDate *selectedDate;//选中的日期

@property (nonatomic, strong) NSSDKDevConfig *SDKDevConfig;//用于搜索录像信息

@property (nonatomic,assign) H264_DVR_FILE_DATA *pFiles;//回调数据数组

@property (nonatomic, copy) NSString *devSN;//设备序列号
@property (nonatomic, assign) int channelNum;//通道号

@property (nonatomic, strong) BottomImageView *bView;

//controls
@property (nonatomic,strong) UIView *videoPlayView;//VideoPlayView
@property (nonatomic,strong) VideoShowWindow *videoShowWindow;//播放视图and 鱼眼VC
@property (nonatomic,strong) NSSDKMediaPlayer *player;

@property (nonatomic,assign) int nFileCount;
@property (nonatomic,strong) NSDate *fileDate;
@property (nonatomic,assign) int nSelectedIndex;
@property (nonatomic,assign) BOOL bFirst;

@property (nonatomic,strong) UITableView *fileListTB;//视频列表
@property (nonatomic,assign) SDK_File_Type fileType;

@end

@implementation RemoteImageVc

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"远程截图", nil);
    
    self.devSN = [[SDKDataCenter instance] OptDeviceSN];
    self.channelNum = [[SDKDataCenter instance] OptChannelNum];
    
    [self layOutSubviews];
    
    [self SearchFiles:SDK_PIC_ALL];//获取设备里录像文件列表
}

-(void)layOutSubviews{
    //设置中间导航栏的button
    //    [self setCenterBtnText:TS("Choose Device")];
    
    //获取当前日期
    self.fileDate = [NSDate date];
    
    self.fileListTB = [[UITableView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT,SCREEN_WIDTH,SCREEN_HEIGHT )];
    self.fileListTB.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.fileListTB.delegate = self;
    self.fileListTB.dataSource = self;
    [self.view addSubview:self.fileListTB];
    
//    _bView = [[BottomImageView alloc] initWithFrame:CGRectMake(0,TOP_HEIGHT + self.fileListTB.frame.size.height, self.view.frame.size.width, 40)];
//    [self.view addSubview:_bView];
    
    _bView.allBtn.tag = 10;
    [_bView.allBtn addTarget:self action:@selector(SearchFilesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _bView.alramBtn.tag = 11;
    [_bView.alramBtn addTarget:self action:@selector(SearchFilesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _bView.ctrBtn.tag = 12;
    [_bView.ctrBtn addTarget:self action:@selector(SearchFilesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _bView.dateBtn.tag = 13;
    [_bView.dateBtn addTarget:self action:@selector(SearchFilesAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //日期选择
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"日期", nil) style:UIBarButtonItemStylePlain target:self action:@selector(selectDate)];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"01-日历"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(selectDate)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)selectDate{
    
    SelectDateViewVc *selectView = [[SelectDateViewVc alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectView];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    
    __weak __typeof(self)weakSelf = self;
    selectView.selectCalendarBlock = ^(NSString *date){
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
        weakSelf.fileDate = [dateFormat dateFromString:date];
        [weakSelf SearchFiles:weakSelf.fileType];
    };
}

- (void)SearchFilesAction:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    switch (btn.tag) {
        case 10:
            self.fileType = SDK_PIC_ALL;
               [self SearchFiles:SDK_PIC_ALL];
            break;
        case 11:
            self.fileType = SDK_PIC_ALARM;
            [self SearchFiles:SDK_PIC_ALARM];
            break;
        case 12:
            self.fileType = SDK_PIC_MANUAL;
            [self SearchFiles:SDK_PIC_MANUAL];
            break;
        case 13:
            self.fileType = SDK_PIC_REGULAR;
            [self SearchFiles:SDK_PIC_REGULAR];
            break;
            
        default:
            break;
    }
}

////显示日期
//- (void)changeDateButtonText{
//    NSLog(@"%@----------------",self.selectedDate);
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:self.selectedDate];
//    //显示当前日期
////    [self setRightBtnText:dateString];
//}



-(void)SearchFiles:(SDK_File_Type)fileType{
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍后...", nil)];
    
    H264_DVR_FINDINFO info = {0,10};
    
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
    
    [self.SDKDevConfig FindFile:&info MaxCount:9999];
}

- (void)SearchFilesByTime{
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"请稍后...", nil)];
    
    SDK_SearchByTime info = {0};
    
    NSInteger year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0, nanosecond = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar getEra:nil year:&year month:&month day:&day fromDate:self.fileDate];
    
    NSDateFormatter *formatterHH = [[NSDateFormatter alloc] init];
    [formatterHH setDateFormat:@"hh"];
    
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self.fileDate];
    
    int endHour = (int) [dateComponent hour];
    int endMM = (int) [dateComponent minute];
    int endSS = (int) [dateComponent second];
    
    info.stBeginTime.year = info.stEndTime.year = year;
    info.stBeginTime.month = info.stEndTime.month = month;
    info.stBeginTime.day = info.stEndTime.day = day;
    info.stBeginTime.hour = 0;
    
    info.stEndTime.hour = endHour;
    info.stBeginTime.minute = 0;
    info.stEndTime.minute = endMM;
    info.stBeginTime.second = 0;
    info.stEndTime.second = endSS;
    
    [self.SDKDevConfig FindFileByTime:&info];
    
}

#pragma mark TableViewdelegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nFileCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"riceFun";
    RecordDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell= [[[NSBundle mainBundle]loadNibNamed:@"RecordDownloadCell" owner:nil options:nil] firstObject];//使用xib这么写
    }
    
    if (self.pFiles && indexPath.row < self.nFileCount) {
        H264_DVR_FILE_DATA *pFile = &self.pFiles[indexPath.row];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d-%02d:%02d:%02d",pFile->stBeginTime.hour,pFile->stBeginTime.minute,pFile->stBeginTime.second,pFile->stEndTime.hour,pFile->stEndTime.minute,pFile->stEndTime.second];
    }
    cell.recordThumbnail.backgroundColor = [UIColor grayColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
   
    if (nResult < 0 && nResult != EE_MENTSDK_NOFILEFOUND) {
        [SVProgressHUD showErrorWithStatus: NSLocalizedString(@"没有图像", nil) duration:3];
    }
    else if (nResult > 0) {
        //        [self PlayByIndex:nResult - 1];
    }
    else {
//        [SVProgressHUD dismiss];
    }
    
     [self.fileListTB reloadData];
}

-(void)OnSDKSeachFileByTime:(NSSDKDevConfig *)sender Files:(SDK_SearchByTimeInfo *)pFiles Result:(int)nResult{
    
    [SVProgressHUD dismiss];
    
    self.nFileCount = 0;
    self.nSelectedIndex = -1;
    if (self.pFiles != NULL) {
        //        delete [] self.pFiles;
        //        self.pFiles = NULL;
    }
    if (nResult > 0) {
        self.pFiles = new H264_DVR_FILE_DATA[nResult];
        self.nFileCount = nResult;
        self.nSelectedIndex = nResult - 1;
        memcpy(self.pFiles, pFiles, sizeof(H264_DVR_FILE_DATA) * nResult);
    }
    [self.fileListTB reloadData];
    
    if (nResult < 0 && nResult != EE_MENTSDK_NOFILEFOUND) {
        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:nResult] duration:3];
    }
    //    else if (nResult > 0) {
    //        //        [self PlayByIndex:nResult - 1];
    //    }
    //    else {
    //        [SVProgressHUD dismiss];
    //    }
}


@end


@implementation BottomImageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    
    float btnW= 60.0f;
    float btnH= 40.0f;
    
    _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, btnW, btnH)];
    [_allBtn setTitle:NSLocalizedString(@"全部", nil) forState:UIControlStateNormal];
    [_allBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_allBtn];
    
    _alramBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 + btnW, 0, btnW, btnH)];
    [_alramBtn setTitle:NSLocalizedString(@"警报", nil) forState:UIControlStateNormal];
    [_alramBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_alramBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_alramBtn];
    
    _ctrBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 + 2*btnW, 0, btnW, btnH)];
    [_ctrBtn setTitle:NSLocalizedString(@"控制", nil) forState:UIControlStateNormal];
    [_ctrBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_ctrBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_ctrBtn];
    
    _dateBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 + 3*btnW, 0, btnW, btnH)];
    [_dateBtn setTitle:NSLocalizedString(@"日期", nil) forState:UIControlStateNormal];
    [_dateBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_dateBtn];
    
}

- (void)btnAction:(id)sender{
    
}



@end

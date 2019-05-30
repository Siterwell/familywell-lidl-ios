//
//  VideoLiveViewController.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/3.
//  Copyright © 2017年 riceFun. All rights reserved.
//

#import "VideoLiveViewController.h"
#import "GTMNSString+HTML.h"
#import "FunSDK/FunSDK.h"
#import "GUI.h"
#import "FunctionView.h"
#import "FunctionScrollView.h"
#import "Helper.h"
#import "FunSupport.h"
//#import "DeviceList.h"
#import "NSString+Exsmaple.h"
#import "NSSDKPTZContoller.h"
#import "NSSDKTalker.h"
#import "NSSDKMediaPlayer.h"
#import "SDKDataCenter.h"
#import "NSSDKDevConfig.h"
#import "VRGLViewController.h"
#import "VideoShowWindow.h"
#import "GUI.h"
#import "Helper.h"
#import "MrgVideoVc.h"
#import "VideoDataBase.h"
#import "CustomAlertView.h"

#import "DeviceConfig.h"
#import "SystemInfo.h"
#import "NSSDKDevConfig.h"
#import "LocalImgVdieoVc.h"
#import "VideoLocalDataBase.h"
#import "RemoteVideoVc.h"
#import "RemoteImageVc.h"

//#import "ManagerViewController.h"
#import "XMSingleton.h"
#import <LCActionSheet.h>


#define _K_SCREEN_WIDTH ([[UIScreen mainScreen ] bounds ].size.width)
#define kAlertWidth (245  * _K_SCREEN_WIDTH/320)

#define SELF [self MsgHandle]
#define AS_HANDLE(x) (__bridge void*) x

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface CYCameraCell : UICollectionViewCell
@property (nonatomic) UIImageView *icon;
@property (nonatomic) UILabel *name;
@end

@implementation CYCameraCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    _icon = [[UIImageView alloc] init];
    [self.contentView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(0).offset(-15);
//        make.width.height.equalTo(44);
    }];
    
    _name = [[UILabel alloc] init];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.font = [UIFont systemFontOfSize:13];
    _name.numberOfLines = 1;
    [self.contentView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(_icon.mas_bottom).offset(10);
        make.left.equalTo(2);
        make.right.equalTo(-2);
    }];
}

@end


@interface VideoLiveViewController ()<SDKMediaPlayerDelegate, NSSDKTalkerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
        
    CGFloat showY;
    CGFloat hiddenY;
    SystemInfo JSystemInfo;
    CGFloat lastScale;
    CGFloat totalScale;
}

//控件
@property (nonatomic,strong) FunctionView *funView;//功能视图：上面有暂停、静音、抓图、录像按钮
@property (nonatomic,strong) FunctionScrollView *subView;//滚动功能视图
@property (nonatomic,copy)   NSString *deviceSn;
@property (nonatomic,strong) NSSDKMediaPlayer *player;
@property (nonatomic,assign) int channelNum;
@property (nonatomic,strong) NSSDKPTZContoller *ptzController;//云台控制
@property (nonatomic,strong) NSSDKTalker *talker;//对讲
@property (nonatomic,strong) VideoShowWindow *videoShowWindow;//播放视图and 鱼眼VC
@property (nonatomic,strong) id window;

@property (nonatomic,assign) int funViewShowing;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *captureTimer;

@property (nonatomic,assign) CGRect videoShowWindowFrameOld;
@property (nonatomic,assign) CGRect funViewOld;

@property (nonatomic,copy)   NSString *devName;

@property (nonatomic,assign) BOOL stateBarShow;
@property (nonatomic,assign) BOOL doTransform;

@property (nonatomic,strong) NSString *videoPath;

@property (nonatomic, strong) NSSDKDevConfig *SDKDevConfig;
@property (readonly, nonatomic) int hObj;

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) RFCustomButton *talkBtn;

@property (nonatomic) RFCustomButton *leftBtn;
@property (nonatomic) RFCustomButton *rightBtn;
@property (nonatomic) RFCustomButton *upBtn;
@property (nonatomic) RFCustomButton *downBtn;

@property(nonatomic,assign) BOOL type_qiang;

@end

@implementation VideoLiveViewController

#pragma mark - 新版增加的摄像头列表部分
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 10, 5);
        CGFloat w = (int)((SCREEN_WIDTH- 5*2 - 10*4) / 5.0);
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(w, w+20);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        NSLog(@"CGRectGetMaxY(self.videoShowWindow.showWindow.frame)%f",CGRectGetMaxY(self.videoShowWindow.showWindow.frame));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.videoShowWindow.showWindow.frame), SCREEN_WIDTH, 130) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CYCameraCell class] forCellWithReuseIdentifier:@"CYCameraCell"];
        [self.view addSubview:_collectionView];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = (int)((self.videoArray.count-1)/5) + 1;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self.view addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(self.collectionView.mas_bottom).offset(-5);
            make.height.equalTo(20);
            make.width.equalTo(40);
        }];
    }
    return _pageControl;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CYCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYCameraCell" forIndexPath:indexPath];
    
    if ([self.videoArray[indexPath.row][@"name"] isEqualToString:self.vInfo.name] && [self.videoArray[indexPath.row][@"devid"] isEqualToString:self.vInfo.devid]) {
        [cell.icon setImage:[UIImage imageNamed:@"15-摄像头当前选中"]];
//        self.selectIndex = indexPath.row;
    } else {
        [cell.icon setImage:[UIImage imageNamed:@"16-摄像头当前未选中"]];
    }
    [cell.name setText:self.videoArray[indexPath.row][@"name"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
    vInfo.devid = self.videoArray[indexPath.row][@"devid"];
    vInfo.name = self.videoArray[indexPath.row][@"name"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
    vInfo.userName = userName;
    self.vInfo = vInfo;
    _type_qiang = NO;
    _deviceSn = vInfo.devid;
    [XMSingleton sharedXM].vInfo = vInfo;
    FUN_DevGetConfig_Json(SELF,CSTR(_deviceSn),"SystemInfo",0);
    self.title = self.vInfo.name;
    
    _stateBarShow = NO;
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
//    VideoInfoModel *vinfoa = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:self.deviceSn andUserName:userName];
//    self.devName = (vinfoa==nil||vinfoa.name == nil) ? self.vInfo.name : vinfoa.name;
//    self.title = self.devName;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [self.player stop];
    self.deviceSn = _vInfo.devid;
    self.channelNum = 0;
    
    [DATACENTER setOptDeviceSN:_deviceSn Channel:self.channelNum];
    
    [self.talker stop];
    self.talker = nil;
    self.talker = [[NSSDKTalker alloc] init];
    self.talker.device = self.deviceSn;
    self.talker.channel = self.channelNum;
    self.talker.delegate = self;
    
    _ptzController = nil;
    _ptzController = [[NSSDKPTZContoller alloc] init];
    _ptzController.device = self.deviceSn;
    _ptzController.channel = self.channelNum;
    
    //获取设备信息
    FUN_DevGetConfig_Json(SELF,CSTR(_deviceSn),"SystemInfo",0);
    
//    [self creatSubViews];//创建子视图
    if (self.deviceSn.length > 0) {//如果之前有操作过某个设备 会被保存下来 下次播放这个设备
        [self toPlay];
    }
    [self.player setSound:100];
    [self timerShowHidden];
    [(DisplayView*)self.window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuchShow)]];
    
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    int page = (scrollView.contentOffset.x / scrollView.frame.size.width) ;
    int page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    [self.pageControl setCurrentPage:page];
}


- (void)handlePanFrom:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self commitTranslation:[pan translationInView:(DisplayView*)self.window]];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        [self.ptzController PTZControl:PAN_LEFT | PAN_RIGHT | TILT_UP | TILT_DOWN IsStop:YES Speed:4];
        self.leftBtn.hidden = self.rightBtn.hidden = self.upBtn.hidden = self.downBtn.hidden = YES;
    }
}

- (void)commitTranslation:(CGPoint)translation {
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    // 设置滑动有效距离
    if (MAX(absX, absY) < 5)
        return;
    if (absX > absY ) {
        if (translation.x<0) {
            //向左滑动
            [self.ptzController PTZControl:PAN_RIGHT IsStop:NO Speed:4];
            self.leftBtn.hidden = NO;
        }else{
            //向右滑动
            [self.ptzController PTZControl:PAN_LEFT IsStop:NO Speed:4];
            self.rightBtn.hidden = NO;
        }
    } else if (absY > absX) {
        if (translation.y<0) {
            //向上滑动
            [self.ptzController PTZControl:TILT_DOWN IsStop:NO Speed:4];
            self.upBtn.hidden = NO;
        }else{
            //向下滑动
            [self.ptzController PTZControl:TILT_UP IsStop:NO Speed:4];
            self.downBtn.hidden = NO;
        }
    }
}

- (void)handleScaleFrom:(UIPinchGestureRecognizer *)pinch {
    if(pinch.state == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
    if (pinch.state == UIGestureRecognizerStateBegan || pinch.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = 1.0 - (lastScale - pinch.scale);
        if (totalScale < 1 && scale < 1) {
            pinch.view.transform  = CGAffineTransformIdentity;
            return;
        }
        pinch.view.transform = CGAffineTransformScale(pinch.view.transform, scale, scale);
        totalScale *= scale;
        lastScale = pinch.scale;
    }
}

#pragma mark Lazyload

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
    VideoInfoModel *vinfoa = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:self.deviceSn andUserName:userName];
    
    [XMSingleton sharedXM].vInfo = self.vInfo;
    
    self.devName = (vinfoa == nil || vinfoa.name == nil) ? [XMSingleton sharedXM].vInfo.name : vinfoa.name;
    self.title = self.devName;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _stateBarShow = NO;
//    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
//    VideoInfoModel *vinfoa = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:self.deviceSn andUserName:userName];
//    [XMSingleton sharedXM].vInfo = self.vInfo;
//    self.devName = (vinfoa == nil || vinfoa.name == nil) ? [XMSingleton sharedXM].vInfo.name : vinfoa.name;
//    self.title = self.devName;
    self.devName = (![XMSingleton sharedXM].vInfo || ![XMSingleton sharedXM].vInfo.name) ? self.vInfo.name : [XMSingleton sharedXM].vInfo.name;
    self.title = self.devName;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.player = [[NSSDKMediaPlayer alloc] init];
    self.player.playType = RealPlay;
    self.player.delegate = self;
    self.deviceSn = _vInfo.devid;
    self.channelNum = 0;
    [DATACENTER setOptDeviceSN:_deviceSn Channel:self.channelNum];
    
    _talker = [[NSSDKTalker alloc] init];
    _talker.device = self.deviceSn;
    _talker.channel = self.channelNum;
    _talker.delegate = self;
    
    _ptzController = [[NSSDKPTZContoller alloc] init];
    _ptzController.device = self.deviceSn;
    _ptzController.channel = self.channelNum;
    
    //获取设备信息
    FUN_DevGetConfig_Json(SELF,CSTR(_deviceSn),"SystemInfo",0);

    [self creatSubViews];//创建子视图
    
    if (self.deviceSn.length > 0) { //如果之前有操作过某个设备 会被保存下来 下次播放这个设备
        [self toPlay];
    }
    [self.player setSound:100];
    
    [self timerShowHidden];
    
    [(DisplayView*)self.window addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuchShow)]];
//     [ requestGetConfigWithChannel:self.channelNum andJObject:&JSupportExtRecord];//是否支持主副码流
    
    /** 添加上下左右方向旋转 */
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    pan.maximumNumberOfTouches = 1;
    [(DisplayView*)self.window addGestureRecognizer:pan];
    
    /** 添加画面大小缩放 */
    totalScale = 1;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleScaleFrom:)];
    [(DisplayView*)self.window addGestureRecognizer:pinch];
    
    _talkBtn = [[RFCustomButton alloc] init];
    [_talkBtn setFrame:CGRectMake(15, SCREEN_HEIGHT - (SCREEN_HEIGHT-SCREEN_WIDTH)/2 - 12, 70, 70)];
    [_talkBtn setBackgroundImage:[UIImage imageNamed:@"21-长按语音对话未选中"] forState:UIControlStateNormal];
    [_talkBtn setBackgroundImage:[UIImage imageNamed:@"22-长按语音对话选中"] forState:UIControlStateHighlighted];
    _talkBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    _talkBtn.hidden = YES;
    [_talkBtn addTarget:self action:@selector(intercomStar:) forControlEvents:UIControlEventTouchDown];
    [_talkBtn addTarget:self action:@selector(intercomEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_talkBtn];
    
    _leftBtn = [[RFCustomButton alloc] init];
    [_leftBtn setFrame:CGRectMake(10, SCREEN_WIDTH*9/16/2-10+64, 30, 30)];
    [_leftBtn setImage:[UIImage imageNamed:@"left_selected"] forState:UIControlStateNormal];
    _leftBtn.hidden = YES;
    [self.view addSubview:_leftBtn];
    
    _rightBtn = [[RFCustomButton alloc] init];
    [_rightBtn setFrame:CGRectMake(SCREEN_WIDTH-10-30, SCREEN_WIDTH*9/16/2-10+64, 30, 30)];
    [_rightBtn setImage:[UIImage imageNamed:@"right_selected"] forState:UIControlStateNormal];
    _rightBtn.hidden = YES;
    [self.view addSubview:_rightBtn];
    
    _upBtn = [[RFCustomButton alloc] init];
    [_upBtn setFrame:CGRectMake(SCREEN_WIDTH/2-10, 10+64, 30, 30)];
    [_upBtn setImage:[UIImage imageNamed:@"up_selected"] forState:UIControlStateNormal];
    _upBtn.hidden = YES;
    [self.view addSubview:_upBtn];
    
    _downBtn = [[RFCustomButton alloc] init];
    [_downBtn setFrame:CGRectMake(SCREEN_WIDTH/2-10, SCREEN_WIDTH*9/16-10+64-30, 30, 30)];
    [_downBtn setImage:[UIImage imageNamed:@"down_selected"] forState:UIControlStateNormal];
    _downBtn.hidden = YES;
    [self.view addSubview:_downBtn];
    
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [self.ptzController PTZControl:PAN_LEFT | PAN_RIGHT | TILT_UP | TILT_DOWN IsStop:YES Speed:4];
    self.leftBtn.hidden = self.rightBtn.hidden = self.upBtn.hidden = self.downBtn.hidden = YES;
    
//    FUN_DevLogout(self.MsgHandle, [self.deviceSn UTF8String]);
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (_talker != nil) {
        [self.talker stop];
    }
    [self.player stop];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //当前视图控制器在栈中，故为push操作
        NSLog(@"push");
    } else{
        //当前视图控制器不在栈中，故为pop操作
        NSLog(@"pop");
        FUN_DevLogout(self.MsgHandle, [self.deviceSn UTF8String]);
    }

}


- (id)getWindow {
    self.window = [self.videoShowWindow getAndShowWindow];
    return self.window;
}


- (void)toPlay {
    if ([self.deviceSn length] <= 0) {
        [MBProgressHUD showMessage:NSLocalizedString(@"视频不存在",nil) ToView:self.view RemainTime:1.2f];
        return;
    }
    [MBProgressHUD showMessage:NSLocalizedString(@"正在打开视频", nil) ToView:self.view RemainTime:8.0f];
    [self.player play:self.deviceSn andWnd:[self getWindow] andChannel:self.channelNum andStreamType:1 andSeq:0];
}

- (void)toStop {
    [self.funView.playOrStopBtn setTitle:TS("Play") forState:UIControlStateNormal];
    [self.player stop];
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)tuchShow {
    [self showMenue];
}

- (void)creatSubViews {
    showY = TOP_HEIGHT + self.view.frame.size.width*9/16 - 44;
    hiddenY = TOP_HEIGHT + self.view.frame.size.width*9/16;
    _funViewShowing = 1;
    
    //设备管理
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"01-设置"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(mrgVideo)];
    self.navigationItem.rightBarButtonItem = rightBar;

    self.videoShowWindow = [[VideoShowWindow alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT, self.view.frame.size.width, self.view.frame.size.width*9/16)];
    self.videoShowWindow.parentVC = self;
    self.player.fishDelegate = self.videoShowWindow;
    [self.view addSubview:self.videoShowWindow.showWindow];
    
    self.videoShowWindowFrameOld = CGRectMake(0, TOP_HEIGHT, self.view.frame.size.width, self.view.frame.size.width*9/16);
    
    //控制菜单
    self.funView = [[FunctionView alloc]initWithFrame:CGRectMake(0, TOP_HEIGHT + self.videoShowWindow.showWindow.frame.size.height - 44, self.view.frame.size.width, 44)];
    [self.view addSubview:self.funView];
    
    self.funViewOld = CGRectMake(0, showY, self.view.frame.size.width, 44);
    
    [self collectionView];
    [self pageControl];
    
    //底部控件
    self.subView = [[FunctionScrollView alloc]initWithFrame:CGRectMake(0,64 + self.videoShowWindow.showWindow.frame.size.height+130, self.view.frame.size.width, self.view.frame.size.height - 64 - self.videoShowWindow.showWindow.frame.size.height-130)];
    self.subView.scrollEnabled = NO;
    [self.view addSubview:self.subView];
    
    //media function
    BUTTON_TARGET(self.funView.playBtn, playVideo);
    [self.funView.soundBtn addTarget:self action:@selector(setMuteOrNot:) forControlEvents:UIControlEventTouchUpInside];
    [self.funView.resolutionBtn addTarget:self action:@selector(setResolution:) forControlEvents:UIControlEventTouchUpInside];
    BUTTON_TARGET(self.funView.captureBtn, captureVideo);
    BUTTON_TARGET(self.funView.fullScreenBtn, fullScreenVideo);
    
    //六个功能键
    self.subView.zoomUpBtn.tag = ZOOM_IN_1;
    self.subView.zoomDownBtn.tag = ZOOM_OUT_1;
    self.subView.focusUpBtn.tag = FOCUS_FAR;
    self.subView.focusDownBtn.tag = FOCUS_NEAR;
    self.subView.irisUpBtn.tag = IRIS_OPEN;
    self.subView.irisDownBtn.tag = IRIS_CLOSE;
//    BUTTON_TARGET(self.subView.zoomUpBtn, BtnPtzFunUp);
//    BUTTON_TARGET(self.subView.zoomDownBtn, BtnPtzFunUp);
//    BUTTON_TARGET(self.subView.focusUpBtn, BtnPtzFunUp);
//    BUTTON_TARGET(self.subView.focusDownBtn, BtnPtzFunUp);
//    BUTTON_TARGET(self.subView.irisUpBtn, BtnPtzFunUp);
//    BUTTON_TARGET(self.subView.irisDownBtn, BtnPtzFunUp);
    
    //对讲按钮
    BUTTON_TARGET_DOWN(self.subView.intercomBtn, intercomStar);
    BUTTON_TARGET(self.subView.intercomBtn, intercomEnd);
    
    //图片视频
    BUTTON_TARGET(self.subView.iconLbrBtn, lookImage);
    BUTTON_TARGET(self.subView.videoLbrBtn, lookVideo);
    if (self.selectIndex < self.videoArray.count - 2) {
        if (self.selectIndex+2 > 2) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex+2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        
    } else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex+2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

- (void)setResolution:(UIButton *)sender {
    if (self.player.nStreamType == 1) {
//        [self.player setSound:100];
        [self.player play:self.deviceSn andWnd:[self getWindow] andChannel:self.channelNum andStreamType:0 andSeq:0];
    } else {
        [self.player play:self.deviceSn andWnd:[self getWindow] andChannel:self.channelNum andStreamType:1 andSeq:0];
    }
    sender.selected = !sender.selected;
}

- (void)lookImage:(UIButton *)btn {
//    [self showSheet:23];
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:NSLocalizedString(@"照片管理", nil) cancelButtonTitle:NSLocalizedString(@"取消", nil) clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        else if (buttonIndex == 1) {
            RemoteImageVc *rImage = [[RemoteImageVc alloc] init];
            [self.navigationController pushViewController:rImage animated:YES];
        }
        else if (buttonIndex == 2) {
            LocalImgVdieoVc *local = [[LocalImgVdieoVc alloc] init];
            local.devsn = self.deviceSn;
            local.ivFlag = 0;
            [self.navigationController pushViewController:local animated:YES];
        }
        
    } otherButtonTitles:NSLocalizedString(@"查看远程图像", nil), NSLocalizedString(@"查看本地截图", nil), nil];
    [sheet show];
}

- (void)lookVideo:(UIButton *)btn {
    RemoteVideoVc *rVideo = [[RemoteVideoVc alloc] init];
    [self.navigationController pushViewController:rVideo animated:YES];
    
//    RemoteImageVc *rImage = [[RemoteImageVc alloc] init];
//    [self.navigationController pushViewController:rImage animated:YES];
    
    
    
//    [self showSheet:22];
//    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:NSLocalizedString(@"视频管理", nil) cancelButtonTitle:NSLocalizedString(@"取消", nil) clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
//        if (buttonIndex == 0) {
//            return ;
//        }
//        else if (buttonIndex == 1) {
//    RemoteVideoVc *rVideo = [[RemoteVideoVc alloc] init];
//    [self.navigationController pushViewController:rVideo animated:YES];
//        }
//        else if (buttonIndex == 2) {
//            LocalImgVdieoVc *local = [[LocalImgVdieoVc alloc] init];
//            local.devsn = self.deviceSn;
//            local.ivFlag = 1;
//            [self.navigationController pushViewController:local animated:YES];
//        }
//
//    } otherButtonTitles:NSLocalizedString(@"查看远程视频", nil), NSLocalizedString(@"查看本地视频", nil), nil];
//    [sheet show];
}

- (void)mrgVideo {
//    ManagerViewController *vc = [[ManagerViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    MrgVideoVc *mrgVideo = [[MrgVideoVc alloc] init];
    mrgVideo.vInfo = self.vInfo;
    mrgVideo.type_qiang = _type_qiang;
    [XMSingleton sharedXM].deviceSn = self.deviceSn;
    [XMSingleton sharedXM].channelNum = self.channelNum;
    [self.navigationController pushViewController:mrgVideo animated:YES];
}

- (void)timerCaptureVideoAction {
    if (self.player.playState != ENSMEDIA_STATE_PLAY) {
        return;
    }
    [self.player snapImage:[NSString getJPGFilePathByDevSn:self.deviceSn]];
}

//播放或者停止
- (void)playOrStopVideo:(UIButton *)btn {
    if ([self.deviceSn length] <= 0) {
        return;
    }
    if (self.player.playState == ENSMEDIA_STATE_STOP) {
        [self toPlay];
    } else {
        [self toStop];
    }
}

//播放
- (void)playVideo:(UIButton *)btn{
    if ([self.deviceSn length] <= 0) {
        return;
    }
    [self toPlay];
}

//停止
- (void)stopVideo:(UIButton *)btn{
    if ([self.deviceSn length] <= 0) {
        return;
    }
    [self toStop];
}

//静音
- (void)setMuteOrNot:(UIButton *)btn{
    if (self.player.nSound == 0) {
        [self.player setSound:100];
        btn.selected = NO;
    } else {
        [self.player setSound:0];
        btn.selected = YES;
    }
}

//抓图
- (void)captureVideo:(UIButton *)btn{
    if (self.player.playState != ENSMEDIA_STATE_PLAY) {
        return;
    }
    [self.player snapImage:[NSString getJPGFilePath:self.deviceSn Channel:self.channelNum]];
}

- (void)captureVideoAuto {
  
    if (self.player.playState != ENSMEDIA_STATE_PLAY) {
        return;
    }
    [self.player snapImage:[NSString getJPGFilePathByDevSn:self.deviceSn]];
    self.vInfo.imagePath = [NSString getJPGFilePathByDevSn:self.deviceSn];
}

//计时显示隐藏
- (void)timerShowHidden {
    if (_funViewShowing == 1) {
        _timer = nil;
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showMenue) userInfo:nil repeats:NO];
    }
}

//显示隐藏功能菜单
- (void)showMenue {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (self.videoShowWindow.screenFullState == ShowWindowScreenNoFull) {
        [UIView animateWithDuration:0.3 animations:^{
            if (_funViewShowing != 1) {
                self.funView.frame = CGRectMake(0, showY, self.view.frame.size.width, 44);
                self.funView.hidden = NO;
                _funViewShowing = 1;
            }else{
//                self.funView.frame = CGRectMake(0, hiddenY, 0, 0);
                self.funView.hidden = YES;
                _funViewShowing = 0;
            }
            
        } completion:^(BOOL finished) {
            [self timerShowHidden];
        }];
        
    }else{
        //全屏时
        [UIView animateWithDuration:0.3 animations:^{
            if (_funViewShowing != 1) {
                //执行显示
                self.funView.frame = CGRectMake(25,(SCREEN_HEIGHT - SCREEN_WIDTH)/2, 44,self.view.frame.size.width);
                self.talkBtn.frame = CGRectMake(12.5, CGRectGetMaxX(self.funView.bounds) + (SCREEN_HEIGHT - SCREEN_WIDTH)/2 - 15, 70, 70);
                _funViewShowing = 1;
                
            }else{
                self.funView.frame = CGRectMake(-44,(SCREEN_HEIGHT - SCREEN_WIDTH)/2, 44,self.view.frame.size.width);
                self.talkBtn.frame = CGRectMake(-70, CGRectGetMaxX(self.funView.bounds) + (SCREEN_HEIGHT - SCREEN_WIDTH)/2 - 15, 70, 70);
                _funViewShowing = 0;
            }
            
        } completion:^(BOOL finished) {
            [self timerShowHidden];
        }];
    }
}

//对讲按钮
- (void)intercomStar:(UIButton *)btn{
    [self.timer invalidate];
    self.timer = nil;
    [self.talker startTalker];
}

//松开
- (void)intercomEnd:(UIButton *)btn{
    [self showMenue];
    [self.talker startListening];
}

//定时抓图
- (void)timerCaptureVideo{
    _captureTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerCaptureVideoAction) userInfo:nil repeats:YES];
}

//全屏
- (void)fullScreenVideo:(UIButton *)btn {
    _funViewShowing = 0;
    if(self.videoShowWindow.screenFullState == ShowWindowScreenNoFull){
        [UIView animateWithDuration:0.5 animations:^{
            self.subView.hidden = YES;
            self.collectionView.hidden = YES;
            self.pageControl.hidden = YES;
            self.talkBtn.hidden = NO;
            self.talkBtn.frame = CGRectMake(12.5, CGRectGetMaxY(self.funView.frame)+(SCREEN_HEIGHT - SCREEN_WIDTH)/2-15, 70, 70);
            self.videoShowWindow.showWindow.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.videoShowWindow.showWindow.bounds = CGRectMake(0, 0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.superview.bounds));
            self.videoShowWindow.showWindow.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
            self.funView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.funView.frame = CGRectMake(25, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, 44, self.view.frame.size.width);
            [self.funView.fullScreenBtn setImage:[UIImage imageNamed:@"narrow_icon"] forState:UIControlStateNormal];
            
            [self.leftBtn setFrame:CGRectMake(self.videoShowWindow.showWindow.frame.size.width/2-10, 10, 30, 30)];//up
            [self.upBtn setFrame:CGRectMake(self.videoShowWindow.showWindow.frame.size.width-10-30, self.videoShowWindow.showWindow.frame.size.height/2-10, 30, 30)];//right
            [self.rightBtn setFrame:CGRectMake(self.videoShowWindow.showWindow.frame.size.width/2-10, self.videoShowWindow.showWindow.frame.size.height-10-30, 30, 30)];//down
            [self.downBtn setFrame:CGRectMake(10, self.videoShowWindow.showWindow.frame.size.height/2-10, 30, 30)];//left
            
            self.leftBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.rightBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.downBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.upBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
            
            _doTransform = YES;
            //隐藏
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                //调用隐藏方法
                _stateBarShow = YES;
                self.navigationController.navigationBar.hidden = YES;
                [self prefersStatusBarHidden];
                [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            }
        } completion:^(BOOL finished) {
            self.videoShowWindow.screenFullState = ShowWindowScreenFull;
            [self showMenue];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.subView.hidden = NO;
            self.collectionView.hidden = NO;
            self.pageControl.hidden = NO;
            self.talkBtn.hidden = YES;
            self.videoShowWindow.showWindow.transform = CGAffineTransformIdentity;
            self.videoShowWindow.showWindow.frame = self.videoShowWindowFrameOld;
            
            self.funView.transform = CGAffineTransformIdentity;
            self.funView.frame = self.funViewOld;
            [self.funView.fullScreenBtn setImage:[UIImage imageNamed:@"enlarge_icon"] forState:UIControlStateNormal];
            _doTransform = NO;
            
            [self.leftBtn setFrame:CGRectMake(10, self.videoShowWindow.showWindow.frame.size.height/2-10+64, 30, 30)];
            [self.upBtn setFrame:CGRectMake(self.videoShowWindow.showWindow.frame.size.width/2-10, 10+64, 30, 30)];
            [self.rightBtn setFrame:CGRectMake(self.videoShowWindow.showWindow.frame.size.width-10-30, self.videoShowWindow.showWindow.frame.size.height/2-10+64, 30, 30)];
            [self.downBtn setFrame:CGRectMake(self.videoShowWindow.showWindow.frame.size.width/2-10, self.videoShowWindow.showWindow.frame.size.height-10+64-30, 30, 30)];
            
            self.leftBtn.transform = CGAffineTransformIdentity;
            self.rightBtn.transform = CGAffineTransformIdentity;
            self.downBtn.transform = CGAffineTransformIdentity;
            self.upBtn.transform = CGAffineTransformIdentity;
            
            //显示
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                _stateBarShow = NO;
                self.navigationController.navigationBar.hidden = NO;
                //调用隐藏方法
                [self prefersStatusBarHidden];
                [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            }
        } completion:^(BOOL finished) {
            self.videoShowWindow.screenFullState = ShowWindowScreenNoFull;
            [self showMenue];
        }];
    }
}

-(void)OnPlay:(NSSDKMediaPlayer *)sender Result:(int)result Param1:(int)Param1 {
    if (result < 0) {
        if (result == EE_DVR_PASSWORD_NOT_VALID) { //密码错误
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请输入设备登录密码", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            UITextField *txtName = [alert textFieldAtIndex:0];
            txtName.placeholder = NSLocalizedString(@"请输入密码", nil);
            alert.tag = 201;
            [alert show];
            
        }else{
            [SVProgressHUD showErrorWithStatus: [self resultPrase:result] duration:3];
        }
    } else {
   
    }
}

-(void)OnPause:(NSSDKMediaPlayer *)sender Result:(int)result CurState:(int)state{
}

-(void)OnPlayEnd:(NSSDKMediaPlayer *)sender{
}

-(void)OnPlayInfo:(NSSDKMediaPlayer *)sender StrInfo:(const char *)szStr Param1:(int)Param1 Param2:(int)Param2{
}

-(void)OnStartRecord:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath{
    if (filePath!=nil&&[filePath isKindOfClass:[NSString class]]&&[filePath hasSuffix:@".mp4"]) {
        self.videoPath = filePath;
    }
}

-(void)OnStopRecord:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath{
    if (filePath!=nil&&[filePath isKindOfClass:[NSString class]]&&[filePath hasSuffix:@".mp4"]) {
        self.videoPath = filePath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"保存", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        alert.tag = 202;
        [alert show];
    }
}

- (void)OnSnapImage:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath {
    NSLog(@"截图了");
    
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
                VideoInfoModel *imgInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:self.deviceSn andUserName:userName];
                
                VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                vInfo.filePath = filePath;
                vInfo.fileName = [filePath substringFromIndex:([filePath length] - 38)];
                vInfo.updataTime = strDate;
                vInfo.devid = self.deviceSn;
                vInfo.infoType = 1;
                
                if (imgInfo!=nil) {
                    vInfo.imagePath = imgInfo.imagePath;
                }
                
                [[VideoLocalDataBase sharedDataBase] updateVideoInfo:vInfo];
                
                [self loadImageFinished:imgFromUrl3];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"成功", nil)];
            } dismissBlock:^{
                                  
                              }];
        } else {
            //保存到沙盒中
            self.vInfo.imagePath = filePath;
            [[VideoDataBase sharedDataBase] updateVideoInfo:self.vInfo];
        }
    }
}

- (void)OnSnapThumbnail:(NSSDKMediaPlayer *)sender Result:(int)result FilePath:(NSString *)filePath {
}

- (void)OnTalkerStateChannage:(NSSDKTalker *)sender Result:(int)result State:(ETALKER_STATE)state {
    if(result == EE_DVR_PASSWORD_NOT_VALID){
//        NSDeviceInfo *dev = [DATACENTER GetDeviceBySN:self.deviceSn];
    }
}

- (void)loadImageFinished:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}

- (NSString*)resultPrase:(int)result {
    if (result == -10005) {
        return NSLocalizedString(@"连接超时", nil);
    }else{
        return NSLocalizedString(@"连接失败", nil);
    }
    return @"";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 201) {
        if (buttonIndex == 1) {
            UITextField *txt = [alertView textFieldAtIndex:0];
            SDKDataCenter *pDC = [SDKDataCenter instance];
            NSDeviceInfo *pNSDev = [NSDeviceInfo   NewDeviceInfo:self.deviceSn
                                                         andName:self.vInfo.name
                                                     andUserName:nil
                                                     andPassword:txt.text];
            [pDC AddDevice:pNSDev ResetPassword:YES];
            [self toPlay];
        }
    }else{
        if (buttonIndex == 1) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
            VideoInfoModel *imgInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:self.deviceSn andUserName:userName];
            VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
            vInfo.filePath = self.videoPath;
            vInfo.fileName = [self.videoPath substringFromIndex:([self.videoPath length] - 38)];
            vInfo.updataTime = strDate;
            vInfo.devid = self.deviceSn;
            vInfo.infoType = 2;
            if (imgInfo!=nil) {
                vInfo.imagePath = imgInfo.imagePath;
            }
            [[VideoLocalDataBase sharedDataBase] updateVideoInfo:vInfo];
        }else{
            //删除本地图片
            if([[NSFileManager defaultManager] fileExistsAtPath:self.videoPath]) {
                [[NSFileManager defaultManager]  removeItemAtPath:self.videoPath error:nil];
            }
        }
    }
}

- (int)MsgHandle {
    if ( !_hObj ) {
        _hObj = FUN_RegWnd((__bridge void*)self);
    }
    return _hObj;
}

//obj不再使用时，请主动调用下CloseHandle
-(void)CloseHandle{
    FUN_UnRegWnd(_hObj);
    _hObj = 0;
}

- (void)OnFunSDKResult:(NSNumber*)pParam{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent*)nAddr;


    if (msg->param1 > 0) {
        [self captureVideoAuto];
        if(msg->id==5128 && msg->pObject!=nil){
            NSString *str=[NSString stringWithCString:msg->pObject encoding:NSUTF8StringEncoding];
            if(str!=nil){
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if([[tempDictQueryDiamond objectForKey:@"SystemInfo"] objectForKey:@"DeviceType"] !=nil){
                    NSNumber *ds = [[tempDictQueryDiamond objectForKey:@"SystemInfo"] objectForKey:@"DeviceType"];
                    if([ds intValue]==22){
                        _type_qiang = YES;
                    }
                }else{
                    _type_qiang = NO;
                }
            }else{
                _type_qiang = NO;
            }
            
            return;
        }
        return;
    }  else if (msg->param1 == EE_DVR_PASSWORD_NOT_VALID) { //密码错误
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请输入设备登录密码", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *txtName = [alert textFieldAtIndex:0];
        txtName.placeholder = NSLocalizedString(@"请输入密码", nil);
        alert.tag = 201;
        [alert show];
        return;
    }
    [MBProgressHUD showMessage:[NSString stringWithFormat:@"%d", msg->param1] ToView:self.view RemainTime:2.0];
}


@end

//
//  HomeHeadView.m
//  Qibuer
//
//  Created by shap on 2016/11/30.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "HomeHeadView.h"
#import "VideoInfoModel.h"
#import "VideoDataBase.h"
#import "DeviceDataBase.h"
#import "ArrayTool.h"
#import "DeviceDetailVC.h"
#import "TempControlDetailVC.h"
#import "SceneDetailVC.h"
#import "LightDetailVC.h"

@interface HomeHeadView ()
@property (nonatomic, strong) NSMutableArray *modelSource;
@property (nonatomic, strong) NSMutableArray *deviceItems;
@end

@implementation HomeHeadView
{
    UIPageControl    *_pageControl; //分页控件
    NSMutableArray *_curImageArray; //当前显示的图片数组
    NSInteger          _curPage;    //当前显示的图片位置
//    NSTimer           *_timer;      //定时器
    UIView          *_subview;
}

-(id)initWithSubView:(UIView *)view{
    if (self = [super init]) {
        _subview = view;

        [self setupUI];

        //初始化数据，当前图片默认位置是0
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setupUI];
        
        //初始化数据，当前图片默认位置是0
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}

-(void)setupUI{
    
    WS(ws)
    
    [self setBackgroundColor:RGB(33, 33, 33)];
    
    _scrollView = [UIScrollView new];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    [self addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right);
        make.top.equalTo(ws.mas_top);
        make.bottom.equalTo(ws.mas_bottom).offset(-36);
    }];
    
    self.deviceItems = [[NSMutableArray alloc]init];

    [self setImages];

    //分页控件
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPageIndicatorTintColor = RGB(40, 184, 215);
    _pageControl.pageIndicatorTintColor = RGB(203, 203, 203);
    [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(ws.mas_left);
        make.right.equalTo(ws.mas_right).offset(-13);
        make.bottom.equalTo(ws.mas_bottom).offset(-13);
        make.height.equalTo(@10);
    }];
    
}

-(void)reloadDevice {
    NSLog(@"[RYAN] HomeHeadView > reloadDevice");
    [self setImages];
}

-(void)setImages{

    WS(ws)

    UIView *contView = [UIView new];
    [_scrollView addSubview:contView];

    [contView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.scrollView);
        make.height.equalTo(ws.scrollView.mas_height);
    }];
    
    for (int i=0; i<[_curImageArray count]; i++) {
        
        VideoInfoModel *vInfo = [_curImageArray objectAtIndex:i];
        NSLog(@"[RYAN] setImages > vInfo.devid : %@", vInfo.devid);
        
//        NSString *imagePath = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:vInfo.devid].imagePath;
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
        NSString *imagePath = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:vInfo.devid andUserName:userName].imagePath;
        
//         NSLog(@"koyang=======koyang====koyang=666666666666==imagePath=%@=====%@===%@",imagePath,vInfo.devid,vInfo.name);

        UIImageView *imageView1 = [UIImageView new];
        [contView addSubview:imageView1];
        imageView1.tag = i+20;
        imageView1.userInteractionEnabled = YES;
        
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(contView.mas_left);
            }else{
                make.left.equalTo([contView viewWithTag:(i + 20 - 1)].mas_right);
            }
            make.height.equalTo(contView.mas_height);
            make.top.equalTo(contView.mas_top);
            make.width.equalTo(ws.mas_width);
        }];
        
        UILabel *nameLbl = [UILabel new];
        [imageView1 addSubview:nameLbl];
        
        nameLbl.textColor = RGB(40, 184, 215);
        nameLbl.font = [UIFont boldSystemFontOfSize:14.0f];
        
        [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(imageView1.mas_bottom).offset(-10.0f);
            make.left.mas_equalTo(imageView1.mas_left).offset(10.0f);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(Main_Screen_Width-10.0f);
        }];
        
        //判断本地图片是否存在
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:imagePath];
    
            [imageView1 setImage:imgFromUrl3];
            nameLbl.text = vInfo.name;
        }else if ([@"dev_list" isEqualToString:vInfo.devid]) {
            UIColor* color = [UIColor colorWithRed:0.0f/255.0f
                                             green:157.0f/255.0f
                                              blue:224.0f/255.0f
                                             alpha:1.0f];
            [imageView1 setBackgroundColor:color];
            
            [self.deviceItems removeAllObjects];
            [self lodaData];
            
            NSUInteger size = ([self.modelSource count]>6 ? 6 : [self.modelSource count]);
            for (int i=0 ; i<size ; i++) {
                UIImageView *deviceImage = [self addDeviceItem:imageView1 index:i];
                [self.deviceItems addObject:deviceImage];
            }
        } else {
            [imageView1 setImage:[UIImage imageNamed:@"lbt_01"]];
        }
        
        
        if ([@"lbt_01" isEqualToString:vInfo.devid]) {
            nameLbl.text = NSLocalizedString(@"无视频，点击添加", nil);
        } else if ([@"dev_list" isEqualToString:vInfo.devid]) {
            nameLbl.text = NSLocalizedString(@"", nil);
        }else{
            nameLbl.text = vInfo.name;
            
            UIImageView *playIcon = [UIImageView new];
            [contView addSubview:playIcon];
            
            [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(imageView1);
                make.width.and.height.mas_equalTo(60);
            }];
            [playIcon setImage:[UIImage imageNamed:@"video_play_icon"]];
        }
        
        //tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [imageView1 addGestureRecognizer:tap];
        
    }
    if (_curImageArray.count > 0){
        [contView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo((UIImageView*)[contView viewWithTag:([_curImageArray count] - 1 + 20)].mas_right);
        }];
    }
    [_scrollView setContentOffset:CGPointMake(self.mj_size.width*_curPage, 0)];
    
}

-(void)lodaData{
    NSLog(@"[RYAN] HomeHeadView > lodaData");
    
    NSMutableArray *mainItems = [[DeviceDataBase sharedDataBase] selectDevice];
    
    if (!self.modelSource) {
        self.modelSource = [[NSMutableArray alloc]init];
    }
    
    self.modelSource  = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/devices.archiver"]];
    
    self.modelSource = [ArrayTool addJudgeArr:self.modelSource UpdateArr:mainItems];
    self.modelSource = [ArrayTool deletJundgeArr:self.modelSource UpdateArr:mainItems];
    self.modelSource = [ArrayTool updateJundgeArr:self.modelSource UpdateArr:mainItems];
    
    NSLog(@"[RYAN] HomeHeadView > modelSource size : %lu", [self.modelSource count]);
    
//    [self.bookShelfMainView initWithData:self.modelSource];
//    [self.bookShelfMainView reloadData];
}

- (UIImageView*)addDeviceItem:(UIImageView *)imageView index:(int)i {
    ItemData *device = [self.modelSource objectAtIndex:i];

    float rangeW = Main_Screen_Width/3;
    float rangeH = Main_Screen_Width/4 + 20;
    
    float left = 0.0f;
    float offsetY = 0.0f;
    float offsetX = left;
    if (i==0) {
        offsetY = rangeH;
    } else if (i==1) {
        offsetY = rangeH;
        offsetX += rangeW;
    } else if (i==2) {
        offsetY = rangeH;
        offsetX += rangeW*2;
    } else if (i==3) {
        offsetY = rangeH*2;
    } else if (i==4) {
        offsetY = rangeH*2;
        offsetX += rangeW;
    } else if (i==5) {
        offsetY = rangeH*2;
        offsetX += rangeW*2;
    }
    
    BOOL isGroup = [device isKindOfClass:[NSArray class]];
    
    UIImageView *deviceImage = [UIImageView new];
    [imageView addSubview:deviceImage];
    deviceImage.userInteractionEnabled = FALSE;
    if (isGroup) {
        [deviceImage setImage:[UIImage imageNamed:@"sbz_icon"]];
    } else {
        [deviceImage setImage:[UIImage imageNamed:device.image]];
    }
    
    NSString* deviceName;
    if (isGroup) {
        deviceName = @"Group";
    } else {
        if([device.customTitle isEqualToString:@""]){
            deviceName = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(device.title, nil) ,device.devID];
        }else{
            deviceName = device.customTitle;
        }
    }
    
    int labelHeight = 20;
    CGRect rect = CGRectMake(offsetX, offsetY , rangeW, labelHeight);
    UILabel *labelDevice = [[UILabel alloc] initWithFrame:rect];
    labelDevice.textAlignment = NSTextAlignmentCenter;
    labelDevice.text = deviceName;
    labelDevice.numberOfLines = 1; //0 表示label可以多行显示
//    labelDevice.lineBreakMode = NSLineBreakByCharWrapping;//换行模式
//    [labelDevice sizeToFit];
    
    labelDevice.textColor = RGB(255, 255, 255);
    labelDevice.font = [UIFont systemFontOfSize:14.0f];
    
    [imageView addSubview:labelDevice];

    
    NSLog(@"[RYAN] imageView.frame.size.width:%f", imageView.frame.size.width);
    NSLog(@"[RYAN] labelDevice.frame.size.width:%f", labelDevice.frame.size.width);

//    [labelDevice mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(imageView.mas_top).offset(offsetY);
//        make.centerX.mas_equalTo(imageView.left).offset(offsetX);
//    }];

    [deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(60);
        make.bottom.mas_equalTo(imageView.mas_top).offset(offsetY);
        make.centerX.mas_equalTo(imageView.left).offset(offsetX + rangeW/2);
    }];
    
    if (!isGroup) {
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
//        singleTap.numberOfTapsRequired = 1;
//        [deviceImage addGestureRecognizer:singleTap];
        [deviceImage setUserInteractionEnabled:YES];
        [deviceImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    }

    return deviceImage;
}

//-(void)tapDetected{
//    NSLog(@"[RYAN] single Tap on imageview");
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
//    DeviceDetailVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DeviceDetailVC"];
//    vc.data = [self.modelSource objectAtIndex:0];
//    [self.subVC.navigationController pushViewController:vc animated:YES];
//}

-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"[RYAN] clickCategory");
    
    UIView *viewClicked=[gestureRecognizer view];
    
    int index=0;
    for (int i=0; i<[self.deviceItems count]; i++) {
        if (viewClicked == [self.deviceItems objectAtIndex:i]) {
            index = i;
            break;
        }
    }
    NSLog(@"[RYAN] viewClicked index: %d", index);
    
    ItemData *data = [self.modelSource objectAtIndex:index];
    
    if([data.title isEqualToString:@"温控器"]){
        TempControlDetailVC *vc = [[TempControlDetailVC alloc] init];
        vc.data = data;
        [self.subVC.navigationController pushViewController:vc animated:YES];
    }
    else if ([data.title isEqualToString:@"情景开关"]) {
        SceneDetailVC *sdVC = [[SceneDetailVC alloc] init];
        sdVC.data = data;
        [self.subVC.navigationController pushViewController:sdVC animated:YES];
    }
    else if ([data.title isEqualToString:@"调光模块"]) {
        LightDetailVC *ldVC = [[LightDetailVC alloc] init];
        ldVC.data = data;
        [self.subVC.navigationController pushViewController:ldVC animated:YES];
    }
    else {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"DeviceStoryboard" bundle:nil];
        DeviceDetailVC *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"DeviceDetailVC"];
        vc.data = data;
        [self.subVC.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    int index = scrollView.contentOffset.x/self.mj_size.width;
    
    if (index > _curPage) {
        
        _curPage = index;
        [scrollView setContentOffset:CGPointMake(self.mj_size.width*_curPage, 0)];
    }else if (index < _curPage){
        _curPage --;
    }
}


//停止滚动的时候回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置scrollView偏移位置
//    [scrollView setContentOffset:CGPointMake(self.mj_size.width, 0) animated:YES];
    //设置页数
    _pageControl.currentPage = _curPage;
}

- (void)reloadData
{
    //设置页数
    _pageControl.currentPage = _curPage;
    //根据当前页取出图片
    [self getDisplayImagesWithCurpage:_curPage];
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if ([subViews count] > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //创建imageView
    [self setImages];

}

- (void)setVideoArray:(NSMutableArray *)videoArray
{
    _videoArray = videoArray;
    //设置分页控件的总页数
    _pageControl.numberOfPages = videoArray.count;
    //刷新图片
    [self reloadData];
    
//    _scrollView.contentOffset = CGPointMake(self.mj_size.width*2, 0);

    
    //开启定时器
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
    
    //判断图片长度是否大于1，如果一张图片不开启定时器
//    if ([imageArray count] > 1) {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:10000000000.0 target:self selector:@selector(timerScrollImage) userInfo:nil repeats:NO];
//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate date]];
//    }
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page
{
    //取出开头和末尾图片在图片数组里的下标
    NSInteger front = page - 1;
    NSInteger last = page + 1;
    
    //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
    if (page == 0) {
        front = [self.videoArray count]-1;
    }
    
    //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
    if (page == [self.videoArray count]-1) {
        last = 0;
    }
    
    //如果当前图片数组不为空，则移除所有元素
    if ([_curImageArray count] > 0) {
        [_curImageArray removeAllObjects];
    }
    
    //当前图片数组添加图片
    for (int i = 0; i < [self.videoArray count]; i++) {
        
        VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
        NSDictionary *videoDic = (NSDictionary *)self.videoArray[i];
        vInfo.devid = videoDic[@"devid"];
        vInfo.name = videoDic[@"name"];
        [_curImageArray addObject:vInfo];
    }
}

-(void)timerScrollImage{
    //刷新图片
    [self reloadData];
    
    //设置scrollView偏移位置
    [self.scrollView setContentOffset:CGPointMake(self.mj_size.width*2, 0) animated:YES];
}

-(void)tapImage:(id *)sender{
    NSLog(@"[RYAN] tapImage");
    //设置代理
    if ([_delegate respondsToSelector:@selector(cycleScrollView:didSelectImageView:videoInfos:)]) {
        [_delegate cycleScrollView:self didSelectImageView:_curPage videoInfos:_curImageArray];
    }
}

- (void)dealloc
{
    //代理指向nil，关闭定时器
    self.scrollView.delegate = nil;
//    [_timer invalidate];
}
@end

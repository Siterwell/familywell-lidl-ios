//
//  FunctionScrollView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/2.
//  Copyright © 2017年 riceFun. All rights reserved.
//

#import "FunctionScrollView.h"
#import "GUI.h"
@interface FunctionScrollView()
@property (nonatomic,strong)UIView *firstView;//第一个界面
@property (nonatomic,strong)UIView *secondView;//第二个界面
@property (nonatomic,strong)UIView *thridView;//第三个界面
@property (nonatomic,strong)UIPageControl *pageControl;//页面指示点

@property (nonatomic,strong)UIView *derectionView;//用于放置上下左右的view


@end

@implementation FunctionScrollView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(frame.size.width,frame.size.height);//三部分所以*3
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        self.pagingEnabled = YES;//整页滚动
        self.bounces = NO;//边缘不弹跳
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        
        [self addSubview:self.firstView];
//        [self addSubview:self.secondView];
//        [self addSubview:self.thridView];
     }
    return self;
}

#pragma mark lazyload
- (UIView *)firstView{
    if (!_firstView) {
        _firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _firstView.backgroundColor = RGB(230, 230, 230);
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        topView.backgroundColor = RGB(240, 240, 240);
        [_firstView addSubview:topView];
        
        //语音
        self.intercomBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
        self.intercomBtn.titleLabel.lineBreakMode = 0;    //title文字多行显示
        self.intercomBtn.center = CGPointMake(topView.frame.size.width/2, topView.frame.size.height/2-20);
        [self.intercomBtn setBackgroundImage:[UIImage imageNamed:@"21-长按语音对话未选中"] forState:UIControlStateNormal];
        [self.intercomBtn setBackgroundImage:[UIImage imageNamed:@"22-长按语音对话选中"] forState:UIControlStateHighlighted];
        NSLog(@"%@",NSStringFromCGRect(self.intercomBtn.frame));
        [topView addSubview:self.intercomBtn];
        
        UILabel *yuyin = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.intercomBtn.frame)+8, [UIScreen mainScreen].bounds.size.width, 40)];
        yuyin.text = NSLocalizedString(@"长按语音对话", nil);
        yuyin.textAlignment = NSTextAlignmentCenter;
        yuyin.font = [UIFont systemFontOfSize:15];
        yuyin.textColor = [UIColor darkGrayColor];
        [topView addSubview:yuyin];
        
        //图片库
        self.iconLbrBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(0, 0, 72, 72)];
        self.iconLbrBtn.center = CGPointMake(topView.frame.size.width/2 - 110, topView.frame.size.height/2-20);
        [self.iconLbrBtn setBackgroundImage:[UIImage imageNamed:@"18-照片管理未选中"] forState:UIControlStateNormal];
        [self.iconLbrBtn setBackgroundImage:[UIImage imageNamed:@"17-照片管理选中"] forState:UIControlStateHighlighted];
        [topView addSubview:self.iconLbrBtn];
        
        
        //视频库
        self.videoLbrBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(0, 0, 72, 72)];
        self.videoLbrBtn.center = CGPointMake(topView.frame.size.width/2 + 110, topView.frame.size.height/2-20);
        [self.videoLbrBtn setBackgroundImage:[UIImage imageNamed:@"20-视频管理未选中"] forState:UIControlStateNormal];
        [self.videoLbrBtn setBackgroundImage:[UIImage imageNamed:@"19-视频管理选中"] forState:UIControlStateHighlighted];
        [topView addSubview:self.videoLbrBtn];
        

        CGFloat derectionViewWidth = self.bounds.size.width/2 < self.bounds.size.height ? self.bounds.size.width/2 : self.bounds.size.height;
        
        CGFloat buttonWidth = derectionViewWidth/3 - 10;
        
        //右侧方向键视图
        self.derectionView = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height/3 + 1, self.bounds.size.width, self.bounds.size.height/2)];
        self.derectionView.center = CGPointMake(self.bounds.size.width/2 - buttonWidth, self.bounds.size.height*2/3);
        self.derectionView.backgroundColor = [UIColor clearColor];
//        [_firstView addSubview:self.derectionView];
        
        CGFloat toleft = (self.bounds.size.width - buttonWidth)/2;
        
        self.upBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(buttonWidth + toleft, 0, buttonWidth, buttonWidth)];
        [self.upBtn setTitle:TS("up") forState:UIControlStateNormal];
//        [self.derectionView addSubview:self.upBtn];
        
        self.downBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(buttonWidth+toleft,2 * buttonWidth, buttonWidth, buttonWidth)];
        [self.downBtn setTitle:TS("down") forState:UIControlStateNormal];
//        [self.derectionView addSubview:self.downBtn];
        
        self.leftBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(toleft, buttonWidth, buttonWidth, buttonWidth)];
        [self.leftBtn setTitle:TS("left") forState:UIControlStateNormal];
//        [self.derectionView addSubview:self.leftBtn];
        
        self.rightBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(toleft+buttonWidth * 2, buttonWidth, buttonWidth, buttonWidth)];
        [self.rightBtn setTitle:TS("right") forState:UIControlStateNormal];
//        [self.derectionView addSubview:self.rightBtn];
        
        //右侧 预设点列表
        UIView *ysdVeiw = [[UIView alloc]initWithFrame:CGRectMake(derectionViewWidth, self.bounds.size.height/3 + 1, self.bounds.size.width - derectionViewWidth, self.bounds.size.height*2/3)];
//        [_firstView addSubview:ysdVeiw];
        
        CGFloat ysdBtnWidth = self.bounds.size.width - derectionViewWidth - 60;
        CGFloat ysdBtnHight = 40.0f;
        
        //设置预设点
        self.szysdBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(30.0f, buttonWidth, ysdBtnWidth, ysdBtnHight)];
        [self.szysdBtn  setTitle:TS("本地图片及视频") forState:UIControlStateNormal];
        self.szysdBtn.backgroundColor = [UIColor grayColor];
//        [ysdVeiw addSubview:self.szysdBtn];
        
        //设置预设点
        self.ysdListBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(30.0f, buttonWidth + ysdBtnHight + ysdBtnHight, ysdBtnWidth, ysdBtnHight)];
        [self.ysdListBtn  setTitle:TS("预设点列表") forState:UIControlStateNormal];
        self.ysdListBtn.backgroundColor = [UIColor grayColor];
//        [ysdVeiw addSubview:self.ysdListBtn];
        
    
        //左侧6个功能按钮视图
        UIView *firstViewLeftVeiw = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height)];
//        firstViewLeftVeiw.backgroundColor = [UIColor redColor];
//        [_firstView addSubview:firstViewLeftVeiw];
        
        CGFloat buttonHeight = (self.bounds.size.height - 20)/3;
        
        //zoom
        self.zoomDownBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
        self.zoomDownBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        self.zoomDownBtn.layer.borderWidth = 2;
        [self.zoomDownBtn  setTitle:TS("-") forState:UIControlStateNormal];
        [firstViewLeftVeiw addSubview:self.zoomDownBtn];
        
        UILabel *zoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight)];
        zoomLabel.text = TS("zoom");
        zoomLabel.textColor = [UIColor cyanColor];
        zoomLabel.textAlignment = NSTextAlignmentCenter;
        [firstViewLeftVeiw addSubview:zoomLabel];
        
        self.zoomUpBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight)];
        self.zoomUpBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        self.zoomUpBtn.layer.borderWidth = 2;
        [self.zoomUpBtn  setTitle:TS("+") forState:UIControlStateNormal];
        [firstViewLeftVeiw addSubview:self.zoomUpBtn];
        
        
        //focus
        self.focusDownBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(0, buttonHeight, buttonWidth, buttonHeight)];
        self.focusDownBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        self.focusDownBtn.layer.borderWidth = 2;
        [self.focusDownBtn  setTitle:TS("-") forState:UIControlStateNormal];
        [firstViewLeftVeiw addSubview:self.focusDownBtn];
        
        UILabel *focusLabel = [[UILabel alloc]initWithFrame:CGRectMake(buttonWidth, buttonHeight, buttonWidth, buttonHeight)];
        focusLabel.text = TS("focus");
        focusLabel.textColor = [UIColor cyanColor];
        focusLabel.textAlignment = NSTextAlignmentCenter;
        [firstViewLeftVeiw addSubview:focusLabel];
        
        self.focusUpBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(buttonWidth*2, buttonHeight, buttonWidth, buttonHeight)];
        self.focusUpBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        self.focusUpBtn.layer.borderWidth = 2;
        [self.focusUpBtn  setTitle:TS("+") forState:UIControlStateNormal];
        [firstViewLeftVeiw addSubview:self.focusUpBtn];
        
        
        //irisUpBtn
        self.irisDownBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(0, buttonHeight*2, buttonWidth, buttonHeight)];
        self.irisDownBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        self.irisDownBtn.layer.borderWidth = 2;
        [self.irisDownBtn  setTitle:TS("-") forState:UIControlStateNormal];
        [firstViewLeftVeiw addSubview:self.irisDownBtn];
        
        UILabel *irisLabel = [[UILabel alloc]initWithFrame:CGRectMake(buttonWidth, buttonHeight*2, buttonWidth, buttonHeight)];
        irisLabel.text = TS("iris");
        irisLabel.textColor = [UIColor cyanColor];
        irisLabel.textAlignment = NSTextAlignmentCenter;
        [firstViewLeftVeiw addSubview:irisLabel];
        
        self.irisUpBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(buttonWidth*2, buttonHeight*2, buttonWidth, buttonHeight)];
        self.irisUpBtn.layer.borderColor = [UIColor cyanColor].CGColor;
        self.irisUpBtn.layer.borderWidth = 2;
        [self.irisUpBtn  setTitle:TS("+") forState:UIControlStateNormal];
        [firstViewLeftVeiw addSubview:self.irisUpBtn];        
    }
    return _firstView;
}


-(UIView *)secondView{
    if (!_secondView) {
        _secondView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        _secondView.backgroundColor = [UIColor blackColor];
        _secondView.alpha = 0.6;
        
        self.intercomBtn = [[RFCustomButton alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        self.intercomBtn.titleLabel.lineBreakMode = 0;//title文字多行显示
        self.intercomBtn.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.intercomBtn.backgroundColor = [UIColor blueColor];
        [self.intercomBtn setTitle:TS("Press intercom") forState:UIControlStateNormal];
        NSLog(@"%@",NSStringFromCGRect(self.intercomBtn.frame));
        [_secondView addSubview:self.intercomBtn];
    }
    return _secondView;
}

-(UIView *)thridView{
    if (!_thridView) {
        _thridView = [[UIView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height)];
        _thridView.backgroundColor = [UIColor blackColor];
        _thridView.alpha = 0.7;
        
    }
    return _thridView;
}


@end

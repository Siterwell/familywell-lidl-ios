//
//  JhDownProgressController.m
//  JhDownProgressView
//
//

#import "JhDownProgressController.h"
#import "JhDownProgressView.h"

@interface JhDownProgressController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer2;

@property (nonatomic, strong) JhDownProgressView *progressView;
@property (nonatomic, strong) JhDownProgressView *progressView2;
@property (nonatomic, strong) JhDownProgressView *progressView3;
@property (nonatomic, strong) JhDownProgressView *progressView4;
@property (nonatomic, strong) JhDownProgressView *progressView5;
@property (nonatomic, strong) JhDownProgressView *progressView6;



@end

@implementation JhDownProgressController

-(void)setNOClick{
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled=NO;//将nav事件禁止
    self.tabBarController.tabBar.userInteractionEnabled=NO;//将tabbar事件禁止
}

-(void)setYESClick{
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled=YES;
    self.tabBarController.tabBar.userInteractionEnabled=YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   self.modalPresentationStyle = UIModalPresentationCustom;
    /********************************* 模拟下载 ********************************/
    [self setNOClick]; //真实下载时如果不让交互使用
    
    //点击下载按钮 ,开始下载
    //创建控件
    [self creatControl];
    //添加定时器
    [self addTimer];
    /********************************* 模拟下载 ********************************/
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeTimer];
    [self removeTimerApi];
}

#pragma mark - 点击背景
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
     NSLog(@"模拟交互 点击背景 ");
    
}


- (void)creatControl
{
    
    JhDownProgressView *proress = [JhDownProgressView showWithStyle:JhStyle_percentAndText];
    proress.TextLabel.text = _hintMessage;
//    JhDownProgressView *progressView = [JhDownProgressView showWithStyle:JhStyle_percentAndRing];
//    JhDownProgressView *progressView = [JhDownProgressView showWithStyle:JhStyle_Ring];
//    JhDownProgressView *progressView = [JhDownProgressView showWithStyle:JhStyle_Sector];
//    JhDownProgressView *progressView = [JhDownProgressView showWithStyle:JhStyle_Rectangle];
//    JhDownProgressView *progressView = [JhDownProgressView showWithStyle:JhStyle_ball];
    [self.view addSubview:proress];
    _progressView = proress;
    
    
    
//    JhDownProgressView *proress2 = [[JhDownProgressView alloc]initWithFrame:CGRectMake(20, 100, 150, 120)];
//    proress2.jhDownProgressViewStyle = JhStyle_percentAndRing;
//    [self.view addSubview:proress2];
//    _progressView2 = proress2;
//
//    JhDownProgressView *proress3 = [[JhDownProgressView alloc]initWithFrame:CGRectMake(200, 100, 150, 120)];
//    proress3.jhDownProgressViewStyle = JhStyle_Ring;
//    [self.view addSubview:proress3];
//    _progressView3 = proress3;
//
//
//    JhDownProgressView *proress4 = [[JhDownProgressView alloc]initWithFrame:CGRectMake(20, 600, 150, 120)];
//    proress4.jhDownProgressViewStyle = JhStyle_Sector;
//    [self.view addSubview:proress4];
//    _progressView4 = proress4;
//
//
//    JhDownProgressView *proress5 = [[JhDownProgressView alloc]initWithFrame:CGRectMake(200, 300, 150, 15)];
//    proress5.jhDownProgressViewStyle = JhStyle_Rectangle;
//    [self.view addSubview:proress5];
//    _progressView5 = proress5;
//
//
//    JhDownProgressView *proress6= [[JhDownProgressView alloc]initWithFrame:CGRectMake(200, 600, 150, 120)];
//    proress6.jhDownProgressViewStyle = JhStyle_ball;
//    [self.view addSubview:proress6];
//    _progressView6 = proress6;
    
    
    
}

- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timer1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _timer2 = [NSTimer scheduledTimerWithTimeInterval:self.timerApi target:self selector:@selector(timerApiAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer2 forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if(!_success)
    _progressView.progress += 0.01;
    else{
    _progressView.progress += 0.30;
    }
//    _progressView2.progress += 0.01;
//    _progressView3.progress += 0.01;
//    _progressView4.progress += 0.01;
//    _progressView5.progress += 0.01;
//    _progressView6.progress += 0.01;
    if (_progressView.progress >= 1) {
        [self removeTimer];
        NSLog(@"下载完成");
        [self setYESClick];
        [self dismissViewControllerAnimated:NO completion:nil];
        self.finish(_success);
    }
}

-(void) timerApiAction{
    self.getApi();
    
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)removeTimerApi
{
    [_timer2 invalidate];
    _timer2 = nil;
}
@end

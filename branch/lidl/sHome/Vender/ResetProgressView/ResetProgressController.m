//
//  ResetProgressController.m
//
//

#import "ResetProgressController.h"
#import "CircleScaleView.h"

@interface ResetProgressController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) CircleScaleView *circle;

@property (nonatomic,strong) UILabel *unit_label;

@property (nonatomic,strong) UILabel *count_label;

@property (nonatomic,assign) int count;
@end

@implementation ResetProgressController

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
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self rotote];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeTimer];
}

#pragma mark - 点击背景
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
     NSLog(@"模拟交互 点击背景 ");
    
}


- (void)creatControl
{
    
    
    CGFloat width = Main_Screen_Width-100;
    CGFloat height = Main_Screen_Width-100;
    
    
    CGRect frame = CGRectMake((Main_Screen_Width-width)/2,(Main_Screen_Height-height)/2, width, height+100);
 
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.cornerRadius = 10;
    view.clipsToBounds = YES;
    view.backgroundColor =[UIColor whiteColor];
    
    
 
    
    CGRect frame2 = CGRectMake(0,100, width, height);
    _circle = [[CircleScaleView alloc] initWithFrame:frame2];
    [view addSubview:_circle];
    
    _count_label = [[UILabel alloc] init];
    [_count_label setTextColor:ThemeColor];
    [_count_label setFont:SYSTEMFONT(60)];
    _count_label.text = @"60";
    [view addSubview:_count_label];
    [_count_label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY).offset(50);
    }];
    
    _unit_label = [[UILabel alloc] init];
    [_unit_label setTextColor:ThemeColor];
    [_unit_label setFont:SYSTEMFONT(30)];
    _unit_label.text = NSLocalizedString(@"秒", nil);
    [view addSubview:_unit_label];
    [_unit_label makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.equalTo(view.mas_centerX);
          make.top.equalTo(_count_label.mas_bottom).offset(20);
    }];
    
    CGRect frame3 = CGRectMake(0,20, width, 60);
    UITextView *txt = [[UITextView alloc] initWithFrame:frame3];
    [txt setFont:SYSTEMFONT(20)];
    [txt setTextColor:ThemeColor];
    [txt setText:_hintTitle];
    [view addSubview:txt];
    [txt setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:view];
    

}

- (void)addTimer
{
    _count = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timer1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)timerAction
{
    _count ++;
    _count_label.text = [NSString stringWithFormat:@"%d",(60-_count)];
    if (_count >= 60) {
        [self removeTimer];
        NSLog(@"下载完成");
        [self setYESClick];
        [self dismissViewControllerAnimated:NO completion:nil];
        if(self.finish!=nil){
                  self.finish(_success);
        }
    }
}


- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)rotote{
    
    [_circle.layer removeAnimationForKey:@"A"];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        animation.duration = 6;
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
        [_circle.layer addAnimation:animation forKey:@"A"];
    
}

@end

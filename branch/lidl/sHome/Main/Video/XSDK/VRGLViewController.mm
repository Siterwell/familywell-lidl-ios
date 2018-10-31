//
//  VRGLViewController.m
//  VRDemo
//
//  Created by J.J. on 16/8/26.
//  Copyright © 2016年 xm. All rights reserved.
//

#import "VRGLViewController.h"
#import "VRSoft.h"
#import "VRFunctionView.h"

@interface VRGLViewController ()
{
    VRHANDLE mVRHandle;
    XMVRType mVRType;
    UInt64 mTimeTouchDown;
    double mTouchDownX;
    double mTouchDownY;
    QUEUE_YUV_DATA _yuvDatas;
    unsigned char * _pbyYUV;
    
    int _nYUVBufLen;
    int shapeNum;
    
}
@property(strong,nonatomic)EAGLContext *context;
@property(strong,nonatomic)GLKBaseEffect *effect;
@property(nonatomic,strong)VRFunctionView *functionView;
@end
@implementation VRGLViewController

-(id)init{
    self = [super init];
    if ( self ) {
        // mVRType = XMVR_TYPE_180D;   // default
    }
    return self;
}


-(void)setVRShapeType:(XMVRShape)shapetype{
//    NSLog(@"\n\n-------> setVRType = %d\n\n", mVRType);
    if ( mVRHandle ) {
        VRSoft_SetShape(mVRHandle, shapetype);
    }
}
-(void)setVRType:(XMVRType)type {
    // set 180VR or 360VR
    mVRType = type;
    [self.functionView showFunctionViewWith:type];
//    NSLog(@"\n\n-------> setVRType = %d\n\n", mVRType);
    if ( mVRHandle ) {
        VRSoft_SetType(mVRHandle, mVRType);
    }
    if(mVRType == XMVR_TYPE_360D){
        VRSoft_SetCameraMount(mVRHandle,Ceiling);
    }
}
-(void)setVRVRCameraMount:(XMVRMount)Mount
{
    VRSoft_SetCameraMount(mVRHandle,Mount);
    
}
-(void)setVRFecParams:(int)xCenter yCenter:(int)yCenter radius:(int)radius Width:(int)imgWidth Height:(int)imgHeight
{
    if (mVRHandle) {
        
        VRSoft_SetFecParams(mVRHandle, xCenter, yCenter, radius, imgWidth, imgHeight);
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor orangeColor];
    // 使用“ES2”创建一个“EAGLEContext”实例
    
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // 将“view”的context设置为这个“EAGLContext”实例的引用。并且设置颜色格式和深度格式。
    GLKView* view = (GLKView*)self.view;
    
    view.context = self.context;
    
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    
    // 将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。随后，发送第一个“GL”指令：激活“深度检测”。
    
    [EAGLContext setCurrentContext:_context];
    
    self.preferredFramesPerSecond = 60;
    //glEnable(GL_DEPTH_TEST);
    
    VRSoft_Create(&mVRHandle);
    
    VRSoft_Prepare(mVRHandle);
    
//    NSLog(@"\n\n-------> mVRType = %d\n\n", mVRType);
    VRSoft_SetType(mVRHandle, mVRType);
    
    // 1.0.7版本之后必须设置版权声明信息 /*下方COPYRIGHT CODE  需要替换成贵公司自己的版权代码(该版权代码，需要向雄迈申请) 如果没有填写版权信息，在屏幕左下方显示雄迈公司logo*/
    VRSoft_SetAttribute(mVRHandle, "COPYRIGHT", "COPYRIGHT CODE");
    VRSoft_SetAttribute(mVRHandle, "PLATFORM", "iOS");

    UIPinchGestureRecognizer * twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(touchesPinch:)];
    [self.view addGestureRecognizer:twoFingerPinch];
    
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [self.view addGestureRecognizer:doubleRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
    self.VRFunction = [[UIButton alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 60,60,60)];
    [self.VRFunction setImage:[UIImage imageNamed:@"360VR-ins_default"] forState:UIControlStateNormal];
    BUTTON_TARGET(self.VRFunction, showVRFunctionView);
    [self.view addSubview:self.VRFunction];
}

//显示壁挂吸顶功能菜单
-(void)showVRFunctionView:(UIButton *)btn{
    self.VRFunction.hidden = YES;
    [self.view addSubview:self.functionView];
}


//关闭壁挂吸顶功能菜单 并显示功能按钮
- (void)closeFunctionViewAndShowFunctionVRButton{
    self.VRFunction.hidden = NO;
    self.VRFunction.frame = CGRectMake(0,self.view.frame.size.height - 60,60,60);
}

#pragma mark lazyload
-(VRFunctionView *)functionView{
    if(!_functionView){
        _functionView = [[VRFunctionView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width,60)];
        [_functionView.closeMode addTarget:self action:@selector(closeFunctionViewAndShowFunctionVRButton) forControlEvents:UIControlEventTouchUpInside];
#pragma mark 360
        [_functionView.war addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.ceiling addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.Ball addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.Rectangle addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.BallBowl addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.BallHat addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.Cylinder addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.Split addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.dichotomia addTarget:self action:@selector(clickVRFunctionBottun:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark 180
        [_functionView.curve_180 addTarget:self action:@selector(click_curve_180:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.rectangle_180 addTarget:self action:@selector(click_rectangle_180:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.cylindrical_180 addTarget:self action:@selector(click_cylindrical_180:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.split_180 addTarget:self action:@selector(click_split_180:) forControlEvents:UIControlEventTouchUpInside];
        [_functionView.three_180 addTarget:self action:@selector(click_three_180:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _functionView;
}






-(void)creatGLKView
{
    GLKView* view = (GLKView*)self.view;
    
    // 使用“ES2”创建一个“EAGLEContext”实例
    // 将“view”的context设置为这个“EAGLContext”实例的引用。并且设置颜色格式和深度格式。
    
    //去掉这两句普通相机可以，加上这两句鱼眼相机可以，待调试。
    
    if (!_context) {
        _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
        view.context = _context;
        
        view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
        view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
        
        
        // 将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。随后，发送第一个“GL”指令：激活“深度检测”。
        
        BOOL result = [EAGLContext setCurrentContext:_context];
        
        self.preferredFramesPerSecond = 60;
    }
    
    [self.view setNeedsDisplay];
    
    //glEnable(GL_DEPTH_TEST);
}

-(void)SetPPIandInt
{
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    VRSoft_SetPPIZoom(scale_screen);
    if (TARGET_IPHONE_SIMULATOR || scale_screen != 3) {
        VRSoft_Init(mVRHandle,
                    self.view.frame.size.width ,
                    self.view.frame.size.height );
        //        NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
        
        
    }else{
        
        VRSoft_Init(mVRHandle,
                    self.view.frame.size.width * 414 * 1080 / 1242 / 375,
                    self.view.frame.size.height * 414 * 1920 / 2208 / 375);
        //        NSLog(@"%f,%f,%f,%f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        //        NSLog(@"-->>>>>>>-");
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"\n---------> vrview width : %f\n", self.view.frame.size.width);
//    NSLog(@"\n---------> vrview height : %f\n", self.view.frame.size.height);
    
    VRSoft_Init(mVRHandle,
                self.view.frame.size.width,
                self.view.frame.size.height);
//    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    VRSoft_SetPPIZoom(scale_screen);
    
}
- (void)update {
    
    //[self drawYUVFrame];
    
}


-(void)reloadInitView:(CGRect)frame
{
    VRSoft_Init(mVRHandle,
                frame.size.width,
                frame.size.height);
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 1.0f);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self loadYUVImageFromFile];
    
    VRSoft_Drawself(mVRHandle);
}




//-(void)SoftTouchMoveBegan:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent
//{
//    NSLog(@"---> touchesBegan");
//    for(UITouch *touch in Softevent.allTouches) {
//
//        CGPoint locInSelf = [touch locationInView:self.view];
//
//        VRSoft_OnTouchDown(mVRHandle, locInSelf.x, locInSelf.y);
//
//        mTouchDownX = locInSelf.x;
//        mTouchDownY = locInSelf.y;
//        mTimeTouchDown = [self getTimeMS];
//        // 只处理一个点就可以了
//        break;
//    }
//
//}
//
//-(void)SoftTouchMove:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent
//{
//    //NSLog(@"---> touchesMoved");
//    // 最多只处理两个点
//    GLfloat values[4];
//    int pointerCount = 0;
//
//    for(UITouch *touch in Softevent.allTouches) {
//        if ( pointerCount < 2 ) {
//            CGPoint locInSelf = [touch locationInView:self.view];
//            values[pointerCount*2] = locInSelf.x;
//            values[pointerCount*2 + 1] = locInSelf.y;
//            pointerCount ++;
//            continue;
//        } else {
//            break;
//        }
//    }
//
//    if ( pointerCount == 1 ) {
//        VRSoft_OnTouchMove(mVRHandle, values[0], values[1]);
//    }
//}
//
//-(void)SoftTouchMoveEnd:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent
//{
//    for(UITouch *touch in Softevent.allTouches) {
//
//        CGPoint locInSelf = [touch locationInView:self.view];
//
//        VRSoft_OnTouchUp(mVRHandle, locInSelf.x, locInSelf.y);
//
//        UInt64 timeOffset = [self getTimeMS] - mTimeTouchDown;
//        if ( timeOffset > 0 && timeOffset < 200 ) {
//            double dx = locInSelf.x - mTouchDownX;
//            double dy = locInSelf.y - mTouchDownY;
//
//            NSLog(@"---> timeOffset = %llu, dx = %f, dy = %f", timeOffset, dx, dy);
//            if((dx > -10 && dx < 10) && (dy > -10 && dy < 10)){
//                return;
//            }
//            double velocityX = dx * 1000 / timeOffset;
//            double velocityY = dy * 1000 / timeOffset;
//
//            NSLog(@"---> velocityX = %f, velocityY = %f", velocityX, velocityY);
//
//            VRSoft_OnTouchFling(mVRHandle, velocityX*2, velocityY*2);
//        }
//
//        // 只处理一个点就可以了
//        break;
//    }
//
//    [self performSelector:@selector(delayAutoAdjust) withObject:nil afterDelay:0.12f];
//
//}
#pragma mark 捏合
-(void)SoftTouchesPinch:(CGFloat)scale
{
    VRSoft_OnTouchPinchScale(mVRHandle,scale);
}
//鱼眼YUV数据
-(void)PushData:(int)width height:(int)height YUVData:(unsigned char *)pData
{
    
    //    @synchronized(self)
    {
        SYUVData *pNew = new SYUVData(width, height, pData);
        _yuvDatas.push(pNew);
        int nSize = (int)_yuvDatas.size();
        for (int i = 4; i < nSize; i++) {
            SYUVData *item = _yuvDatas.front();
            _yuvDatas.pop();
            delete item;
        }
    }
}
-(SYUVData *)PopData
{
    SYUVData *pItem = NULL;
    //    @synchronized(self)
    {
        if (!_yuvDatas.empty()) {
            pItem = _yuvDatas.front();
            _yuvDatas.pop();
        }
    }
    return pItem;
    
    
}
- (void)loadYUVImageFromFile
{
    SYUVData *pData = [self PopData];
    if (pData) {
        int nDataLen = pData->width * pData->height * 3 / 2;
        
        
        if (_nYUVBufLen< nDataLen || _pbyYUV == NULL) {
            if (_pbyYUV) {
                free(_pbyYUV);
                _pbyYUV = NULL;
            }
            _pbyYUV = (unsigned char *)malloc(nDataLen);//new unsigned char[nDataLen];
            _nYUVBufLen = nDataLen;
        }
        memcpy(_pbyYUV, pData->pData, nDataLen);
        
        VRSoft_SetYUV420PTexture(mVRHandle,_pbyYUV, _nYUVBufLen , pData->width, pData->height );
        
        
        delete pData;
        //[self ClearYUVData];
    }
    
    
}


-(UInt64)getTimeMS{
    return [[NSDate date] timeIntervalSince1970]*1000;
}

-(void)delayAutoAdjust {
    VRSoft_AutoAdjust(mVRHandle);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"---> touchesBegan");
    for(UITouch *touch in event.allTouches) {
        
        CGPoint locInSelf = [touch locationInView:self.view];
        
        VRSoft_OnTouchDown(mVRHandle, locInSelf.x, locInSelf.y);
        
        mTouchDownX = locInSelf.x;
        mTouchDownY = locInSelf.y;
        mTimeTouchDown = [self getTimeMS];
        // 只处理一个点就可以了
        break;
    }
    
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"---> touchesMoved");
    // 最多只处理两个点
    GLfloat values[4];
    int pointerCount = 0;
    
    for(UITouch *touch in event.allTouches) {
        if ( pointerCount < 2 ) {
            CGPoint locInSelf = [touch locationInView:self.view];
            values[pointerCount*2] = locInSelf.x;
            values[pointerCount*2 + 1] = locInSelf.y;
            pointerCount ++;
            continue;
        } else {
            break;
        }
    }
    
    if ( pointerCount == 1 ) {
        VRSoft_OnTouchMove(mVRHandle, values[0], values[1]);
    }
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in event.allTouches) {
        
        CGPoint locInSelf = [touch locationInView:self.view];
        
        VRSoft_OnTouchUp(mVRHandle, locInSelf.x, locInSelf.y);
        
        UInt64 timeOffset = [self getTimeMS] - mTimeTouchDown;
        if ( timeOffset > 0 && timeOffset < 200 ) {
            double dx = locInSelf.x - mTouchDownX;
            double dy = locInSelf.y - mTouchDownY;
            
//            NSLog(@"---> timeOffset = %llu, dx = %f, dy = %f", timeOffset, dx, dy);
            if((dx > -10 && dx < 10) && (dy > -10 && dy < 10)){
                return;
            }
            double velocityX = dx * 1000 / timeOffset;
            double velocityY = dy * 1000 / timeOffset;
            
//            NSLog(@"---> velocityX = %f, velocityY = %f", velocityX, velocityY);
            
            VRSoft_OnTouchFling(mVRHandle, velocityX*2, velocityY*2);
        }
        
        // 只处理一个点就可以了
        break;
    }
    
    [self performSelector:@selector(delayAutoAdjust) withObject:nil afterDelay:0.12f];
    
    
}
- (void) touchesPinch:(UIPinchGestureRecognizer *)recognizer
{
    
    VRSoft_OnTouchPinchScale(mVRHandle,recognizer.scale);
    
}

#pragma mark  鱼眼显示功能按钮方法  吸顶壁挂模式设置


-(void)DoubleTap:(UITapGestureRecognizer*)recognizer
{
    //根据吸顶 还是 壁挂模式  设置双击时的响应的形状
    int times;
    if ( [[NSUserDefaults standardUserDefaults] integerForKey:@"VRShowMode"] == 1) {
        times = 7;
    }else{
        times = 2;
    }
    
    shapeNum++;
    if (shapeNum == times)
    {
        shapeNum = 0;
    }
    
    //改变按钮的seected 的状态
    if (self.ScenceDelegate && [self.ScenceDelegate respondsToSelector:@selector(changeButtonWithIndex:)]) {
        [self.ScenceDelegate changeButtonWithIndex:shapeNum];
    }
    
    switch (shapeNum) {
        case 0:
            [self setVRShapeType:Shape_Ball];
            break;
        case 1:
            [self setVRShapeType:Shape_Rectangle];
            break;
        case 2:
            [self setVRShapeType:Shape_Ball_Bowl];
            break;
        case 3:
            [self setVRShapeType:Shape_Ball_Hat];
            break;
        case 4:
            [self setVRShapeType:Shape_Cylinder];
            break;
        case 5:
            [self setVRShapeType:Shape_Grid_4R];
            break;
        case 6:
            [self setVRShapeType:Shape_Rectangle_2R];
            break;
        default:
            break;
    }
}



//响应代理
- (void)changeButtonWithIndex:(int)Index{
    switch (Index) {
        case 0:
            self.functionView.Ball.selected = YES;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
            self.functionView.Rectangle.selected = NO;
            self.functionView.BallBowl.selected = NO;
            self.functionView.BallHat.selected = NO;
            self.functionView.Cylinder.selected = NO;
            self.functionView.Split.selected = NO;
            self.functionView.dichotomia.selected = NO;
            break;
        case 1:
            self.functionView.Ball.selected = NO;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
            self.functionView.Rectangle.selected = YES;
            self.functionView.BallBowl.selected = NO;
            self.functionView.BallHat.selected = NO;
            self.functionView.Cylinder.selected = NO;
            self.functionView.Split.selected = NO;
            self.functionView.dichotomia.selected = NO;
            break;
        case 2:
            self.functionView.Ball.selected = NO;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
            self.functionView.Rectangle.selected = NO;
            self.functionView.BallBowl.selected = YES;
            self.functionView.BallHat.selected = NO;
            self.functionView.Cylinder.selected = NO;
            self.functionView.Split.selected = NO;
            self.functionView.dichotomia.selected = NO;
            break;
        case 3:
            self.functionView.Ball.selected = NO;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
            self.functionView.Rectangle.selected = NO;
            self.functionView.BallBowl.selected = NO;
            self.functionView.BallHat.selected = YES;
            self.functionView.Cylinder.selected = NO;
            self.functionView.Split.selected = NO;
            self.functionView.dichotomia.selected = NO;
            break;
        case 4:
            self.functionView.Ball.selected = NO;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
            self.functionView.Rectangle.selected = NO;
            self.functionView.BallBowl.selected = NO;
            self.functionView.BallHat.selected = NO;
            self.functionView.Cylinder.selected = YES;
            self.functionView.Split.selected = NO;
            self.functionView.dichotomia.selected = NO;
            break;
        case 5:
            self.functionView.Ball.selected = NO;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
            self.functionView.Rectangle.selected = NO;
            self.functionView.BallBowl.selected = NO;
            self.functionView.BallHat.selected = NO;
            self.functionView.Cylinder.selected = NO;
            self.functionView.Split.selected = YES;
            self.functionView.dichotomia.selected = NO;
            break;
        case 6:
            self.functionView.Ball.selected = NO;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
            self.functionView.Rectangle.selected = NO;
            self.functionView.BallBowl.selected = NO;
            self.functionView.BallHat.selected = NO;
            self.functionView.Cylinder.selected = NO;
            self.functionView.Split.selected = NO;
            self.functionView.dichotomia.selected = YES;
            break;
        default:
            break;
    }
}

//点击某个按钮响应显示不同的图片
-(void)clickVRFunctionBottun:(UIButton*)btn{
    if (btn == self.functionView.war) {
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"VRShowMode"];//1代表吸顶(ceiling)模式 0代表壁挂(wall)
        self.functionView.war.selected = YES;
        self.functionView.ceiling.selected = NO;
        
        self.functionView.Ball.selected = YES;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
        self.functionView.Rectangle.selected = NO;
        self.functionView.BallBowl.selected = NO;
        self.functionView.BallHat.selected = NO;
        self.functionView.Cylinder.selected = NO;
        self.functionView.Split.selected = NO;
        self.functionView.dichotomia.selected = NO;
        
        [self setVRVRCameraMount:Wall];
        [self.functionView.Ball sendActionsForControlEvents:UIControlEventTouchUpInside];//球形默认
        
    }else if (btn == self.functionView.ceiling) {
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"VRShowMode"];//1代表吸顶(ceiling)模式 0代表壁挂(wall)
        self.functionView.war.selected = NO;
        self.functionView.ceiling.selected = YES;
        
        self.functionView.Ball.selected = YES;//默认当选择壁挂或者吸顶按钮  都执行默认球型形状
        self.functionView.Rectangle.selected = NO;
        self.functionView.BallBowl.selected = NO;
        self.functionView.BallHat.selected = NO;
        self.functionView.Cylinder.selected = NO;
        self.functionView.Split.selected = NO;
        self.functionView.dichotomia.selected = NO;
        
        [self setVRVRCameraMount:Ceiling];
        [self.functionView.Ball sendActionsForControlEvents:UIControlEventTouchUpInside];//球形默认
    }
    
    else if (btn == self.functionView.Ball) {
        [self changeButtonWithIndex:0];
        [self setVRShapeType:Shape_Ball];
    }else if (btn == self.functionView.Rectangle) {
        [self changeButtonWithIndex:1];
        [self setVRShapeType:Shape_Rectangle];
    }else if (btn == self.functionView.BallBowl) {
        [self changeButtonWithIndex:2];
        [self setVRShapeType:Shape_Ball_Bowl];
    }
    else if (btn == self.functionView.BallHat) {
        [self changeButtonWithIndex:3];
        [self setVRShapeType:Shape_Ball_Hat];
    }
    else if (btn == self.functionView.Cylinder) {
        [self changeButtonWithIndex:4];
        [self setVRShapeType:Shape_Cylinder];
    }else if (btn == self.functionView.Split) {
        [self changeButtonWithIndex:5];
        [self setVRShapeType:Shape_Grid_4R];
    }else  /*(btn == self.functionView.Split)*/ {
        [self changeButtonWithIndex:6];
        [self setVRShapeType:Shape_Rectangle_2R];
    }
}


#pragma mark click 180 button method
-(void)click_curve_180:(UIButton *)btn{
    [self setVRShapeType:Shape_Ball];
}

-(void)click_rectangle_180:(UIButton *)btn{
    [self setVRShapeType:Shape_Rectangle];
}

-(void)click_cylindrical_180:(UIButton *)btn{
    [self setVRShapeType:Shape_Cylinder];
}

-(void)click_split_180:(UIButton *)btn{
    [self setVRShapeType:Shape_Grid_4R];
}

-(void)click_three_180:(UIButton *)btn{
    [self setVRShapeType:Shape_Grid_3R];
}

@end

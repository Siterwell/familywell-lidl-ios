//
//  VRGLViewController.h
//  VRDemo
//
//  Created by J.J. on 16/8/26.
//  Copyright © 2016年 xm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "VRSoft.h"
#import "DisplayView.h"
#import "Helper.h"

#include <queue>
using namespace std;

typedef struct SYUVData
{
    int width;
    int height;
    unsigned char *pData;
    SYUVData(int width, int height, unsigned char *pData)
    {
        this->width = width;
        this->height = height;
        int len = width * height * 3 / 2;
        if(len > 0){
            this->pData = new unsigned char[len];
            memcpy(this->pData, pData, len);
        } else {
            this->pData = NULL;
        }
    }
    ~SYUVData()
    {
        if(pData){
            delete []pData;
            pData = NULL;
        }
    }
} SYUVData;
typedef std::queue<SYUVData *> QUEUE_YUV_DATA;

@protocol VRGLViewControllerChangeFunctionScenceDelegate <NSObject>
-(void)changeButtonWithIndex:(int)Index;//用于双击屏幕时 根据状态显示不同的按钮selected
@end

@interface VRGLViewController : GLKViewController

@property (nonatomic,weak)id<VRGLViewControllerChangeFunctionScenceDelegate> ScenceDelegate;
@property (nonatomic, strong) UIButton *VRFunction;//鱼眼显示形状功能 functionView  的button
@property (nonatomic, strong) DisplayView *generalView;//普通播放视图

-(void)setVRType:(XMVRType)type;

-(void)setVRShapeType:(XMVRShape)shapetype;

-(void)setVRVRCameraMount:(XMVRMount)Mount;
//鱼眼参数设置(半径宽高)
-(void)setVRFecParams:(int)xCenter yCenter:(int)yCenter radius:(int)radius Width:(int)imgWidth Height:(int)imgHeight;

-(void)PushData:(int)width height:(int)height YUVData:(unsigned char *)pData;

//滑动开始
-(void)SoftTouchMoveBegan:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent;
//滑动
-(void)SoftTouchMove:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent;
//滑动结束
-(void)SoftTouchMoveEnd:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent;

//捏合手势
-(void)SoftTouchesPinch:(CGFloat)scale;

-(void)reloadInitView:(CGRect)frame;



@end

//
//  FunBaseObject.mm
//
//
//  Created by liuguifang on 16/5/10.
//  Copyright (c) 2016年 xiongmaitech. All rights reserved.
//
#import "BaseViewControler.h"
#import "FunSDK/FunSDK.h"

//该类不使用ARC -fno-objc-arc
@implementation BaseViewController

-(void)viewDidDisappear:(BOOL)animated{
    [self CloseHandle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(int)MsgHandle{
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

@end

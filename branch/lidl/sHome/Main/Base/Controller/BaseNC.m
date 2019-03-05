//
//  BaseNC.m
//  Qibuer
//
//  Created by shaop on 2016/12/12.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "BaseNC.h"
#import "ForgetPsdVC.h"
#import "RegistVC.h"
@interface BaseNC ()

@end

@implementation BaseNC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    viewController.hidesBottomBarWhenPushed = YES;
    
    [super pushViewController:viewController animated:animated];
    
    if (viewController.navigationItem.leftBarButtonItem==nil&&[self.viewControllers count]>1) {
        if ([viewController isKindOfClass:[ForgetPsdVC class]] || [viewController isKindOfClass:[RegistVC class]]) {
            viewController.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popself) image:@"back_icon" highImage:@"back_icon" withTintColor:[UIColor blackColor]];
        } else {
            viewController.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(popself) image:@"back_icon" highImage:@"back_icon" withTintColor:[UIColor whiteColor]];
//            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
        }
    }
}

-(void)popself{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage withTintColor:(UIColor *)color
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *img=[UIImage imageNamed:image];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTintColor:color];
//    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    CGSize btnSize = img.size;
//    CGRect frame = btn.frame;
//    frame.size = btnSize;
    btn.frame = CGRectMake(0, 0, 44, 44);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end

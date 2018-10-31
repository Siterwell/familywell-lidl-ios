//
//  NavigaterViewController.m
//  FunSDKDemo
//
//  Created by liuguifang on 16/5/17.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "Helper.h"
#import "NavigationViewController.h"
#import "SVProgressHUD.h"

@implementation NavigationViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat myWidth = SCREEN_WIDTH;
    CGFloat myHeight = SCREEN_HEIGHT;
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        myWidth = SCREEN_HEIGHT;
        myHeight = SCREEN_WIDTH;
    }
    
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, INFO_BAR_HEIGHT, myWidth, TOP_BAR_HEIGHT)];
    self.navigationView.backgroundColor = [UIColor orangeColor];

    _back = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 28, 23)];
    [_back setBackgroundImage:[UIImage imageNamed:@"icon_back_normal"] forState:UIControlStateNormal];
    [_back setBackgroundImage:[UIImage imageNamed:@"icon_back_pressed"] forState:UIControlStateSelected];
    [_back addTarget:self action:@selector(btnBackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:_back];
    [self.view addSubview:self.navigationView];

    UILabel* lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, INFO_BAR_HEIGHT, SCREEN_WIDTH, TOP_BAR_HEIGHT)];
    [lableTitle setTextAlignment:NSTextAlignmentCenter];
    [lableTitle setText:self.name];
    [self.view addSubview:lableTitle];
    
    self.centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(60 , INFO_BAR_HEIGHT, 200, TOP_BAR_HEIGHT)];
//    [self.centerBtn setTitle:TS("Choose Device") forState:UIControlStateNormal];
    self.centerBtn.backgroundColor = [UIColor orangeColor];
    self.centerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.centerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.centerBtn addTarget:self action:@selector(btnCenterClicked) forControlEvents:UIControlEventTouchUpInside];
    self.centerBtn.hidden = YES;
    [self.view addSubview:self.centerBtn];
    

    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(btnRightClicked) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.hidden = YES;
    [self.view addSubview:_rightBtn];
    
    _rightBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _rightBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightBtn2.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn2 addTarget:self action:@selector(btnRightClicked2) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn2.hidden = YES;
    [self.view addSubview:_rightBtn2];
}

-(void)setRightBtnText:(NSString *)text{
    if (text == nil || [text length] == 0) {
        _rightBtn.hidden = YES;
        return;
    }

    [self.rightBtn setTitle:text forState:UIControlStateNormal];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [_rightBtn setFrame:CGRectMake(SCREEN_WIDTH - textSize.width - 10, INFO_BAR_HEIGHT, textSize.width + 10, TOP_BAR_HEIGHT)];
    _rightBtn.hidden = NO;
   
}

-(void)setCenterBtnText:(NSString *)text{
    if (text == nil || [text length] == 0) {
        _centerBtn.hidden = YES;
        return;
    }
    NSMutableAttributedString *btnTitle = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange titleRange = {0,[btnTitle length]};
    [btnTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [btnTitle addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:titleRange];
    [_centerBtn setAttributedTitle:btnTitle
                          forState:UIControlStateNormal];
    _centerBtn.hidden = NO;
}


-(void)setrightBtn2Text:(NSString *)text{
    if (text == nil || [text length] == 0) {
        _rightBtn2.hidden = YES;
        return;
    }
    
    [_rightBtn2 setTitle:text forState:UIControlStateNormal];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    [_rightBtn2 setFrame:CGRectMake(SCREEN_WIDTH/2, INFO_BAR_HEIGHT, textSize.width, TOP_BAR_HEIGHT)];
    _rightBtn2.center = CGPointMake(SCREEN_WIDTH *3/4, TOP_BAR_HEIGHT);
    _rightBtn2.hidden = NO;
}

-(void)btnCenterClicked{
    
}

- (void)btnBackClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnRightClicked{
    
}

-(void)btnRightClicked2{
    
}
@end

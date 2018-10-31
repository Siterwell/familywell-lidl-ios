//
//  Helper.m
//  FunSDKDemo
//
//  Created by liugufiang on 16/5/16.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "Helper.h"
@implementation GView
+(int)topBarHeight{
    static int g_nHeight = 0;
    if (g_nHeight == 0) {
        g_nHeight = iOS_VERSION >= 7.0 ? 44 : 24;
    }
    return g_nHeight;
}

+(UITextField *)newTextField:(UIViewController *)parent top:(int *)nTop tip:(NSString *)tip{
    return [GView newTextField:parent top:nTop text:@"" tip:tip];
}

+(UITextField *)newTextField:(UIViewController *)parent top:(int *)nTop text:(NSString *)text tip:(NSString *)tip{
    UITextField *pNew = [[UITextField alloc] initWithFrame:CGRectMake(ITEM_SIDE_WIDTH, *nTop, SCREEN_WIDTH - ITEM_SIDE_WIDTH * 2, TEXT_FIELD_HEIGHT)];
    [parent.view addSubview:pNew];
    
    pNew.text = text;
    pNew.placeholder = tip;
    pNew.layer.borderColor=  [UIColor darkGrayColor].CGColor;
    pNew.layer.borderWidth= 1.0f;
    
    *nTop += TEXT_FIELD_HEIGHT + ITEM_ITEM_Y;
    return pNew;
}

+(UIButton *)newButton:(UIViewController *)parent top:(int *)nTop title:(NSString *)title action:(SEL)action{
    UIButton *pNew = [[UIButton alloc] initWithFrame:CGRectMake(ITEM_SIDE_WIDTH, *nTop, SCREEN_WIDTH - ITEM_SIDE_WIDTH * 2, TEXT_FIELD_HEIGHT)];
    [parent.view addSubview:pNew];
    
    [pNew setTitle:title forState:UIControlStateNormal];
    [pNew addTarget:parent action:action forControlEvents:UIControlEventTouchUpInside];
    pNew.titleLabel.textAlignment = NSTextAlignmentCenter;
    pNew.layer.backgroundColor = [UIColor orangeColor].CGColor;
    [pNew setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pNew setTitleColor:[UIColor lightTextColor] forState:UIControlStateSelected];
    [pNew setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    
    *nTop += TEXT_FIELD_HEIGHT + ITEM_ITEM_Y;
    return pNew;
}

+(float)GetStrShowHeight:(NSString *)text fontSize:(float)size maxWidth:(float)width{
    if (width < 1) {
        return 0;
    }
    if (text == nil) {
        text = @"";
    }
    CGSize maxSize = CGSizeMake(width, 2000);
    CGSize labelsize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    return labelsize.height;
}

+(float)GetStrShowHeightOfSignLine:(NSString *)text fontSize:(float)size{
    if (text == nil) {
        text = @"";
    }
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:size],};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return textSize.height;
}

+(UILabel *)newLabel:(UIViewController *)parent top:(int *)nTop text:(NSString *)text fontSize:(float)size linNumber:(int)line{
    float w = SCREEN_WIDTH - ITEM_SIDE_WIDTH * 2;
    float h = 0;
    if (line == 1) {
        h = [GView GetStrShowHeightOfSignLine:text fontSize:size];
    } else {
        h = [GView GetStrShowHeight:text fontSize:size maxWidth:w];
    }
    UILabel *pNew = [[UILabel alloc] initWithFrame:CGRectMake(ITEM_SIDE_WIDTH, *nTop, w, h)];
    [parent.view addSubview:pNew];
    pNew.text = text;
    pNew.numberOfLines = line;
    pNew.font = [UIFont systemFontOfSize:size];
    pNew.textColor = [UIColor whiteColor];
    pNew.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    *nTop += h + ITEM_ITEM_Y;
    return pNew;
}

+(UILabel *)newTip:(UIViewController *)parent top:(int *)nTop text:(NSString *)text{
    return [GView newLabel:parent top:nTop text:text fontSize:13 linNumber:0];
}

+(UILabel *)newLabel:(UIViewController *)parent top:(int *)nTop text:(NSString *)text{
    return [GView newLabel:parent top:nTop text:text fontSize:UIFont.labelFontSize  linNumber:1];
}
@end

@implementation UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end

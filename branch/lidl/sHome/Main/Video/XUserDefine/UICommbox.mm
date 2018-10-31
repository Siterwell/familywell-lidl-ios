//
//  CCommbox.m
//  未来家庭
//
//  Created by zyj on 16/4/13.
//  Copyright © 2016年 zyj. All rights reserved.
//

#import "UICommbox.h"



@implementation UICommbox


@synthesize tv, showArray, textField, strvalues, intValues;

#define ITEM_HEIGHT 40
-(id)initWithFrame:(CGRect)frame
{
    nSelectedIndex = 0;
    strvalues = nil;
    intValues = nil;
    frameHeight = 30;
    if (frame.size.height < 230) {
        frameHeight = 230;
    }else{
        frameHeight = frame.size.height;
    }
    frame.size.height = 30.0f;
    self = [super initWithFrame:frame];
    if(self){
        showList = NO; //默认不显示下拉框
        UIImageView *limageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height - 15, frame.size.width, 15)];        limageview.image=[UIImage imageNamed:@"subscript.png"];
        [self addSubview:limageview];
        
        textField = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 5)];
        [textField addTarget:self action:@selector(dropdown:) forControlEvents:UIControlEventTouchUpInside];
        [textField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        textField.titleLabel.font = [UIFont systemFontOfSize:16];
        textField.layer.cornerRadius=8.0;
        textField.hidden = NO;
        [self addSubview:textField];
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.hidden = YES;
        tv.layer.borderColor = [[UIColor grayColor] CGColor];
        tv.layer.borderWidth  = 1.0;
        [self addSubview:tv];
        
    }
    self.userInteractionEnabled = YES;
    return self;
}

-(void)Select:(int)nIndex{
    if (nIndex < 0 || showArray == nil || nIndex >= [showArray count]) {
        return;
    }
    nSelectedIndex = nIndex;
    [textField setTitle:showArray[nIndex] forState:UIControlStateNormal];
}

-(void)SetFromIntValue:(int)nValue{
    int nIndex = 0;
    if (intValues != nil) {
        for(int i = 0; i < [intValues count]; i++){
            NSNumber *v = intValues[i];
            if ([v intValue] == nValue) {
                nIndex = i;
                break;
            }
        }
    }
    [self Select:nIndex];
}

-(void)SetFromStrValue:(NSString *)strValue{
    int nIndex = 0;
    if (strvalues != nil) {
        for(int i = 0; i < [strvalues count]; i++){
            if ([strValue isEqualToString:strvalues[i]]) {
                nIndex = i;
                break;
            }
        }
    }
    [self Select:nIndex];
}

-(NSString *)GetStrValue{
    if (nSelectedIndex < 0 || showArray == nil || nSelectedIndex >= [showArray count]) {
        return @"";
    }
    if (nSelectedIndex >= 0 && strvalues != nil && nSelectedIndex < [strvalues count]) {
        return strvalues[nSelectedIndex];
    }
    NSString *text = [textField titleLabel].text;
    return text;
}

-(int)GetIntValue{
    if (nSelectedIndex < 0 || showArray == nil || nSelectedIndex >= [showArray count]) {
        return 0;
    }
    if (nSelectedIndex >= 0 && intValues != nil && nSelectedIndex < [intValues count]) {
        NSNumber *aNumber = intValues[nSelectedIndex];
        return [aNumber intValue];
    }
    return nSelectedIndex;
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
-(void)dropdown:(UIButton *)btn{
    [textField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedTableAction" object:nil];
    if (showList) {//如果下拉框已显示，那么就收回
        [self hideTableView];
        return;
    }
    
    CGRect sf = self.frame;
    sf.size.height = frameHeight;
    
    //把dropdownList放到前面，防止下拉框被别的控件遮住
    [self.superview bringSubviewToFront:self];
    tv.hidden = NO;
    showList = YES;//显示下拉框
    
    CGRect frame = tv.frame;
    tv.frame = frame;
    if (showArray != nil) {
        frame.size.height = [showArray count] * ITEM_HEIGHT;
        if (frame.size.height > 230) {
            frame.size.height = 200;
        }
    }
    else{
        frame.size.height = ITEM_HEIGHT;
    }
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = sf;
    tv.frame = frame;
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [showArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [showArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ITEM_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self Select:(int)[indexPath row]];
    [self hideTableView];
}
-(void)hideTableView
{
    showList = NO;
    tv.hidden = YES;
    CGRect sf = self.frame;
    sf.size.height = ITEM_HEIGHT;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

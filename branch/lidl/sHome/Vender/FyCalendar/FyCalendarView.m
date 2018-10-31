//
//  FyCalendarView.m
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "FyCalendarView.h"

@interface FyCalendarView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *daysArray;
@end

@implementation FyCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self setupDate];
        [self setupNextAndLastMonthOrYearView];
    }
    return self;
}

- (void)setupDate {
    self.daysArray = [NSMutableArray arrayWithCapacity:42];
    for (int i = 0; i < 42; i++) {
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        [_daysArray addObject:button];
        [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupNextAndLastMonthOrYearView {
    //上一个月
    UIButton *lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastMonthBtn setImage:[UIImage imageNamed:@"icon_date_left.png"] forState:UIControlStateNormal];
    [lastMonthBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    lastMonthBtn.tag = 1;
    lastMonthBtn.frame = CGRectMake(self.frame.size.width*0.57,17, 20, 20);
    [self addSubview:lastMonthBtn];
    //下一个月
    UIButton *nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextMonthBtn setImage:[UIImage imageNamed:@"icon_date_right.png"] forState:UIControlStateNormal];
    nextMonthBtn.tag = 2;
    [nextMonthBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    nextMonthBtn.frame = CGRectMake(self.frame.size.width*0.912, 17, 20, 20);
    [self addSubview:nextMonthBtn];
    //上一年
    UIButton *lastYearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [lastYearBtn setImage:[UIImage imageNamed:@"icon_date_left.png"] forState:UIControlStateNormal];
    [lastYearBtn addTarget:self action:@selector(nextAndLastYear:) forControlEvents:UIControlEventTouchUpInside];
    lastYearBtn.tag=33;
    lastYearBtn.frame=CGRectMake(self.frame.size.width*0.069,17,20,20);
    [self addSubview:lastYearBtn];
    //下一年
    UIButton *nextYearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextYearBtn setImage:[UIImage imageNamed:@"icon_date_right.png"] forState:UIControlStateNormal];
    [nextYearBtn addTarget:self action:@selector(nextAndLastYear:) forControlEvents:UIControlEventTouchUpInside];
    nextYearBtn.tag=44;
    nextYearBtn.frame=CGRectMake(self.frame.size.width*0.413, 17, 20, 20);
    [self addSubview:nextYearBtn];

   
}


-(void)nextAndLastYear:(UIButton*)button
{
    if (button.tag==33)
    {
        [self createCalendarViewWith:[self lastYear:self.date]];
    }
    else
    {
        [self createCalendarViewWith:[self nextYear:self.date]];
    }
    
}
- (void)nextAndLastMonth:(UIButton *)button {
    if (button.tag == 1) {
        [self createCalendarViewWith:[self lastMonth:self.date]];
    } else {
        [self createCalendarViewWith:[self nextMonth:self.date]];
    }
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.width / 7;
    
    //1.year
    if (self.yearlabel == nil) {
        self.yearlabel=[[UILabel alloc]init];
        // NSLog(@"%@",self.yearlabel.text);
        self.yearlabel.font=[UIFont systemFontOfSize:14];
        self.yearlabel.textAlignment=NSTextAlignmentCenter;
        self.yearlabel.frame=CGRectMake(self.frame.size.width*0.197, 17, 50, 20);
        self.yearlabel.textColor= self.headColor;
        [self addSubview:self.yearlabel];
    }
    self.yearlabel.text=[NSString stringWithFormat:@"%li%@",[self year:date], NSLocalizedString(@"年", nil)];
  
    // 2. month
    if (self.monthlabel == nil) {
        self.monthlabel = [[UILabel alloc] init];
        // NSLog(@"%@", self.monthlabel.text);
        self.monthlabel.font     = [UIFont systemFontOfSize:14];
        self.monthlabel.frame           = CGRectMake(self.frame.size.width*0.725,17,40,20);
        self.monthlabel.textAlignment   = NSTextAlignmentCenter;
        self.monthlabel.textColor = self.headColor;
        [self addSubview: self.monthlabel];
    }
   self.monthlabel.text     = [NSString stringWithFormat:@"%li%@",[self month:date], NSLocalizedString(@"月", nil)];
    

    
//    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    headBtn.backgroundColor = [UIColor clearColor];
//    headBtn.frame = self.headlabel.frame;
//    [headBtn addTarget:self action:@selector(chooseMonth:) forControlEvents:UIControlEventTouchUpInside];
  //  [self addSubview:self.headlabel];
    
    // 2.weekday
    NSArray *array = @[NSLocalizedString(@"日", nil), NSLocalizedString(@"一", nil), NSLocalizedString(@"二", nil), NSLocalizedString(@"三", nil), NSLocalizedString(@"四", nil), NSLocalizedString(@"五", nil), NSLocalizedString(@"六", nil)];
    
    if (self.weekBg == nil) {
        self.weekBg = [[UIView alloc] init];
        //    weekBg.backgroundColor = [UIColor orangeColor];
        self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.monthlabel.frame)+20, self.frame.size.width, itemH);
        [self addSubview:self.weekBg];
    }
  
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(_weekBg.frame.origin.x+20, CGRectGetMaxY(_weekBg.frame)-20, _weekBg.frame.size.width*0.9, 1)];
    line.backgroundColor= RGB(40, 184, 215);
    [self addSubview:line];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = self.weekDaysColor;
        [self.weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(self.weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 5.0f;
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
      // NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
         //   day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        dayButton.titleLabel.font = [UIFont systemFontOfSize:21];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if (i < todayIndex && i >= firstWeekday) {
//                [self setStyle_BeforeToday:dayButton];
            }else if(i ==  todayIndex&&[self year:date] == [self year:[NSDate date]]){
                [self setStyle_Today:dayButton];
            }
            
        }
    }
}

#pragma mark - chooseMonth
- (void)chooseMonth:(UIButton *)button {
    //下期版本
}


#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    self.selectBtn.selected = NO;
    [self.selectBtn setBackgroundColor:[UIColor clearColor]];
    dayBtn.selected = YES;
    self.selectBtn = dayBtn;
    dayBtn.layer.cornerRadius = dayBtn.frame.size.height / 2;
    dayBtn.layer.masksToBounds = YES;
    [dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [dayBtn setBackgroundColor:self.dateColor];
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    if (self.calendarBlock) {
        self.calendarBlock(day,[comp month],[comp year]);
    }
}

#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isShowOnlyMonthDays) {
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}

//- (void)setStyle_BeforeToday:(UIButton *)btn
//{
//        btn.enabled = NO;
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    for (NSString *str in self.allDaysArr) {
//        if ([str isEqualToString:btn.titleLabel.text]) {
//            UIView *domView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.size.width / 2 - 3, btn.frame.size.height - 6, 6, 6)];
//            domView.backgroundColor = [UIColor orangeColor];
//            domView.layer.cornerRadius = 3;
//            domView.layer.masksToBounds = YES;
//            [btn addSubview:domView];
//        }
//    }
//    for (NSString *str in self.allDaysArr) {
//        if ([str isEqualToString:btn.titleLabel.text]) {
//            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
//            stateView.layer.cornerRadius = btn.frame.size.height / 2;
//            stateView.layer.masksToBounds = YES;
//            stateView.backgroundColor = [UIColor blueColor];
//            stateView.alpha = 0.5;
//            [btn addSubview:stateView];
//        }
//    }
//}

- (void)setStyle_Today:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.frame.size.height / 2;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:RGB(40, 184, 215)];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            stateView.layer.cornerRadius = btn.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            stateView.backgroundColor = self.allDaysColor;
            stateView.image = self.allDaysImage;
            stateView.alpha = 0.5;
            [btn addSubview:stateView];
        }
    }
    for (NSString *str in self.partDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            stateView.layer.cornerRadius = btn.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            stateView.backgroundColor = self.partDaysColor;
            stateView.image = self.partDaysImage;
            stateView.alpha = 0.5;
            [btn addSubview:stateView];
        }
    }
}

#pragma mark - Lazy loading
- (NSArray *)allDaysArr {
    if (!_allDaysArr) {
        _allDaysArr = [NSArray array];
    }
    return _allDaysArr;
}

- (NSArray *)partDaysArr {
    if (!_partDaysArr) {
        _partDaysArr = [NSArray array];
    }
    return _partDaysArr;
}

- (UIColor *)headColor {
    if (!_headColor) {
        _headColor = [UIColor grayColor];
    }
    return _headColor;
}

- (UIColor *)dateColor {
    if (!_dateColor) {
        _dateColor = [UIColor orangeColor];
    }
    return _dateColor;
}

- (UIColor *)allDaysColor {
    if (!_allDaysColor) {
        _allDaysColor = [UIColor blueColor];
    }
    return _allDaysColor;
}

- (UIColor *)partDaysColor {
    if (!_partDaysColor) {
        _partDaysColor = [UIColor cyanColor];
    }
    return _partDaysColor;
}

- (UIColor *)weekDaysColor {
    if (!_weekDaysColor) {
        _weekDaysColor = [UIColor lightGrayColor];
    }
    return _weekDaysColor;
}

//一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;
}

#pragma mark - year+/-
-(NSDate*)lastYear:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;

}

-(NSDate*)nextYear:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;
    
}


#pragma mark - date get: day-month-year

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

@end

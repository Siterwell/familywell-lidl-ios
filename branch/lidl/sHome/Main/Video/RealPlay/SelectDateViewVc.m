//
//  SelectDateViewVc.m
//  sHome
//
//  Created by Apple on 2017/8/21.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "SelectDateViewVc.h"
#import "FyCalendarView.h"

@interface SelectDateViewVc ()

@property (nonatomic,strong) FyCalendarView *calendarView;

@end

@implementation SelectDateViewVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"日期选择", nil);
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(239, 239, 244);
    [self initFyCalendarView];
    
    UIBarButtonItem *cancelBar = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [self.navigationController.navigationBar setTintColor:RGB(40, 184, 254)];
    self.navigationItem.leftBarButtonItem = cancelBar;
}

- (void)initFyCalendarView{
    
    _calendarView = [[FyCalendarView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width,self.view.frame.size.width+60)];
    _calendarView.weekDaysColor = RGB(40, 184, 215);
    _calendarView.headColor = RGB(40, 184, 215);
    _calendarView.dateColor = RGB(40, 184, 215);
    
    [self.view addSubview:_calendarView];
    
    _calendarView.date = [NSDate date];
    
    __weak __typeof(self)weakSelf = self;
    _calendarView.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        
        NSString *dateString=[NSString stringWithFormat:@"%lu-%lu-%lu",year,month,day];
        
        if (weakSelf.selectCalendarBlock) {
            weakSelf.selectCalendarBlock(dateString);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.calendarView.nextMonthBlock = ^(){
        
        //        [weakSelf setupNextMonth];
    };
    //    self.calendarView.lastMonthBlock = ^(){
    //        [weakSelf setupLastMonth];
    //    };
    //    self.calendarView.lastYearBlock=^(){
    //        [weakSelf setupLastYear];
    //    };
    //
    //    self.calendarView.nextYearBlock=^(){
    //        [weakSelf setupNextYear];
    //    };
    
}

- (void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

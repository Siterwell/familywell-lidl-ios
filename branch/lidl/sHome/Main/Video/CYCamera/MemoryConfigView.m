//
//  MemoryConfigView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/22.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "MemoryConfigView.h"

#import "CYWaveView.h"

@interface MemoryConfigView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellNameArr;

@property (nonatomic) NSArray *titles;
@property (nonatomic) NSArray *icons;

@property (nonatomic) UIView *headerView;
@property (nonatomic) UIView *footerView;

@property (nonatomic) CYWaveView *waveView;

@end

@implementation MemoryConfigView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.titles = @[NSLocalizedString(@"存储容量", nil), NSLocalizedString(@"剩余容量", nil), NSLocalizedString(@"录像满时", nil)];
        self.icons = @[@"09-存储", @"09-存储", @"10-录制满时"];
        
        self.cellNameArr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"TotolCapacity", nil), NSLocalizedString(@"RecPartCapacity", nil), NSLocalizedString(@"PicPartCapacity", nil), NSLocalizedString(@"ResidueCapacity", nil), NSLocalizedString(@"FullAction", nil), NSLocalizedString(@"lLll", nil), nil];
        self.dataArr = [NSMutableArray arrayWithObjects:@"0.00K",@"0.00K",@"0.00K",@"0.00K",@"0.00K",@"0.00K", nil];
        
        [self addSubview:self.memoryTableView];
    }
    return self;
}

#pragma mark LazyLoad
- (UITableView *)memoryTableView{
    if (!_memoryTableView) {
        _memoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        _memoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _memoryTableView.delegate = self;
        _memoryTableView.dataSource = self;
        _memoryTableView.scrollEnabled = NO;
        _memoryTableView.tableHeaderView = self.headerView;
        _memoryTableView.tableFooterView = self.footerView;
    }
    return _memoryTableView;
}

-(UISegmentedControl *)OverWriteSegment{
    if (!_OverWriteSegment) {
        NSArray *arr = @[NSLocalizedString(@"StopRecord", nil), NSLocalizedString(@"CirculationRecord", nil)];
        _OverWriteSegment = [[UISegmentedControl alloc]initWithItems:arr];
        _OverWriteSegment.frame =CGRectMake(0, 0, Main_Screen_Width * 0.5 - 20, 36);
        _OverWriteSegment.center = CGPointMake(Main_Screen_Width * 0.75, 22);
        _OverWriteSegment.layer.cornerRadius = 5.0;
        _OverWriteSegment.layer.masksToBounds = YES;
        _OverWriteSegment.layer.borderColor = [UIColor orangeColor].CGColor;
        _OverWriteSegment.layer.borderWidth = 1.0;
    }
    return _OverWriteSegment;
}

-(UIButton *)formatterButton{
    if (!_formatterButton) {
        _formatterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_formatterButton setFrame:CGRectMake(44, 17, Main_Screen_Width-88, 44)];
        [_formatterButton setTitle:NSLocalizedString(@"格式化", nil) forState:UIControlStateNormal];
        [_formatterButton setBackgroundColor:ThemeColor];
        _formatterButton.layer.cornerRadius = 22.0;
        _formatterButton.clipsToBounds = YES;
    }
    return _formatterButton;
}

- (CYWaveView *)waveView {
    if (!_waveView) {
        _waveView = [[CYWaveView alloc] init];
        //waveView的形状
        _waveView.pathType = PYWaveViewPathType_CIRCULAR;
        //进度（从下到上占得self.Height的比例）
        if (self.occupation > 0) {
            _waveView.progress = self.occupation;
        } else {
            _waveView.progress = 0.08;
        }
        //颜色数组
//        _waveView.colorMutableArray = [NSMutableArray arrayWithObject:self.colorArray.firstObject];
        _waveView.colorMutableArray = [[NSMutableArray alloc] initWithObjects:RGBA(255, 255, 255, 0.6), [UIColor whiteColor], RGBA(255, 255, 255, 0.6), [UIColor whiteColor], nil];
        //背景颜色
        _waveView.waveViewBackgroundColor = ThemeColor;
        //色块之间横向的距离
        _waveView.distanceH = 73;
        //色块之间纵向的距离
        _waveView.distanceV = 4;
        //水波的振幅
        _waveView.amplitude = 6;
        //水波的速率（别太大，会很快的，zz）
        _waveView.waveScale = 0.14;
        
        //MARK: 这个类一定要调用个方法才会开始冲浪
        _waveView.isWaveStart = true;
        
        _waveView.layer.borderWidth = 1.2;
        _waveView.layer.cornerRadius = (Main_Screen_Width/2*1.2-50)/2;
        _waveView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _waveView;
}

- (void)setOccupation:(CGFloat)occupation {
    _occupation = occupation;
    if (occupation >= 1) {
        _occupation = 0.95;
    }
    self.waveView.progress = _occupation;
}

#pragma mark uitableviewdelegate& dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCellID = @"riceFunCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    if (indexPath.row < 3) {
        cell.textLabel.text = self.titles[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.icons[indexPath.row]];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.dataArr[0];
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = self.dataArr[3];
        }
    }
    else if(indexPath.row == 3){
        [cell.contentView addSubview:self.stopBtn];
        [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(15);
            make.height.equalTo(40);
        }];
    }else{
        [cell.contentView addSubview:self.circleBtn];
        [self.circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(15);
            make.height.equalTo(40);
        }];
    }

    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    else {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, Main_Screen_Width);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 3) {
        return 44;
    }
    return 44;
}

- (UIButton *)stopBtn {
    if (!_stopBtn) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_stopBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_stopBtn setTitle:[@" " stringByAppendingString:NSLocalizedString(@"停止录像", nil)] forState:UIControlStateNormal];
        [_stopBtn setImage:[UIImage imageNamed:@"11-未选中"] forState:UIControlStateNormal];
        [_stopBtn setImage:[UIImage imageNamed:@"12-选中"] forState:UIControlStateSelected];
    }
    return _stopBtn;
}

- (UIButton *)circleBtn {
    if (!_circleBtn) {
        _circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _circleBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_circleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_circleBtn setTitle:[@" " stringByAppendingString:NSLocalizedString(@"循环录像", nil)] forState:UIControlStateNormal];
        [_circleBtn setImage:[UIImage imageNamed:@"11-未选中"] forState:UIControlStateNormal];
        [_circleBtn setImage:[UIImage imageNamed:@"12-选中"] forState:UIControlStateSelected];
    }
    return _circleBtn;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, Main_Screen_Width/2*1.2)];
        _headerView.backgroundColor = ThemeColor;
        [_headerView addSubview:self.waveView];
        [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(0);
            make.top.equalTo(25);
            make.width.equalTo(self.waveView.mas_height);
        }];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
        _footerView.backgroundColor = RGB(241, 241, 241);
        [_footerView addSubview:self.formatterButton];
    }
    return _footerView;
}

@end

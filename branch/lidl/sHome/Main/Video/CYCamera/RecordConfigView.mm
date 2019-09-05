//
//  RecordConfigView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/30.
//  Copyright © 2017年 zyj. All rights reserved.
//
 
#import "RecordConfigView.h"
#import "RecordConfigInfo.h"
#import "RecordCfg.h"
#import "GUI.h"
#import <LCActionSheet.h>
#import "Simplify_Encode.h"
#import "TXScrollLabelView.h"

@interface RecordConfigView()<TXScrollLabelViewDelegate>{
    RecordCfg *_pCfg[2];
    NSArray *_recordWays;
}
@property (nonatomic,strong)NSArray *titleArr;

@property (nonatomic) UIButton *wayBtn;
@property (nonatomic) TXScrollLabelView *scrollview;
@end

@implementation RecordConfigView

-(void)setConfig:(void *)pCfgMain andCfg:(void *)pCfgSub{
    _pCfg[0] = (RecordCfg *)pCfgMain;
    _pCfg[1] = (RecordCfg *)pCfgSub;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        _recordWays = @[NSLocalizedString(@"始终录像", nil), NSLocalizedString(@"从不录像", nil), NSLocalizedString(@"联动录像", nil)];
        [self addSubview:self.configTableView];
    }
    return self;
}

#pragma mark lazyLoad
-(UITableView *)configTableView{
    if (!_configTableView) {
        _configTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        _configTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _configTableView.dataSource = self;
        _configTableView.delegate = self;
        _configTableView.rowHeight = 70;
        _configTableView.separatorInset = UIEdgeInsetsZero;
    }
    return _configTableView;
}


-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        RecordConfigInfo *info = [[RecordConfigInfo alloc]init];
        info.recordType = RecodeStreamType_Main;
        info.perRecord = 0;
        info.recordLength = 0;
        
        RecordConfigInfo *info1 = [[RecordConfigInfo alloc]init];
        info1.recordType = RecodeStreamType_Sub;
        info1.perRecord = 0;
        info1.recordLength = 0;
        _dataArr = [NSMutableArray arrayWithArray:@[info,info1]];
    }
    return _dataArr;
}

-(NSArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[[NSString stringWithFormat:@"%@ %ds", TS("预录"),0],[NSString stringWithFormat:@"%@ %d min", TS("录像长度"),0]];
    }
    return _titleArr;
}

-(UISlider *)mainPer_recordSlider{
    if (!_mainPer_recordSlider) {
        _mainPer_recordSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.3, 44)];
        [_mainPer_recordSlider addTarget:self action:@selector(mainPer_recordSliderChange:) forControlEvents:UIControlEventValueChanged];
        _mainPer_recordSlider.minimumValue = 0;
        _mainPer_recordSlider.maximumValue = 30;
        [_mainPer_recordSlider setThumbImage:[UIImage imageNamed:@"14-录像配置进度球激活状态"] forState:UIControlStateNormal];
        [_mainPer_recordSlider setMinimumTrackTintColor:ThemeColor];
    }
    return _mainPer_recordSlider;
}
-(UISlider *)mainRecordLength{
    if (!_mainRecordLength) {
        _mainRecordLength = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.3, 44)];
        [_mainRecordLength addTarget:self action:@selector(mainRecordLengthChange:) forControlEvents:UIControlEventValueChanged];
        _mainRecordLength.minimumValue = 1;
        _mainRecordLength.maximumValue = 30;
        [_mainRecordLength setThumbImage:[UIImage imageNamed:@"14-录像配置进度球激活状态"] forState:UIControlStateNormal];
        [_mainRecordLength setMinimumTrackTintColor:ThemeColor];
    }
    return _mainRecordLength;
}

-(UISlider *)subPer_recordSlider{
    if (!_subPer_recordSlider) {
        _subPer_recordSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.3, 44)];
        [_subPer_recordSlider addTarget:self action:@selector(subPer_recordSliderChange:) forControlEvents:UIControlEventValueChanged];
        _subPer_recordSlider.minimumValue = 0;
        _subPer_recordSlider.maximumValue = 30;
        [_subPer_recordSlider setThumbImage:[UIImage imageNamed:@"14-录像配置进度球激活状态"] forState:UIControlStateNormal];
        [_subPer_recordSlider setMinimumTrackTintColor:ThemeColor];
    }
    return _subPer_recordSlider;
}
-(UISlider *)subRecordLength{
    if (!_subRecordLength) {
        _subRecordLength = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.3, 44)];
        [_subRecordLength addTarget:self action:@selector(subRecordLengthChange:) forControlEvents:UIControlEventValueChanged];
        _subRecordLength.minimumValue = 1;
        _subRecordLength.maximumValue = 30;
    }
    return _subRecordLength;
}

#pragma mark Controls methods

-(void)mainPer_recordSliderChange:(UISlider *)SLD{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.configTableView cellForRowAtIndexPath:indexPath];
    int value = SLD.value;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %ds", TS("预录"),value];
    _pCfg[0]->PreRecord = value;

}
-(void)mainRecordLengthChange:(UISlider *)SLD{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.configTableView cellForRowAtIndexPath:indexPath];
    int value = SLD.value;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %dmin", TS("录像长度"),value];
    _pCfg[0]->PacketLength = value;
}
-(void)subPer_recordSliderChange:(UISlider *)SLD{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [self.configTableView cellForRowAtIndexPath:indexPath];
    int value = SLD.value;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %ds", TS("预录"),value];
    _pCfg[1]->PreRecord = value;
}
-(void)subRecordLengthChange:(UISlider *)SLD{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell = [self.configTableView cellForRowAtIndexPath:indexPath];
    int value = SLD.value;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %dmin", TS("录像长度"),value];
    _pCfg[1]->PacketLength = value;
}

#pragma mark tableViewdelegate & dataSource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    int nCount = 0;
//    if (_pCfg[0] != NULL) {
//        nCount++;
//    }
//    if (_pCfg[1] != NULL) {
//        nCount++;
//    }
//    return nCount;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"riceFun";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (indexPath.section == 0) {
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %ds", TS("预录"),_pCfg[0]->PreRecord.Value()];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        CGSize size = [cell.textLabel sizeThatFits:CGSizeMake(Main_Screen_Width-26, CGFLOAT_MAX)];
        
        /** Step2: 创建 ScrollLabelView */
        if(self.scrollview==nil){
            self.scrollview = [TXScrollLabelView scrollWithTitle:NSLocalizedString(@"设置摄像机报警或者无线遥控器产生联动录像时提前预录时间", nil) type:TXScrollLabelViewTypeLeftRight velocity:1 options:UIViewAnimationOptionCurveEaseInOut];
            
            /** Step3: 设置代理进行回调 */
            self.scrollview.scrollLabelViewDelegate = self;
            
            /** Step4: 布局(Required) */
            self.scrollview.frame = CGRectMake(15, size.height/2+22, 300, 30);
            
            
            
            //偏好(Optional), Preference,if you want.
            
            
            self.scrollview.scrollInset = UIEdgeInsetsMake(0, 10 , 0, 10);
            self.scrollview.scrollSpace = 10;
            self.scrollview.font = [UIFont systemFontOfSize:15];
            self.scrollview.textAlignment = NSTextAlignmentCenter;
            self.scrollview.scrollTitleColor = [UIColor blackColor];
            self.scrollview.backgroundColor = [UIColor clearColor];
            self.scrollview.layer.cornerRadius = 5;
            [cell.contentView addSubview:self.scrollview];
            [self.scrollview beginScrolling];
        }
        
        [cell.contentView addSubview: self.mainPer_recordSlider];
        [self.mainPer_recordSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-15);
            make.centerY.equalTo(-10);
            make.width.equalTo(self.frame.size.width * 0.3);
        }];

        [self.mainPer_recordSlider setValue:_pCfg[0]->PreRecord.Value() animated:YES];
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %dmin", TS("录像长度"),_pCfg[0]->PacketLength.Value()];
        cell.accessoryView = self.mainRecordLength;
        [self.mainRecordLength setValue:_pCfg[0]->PacketLength.Value() animated:YES];
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"录像方式", nil);
        UIButton *selectBtn = [self createAccessoryViewSelectBtn];
        [selectBtn addTarget:self action:@selector(selectRecordWay) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = selectBtn;
        NSString *way ;
        int type =_pCfg[0]->Mask[0][0].Value();
        self.recordWay = _pCfg[0]->RecordMode.Value();
        if (strcmp(self.recordWay, "ClosedRecord") == 0) {
            way = NSLocalizedString(@"从不录像", nil);
        } else {
            if(type == 7){
                way = NSLocalizedString(@"始终录像", nil);
            }else{
                way = NSLocalizedString(@"联动录像", nil);
            }
        }
        [selectBtn setTitle:way forState:UIControlStateNormal];
        self.wayBtn = selectBtn;
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"录像音频", nil);
        UIButton *soundBtn = [self createAccessoryViewBtn];
        [soundBtn addTarget:self action:@selector(ifNeedSound:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = soundBtn;
        self.AutoEnableBtn = soundBtn;
        if(self.autoEnable){
             [self.AutoEnableBtn setSelected:YES];
            }else{
              [self.AutoEnableBtn setSelected:NO];
        }
    }
//    }else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            cell.textLabel.text = [NSString stringWithFormat:@"%@%ds", TS("Pre-recorded"),_pCfg[1]->PreRecord.Value()];
//            cell.accessoryView = self.subPer_recordSlider;
//            [self.subPer_recordSlider setValue:_pCfg[1]->PreRecord.Value() animated:YES];
//        }else if (indexPath.row == 1){
//            cell.textLabel.text = [NSString stringWithFormat:@"%@%dmin", TS("Pre-Length"),_pCfg[1]->PacketLength.Value()];
//            cell.accessoryView = self.subRecordLength;
//            [self.subRecordLength setValue:_pCfg[1]->PacketLength.Value() animated:YES];
//        }
//    }
    return cell;
}

- (UIButton *)createAccessoryViewBtn {
    UIButton *udBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [udBtn setFrame:CGRectMake(0, 0, 55, 40)];
    [udBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 9, 10, 9)];
    [udBtn setImage:[UIImage imageNamed:@"off_icon"] forState:UIControlStateNormal];
    [udBtn setImage:[UIImage imageNamed:@"on_icon"] forState:UIControlStateSelected];

    return udBtn;
}

- (UIButton *)createAccessoryViewSelectBtn {
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *way ;
    if (strcmp(self.recordWay, "ConfigRecord") == 0) {
        way = NSLocalizedString(@"始终录像", nil);
    } else if (strcmp(self.recordWay, "ClosedRecord") == 0) {
        way = NSLocalizedString(@"从不录像", nil);
    } else if (strcmp(self.recordWay, "ManualRecord") == 0) {
        way = NSLocalizedString(@"联动录像", nil);
    }
    [selectBtn setTitle:way forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"16-录像配置下拉选中"] forState:UIControlStateNormal];
    [selectBtn setFrame:CGRectMake(0, 0, 100, 20)];
    return selectBtn;
}

- (void)selectRecordWay {
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:NSLocalizedString(@"取消", nil) clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        const char *selectWay = "ConfigRecord";
        if (buttonIndex == 1) {
            selectWay = "ConfigRecord";
        } else if (buttonIndex == 2) {
            selectWay = "ClosedRecord";
        } else if (buttonIndex == 3) {
            selectWay = "ManualRecord";
        }
        if (self.recordWayBlock) {
            self.recordWayBlock(selectWay);
        }
        [_wayBtn setTitle:_recordWays[buttonIndex-1] forState:UIControlStateNormal];
    } otherButtonTitleArray:_recordWays];
    [sheet show];
}

- (void)ifNeedSound:(UIButton *)sender {
    sender.selected = !sender.selected;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return NSSTR(_pCfg[section]->Name());
//}
- (void)scrollLabelView:(TXScrollLabelView *)scrollLabelView didClickWithText:(NSString *)text atIndex:(NSInteger)index{
    NSLog(@"%@--%ld",text, index);
}
@end

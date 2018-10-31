//
//  AlarmConfigView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/27.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "AlarmConfigView.h"
#import "GUI.h"
#import <LCActionSheet.h>
#import "XMSingleton.h"
#import "NSSDKDevConfig.h"

@interface AlarmConfigView()
@property(nonatomic,strong)NSArray *sectionTitleArr;
@property(nonatomic,strong)NSArray *subTitleArr;

@property (nonatomic) NSArray *titles;
@property (nonatomic) NSArray *descriptions;

@property (nonatomic) NSArray *levelArray;



@end

@implementation AlarmConfigView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.alarmTableView.backgroundColor = RGB(239, 239, 239);
        self.titles = @[NSLocalizedString(@"联动录像", nil), NSLocalizedString(@"拍照联动", nil), NSLocalizedString(@"推送联动", nil), NSLocalizedString(@"视频遮挡", nil), NSLocalizedString(@"报警灵敏度", nil), ];
        self.descriptions = @[NSLocalizedString(@"设备检查到移动物体就会开始录像", nil),
                              NSLocalizedString(@"设备检查到移动物体就会抓取图片", nil),
                              NSLocalizedString(@"设备触发报警时，就会推送一条消息到手机", nil),
                              NSLocalizedString(@"设备触发报警时，就会推送一条消息到手机", nil),
                              NSLocalizedString(@"", nil),];
        [self addSubview:self.alarmTableView];
        self.levelArray = @[NSLocalizedString(@"低级", nil), NSLocalizedString(@"中级", nil), NSLocalizedString(@"高级", nil)];
    }
    return self;
}

#pragma mark lazyLoad
-(UITableView *)alarmTableView{
    if (!_alarmTableView) {
        _alarmTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        _alarmTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _alarmTableView.dataSource = self;
        _alarmTableView.delegate = self;
        _alarmTableView.bounces = NO;
        _alarmTableView.rowHeight = 65;
    }
    return _alarmTableView;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
         NSArray *arr = @[@0,@0,@0,@0,@0,@0,@0,@0,@0];
        _dataArr = [NSMutableArray arrayWithArray:arr];
    }
    return _dataArr;
}

-(NSArray *)sectionTitleArr{
    if (!_sectionTitleArr) {
        _sectionTitleArr = @[TS("Motion detection"),TS("Video cover"),TS("Video loss")];
    }
    return _sectionTitleArr;
}

-(NSArray *)subTitleArr{
    if (!_subTitleArr) {
        _subTitleArr = @[TS("Alarm function"),TS("Alarm recording"),TS("Alarm capture"),TS("Push notification")];
    }
    return _subTitleArr;
}


#pragma mark uitableviewdelegate& dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 4;
//    }else if (section == 1){
//        return 4;
//    }else{
//        return 1;
//    }
    if (section == 0) {
        return 1;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"alarmCell";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        UILabel *mainLb = [self createMainLabel];
        mainLb.text = NSLocalizedString(@"移动侦测", nil);
        [cell.contentView addSubview:mainLb];
        [mainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
        }];
        
        UILabel *lb = [self createTipLabel];
        [cell.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-10);
            make.left.equalTo(15);
        }];
        lb.text = NSLocalizedString(@"设备检测到移动物体就会触发报警事件", nil);
        
        UIButton *move = [self createAccessoryViewBtn];
        move.selected = [self.dataArr[0] intValue];
        move.tag = 10;
        cell.accessoryView = move;
    }
    else {
        UILabel *mainLb = [self createMainLabel];
        mainLb.text = self.titles[indexPath.row];
        [cell.contentView addSubview:mainLb];
        [mainLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(15);
        }];
        
        UILabel *lb = [self createTipLabel];
        [cell.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-10);
            make.left.equalTo(15);
        }];
        lb.text = self.descriptions[indexPath.row];
        
        if (indexPath.row == self.titles.count-1) {
            UIButton *selectBtn = [self createAccessoryViewSelectBtn];
            cell.accessoryView = selectBtn;
        } else {
            UIButton *btn = [self createAccessoryViewBtn];
            btn.tag = indexPath.row;
            
            if (indexPath.row == 0) {
                btn.selected = [self.dataArr[1] intValue];
            } else if (indexPath.row == 1) {
                btn.selected = [self.dataArr[2] intValue];
            } else if (indexPath.row == 2) {
                btn.selected = [self.dataArr[3] intValue];
            } else if (indexPath.row == 3) {
                btn.selected = [self.dataArr[7] intValue];
            }
            cell.accessoryView = btn;
        }
        
    }
    return cell;
}

- (UILabel *)createTipLabel {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:9.5];
    lb.textColor = [UIColor grayColor];
    return lb;
}

- (UILabel *)createMainLabel {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:16];
    
    return lb;
}

- (UIButton *)createAccessoryViewBtn {
    UIButton *udBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [udBtn setFrame:CGRectMake(0, 0, 55, 40)];
    [udBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 18, 10, 0)];
    [udBtn setImage:[UIImage imageNamed:@"off_icon"] forState:UIControlStateNormal];
    [udBtn setImage:[UIImage imageNamed:@"on_icon"] forState:UIControlStateSelected];
    [udBtn addTarget:self action:@selector(changeConfig:) forControlEvents:UIControlEventTouchUpInside];
    return udBtn;
}

- (UIButton *)createAccessoryViewSelectBtn {
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *levelStr = nil;
    if (self.level == 1) {
        levelStr = NSLocalizedString(@"低级", nil);
    } else if (self.level == 3) {
        levelStr = NSLocalizedString(@"中级", nil);
    } else {
        levelStr = NSLocalizedString(@"高级", nil);
    }
    [selectBtn setTitle:levelStr forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectBtn setBackgroundImage:[UIImage imageNamed:@"16-录像配置下拉选中"] forState:UIControlStateNormal];
    [selectBtn setFrame:CGRectMake(0, 0, 100, 20)];
    [selectBtn addTarget:self action:@selector(selectSensitivity:) forControlEvents:UIControlEventTouchUpInside];
    return selectBtn;
}

- (void)selectSensitivity:(UIButton *)sender {
    LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" cancelButtonTitle:NSLocalizedString(@"取消", nil) clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            return ;
        }
        if (buttonIndex == 1) {
            self.level = 1;
        }
        if (buttonIndex == 2) {
            self.level = 3;
        }
        if (buttonIndex == 3) {
            self.level = 6;
        }
        if (self.sensitivityBlock) {
            self.sensitivityBlock(self.level);
        }
        
        [sender setTitle:self.levelArray[buttonIndex-1] forState:UIControlStateNormal];
    } otherButtonTitleArray:self.levelArray];
    [sheet show];
}

- (void)changeConfig:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        switch (sender.tag) {
            case 0: {
                [self.dataArr replaceObjectAtIndex:1 withObject:@1];
            }
                break;
            case 1: {
                [self.dataArr replaceObjectAtIndex:2 withObject:@1];
            }
                break;
            case 2: {
                [self.dataArr replaceObjectAtIndex:3 withObject:@1];
            }
                break;
            case 3: {
                [self.dataArr replaceObjectAtIndex:7 withObject:@1];
            }
                break;
            case 10: {
                [self.dataArr replaceObjectAtIndex:0 withObject:@1];
            }
                break;
                
        }
    } else {
        switch (sender.tag) {
            case 0: {
                [self.dataArr replaceObjectAtIndex:1 withObject:@0];
            }
                break;
            case 1: {
                [self.dataArr replaceObjectAtIndex:2 withObject:@0];
            }
                break;
            case 2: {
                [self.dataArr replaceObjectAtIndex:3 withObject:@0];
            }
                break;
            case 3: {
                [self.dataArr replaceObjectAtIndex:7 withObject:@0];
            }
                break;
            case 10: {
                [self.dataArr replaceObjectAtIndex:0 withObject:@0];
            }
                break;
                
        }
    }
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//        NSInteger index = indexPath.section * 4 +indexPath.row;
//        if (indexPath.section == 0) {
//            if (indexPath.row == 0) {
//                self.alarmCell00 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell00.alarmSwitch addTarget:self action:@selector(valueChange00:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell00.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell00.alarmSwitch.on = [self.dataArr[index] intValue];
//                return self.alarmCell00;
//            }else if (indexPath.row == 1){
//                self.alarmCell01 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell01.alarmSwitch addTarget:self action:@selector(valueChange01:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell01.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell01.alarmSwitch.on = [self.dataArr[index] intValue];
//                if (self.alarmCell00.alarmSwitch.on == NO) {
//                    self.alarmCell01.coverView.hidden = NO;
//                    self.alarmCell01.userInteractionEnabled = NO;
//                }
//                return self.alarmCell01;
//            }else if (indexPath.row == 2){
//                self.alarmCell02 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell02.alarmSwitch addTarget:self action:@selector(valueChange02:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell02.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell02.alarmSwitch.on = [self.dataArr[index] intValue];
//                if (self.alarmCell00.alarmSwitch.on == NO) {
//                    self.alarmCell02.coverView.hidden = NO;
//                    self.alarmCell02.userInteractionEnabled = NO;
//                }
//                return self.alarmCell02;
//            }else if (indexPath.row == 3){
//                self.alarmCell03 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell03.alarmSwitch addTarget:self action:@selector(valueChange03:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell03.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell03.alarmSwitch.on = [self.dataArr[index] intValue];
//                if (self.alarmCell00.alarmSwitch.on == NO) {
//                    self.alarmCell03.coverView.hidden = NO;
//                    self.alarmCell03.userInteractionEnabled = NO;
//                }
//                return self.alarmCell03;
//            }
//        }else if (indexPath.section == 1) {
//            if (indexPath.row == 0) {
//                self.alarmCell10 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell10.alarmSwitch addTarget:self action:@selector(valueChange10:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell10.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell10.alarmSwitch.on = [self.dataArr[index] intValue];
//                return self.alarmCell10;
//            }else if (indexPath.row == 1){
//                self.alarmCell11 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell11.alarmSwitch addTarget:self action:@selector(valueChange11:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell11.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell11.alarmSwitch.on = [self.dataArr[index] intValue];
//                if (self.alarmCell10.alarmSwitch.on == NO) {
//                    self.alarmCell11.coverView.hidden = NO;
//                    self.alarmCell11.userInteractionEnabled = NO;
//                }
//                return self.alarmCell11;
//            }else if (indexPath.row == 2){
//                self.alarmCell12 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell12.alarmSwitch addTarget:self action:@selector(valueChange12:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell12.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell12.alarmSwitch.on = [self.dataArr[index] intValue];
//                if (self.alarmCell10.alarmSwitch.on == NO) {
//                    self.alarmCell12.coverView.hidden = NO;
//                    self.alarmCell12.userInteractionEnabled = NO;
//                }
//                return self.alarmCell12;
//            }else if (indexPath.row == 3){
//                self.alarmCell13 = [[AlarmConfigCell alloc]init];
//                [self.alarmCell13.alarmSwitch addTarget:self action:@selector(valueChange13:) forControlEvents:UIControlEventValueChanged];
//                self.alarmCell13.textLabel.text = self.subTitleArr[indexPath.row];
//                self.alarmCell13.alarmSwitch.on = [self.dataArr[index] intValue];
//                if (self.alarmCell10.alarmSwitch.on == NO) {
//                    self.alarmCell13.coverView.hidden = NO;
//                    self.alarmCell13.userInteractionEnabled = NO;
//                }
//                return self.alarmCell13;
//            }
//        }else{
//            self.alarmCell20 = [[AlarmConfigCell alloc]init];
//            [self.alarmCell20.alarmSwitch addTarget:self action:@selector(valueChange20:) forControlEvents:UIControlEventValueChanged];
//            self.alarmCell20.textLabel.text = TS("Video loss");
//            self.alarmCell20.alarmSwitch.on = [self.dataArr[index] intValue];
//            return self.alarmCell20;
//        }
//    return 0;
//}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.sectionTitleArr[section];
//}

-(void)valueChange00:(UISwitch *)swh{
        self.alarmCell01.coverView.hidden = self.alarmCell00.alarmSwitch.on;
        self.alarmCell02.coverView.hidden = self.alarmCell00.alarmSwitch.on;
        self.alarmCell03.coverView.hidden = self.alarmCell00.alarmSwitch.on;
        self.alarmCell01.userInteractionEnabled = self.alarmCell00.alarmSwitch.on;
        self.alarmCell02.userInteractionEnabled = self.alarmCell00.alarmSwitch.on;
        self.alarmCell03.userInteractionEnabled = self.alarmCell00.alarmSwitch.on;
    if (self.alarmCell00.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:0 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:0 withObject:@0];
    }
    
}

-(void)valueChange01:(UISwitch *)swh{
    if (self.alarmCell01.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:1 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:1 withObject:@0];
    }
}
-(void)valueChange02:(UISwitch *)swh{
    if (self.alarmCell02.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:2 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:2 withObject:@0];
    }
}

-(void)valueChange03:(UISwitch *)swh{
    if (self.alarmCell03.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:3 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:3 withObject:@0];
    }
}

-(void)valueChange10:(UISwitch *)swh{
    self.alarmCell11.coverView.hidden = self.alarmCell10.alarmSwitch.on;
    self.alarmCell12.coverView.hidden = self.alarmCell10.alarmSwitch.on;
    self.alarmCell13.coverView.hidden = self.alarmCell10.alarmSwitch.on;
    self.alarmCell11.userInteractionEnabled = self.alarmCell10.alarmSwitch.on;
    self.alarmCell12.userInteractionEnabled = self.alarmCell10.alarmSwitch.on;
    self.alarmCell13.userInteractionEnabled = self.alarmCell10.alarmSwitch.on;
    if (self.alarmCell10.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:4 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:4 withObject:@0];
    }
}
-(void)valueChange11:(UISwitch *)swh{
    if (self.alarmCell11.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:5 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:5 withObject:@0];
    }
}
-(void)valueChange12:(UISwitch *)swh{
    if (self.alarmCell12.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:6 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:6 withObject:@0];
    }
}
-(void)valueChange13:(UISwitch *)swh{
    if (self.alarmCell13.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:7 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:7 withObject:@0];
    }
}
-(void)valueChange20:(UISwitch *)swh{
    if (self.alarmCell20.alarmSwitch.on == YES) {
        [self.dataArr replaceObjectAtIndex:8 withObject:@1];
    }else{
        [self.dataArr replaceObjectAtIndex:8 withObject:@0];
    }
//    NSLog(@"%@",self.dataArr);
}

@end

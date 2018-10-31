//
//  WarningTableView.m
//  sHome
//
//  Created by shap on 2016/12/15.
//  Copyright © 2016年 shaop. All rights reserved.
//

#import "WarningTableView.h"
#import "SceneModel.h"
#import "SceneDataBase.h"
#import "TimeHelper.h"
#import "BatterHelp.h"
#import "DeviceDataBase.h"

@interface WarningTableView ()

@property (nonatomic) UIImageView *nilImgV;

@end

@implementation WarningTableView

- (UIImageView *)nilImgV {
    if (!_nilImgV) {
        _nilImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_empty"]];
        [self addSubview:_nilImgV];
        [_nilImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-40);
        }];
    }
    return _nilImgV;
}

-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.delegate = self;
    self.dataSource = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 64)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableHeaderView = view;
    
    UILabel *labelTitle = [UILabel new];
    labelTitle.text = NSLocalizedString(@"设备告警历史记录", nil) ;
    labelTitle.font = [UIFont boldSystemFontOfSize:14];
    labelTitle.textColor = [UIColor blackColor];
    [view addSubview:labelTitle];
    
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(7);
    }];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.tintColor = [UIColor blackColor];
    [close setTitle:@"↓" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(actionDown:) forControlEvents:UIControlEventTouchUpInside];
    [close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont systemFontOfSize:20];
    [view addSubview:close];
    
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(13);
        make.centerY.equalTo(labelTitle).offset(1);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = RGB(225, 225, 225);
    [view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
        make.height.equalTo(@0.3);
    }];
    
    self.tableFooterView = line;
    
    self.tableHeaderView.alpha = 0 ;
    
//    if (self.warningList.count > 0) {
//        self.nilImgV.hidden = YES;
//    } else {
//        self.nilImgV.hidden = NO;
//    }
    
//    @weakify(self)
//    [RACObserve(self, mdataSource) subscribeNext:^(NSArray *mdataSource) {
//        @strongify(self)
//        [self reloadData];
//    }];
}

-(void)actionDown:(id *)sender{
    //设置代理
    if(_mdelegate){
        [_mdelegate ActionForTable:self];
    }
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (velocity.y<0) {
        if (scrollView.contentOffset.y < -100) {
            if(_mdelegate){
                [_mdelegate ActionForTable:self];
            }
        }
    }
    
}

#pragma mark --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.mdataSource ? self.mdataSource.count : 0;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.mdataSource[section] ? [self.mdataSource[section] count] : 0;
    return self.warningList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [UIView new];
//    view.backgroundColor = RGB(240, 240, 240);
//
//    UILabel *label = [UILabel new];
//
//    if (self.mheaderDataSource!=nil&&[self.mheaderDataSource count] > 0) {
//        label.text = self.mheaderDataSource[section];
//    }
//
//    label.textColor = [UIColor darkGrayColor];
//    label.font = [UIFont systemFontOfSize:14];
//    [view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(view.mas_left).offset(13);
//        make.centerY.equalTo(view);
//    }];
//
//    return view;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
//    cell.textLabel.text = self.mdataSource[indexPath.section][indexPath.row];
    if (self.warningList.count != 0) {
        cell.textLabel.text = [TimeHelper TimestampToData:[[self.warningList[indexPath.row].reportTime stringValue] substringToIndex:10]];
    }
    
//    cell.detailTextLabel.text = 
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"deviceName" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    dic = [dic objectForKey:@"names"];
    
    NSString *type = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(4, 2)];
    NSString *msg = @"";
    if ([type isEqualToString:@"AC"]) {
        NSString *sid = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(6, 2)];
        int mid = (int)strtoul([sid UTF8String],0,16);
        
        SceneModel *model = [[SceneDataBase sharedDataBase] selectScene:[NSString stringWithFormat:@"%d",mid]];
        if (model.scene_name) {
            msg = [NSString stringWithFormat:@"%@ %@",model.scene_name,NSLocalizedString(@"情景触发",nil)];
        }else{
            msg = [NSString stringWithFormat:@"%@%d %@",NSLocalizedString(@"情景",nil),mid,NSLocalizedString(@"触发",nil)];
        }
    } else {
        
        NSString *sid = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(6, 4)];
        int mid = 0;
        if (sid) {
            mid = (int)strtoul([sid UTF8String],0,16);
        }
//            int mid = (int)strtoul([sid UTF8String],0,16);
        
        if(mid!=0){
            ItemData *data = [[DeviceDataBase sharedDataBase] selectDevice:[NSString stringWithFormat:@"%d",mid]];
            if (!data) {
                NSString *deviceCode = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(11, 3)];
                NSString *deviceName = [dic objectForKey:deviceCode];
                msg = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedString(deviceName, nil), mid, NSLocalizedString(@"报警", nil)];
                
            }else{
                
                NSString *content;
                if([data.customTitle isEqualToString:@""]){
                    content  = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(data.title, nil),data.devID];
                }else{
                    content = data.customTitle;
                }
                msg = [NSString stringWithFormat:@"%@ %@",content,NSLocalizedString(@"报警", nil)];
            }
        }
        else {
            NSString *status = [self.warningList[indexPath.row].answer_content substringWithRange:NSMakeRange(14, 8)];
            //市电断开  //市电恢复//电池正常//电池异常
            if([status isEqualToString:@"00000000"]){
                msg = NSLocalizedString(@"市电断开", nil);
                
            }
               else if([status isEqualToString:@"00000001"]){
                msg = NSLocalizedString(@"市电恢复", nil);
            }
               else if([status isEqualToString:@"00000002"]){
                msg = NSLocalizedString(@"电池正常", nil);
            }
               else if([status isEqualToString:@"00000003"]){
                msg = NSLocalizedString(@"电池异常", nil);
               }else{
                msg = [NSString stringWithFormat:@"%@",NSLocalizedString(@"报警", nil)];
               }
               

        }
    }
        
    cell.detailTextLabel.text = msg;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}


@end

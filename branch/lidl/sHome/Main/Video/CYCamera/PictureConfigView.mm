//
//  PictureConfigView.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/3/24.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "PictureConfigView.h"
#import "GUI.h"
#import "XMSingleton.h"
#import "LEEAlert.h"
#import "NSArray+JSONString.h"
#import "NSString+ArryValue.h"
#import "NSSDKDevConfig.h"
#import "RecordInfo.h"
#import "ErrorCodeUtil.h"

@interface PictureConfigView ()

@property (nonatomic) NSTimer *timer;

@property (nonatomic) NSString *currentTime;

@property (nonatomic) UITextField *nameTF;

@end

@implementation PictureConfigView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
        [self addSubview:self.picConfigTableView];
    }
    return self;
}

#pragma mark lazyLoad
-(UITableView *)picConfigTableView{
    if (!_picConfigTableView) {
        _picConfigTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        _picConfigTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _picConfigTableView.separatorInset = UIEdgeInsetsZero;
        _picConfigTableView.dataSource = self;
        _picConfigTableView.delegate = self;
    }
    return _picConfigTableView;
}

-(UISwitch *)picFlipRightLeftSwitch{
    if (!_picFlipRightLeftSwitch) {
        _picFlipRightLeftSwitch = [[UISwitch alloc]init];
    }
    return _picFlipRightLeftSwitch;
}

-(UISwitch *)picFlipUpDownSwitch{
    if (!_picFlipUpDownSwitch) {
        _picFlipUpDownSwitch = [[UISwitch alloc]init];
    }
    return _picFlipUpDownSwitch;
}

- (UIButton *)lrBtn {
    if (!_lrBtn) {
        _lrBtn = [self createAccessoryViewBtn];
    }
    return _lrBtn;
}

- (UIButton *)udBtn {
    if (!_udBtn) {
        _udBtn = [self createAccessoryViewBtn];
    }
    return _udBtn;
}

#pragma mark uitableviewdelegate& dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseCellID = @"riceFunCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0 || indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"修改名称", nil);
        cell.detailTextLabel.text = [XMSingleton sharedXM].vInfo.name;
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"同步时间", nil);
        cell.detailTextLabel.text = self.currentTime;
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"左右翻转", nil);
//        cell.accessoryView = self.picFlipRightLeftSwitch;
        cell.accessoryView = self.lrBtn;
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = NSLocalizedString(@"上下翻转", nil);
//        cell.accessoryView = self.picFlipUpDownSwitch;
        cell.accessoryView = self.udBtn;
    }
     
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showModifyNameAlert];
    }
    else if (indexPath.row == 1) {
        [self showSyncTimeAlert];
    }
}

- (void)updateCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.currentTime = [formatter stringFromDate:date];
    [self.picConfigTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showModifyNameAlert {
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = NSLocalizedString(@"修改名称", nil);
        label.textColor = RGB(28, 140, 249);
        label.font = [UIFont systemFontOfSize:15];
    })
    .LeeAddTextField(^(UITextField *textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:14];
        textField.text = [XMSingleton sharedXM].vInfo.name;
        self.nameTF = textField;
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"取消", nil);
        action.type = LEEActionTypeCancel;
        action.titleColor = [UIColor grayColor];
        action.font = [UIFont systemFontOfSize:14];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"确定", nil);
        action.titleColor = RGB(28, 140, 249);
        action.font = [UIFont systemFontOfSize:14];
        __weak typeof(self) weakSelf = self;
        action.clickBlock = ^{
            [weakSelf modifyName];
        };
    })
    .LeeShow();
}

- (void)showSyncTimeAlert {
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = NSLocalizedString(@"提示", nil);
        label.textColor = RGB(28, 140, 249);
        label.font = [UIFont systemFontOfSize:15];
    })
    .LeeAddContent(^(UILabel *label) {
        label.textColor = RGB(28, 140, 249);
        label.text = NSLocalizedString(@"同步摄像机时间", nil);
        label.font = [UIFont systemFontOfSize:14.5];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"取消", nil);
        action.type = LEEActionTypeCancel;
        action.titleColor = [UIColor grayColor];
        action.font = [UIFont systemFontOfSize:14];
    })
    .LeeAddAction(^(LEEAction *action) {
        action.title = NSLocalizedString(@"确定", nil);
        action.titleColor = RGB(28, 140, 249);
        action.font = [UIFont systemFontOfSize:14];
        __weak typeof(self) weakSelf = self;
        action.clickBlock = ^{
            [weakSelf syncTime];
        };
    })
    .LeeShow();
}

- (void)modifyName {
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSDictionary *responseObject = [config objectForKey:UserInfos];
    NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
    NSArray *videos = nil;
    if (extraPropertiesDic[@"monitor"] !=nil) {
        videos = [extraPropertiesDic[@"monitor"] arrayValue];
    }
    NSMutableArray *videoMonitor = [[NSMutableArray alloc] init];
    if (videos != nil&&[videos count]>0) {
        for (int i = 0; i < [videos count]; i++) {
            NSDictionary *vInfosDic = [videos objectAtIndex:i];
            NSMutableDictionary *vidic = [NSMutableDictionary dictionaryWithObjectsAndKeys:vInfosDic[@"devid"],@"devid", nil];
            if ([vInfosDic[@"devid"] isEqualToString:[XMSingleton sharedXM].vInfo.devid]) {
                [vidic setValue:self.nameTF.text forKey:@"name"];
            }else{
                [vidic setValue:vInfosDic[@"name"] forKey:@"name"];
            }
            [videoMonitor addObject:vidic];
        }
    }
    NSString *monitorStr = [videoMonitor JSONString];
    //修改昵称
    NSDictionary *monitorDic = @{@"monitor":monitorStr};
    NSDictionary *dic = @{
                          @"extraProperties" : monitorDic,
                          };
    [MBProgressHUD showLoadToView:GetWindow];
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile",(ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"])] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        [XMSingleton sharedXM].vInfo.name = self.nameTF.text;
        [self.picConfigTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:GetWindow animated:YES];
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
        [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:GetWindow];
    }];
}

- (void)syncTime {
    [MBProgressHUD showLoadToView:self];
    SDK_SYSTEM_TIME timeSDK;
    struct tm time;
    timeSDK.year = time.tm_year + 1900;
    timeSDK.month = time.tm_mon + 1;
    timeSDK.day = time.tm_mday;
    timeSDK.hour = time.tm_hour;
    timeSDK.minute = time.tm_min;
    timeSDK.second = time.tm_sec;
    timeSDK.wday = 0;
    timeSDK.isdst = 0;
    char szParam[128] = {0};
    sprintf(szParam, "{\"Name\": \"OPTimeSetting\",\"OPTimeSetting\": \"%04d-%02d-%02d %02d:%02d:%02d\"}",
            timeSDK.year, timeSDK.month, timeSDK.day, timeSDK.hour, timeSDK.minute, timeSDK.second);
    FUN_DevCmdGeneral(self.msgHandle, CSTR([XMSingleton sharedXM].deviceSn), 1450, "OPTimeSetting", 0, 5000, szParam, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self];
        [MBProgressHUD showMessage:NSLocalizedString(@"配置成功", nil) ToView:self RemainTime:1.2f];
    });

}

- (UIButton *)createAccessoryViewBtn {
    UIButton *udBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [udBtn setFrame:CGRectMake(0, 0, 55, 40)];
//    [udBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 18, 10, 0)];
    [udBtn setImage:[UIImage imageNamed:@"off_icon"] forState:UIControlStateNormal];
    [udBtn setImage:[UIImage imageNamed:@"on_icon"] forState:UIControlStateSelected];
    [udBtn addTarget:self action:@selector(picTransForm:) forControlEvents:UIControlEventTouchUpInside];
    return udBtn;
}

- (void)picTransForm:(UIButton *)sender {
    sender.selected = ! sender.selected;
}

-(int)msgHandle{
    if ( !_hObj ) {
        _hObj = FUN_RegWnd((__bridge void*)self);
    }
    return _hObj;
}

//obj不再使用时，请主动调用下CloseHandle
-(void)CloseHandle{
    FUN_UnRegWnd(_hObj);
    _hObj = 0;
}

@end

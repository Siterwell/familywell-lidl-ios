//
//  LangueVC.m
//  sHome
//
//  Created by shap on 2017/2/18.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "LanguageVC.h"
#import "NSBundle+Language.h"
#import "AppDelegate.h"
#import "SettingVC.h"

@interface LanguageVC ()
@end

@implementation LanguageVC
{
    NSIndexPath *_lastIndexPath;
    NSIndexPath *_nowIndexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem =  [super itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
//    self.navigationItem.leftBarButtonItem =  [self itemWithTarget:self action:@selector(cancelItem) Title:NSLocalizedString(@"取消", nil) withTintColor:RGB(40, 184, 215)];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancelItem) image:@"back_icon" highImage:nil withTintColor:[UIColor blackColor]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguagecc"] && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguagecc"] isEqualToString:@""]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguagecc"] isEqualToString:@"zh-Hans"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguagecc"] isEqualToString:@"en"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguagecc"] isEqualToString:@"fr"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:2 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"myLanguagecc"] isEqualToString:@"de"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];
        }
    }else{
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        
        if ([languageName isEqualToString:@"en"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        } else if ([languageName isEqualToString:@"zh-Hans"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        } else if ([languageName isEqualToString:@"fr"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:2 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        } else if ([languageName isEqualToString:@"de"]) {
            _lastIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];
            _nowIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];
        }
    }

}

-(void)clickItem{
    if (_lastIndexPath.row == 0) {
        [self changeLanguageTo:@"zh-Hans"];
    }else if(_lastIndexPath.row == 1){
        [self changeLanguageTo:@"en"];
    } else if (_lastIndexPath.row == 2) {
        [self changeLanguageTo:@"fr"];
    } else if (_lastIndexPath.row == 3) {
        [self changeLanguageTo:@"de"];
    }
}

-(void)cancelItem{
    //判断是否是从设置页面进来的
    if (_isSettingVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"languageCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGB(51, 51, 51);
    if (_lastIndexPath == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"简体中文";

            break;
        case 1:
            cell.textLabel.text = @"English";
            break;
        case 2:
            cell.textLabel.text = @"Français";
            break;
        case 3:
            cell.textLabel.text = @"German";
            break;
        default:
            break;
    }
    
    return cell;
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *lastcell = [tableView cellForRowAtIndexPath:_lastIndexPath];
        if (lastcell.accessoryType == UITableViewCellAccessoryCheckmark) {
            lastcell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        _lastIndexPath = indexPath;
    }
    
    if (_lastIndexPath == _nowIndexPath) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

- (void)changeLanguageTo:(NSString *)language {
    // 设置语言
    [NSBundle setLanguage:language];
    
    // 然后将设置好的语言存储好，下次进来直接加载
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"myLanguagecc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_isSettingVC) {
        NSString *lan ;
        if ([language containsString:@"en"]) {
            lan = @"en";
        } else if ([language containsString:@"de"]) {
            lan = @"de";
        } else if ([language containsString:@"fr"]) {
            lan = @"fr";
        } else {
            lan = @"zh";
        }
        
        [self bindGTIdWithLan:lan];
    }
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSString *storyboardName = @"Main";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
    
    if (_isSettingVC) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isChange"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)bindGTIdWithLan:(NSString *)lan{
    MJWeakSelf
    
    NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
    if ([config objectForKey:AppClientID]) {
        NSDictionary *dic = @{
                              @"clientId" : [config objectForKey:AppClientID],
                              @"pushPlatform" : @"GETUI",
                              @"locale" : lan
                              };
        NSString *https = (ApiMap==nil?@"https://user-openapi.hekr.me":ApiMap[@"user-openapi.hekr.me"]);

        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"%@/user/pushTagBind", https]
 parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"绑定成功！");
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isChange"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            delegate.window.rootViewController = [storyboard instantiateInitialViewController];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf bindGTIdWithLan:lan];
        }];
    }
}

- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action Title:(NSString *)title withTintColor:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTintColor:color];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect frame = btn.frame;
    frame.size = CGSizeMake(55, 20);
    btn.frame = frame;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end

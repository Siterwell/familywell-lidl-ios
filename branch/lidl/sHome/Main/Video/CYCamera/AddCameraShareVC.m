//
//  AddCameraShareVC.m
//  sHome
//
//  Created by TracyHenry on 2018/8/28.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "AddCameraShareVC.h"
#import "WBQRCodeVC.h"
#import "VideoDataBase.h"
#import "NSArray+JSONString.h"
#import "NSString+ArryValue.h"
#import "ErrorCodeUtil.h"
@interface AddCameraShareVC()
@property(nonatomic,weak) IBOutlet UITextField *textfield;
@property(nonatomic,weak) IBOutlet UIButton *add_btn;
@property(nonatomic,weak) IBOutlet UIImageView *imageview;
@property(nonatomic,weak) IBOutlet UILabel *instruction;
@property(nonatomic,copy) NSString * https;
@end

@implementation AddCameraShareVC

#pragma -mark life
-(void)viewDidLoad{
    [super viewDidLoad];
    self.https = (ApiMap==nil?@"https://user-openapi.hekreu.me":ApiMap[@"user-openapi.hekreu.me"]);
    self.title = NSLocalizedString(@"添加摄像机", nil);

    _imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_imageview addGestureRecognizer:singleTap];
    
    [_add_btn setTitle:NSLocalizedString(@"添加摄像机", nil) forState:UIControlStateNormal];
    [_add_btn setTitleColor:ThemeColor forState:UIControlStateNormal];
    _instruction.text = NSLocalizedString(@"点击扫描二维码", nil);
    _textfield.placeholder = NSLocalizedString(@"输入序列号", nil);
}


#pragma -mark method
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    
    WBQRCodeVC *vc = [[WBQRCodeVC alloc] init];
    vc.delegate = [RACSubject subject];
    [vc.delegate subscribeNext:^(id x) {
        _textfield.text = x;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

//下拉历史登录用户
- (IBAction)addCamera:(id)sender {
    if(_textfield.text.length == 0){
        [MBProgressHUD showError:NSLocalizedString(@"内容不能为空", nil) ToView:self.view];
        return;
    }
    
    NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
    NSDictionary *responseObject = [config objectForKey:UserInfos];
    
    NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
    
    NSMutableArray *videos = nil;
    
    if (extraPropertiesDic[@"monitor"] !=nil) {
        
        videos = [[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
    }else{
        videos = [[NSMutableArray alloc] init];
    }
    
    [videos addObject:@{@"devid":_textfield.text,@"name":_textfield.text}];
    
    //        VideoInfoModel *localVInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:sn];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
    VideoInfoModel *localVInfo = [[VideoDataBase sharedDataBase] selectVideoInfoByDevid:_textfield.text andUserName:userName];
    
    if (localVInfo == nil||localVInfo.devid == nil||[localVInfo.devid isEqual:[NSNull class]]) {
        NSString *monitorStr = [videos JSONString];
        
        //修改昵称
        NSDictionary *monitorDic = @{@"monitor":monitorStr};
        NSDictionary *dic = @{
                              @"extraProperties" : monitorDic,
                              };
        
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] PUT:[NSString stringWithFormat:@"%@/user/profile", self.https] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [MBProgressHUD showSuccess:NSLocalizedString(@"请稍后...", nil) ToView:self.view];
            
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"%@/user/profile", self.https] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSUserDefaults *config = [NSUserDefaults standardUserDefaults];
                [config setValue:responseObject forKey:UserInfos];
                [config synchronize];
                
                NSDictionary *extraPropertiesDic = ((NSDictionary *)responseObject)[@"extraProperties"];
                
                if (extraPropertiesDic[@"monitor"] !=nil) {
                    
                    NSMutableArray *monitor = [(NSArray*)[extraPropertiesDic[@"monitor"] arrayValue] mutableCopy];
                    
                    for (int i = 0; i < [monitor count]; i++) {
                        
                        NSDictionary *videoDic = (NSDictionary *)monitor[i];
                        VideoInfoModel *vInfo = [[VideoInfoModel alloc] init];
                        vInfo.devid = videoDic[@"devid"];
                        vInfo.name = videoDic[@"name"];
                        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUserName"];
                        vInfo.userName = userName;
                        [[VideoDataBase sharedDataBase] updateVideoInfo:vInfo];
                    }
                }
                
                [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:self.view];
                [self performSelector:@selector(popPreView) withObject:nil afterDelay:2];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:self.view];
                NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
                [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view];
            NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            ErrorModel *model = [[ErrorModel alloc] initWithString:errResponse error:nil];
            [MBProgressHUD showError:[ErrorCodeUtil getMessageWithCode:model.code] ToView:self.view];
        }];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showSuccess:NSLocalizedString(@"配置成功", nil) ToView:GetWindow];
        [self performSelector:@selector(popPreView) withObject:nil afterDelay:2];
    }
    
    
}

-(void)popPreView{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
@end

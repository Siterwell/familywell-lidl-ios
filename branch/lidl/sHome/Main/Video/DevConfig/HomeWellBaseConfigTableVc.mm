//
//  HomeWellBaseConfigTableVc.m
//  sHome
//
//  Created by Apple on 2017/9/7.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "HomeWellBaseConfigTableVc.h"
#import "NSSDKDevConfig.h"
#import "NSDeviceInfo.h"
#import "SDKDataCenter.h"
#import "FunSDK/FunSDK.h"

@interface HomeWellBaseConfigTableVc ()<NSSDKDevConfigDelegate>

@property (nonatomic,strong)NSSDKDevConfig *SDKDevConfig;

@end

@implementation HomeWellBaseConfigTableVc

-(instancetype)init{
    id obj = [super init];
    
    self.arrayCfgReqs = [[NSMutableArray alloc] initWithCapacity:8];
    
    return obj;
}

#pragma mark Lazyload
-(NSSDKDevConfig *)SDKDevConfig{
    if (!_SDKDevConfig) {
        _SDKDevConfig = [[NSSDKDevConfig alloc]init];
        _SDKDevConfig.delegate = self;
    }
    return _SDKDevConfig;
}

-(int)MsgHandle{
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

-(DeviceConfig *)makeDeviceConfigWithChannel:(int)channel andJObject:(JObject*)jobject{
    DeviceConfig *devConfig = [[DeviceConfig alloc]initWithJObject:jobject];
    devConfig.devId = self.deviceSN;
    devConfig.channel = channel;
    return devConfig;
}

//get
-(void)requestGetConfigWithChannel:(int)channel andJObject:(JObject*)jobject{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestGetConfig:devConfig];
}

-(void)requestGetConfigWithChannel:(int)channel andJObject:(JObject*)jobject andOutTime:(int)outTime{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestGetConfig:devConfig withTimeout:outTime];
}

//set
-(void)requestSetConfigWithChannel:(int)channel andJObject:(JObject*)jobject{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestSetConfig:devConfig];
}
-(void)requestSetConfigWithChannel:(int)channel andJObject:(JObject*)jobject andOutTime:(int)outTime{
    DeviceConfig *devConfig = [self makeDeviceConfigWithChannel:channel andJObject:jobject];
    [self requestSetConfig:devConfig withTimeout:outTime];
}


#pragma mark - 请求获取配置
-(void)requestGetConfig:(DeviceConfig*)config{
    int nSeq = [self.SDKDevConfig requestGetConfig:config];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}

#pragma mark 请求获取配置 (带超时时间)
-(void)requestGetConfig:(DeviceConfig *)config withTimeout:(int)timeout{
    int nSeq = [self.SDKDevConfig  requestGetConfig:config withTimeout:timeout];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}


#pragma mark - 请求设置配置
-(void)requestSetConfig:(DeviceConfig*)config{
    int nSeq = [self.SDKDevConfig requestSetConfig:config];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}

#pragma mark 请求设置配置 (带超时时间)
-(void)requestSetConfig:(DeviceConfig *)config withTimeout:(int)timeout{
    int nSeq = [self.SDKDevConfig requestSetConfig:config withTimeout:timeout];
    [self.arrayCfgReqs addObject:[[NSNumber alloc] initWithInt:nSeq]];
}


#pragma mark - 界面消失后要取消接收该消息
-(void)viewDidDisappear:(BOOL)animated{
    for ( NSNumber* num in self.arrayCfgReqs) {
        [self.SDKDevConfig cancelConfig:[num intValue]];
    }
    [self CloseHandle];
}


#pragma mark FunSDKCallBack  NSSDKDevConfigDelegate
-(void)getConfig:(DeviceConfig *)config result:(int)result{
    [SVProgressHUD dismiss];
    if(result < 0){
        //        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:result] duration:3];
        if (result == EE_DVR_PASSWORD_NOT_VALID) {//密码错误
            NSDeviceInfo *dev = [DATACENTER GetDeviceBySN:self.deviceSN];
            //            DeviceAddVC *pModifyDev = [[DeviceAddVC alloc] initWith:dev IsAdd:NO];
            //            pModifyDev.name = TS("Modify Device Password");
            //            [self presentViewController:pModifyDev animated:YES completion:nil];
        }
    }else{
        [self RefreshUIWithGetConfig:config];
    }
    
}

-(void)setConfig:(DeviceConfig *)config result:(int)result{
    [SVProgressHUD dismiss];
    if (result < 0) {
        //        [SVProgressHUD showErrorWithStatus: [SDKParser parseError:result] duration:3];
    }else{
        [self RefreshUIWithSetConfig:config];
    }
}


//下面两个方法在子类中实现
-(void)RefreshUIWithGetConfig:(DeviceConfig *)config{
    
}

-(void)RefreshUIWithSetConfig:(DeviceConfig *)config{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

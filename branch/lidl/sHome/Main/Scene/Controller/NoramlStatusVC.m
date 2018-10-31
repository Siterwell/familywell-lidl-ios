//
//  NoramlStatusVC.m
//  sHome
//
//  Created by shaop on 2017/2/9.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "NoramlStatusVC.h"

#import "SystemSceneDataBase.h"

@interface NoramlStatusVC ()
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *statusArray;
@end

@implementation NoramlStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(self.deviceName, nil);
    
    NSString *namePath = [[NSBundle mainBundle] pathForResource:@"sceneDeviceStatus" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:namePath];
    
    _statusArray = [dic objectForKey:_deviceName];
    
    if (!_statusArray) {
        [MBProgressHUD showError:NSLocalizedString(@"您所选的设备未支持", nil) ToView:self.view];
    }
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.shouldShowMore == YES) {
        
        if ([self.deviceName containsString:@"网关"]) {
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_statusArray];
            
            NSArray<SystemSceneModel *> *systemArray = [[SystemSceneDataBase sharedDataBase] selectScene];
            for (SystemSceneModel *system in systemArray) {
                NSString *value = [NSString stringWithFormat:@"11%@FFFF", (system.sence_group.length == 2 ? system.sence_group : [@"0" stringByAppendingString:system.sence_group])];
                NSString *name;
                
                if ([system.sence_group isEqualToString:@"0"]) {
                    name = NSLocalizedString(@"在家", nil);
                }
                else if ([system.sence_group isEqualToString:@"1"]) {
                    name = NSLocalizedString(@"离家", nil);
                }
                else if ([system.sence_group isEqualToString:@"2"]) {
                    name = NSLocalizedString(@"睡眠", nil);
                }
                else {
                    name = system.scene_name;
                }
                name = [NSLocalizedString(@"切换到",nil) stringByAppendingString:name];
                
                NSDictionary *dict = @{@"value": value, @"name": name} ;
                
                [array addObject:dict];
            }
            
            _statusArray = array;
        }
    }
    
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(clickItem) Title:NSLocalizedString(@"确定", nil) withTintColor:RGB(40, 184, 215)];

    for (int i = 0; i<_statusArray.count; i++) {
        NSDictionary *dic = _statusArray[i];
        
        if ([[dic objectForKey:@"value"] isEqualToString:_selectCode]) {
            [_pickerView selectRow:i + _statusArray.count * 50 inComponent:0 animated:NO];
            break;
        }
    }

    if (_selectCode == nil) {
        [_pickerView selectRow:0 + _statusArray.count * 50 inComponent:0 animated:NO];
    }
    
}

- (void)clickItem{
    if (self.delegate) {
        NSInteger index = [_pickerView selectedRowInComponent:0];
        
        NSDictionary *dic = _statusArray[index%_statusArray.count];
        
        [self.delegate sendNext:[dic objectForKey:@"value"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _statusArray.count * 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSDictionary *dic = [_statusArray objectAtIndex:row%_statusArray.count];
    
    return NSLocalizedString([dic objectForKey:@"name"], nil);
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = RGB(245, 103, 53);
        }
    }
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.textColor = RGB(245, 103, 53);
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}


@end

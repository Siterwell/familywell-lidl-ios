//
//  PictureConfigVc.m
//  sHome
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 shaop. All rights reserved.
//

#import "PictureConfigVc.h"
#import "RecordMethodCell.h"
#import "RecordConfigThrCell.h"
#import "PictureConfigCell.h"

@interface PictureConfigVc ()

@end

@implementation PictureConfigVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图像配置";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return 6;
    }else if(section == 1){
        return 5;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0) {
            RecordMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordMethodCell" forIndexPath:indexPath];
            cell.rmothedTitle.text = @"清晰度";
            cell.rmethodDes.text = @"";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 5){
            PictureConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PictureConfigCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        RecordConfigThrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordConfigThrCell" forIndexPath:indexPath];
        switch (indexPath.row) {
                
            case 1:{
                cell.recordTitle.text = @"图像上下翻转";
                cell.recordDes.text = @"如果打开，图像将翻转180度，对于设备倒装非常有用(在使用该功能的时候，如果出现图像左右颠倒，则需要使用[图像左右翻转]功能)";
            }
                
                break;
                
            case 2:{
                cell.recordTitle.text = @"图像左右翻转";
                cell.recordDes.text = @"如果打开，图像将左右翻转";
            }
                
                break;
                
            case 3:{
                cell.recordTitle.text = @"自定义水印开关";
                cell.recordDes.text = @"该功能允许您将您喜欢的个性签名、地名、事件标题等叠加到图像中，可以丰富图像的信息，让视频带有情感";
            }
                
                break;
                
            case 4:{
                cell.recordTitle.text = @"时间水印开关";
                cell.recordDes.text = @"该功能设置是否显示水印时间";
            }
                
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
        
    }else if(indexPath.section == 1){
        
        if (indexPath.row == 2||indexPath.row == 4) {
            RecordMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordMethodCell" forIndexPath:indexPath];
            if (indexPath.row == 2) {
                cell.rmothedTitle.text = @"降噪";
                cell.rmethodDes.text = @"光照不佳时，会出现噪点。降噪等级越高，噪点越少";

            }else{
                cell.rmothedTitle.text = @"测光模式";
                cell.rmethodDes.text = @"";

            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        RecordConfigThrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordConfigThrCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
                
            case 0:{
                cell.recordTitle.text = @"背光补偿";
                cell.recordDes.text = @"如果开启该功能，可以有效补偿摄像机在逆光环境下拍摄的画面主体黑暗的缺陷";
            }
                
                break;
                
            case 1:{
                cell.recordTitle.text = @"宽动态";
                cell.recordDes.text = @"如果开启该功能，可以有效的解决摄取的图像在明暗反差过大的场合出现背景过亮或前景太暗的问题";
            }
                
                break;
                
            case 3:{
                cell.recordTitle.text = @"电子防抖";
                cell.recordDes.text = @"减少高频抖动引起的画面模糊";
            }
                
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return [UITableViewCell new];
}

// 预测cell的高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126;
}

// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

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

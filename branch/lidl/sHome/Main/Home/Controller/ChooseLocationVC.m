//
//  ChooseLocation.m
//  sHome
//
//  Created by iMac on 2018/8/18.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "ChooseLocationVC.h"
#import "ChooseLocationCell.h"
#import "NSString+CY.h"

@interface ChooseLocationVC()


@end
@implementation ChooseLocationVC


#pragma -mark life
-(void)viewDidLoad{
        self.title = NSLocalizedString(@"定位设置", nil);
}

#pragma -mark delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *nilView=[[UIView alloc] initWithFrame:CGRectZero];
        return nilView;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChooseLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseLocationCell" forIndexPath:indexPath];
    NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
    NSString * flag_location = [config objectForKey:@"Location"];
    if(indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(@"定位", nil);
        if([NSString isBlankString:flag_location] || (![flag_location isEqualToString:@"2"])){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
             cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }else if(indexPath.row == 1){
        cell.textLabel.text = NSLocalizedString(@"不定位", nil);
        if([flag_location isEqualToString:@"2"]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSUserDefaults *config =  [NSUserDefaults standardUserDefaults];
    if(indexPath.row == 0){
            [config setValue:@"1" forKey:@"Location"];
    }else{
        [config setValue:@"2" forKey:@"Location"];
    }
    [config synchronize];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

@end

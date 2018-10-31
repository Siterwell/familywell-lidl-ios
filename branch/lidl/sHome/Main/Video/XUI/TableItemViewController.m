//
//  TableItemViewController.m
//  FunSDKDemo
//
//  Created by liuguifang on 16/5/5.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "Helper.h"
#import "TableItemViewController.h"
#import "XTableCell.h"

@interface
TableItemViewController ()
@property (nonatomic, strong) UIImage *defaultImage;
@end

@implementation TableItemViewController

-(id)init{
    self = [super init];
    if (self) {
        _hasTopNavigationBar = YES;
        _defaultImage = nil;
        _delegate = nil;
    }
    return self;
}

- (void)setDefaultImage:(UIImage *)defaultImage{
    _defaultImage = defaultImage;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CGFloat myWidth = SCREEN_WIDTH;
    CGFloat myHeight = SCREEN_HEIGHT;
    if (SCREEN_WIDTH > SCREEN_HEIGHT) {
        myWidth = SCREEN_HEIGHT;
        myHeight = SCREEN_WIDTH;
    }
    self.view.bounds = CGRectMake(0, 0, myWidth, myHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    int nYTableOffSet = INFO_BAR_HEIGHT;
    if (self.hasTopNavigationBar) {
        nYTableOffSet += TOP_BAR_HEIGHT;
    } else {
        self.navigationView.hidden = YES;
    }
    
    self.tableItems = [[UITableView alloc] initWithFrame:CGRectMake(0, nYTableOffSet, myWidth, myHeight - nYTableOffSet) style:UITableViewStylePlain];
    self.tableItems.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableItems];
    
    [self.tableItems setDataSource:self];
    [self.tableItems setDelegate:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)addItem:(NSString*)title{
    [self addItem:title exInfo:@"" icon:nil controler:nil];
}

- (void)addItem:(NSString*)title controler:(UIViewController*)vc{
    [self addItem:title exInfo:@"" icon:nil controler:vc];
}

- (void)addItem:(NSString*)title exInfo:(NSString*)info controler:(UIViewController*)vc{
    [self addItem:title exInfo:@"" icon:nil controler:vc];
}

- (void)addItem:(NSString*)title exInfo:(NSString*)info icon:(UIImage*)image controler:(UIViewController*)vc{
    if (!self.arrayItemsInfo) {
        self.arrayItemsInfo = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    if (image == nil && vc == nil) {
        [self.arrayItemsInfo addObject:@{ @"Name" : title, title : @{ @"info" : info} }];
    } else  if (image == nil) {
        [self.arrayItemsInfo addObject:@{ @"Name" : title, title : @{@"info" : info, @"controller" :vc } }];
    } else  if (vc == nil) {
        [self.arrayItemsInfo addObject:@{ @"Name" : title, title : @{ @"icon" : image, @"info" : info} }];
    } else {
        [self.arrayItemsInfo addObject:@{ @"Name" : title, title : @{ @"icon" : image, @"info" : info, @"controller" :vc } }];
    }
    //[self.tableItems reloadData];
}

- (void)removeItem:(NSString*)title{
    for (NSDictionary* dic in self.arrayItemsInfo) {
        if ([dic[@"Name"] isEqualToString:title]) {
            [self.arrayItemsInfo removeObject:dic];
            break;
        }
    }
    [self.tableItems reloadData];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (!self.arrayItemsInfo) {
        return 0;
    }
    return self.arrayItemsInfo.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath;{
    if (!self.arrayItemsInfo) {
        return nil;
    }
    NSString* strIdentifier = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    XTableCell* cell = (XTableCell*)[tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil) {
        cell = [[XTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strIdentifier];
    }
    
    NSString* strName = nil;
    NSMutableDictionary* dicItem = nil;
    NSDictionary* dic = [self.arrayItemsInfo objectAtIndex:indexPath.row];
    if (dic) {
        strName = dic[@"Name"];
        dicItem = dic[strName];
    }
    
    cell.titleLabel.text = strName;
    if (dicItem) {
        NSString* strExInfo = dicItem[@"info"];
        if(strExInfo == nil || [strExInfo length] == 0){
            strExInfo = strName;
        }
        UIImage* img = dicItem[@"icon"];
        cell.Headerphoto.image = img == nil ? _defaultImage : img;
        [cell.Headerphoto setContentMode:UIViewContentModeScaleAspectFit];
        cell.infoLabel.text = strExInfo;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 60;
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController* vc = nil;
    NSString* strName = nil;
    NSMutableDictionary* dicItem = nil;
    NSDictionary* dic = [self.arrayItemsInfo objectAtIndex:indexPath.row];
    if (dic) {
        strName = dic[@"Name"];
        dicItem = dic[strName];
        vc = dicItem[@"controller"];
    }
    
    if (vc == nil && _delegate != nil) {
        vc = [_delegate getViewController:strName];
    }
        
    if (vc) {
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    [self didSelectTableViewItem:strName];
}

- (void)didSelectTableViewItem:(NSString*)title{
}


@end

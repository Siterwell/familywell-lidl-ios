//
//  MyConsumeInfoVc.m
//  NBBicycle
//
//  Created by Apple on 2017/7/18.
//  Copyright © 2017年 Clemente. All rights reserved.
//

#import "LocalImgVdieoVc.h"
#import "VideoLocalDataBase.h"
#import "LocalVideoVcCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface LocalImgVdieoVc ()<UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshBackNormalFooter *footer;
    NSInteger   pageIndex;
    UISegmentedControl *segment;
    NSString *billType;
    
    MJRefreshNormalHeader *header;
}

@property (nonatomic, strong)UITableView    *tableView;
@property (nonatomic, strong)NSMutableArray *imgDataArray;
@property (nonatomic, assign)NSInteger selectIndex;

@end

@implementation LocalImgVdieoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *segmentTitles = @[NSLocalizedString(@"图片", nil)];
    segment = [[UISegmentedControl alloc]initWithItems:segmentTitles];
    segment.frame = CGRectMake(0, 0, 120, 30);
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    pageIndex = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     [_tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.view addSubview:_tableView];
    
    self.selectIndex = self.ivFlag;
    segment.selectedSegmentIndex = self.selectIndex;
    
    [self loadData:(self.selectIndex+1)];
    
    
}

- (void)loadData:(int)infoType{
    self.imgDataArray = [[VideoLocalDataBase sharedDataBase] selectVideoInfoByInfoType:infoType andDevId:self.devsn];
    [self.tableView reloadData];
}

-(void)change:(UISegmentedControl *)sender{
    
    self.selectIndex = sender.selectedSegmentIndex;
    
    if (self.imgDataArray != nil) {
        [self.imgDataArray removeAllObjects];
    }
    
    self.imgDataArray = [[VideoLocalDataBase sharedDataBase] selectVideoInfoByInfoType:(sender.selectedSegmentIndex + 1) andDevId:self.devsn];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectIndex == 0) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        VideoInfoModel *vInfo = [self.imgDataArray objectAtIndex:indexPath.row];
        NSString *path_sandox = NSHomeDirectory();
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/Images/%@",vInfo.fileName]];
        photo.url = [NSURL fileURLWithPath:imagePath];
//        photo.srcImageView =
        NSMutableArray *photos = [NSMutableArray arrayWithObject:photo];
        
        MJPhotoBrowser *photoBro = [[MJPhotoBrowser alloc] init];
        photoBro.currentPhotoIndex = 0;
        photoBro.photos = photos;
        [photoBro show];
    }
    
    
}
/**
 MJPhoto *photo = [[MJPhoto alloc] init];
 photo.url = [NSURL URLWithString:_viewModel.hjInfo.jobCard];
 photo.srcImageView = cell.cardImage;
 [photos addObject:photo];
 
 MJPhotoBrowser *photoBro = [[MJPhotoBrowser alloc] init];
 photoBro.currentPhotoIndex = 0;
 photoBro.photos = photos;
 [photoBro show];
 **/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.imgDataArray!=nil) {
        return self.imgDataArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoInfoModel *vInfo = [self.imgDataArray objectAtIndex:indexPath.row];
    LocalVideoVcCell *localCell = nil;
    
    if (localCell == nil) {
        localCell = [[LocalVideoVcCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
//        localCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [localCell initView];
    }
    
    if (vInfo != nil) {
        
        localCell.imageName.text = [vInfo.fileName substringFromIndex:20];
        
        NSLog(@"yagkklfkjalkfjlksajflkjsalkfjlk  === == %@",vInfo.updataTime);
        localCell.udataTime.text = vInfo.updataTime == nil?@"":vInfo.updataTime;
        
        NSString *path_sandox = NSHomeDirectory();
        
        NSString *imagePath = nil;
        
        if (self.selectIndex == 0) {
            //设置一个图片的存储路径
            imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/Images/%@",vInfo.fileName]];

        }else{
            imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/Images/%@",[vInfo.imagePath substringFromIndex:(vInfo.imagePath.length - 38)]]];
        }
        
        UIImage *tmpiMG = [[UIImage alloc]initWithContentsOfFile:imagePath];
        
        if (tmpiMG != nil) {
            [localCell.tmpImgView setImage:tmpiMG];
        }else{
            [localCell.tmpImgView setImage:[UIImage imageNamed:@"lbt_01"]];
        }
    }
    
    return localCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

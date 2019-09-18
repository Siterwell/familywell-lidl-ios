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
#import <MediaPlayer/MediaPlayer.h>
#import <Social/Social.h>
@interface LocalImgVdieoVc ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>
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
@property (nonatomic,strong)MPMoviePlayerViewController *player;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;
@end

@implementation LocalImgVdieoVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *segmentTitles = @[NSLocalizedString(@"图片", nil),NSLocalizedString(@"视频", nil)];
    segment = [[UISegmentedControl alloc]initWithItems:segmentTitles];
    segment.frame = CGRectMake(0, 0, 120, 30);
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    pageIndex = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
     //[_tableView setSeparatorInset:UIEdgeInsetsZero];
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

    }else{
        NSString *path_sandox = NSHomeDirectory();
                VideoInfoModel *vInfo = [self.imgDataArray objectAtIndex:indexPath.row];
        
        //Step 3: 初始化 及设置代理
        NSURL * url = [NSURL fileURLWithPath:[path_sandox stringByAppendingString:vInfo.filePath]];
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
        
        //Step 4: 显示可以支持视频的应用
        [self.docInteractionController presentOptionsMenuFromRect:self.view.frame
                                                           inView:self.view
                                                         animated:YES];
        
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
    
    return self.imgDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *cellId = @"cell";
    LocalVideoVcCell *localCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (localCell == nil) {
        localCell = [[LocalVideoVcCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//        localCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [localCell initView];
        // 满行
        if ([localCell respondsToSelector:@selector(setSeparatorInset:)]) {
            [localCell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([localCell respondsToSelector:@selector(setLayoutMargins:)]) {
            [localCell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if([localCell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [localCell setPreservesSuperviewLayoutMargins:NO];
        }
    }
    

        VideoInfoModel *vInfo = [self.imgDataArray objectAtIndex:indexPath.row];
        NSLog(@"yagkklfkjalkfjlksajflkjsalkfjlk  === == %@",vInfo.updataTime);
        localCell.udataTime.text = vInfo.updataTime == nil?@"":vInfo.updataTime;
        
        NSString *path_sandox = NSHomeDirectory();

        NSString *imagePath = nil;

        if (self.selectIndex == 0) {
            //设置一个图片的存储路径
            imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/Images/%@",vInfo.fileName]];

            localCell.imageName.text = [vInfo.fileName substringFromIndex:20];
        }else{
//            imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/Images/%@",[vInfo.imagePath substringFromIndex:(vInfo.imagePath.length - 38)]]];
            imagePath =  [path_sandox stringByAppendingString: vInfo.imagePath];
            localCell.imageName.text = [vInfo.fileName substringFromIndex:(vInfo.fileName.length - 23)];
        }
        
        UIImage *tmpiMG = [[UIImage alloc]initWithContentsOfFile:imagePath];
        
        if (tmpiMG != nil) {
            [localCell.tmpImgView setImage:tmpiMG];
        }else{
            [localCell.tmpImgView setImage:[UIImage imageNamed:@"lbt_01"]];
        }
    
    return localCell;
}


// 自动布局后cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 80;
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        [self deleteAction:indexPath];
    }];
    
    return @[deleteRowAction];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -method
-(void)deleteAction:(NSIndexPath *)indexPath {
    UIAlertController *alertVc =[UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"确定删除", nil) preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertVc animated:YES completion:nil];
    
    //弹出框确认
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        VideoInfoModel *vInfo = [self.imgDataArray objectAtIndex:indexPath.row];
        
        NSString *filepath = vInfo.filePath;
        NSString *path_sandox = NSHomeDirectory();
        
        if(self.selectIndex==0){
            NSString *imagePath =  [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Library/Caches/Images/%@",vInfo.fileName]];
            if([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
            {
                if( [[NSFileManager defaultManager]  removeItemAtPath:imagePath error:nil]){
                    [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功", nil) ToView:GetWindow];
                    [[VideoLocalDataBase sharedDataBase] deletVideoByFilePath:filepath];
                    self.imgDataArray = [[VideoLocalDataBase sharedDataBase] selectVideoInfoByInfoType:(self.selectIndex+1) andDevId:self.devsn];
                    [self.tableView reloadData];
                }
            }
        }else if(self.selectIndex==1){
            NSString *videosPath =  [path_sandox stringByAppendingString:vInfo.filePath];
            NSString *imagesPath =  [path_sandox stringByAppendingString:vInfo.imagePath];
            if([[NSFileManager defaultManager] fileExistsAtPath:videosPath])
            {
                if( [[NSFileManager defaultManager]  removeItemAtPath:videosPath error:nil]){
                    [[NSFileManager defaultManager]  removeItemAtPath:imagesPath error:nil];
                    [MBProgressHUD showSuccess:NSLocalizedString(@"删除成功", nil) ToView:GetWindow];
                    [[VideoLocalDataBase sharedDataBase] deletVideoByFilePath:filepath];
                    self.imgDataArray = [[VideoLocalDataBase sharedDataBase] selectVideoInfoByInfoType:(self.selectIndex+1) andDevId:self.devsn];
                    [self.tableView reloadData];
                }
            }
        }
        


    }]];
}


//Step 5:实现代理方法
#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}
@end

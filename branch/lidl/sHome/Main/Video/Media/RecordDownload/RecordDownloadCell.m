//
//  RecordDownloadCell.m
//  FunSDKDemo
//
//  Created by riceFun on 2017/4/21.
//  Copyright © 2017年 zyj. All rights reserved.
//

#import "RecordDownloadCell.h"

@implementation RecordDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cellStatus = CellDownloadStateNot;
    
//    [self.statusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    self.statusBtn.layer.borderWidth = 1.5;
//    self.statusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.statusBtn.layer.borderColor = [UIColor orangeColor].CGColor;
//    [self.statusBtn addTarget:self action:@selector(clickRecordDownloadCellStatusBtn:) forControlEvents:UIControlEventTouchUpInside];
    //使用kvo来动态调整button的显示状态
    [self addObserver:self forKeyPath:@"cellStatus" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self changeButtonStatus];
    
}

- (void)setCellTextColor:(BOOL)setColorFlg{
    
    if (setColorFlg) {
        self.timeLabel.textColor = RGB(40, 184, 215);
        self.decLbl.textColor = RGB(40, 184, 215);
        self.decLbl.text = NSLocalizedString(@"手动录像", nil);
    }else{
        self.timeLabel.textColor = [UIColor blackColor];
        self.decLbl.textColor = [UIColor blackColor];
        self.decLbl.text = NSLocalizedString(@"手动录像", nil);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//点击状态按钮
-(void)clickRecordDownloadCellStatusBtn:(UIButton *)btn{
//    [self changeButtonStatus];
    self.changeStatusBtnActionBlock(self.cellStatus);
    
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"cellStatus"]) {
        [self changeButtonStatus];
    }
}

-(void)changeButtonStatus{
//    if ( self.cellStatus == CellDownloadStateNot) {
//        [self.statusBtn setTitle:TS("DownLoad") forState:UIControlStateNormal];
//        [self.statusBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    }else if (self.cellStatus == CellDownloadStateDownloading){
//        [self.statusBtn setTitle:TS("Stop") forState:UIControlStateNormal];
//        [self.statusBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    }else if (self.cellStatus == CellDownLoadWait){
//        [self.statusBtn setTitle:TS("Wait") forState:UIControlStateNormal];
//        [self.statusBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
//    }else if (self.cellStatus == CellDownloadStateCompleted){
//        [self.statusBtn setTitle:TS("Down") forState:UIControlStateNormal];
//        [self.statusBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    }
}


-(void)dealloc{
    [self removeObserver:self forKeyPath:@"cellStatus"];
}

@end

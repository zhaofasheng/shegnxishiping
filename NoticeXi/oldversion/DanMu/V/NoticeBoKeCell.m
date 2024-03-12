//
//  NoticeDanMuListCell.m
//  NoticeXi
//
//  Created by li lei on 2021/2/2.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeCell.h"
#import "NoticeMoreClickView.h"
#import "NoticeChangeBokeController.h"
#import "NoticeSendBoKeController.h"
@implementation NoticeBoKeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 12, DR_SCREEN_WIDTH-40, 0)];
        self.backView.layer.cornerRadius = 12;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
    
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,self.backView.frame.size.width-30,45)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.numberOfLines = 0;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.titleL];
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.titleL.frame), self.backView.frame.size.width-30, (((DR_SCREEN_WIDTH-70)*203)/305))];
        [self.backView addSubview:self.backImageView];
        self.backImageView.layer.cornerRadius = 8;
        self.backImageView.layer.masksToBounds = YES;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.backImageView.frame)+10,24, 24)];
        _iconImageView.layer.cornerRadius = 12;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        [self.backView addSubview:_iconImageView];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-12, CGRectGetMaxY(_iconImageView.frame)-12,12, 12)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self.backView addSubview:self.markImage];
        self.markImage.hidden = YES;
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(47, CGRectGetMaxY(self.backImageView.frame),DR_SCREEN_WIDTH-70-40, 49)];
        self.numL.font = TWOTEXTFONTSIZE;
        self.numL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8];
        [self.backView addSubview:self.numL];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.backImageView.frame.size.width-28-12, self.backImageView.frame.size.height-14-20, 28, 20)];
        imageView1.image = UIImageNamed(@"bkplay_Image");
        [self.backImageView addSubview:imageView1];
    }
    return self;
}

- (void)setModel:(NoticeDanMuModel *)model{
    _model = model;
    self.backView.frame = CGRectMake(20, 12, DR_SCREEN_WIDTH-40, 50 + model.titleHeight + (((DR_SCREEN_WIDTH-70)*203)/305));
    self.titleL.frame = CGRectMake(15,0,self.backView.frame.size.width-30,model.titleHeight);
    
    self.backImageView.frame = CGRectMake(15, CGRectGetMaxY(self.titleL.frame), self.backView.frame.size.width-30, (((DR_SCREEN_WIDTH-70)*203)/305));
    self.iconImageView.frame = CGRectMake(15,CGRectGetMaxY(self.backImageView.frame)+10,24, 24);
    self.numL.frame = CGRectMake(47, CGRectGetMaxY(self.backImageView.frame),DR_SCREEN_WIDTH-70-40, 49);
    
    if (model.user_id.integerValue == 1) {
        self.markImage.hidden = NO;
    }else{
        self.markImage.hidden = YES;
    }
    
    SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
    [self.backImageView  sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
    
    self.titleL.attributedText = model.allTitleAttStr;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url]];
    self.numL.text = model.nick_name ? model.nick_name:@"声昔官方播客";
    
    if (self.isMine) {
        self.markImage.hidden = YES;
        self.iconImageView.hidden = YES;
        self.numL.frame = CGRectMake(15, CGRectGetMaxY(self.backImageView.frame),DR_SCREEN_WIDTH-70-40, 49);
        self.numL.text = model.is_taketed.boolValue?[NSString stringWithFormat:@"%@%@",[NoticeTools chinese:@"即将发布" english:@"Posting" japan:@"もうすぐ投稿"],model.taketed_atStr]:[NSString stringWithFormat:@"%@%@",[NoticeTools getLocalStrWith:@"em.sentat"],model.taketed_atStr];
        if(model.is_taketed.boolValue){
            self.numL.textColor = [UIColor colorWithHexString:model.is_taketed.boolValue? @"#00ABE4":@"#8A8F99"];
        }
        self.moreBtn.hidden = NO;
    }
}


- (void)moreClick{
    if (self.model.is_taketed.boolValue) {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        } otherButtonTitleArray:@[[NoticeTools chinese:@"编辑" english:@"Edit" japan:@"変更"],[NoticeTools getLocalStrWith:@"py.dele"]]];
        sheet.delegate = self;
        [sheet show];
        return;
    }
    
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.share"],[NoticeTools chinese:@"修改播客" english:@"Edit" japan:@"変更"],[NoticeTools getLocalStrWith:@"py.dele"]]];
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(self.model.is_taketed.boolValue){
        if(buttonIndex == 1){
            __weak typeof(self) weakSelf = self;
            NoticeSendBoKeController *ctl = [[NoticeSendBoKeController alloc] init];
            ctl.bokeModel = self.model;
            ctl.isEditTime = YES;
            ctl.refreshDataBlock = ^(BOOL refresh) {
                if(weakSelf.refreshDataBlock){
                    weakSelf.refreshDataBlock(YES);
                }
            };
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }else if (buttonIndex == 2){
            [self deleteBoke];
        }
        return;
    }
    if (buttonIndex == 1) {
        NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        moreView.isShare = YES;
        moreView.name = self.model.nick_name?self.model.nick_name:@"声昔每日播客";
        moreView.title = self.model.podcast_title;
        [moreView showTost];
    }else if (buttonIndex == 2){

        NoticeChangeBokeController *ctl = [[NoticeChangeBokeController alloc] init];
        ctl.bokeId = self.model.podcast_no;
        ctl.induce = self.model.podcast_intro;
        ctl.coverUrl = self.model.cover_url;
        __weak typeof(self) weakSelf = self;
        ctl.changeBokeIntroBlock = ^(NSString * _Nonnull intro, NSString * _Nonnull bokeId, NSString * _Nonnull coverUrl) {
            
            if([weakSelf.model.podcast_no isEqualToString:bokeId]){
                weakSelf.model.podcast_intro = intro;
                weakSelf.model.cover_url = coverUrl;
                SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
                [self.backImageView  sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.cover_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:nil];
            }
        };

        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
    else if (buttonIndex == 3){
        [self deleteBoke];
    }
}

- (void)deleteBoke{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NoticeTools chinese:@"确定删除此播客吗？" english:@"Delete this podcast?" japan:@"このポッドキャストを削除しますか?"] message:nil sureBtn:[NoticeTools getLocalStrWith:@"py.dele"] cancleBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            [[NoticeTools getTopViewController] showHUD];
            [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"podcast/%@",weakSelf.model.podcast_no] Accept:@"application/vnd.shengxi.v5.4.4+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"DeleteBoKeNotification" object:self userInfo:@{@"danmuNumber":self.model.podcast_no}];
                }
            } fail:^(NSError * _Nullable error) {
                [[NoticeTools getTopViewController] hideHUD];
            }];
        }
    };
    [alerView showXLAlertView];
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-5-49, CGRectGetMaxY(self.backImageView.frame), 49, 49)];
        [_moreBtn setImage:UIImageNamed(@"bokmore_Image") forState:UIControlStateNormal];
        [self.backView addSubview:_moreBtn];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

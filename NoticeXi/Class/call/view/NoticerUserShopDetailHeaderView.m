//
//  NoticerUserShopDetailHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2023/4/11.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticerUserShopDetailHeaderView.h"
#import "NoticeJieYouGoodsComController.h"
@implementation NoticerUserShopDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];

        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-100, 20, 80, 80)];
        [self.iconImageView setAllCorner:40];
        self.iconImageView.userInteractionEnabled = YES;
        [self addSubview:self.iconImageView];
        
        UIImageView *imageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)-32,CGRectGetMaxY(self.iconImageView.frame)-32, 32, 32)];
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 16;
        imageView.layer.masksToBounds = YES;
        imageView.image = UIImageNamed(@"sxplayshops_img");
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [imageView addGestureRecognizer:tap2];
        self.playImageV = imageView;
        [self addSubview:imageView];
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 33, DR_SCREEN_WIDTH-150, 28)];
        self.shopNameL.font = XGTwentyBoldFontSize;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:self.shopNameL];
        
    
        self.checkL = [[UILabel  alloc] initWithFrame:CGRectMake(20, 69, DR_SCREEN_WIDTH-150, 18)];
        self.checkL.font = THRETEENTEXTFONTSIZE;
        self.checkL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.checkL.numberOfLines = 0;
        [self addSubview:self.checkL];
        
        self.goodsNumL = [[UILabel  alloc] initWithFrame:CGRectMake(20, 107+15, GET_STRWIDTH(@"咨询服务 2", 12, 19)+30, 19)];
        self.goodsNumL.font = TWOTEXTFONTSIZE;
        self.goodsNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.goodsNumL.text = @"咨询服务 0";
        [self addSubview:self.goodsNumL];
        
        self.searvNumL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsNumL.frame), self.goodsNumL.frame.origin.y, GET_STRWIDTH(@"被咨询 999", 12, 19)+47, 19)];
        self.searvNumL.font = TWOTEXTFONTSIZE;
        self.searvNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:self.searvNumL];
        
        self.comNumL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searvNumL.frame), self.goodsNumL.frame.origin.y, GET_STRWIDTH(@"评价 9999", 12, 19)+10, 19)];
        self.comNumL.font = TWOTEXTFONTSIZE;
        self.comNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:self.comNumL];
        self.comNumL.userInteractionEnabled = YES;
        UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap)];
        [self.comNumL addGestureRecognizer:comtap];
                
        self.isReplay = YES;
        
        self.markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.markImageView.image = UIImageNamed(@"sxrenztub_img");
        [self addSubview:self.markImageView];
        self.markImageView.hidden = YES;
    }
    return self;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView  alloc] initWithFrame:CGRectMake(15, 156, DR_SCREEN_WIDTH-30, 0)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        
        self.tagsL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-60, 0)];
        self.tagsL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.tagsL.font = FIFTHTEENTEXTFONTSIZE;
        self.tagsL.numberOfLines = 0;
        [_contentView addSubview:self.tagsL];
        
        self.stroryL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-60, 0)];
        self.stroryL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.stroryL.font = FIFTHTEENTEXTFONTSIZE;
        self.stroryL.numberOfLines = 0;
        [_contentView addSubview:self.stroryL];
        
        self.lineView = [[UIView  alloc] initWithFrame:CGRectZero];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [_contentView addSubview:self.lineView];
        
        [self addSubview:self.contentView];
        
        UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(30, 146+15, 24, 18)];
        imageV.image = UIImageNamed(@"introYinhao_img");
        self.yhImageView = imageV;
        self.yhImageView.hidden = YES;
        [self addSubview:self.yhImageView];
    }
    return _contentView;
}

- (void)commentTap{
    NoticeJieYouGoodsComController *ctl = [[NoticeJieYouGoodsComController alloc] init];
    ctl.shopId = self.shopModel.shopId;
    ctl.isUserLookShop = YES;
    ctl.commentNum = self.shopModel.comment_num;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)playNoReplay{
    if (self.isReplay) {
        [self.audioPlayer startPlayWithUrl:self.shopModel.introduce_url isLocalFile:NO];
        self.isReplay = NO;
        self.isPasue = NO;
        [self.playImageV startPulseWithColor:[UIColor colorWithHexString:@"#FFE428"]];
    }else{
        self.isPasue = !self.isPasue;
        [self.audioPlayer pause:self.isPasue];
        if (self.isPasue) {
            [self.playImageV stopPulse];
        }else{
            [self.playImageV startPulseWithColor:[UIColor colorWithHexString:@"#FFE428"]];
        }
    }
    
    __weak typeof(self) weakSelf = self;

    self.audioPlayer.playComplete = ^{
        weakSelf.isReplay = YES;
        [weakSelf.playImageV stopPulse];
    };
    
}


- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    
    self.markImageView.hidden = YES;
    
    if (shopModel.introduce_len.intValue > 0) {
        self.playImageV.hidden = NO;
    }else{
        self.playImageV.hidden = YES;
    }
    
    SXVerifyShopModel *verifyModel = shopModel.verifyModel;
    if (verifyModel.authentication_type.intValue  > 0) {
        if (verifyModel.authentication_type.intValue == 1) {//学历
            self.checkL.text = [NSString stringWithFormat:@"%@ %@%@",verifyModel.school_name,verifyModel.speciality_name,verifyModel.education_optionName];
        }else if (verifyModel.authentication_type.intValue == 2){
            self.checkL.text = [NSString stringWithFormat:@"%@ %@",verifyModel.industry_name,verifyModel.position_name];
        }else if (verifyModel.authentication_type.intValue == 3){
            self.checkL.text = [NSString stringWithFormat:@"%@",verifyModel.credentials_name];
        }
        self.checkL.frame = CGRectMake(20, 69, DR_SCREEN_WIDTH-125, GET_STRHEIGHT(self.checkL.text, 13, DR_SCREEN_WIDTH-125));
        self.markImageView.hidden = NO;
        
       self.markImageView.frame = CGRectMake(20+GET_STRWIDTH(shopModel.shop_name, 21, 28), 33+4, 20, 20);
    }
    
    self.shopNameL.text = shopModel.shop_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.shop_avatar_url]];
    
    if (shopModel.operate_status.intValue == 3) {
        self.workIngView.hidden = NO;
        if (self.markImageView.hidden) {
            self.workIngView.frame = CGRectMake(20+10+GET_STRWIDTH(shopModel.shop_name, 21, 28), 33, 57, 28);
        }else{
            self.workIngView.frame = CGRectMake(CGRectGetMaxX(self.markImageView.frame)+5, 33, 57, 28);
        }
        
    }else{
        _workIngView.hidden = YES;
    }
    
    NSString *str1 = shopModel.order_num.intValue?shopModel.order_num:@"0";
    NSString *str2 = @"被咨询 ";
    NSString *allStr = [NSString stringWithFormat:@"%@%@",str2,str1];
    self.searvNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setSize:16 setLengthString:str1 beginSize:allStr.length-str1.length];
    
    NSString *str3 = shopModel.comment_num.intValue?shopModel.comment_num:@"0";
    NSString *str4 = @"评价 ";
    NSString *allStr1 = [NSString stringWithFormat:@"%@%@",str4,str3];
    self.comNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr1 setColor:[UIColor colorWithHexString:@"#5C5F66"] setSize:16 setLengthString:str3 beginSize:allStr1.length-str3.length];
    
    if (shopModel.tale && shopModel.tale.length && shopModel.tagsTextArr.count) {//故事和标签都存在
      
        CGFloat tagHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tagString isJiacu:NO];
        CGFloat taleHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tale isJiacu:NO];
        
        self.contentView.hidden = NO;
        self.contentView.frame = CGRectMake(15, 156+15, DR_SCREEN_WIDTH-30, tagHeight+taleHeight+60);
        
        self.tagsL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, tagHeight);
        self.tagsL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tagString];
        
        self.lineView.hidden = NO;
        self.lineView.frame = CGRectMake(15, CGRectGetMaxY(self.tagsL.frame)+15, DR_SCREEN_WIDTH-60, 1);
        
        self.stroryL.frame = CGRectMake(15, CGRectGetMaxY(self.lineView.frame)+15, DR_SCREEN_WIDTH-60, taleHeight);
        self.stroryL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tale];
        
        
    }else{
        if (shopModel.tagsTextArr.count) {//有标签
            CGFloat tagHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tagString isJiacu:NO];
            
            self.contentView.hidden = NO;
            self.contentView.frame = CGRectMake(15, 156+15, DR_SCREEN_WIDTH-30, tagHeight+30);
            
            self.tagsL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, tagHeight);
            self.tagsL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tagString];
            
            self.lineView.hidden = YES;
            
        }else if (shopModel.tale && shopModel.tale.length){
            CGFloat taleHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tale isJiacu:NO];
            
            self.contentView.hidden = NO;
            self.contentView.frame = CGRectMake(15, 156+15, DR_SCREEN_WIDTH-30, taleHeight+30);
            
            self.lineView.hidden = YES;
            
            self.stroryL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, taleHeight);
            self.stroryL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tale];
        }
    }
    
    
    if (_contentView.hidden) {
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 156+15);
    }else{
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 156+self.contentView.frame.size.height+15+15);
    }

    if ((shopModel.tale && shopModel.tale.length) || shopModel.tagsTextArr.count){
        self.yhImageView.hidden = NO;
    }else{
        self.yhImageView.hidden = YES;
    }
}

- (void)setGoodsNum:(NSInteger)goodsNum{
    _goodsNum = goodsNum;
    NSString *str1 = [NSString stringWithFormat:@"%ld",goodsNum];
    NSString *str2 = @"咨询服务 ";
    NSString *allStr = [NSString stringWithFormat:@"%@%@",str2,str1];
    self.goodsNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setSize:16 setLengthString:str1 beginSize:allStr.length-str1.length];
}

- (UIView *)workIngView{//sxrenztub_img
    if (!_workIngView) {
        _workIngView = [[UIView  alloc] initWithFrame:CGRectMake(0, 33, 57, 28)];
        
        UIView *cirView = [[UIView  alloc] initWithFrame:CGRectMake(0, 10, 8, 8)];
        cirView.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [cirView setAllCorner:4];
        [_workIngView addSubview:cirView];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(12, 0, 45, 28)];
        label.text = @"服务中";
        label.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        label.font = FOURTHTEENTEXTFONTSIZE;
        
        [_workIngView addSubview:label];
        
        [self addSubview:_workIngView];
    }
    return _workIngView;
}

- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (void)stopPlay{
    self.isReplay = YES;
    [self.audioPlayer stopPlaying];
}


@end

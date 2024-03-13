//
//  NoticeShopDetailHeader.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopDetailHeader.h"
#import "NoticeChangeShopIconController.h"
#import "NoticeHasServeredController.h"
#import "NoticeJieYouGoodsComController.h"
#import "NoticeEditShopInfoController.h"
#import "SXShopCheckController.h"
@implementation NoticeShopDetailHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-100, 20, 80, 80)];
        [self.iconImageView setAllCorner:40];
        self.iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRoleTap)];
        [self.iconImageView addGestureRecognizer:tap];
        [self addSubview:self.iconImageView];
        
        UIImageView *imageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)-32,CGRectGetMaxY(self.iconImageView.frame)-32, 32, 32)];
        imageView.userInteractionEnabled = YES;
        imageView.image = UIImageNamed(@"changeshoproleimg");
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRoleTap)];
        [imageView addGestureRecognizer:tap2];
        [self addSubview:imageView];
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(20, 33, DR_SCREEN_WIDTH-150, 28)];
        self.shopNameL.font = XGTwentyBoldFontSize;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self addSubview:self.shopNameL];
        
    
        self.checkL = [[UILabel  alloc] initWithFrame:CGRectMake(20, 69, DR_SCREEN_WIDTH-150, 18)];
        self.checkL.font = THRETEENTEXTFONTSIZE;
        self.checkL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.checkL.text = @"点击添加认证…";
        self.checkL.numberOfLines = 0;
        [self addSubview:self.checkL];
        self.checkL.userInteractionEnabled = YES;
        UITapGestureRecognizer *checkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkShopTap)];
        [self.checkL addGestureRecognizer:checkTap];
        
        self.goodsNumL = [[UILabel  alloc] initWithFrame:CGRectMake(20, 117, GET_STRWIDTH(@"咨询服务 2", 12, 19)+30, 19)];
        self.goodsNumL.font = TWOTEXTFONTSIZE;
        self.goodsNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.goodsNumL.text = @"咨询服务 0";
        [self addSubview:self.goodsNumL];
        
        self.searvNumL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsNumL.frame), 117, GET_STRWIDTH(@"被咨询 999", 12, 19)+47, 19)];
        self.searvNumL.font = TWOTEXTFONTSIZE;
        self.searvNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:self.searvNumL];
        self.searvNumL.userInteractionEnabled = YES;
        UITapGestureRecognizer *searstap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searTap)];
        [self.searvNumL addGestureRecognizer:searstap];
        
        self.comNumL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searvNumL.frame), 117, GET_STRWIDTH(@"评价 9999", 12, 19)+10, 19)];
        self.comNumL.font = TWOTEXTFONTSIZE;
        self.comNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self addSubview:self.comNumL];
        self.comNumL.userInteractionEnabled = YES;
        UITapGestureRecognizer *comtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTap)];
        [self.comNumL addGestureRecognizer:comtap];
        
        self.photoView = [[UIView  alloc] initWithFrame:CGRectMake(15, 166, DR_SCREEN_WIDTH-30, 38.75)];
        self.photoView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.photoView setCornerOnTop:10];
        [self addSubview:self.photoView];
        
        UILabel *markL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 60, 38.75)];
        markL1.text = @"照片墙";
        markL1.font = FOURTHTEENTEXTFONTSIZE;
        markL1.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.photoView addSubview:markL1];
        
   
        
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick)];
        [self.photoView addGestureRecognizer:photoTap];
        self.photoView.userInteractionEnabled = YES;
        
        self.voiceView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.photoView.frame), DR_SCREEN_WIDTH-30, 38.75)];
        self.voiceView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.voiceView];
        
        UILabel *markL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 60, 38.75)];
        markL2.text = @"我的声音";
        markL2.font = FOURTHTEENTEXTFONTSIZE;
        markL2.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.voiceView addSubview:markL2];
        

        
        UIImageView *voiceBoImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.photoView.frame.size.width-15-16-24, (38.75-24)/2, 24, 24)];
        voiceBoImg.image = UIImageNamed(@"sxplayshops_img");
        self.playImageV = voiceBoImg;
        voiceBoImg.userInteractionEnabled = YES;
        [self.voiceView addSubview:voiceBoImg];
        
        UITapGestureRecognizer *voiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceClick)];
        [self.voiceView addGestureRecognizer:voiceTap];
        self.voiceView.userInteractionEnabled = YES;
        
        self.storyView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.voiceView.frame), DR_SCREEN_WIDTH-30, 38.75)];
        self.storyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.storyView];
        
        UILabel *markL3 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 60, 38.75)];
        markL3.text = @"我的故事";
        markL3.font = FOURTHTEENTEXTFONTSIZE;
        markL3.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.storyView addSubview:markL3];
     
        
        UITapGestureRecognizer *stroyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storyClick)];
        [self.storyView addGestureRecognizer:stroyTap];
        self.storyView.userInteractionEnabled = YES;
        
        self.tagsView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.storyView.frame), DR_SCREEN_WIDTH-30, 38.75)];
        self.tagsView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.tagsView setCornerOnBottom:10];
        [self addSubview:self.tagsView];
        
        UILabel *markL4 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 60, 38.75)];
        markL4.text = @"个性标签";
        markL4.font = FOURTHTEENTEXTFONTSIZE;
        markL4.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.tagsView addSubview:markL4];
       
        
        UITapGestureRecognizer *tagsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagsClick)];
        [self.tagsView addGestureRecognizer:tagsTap];
        self.tagsView.userInteractionEnabled = YES;

    }
    return self;
}

- (void)checkShopTap{
    if (!self.shopModel) {
        return;
    }
    
    SXShopCheckController *ctl = [[SXShopCheckController alloc] init];
    ctl.shopModel = self.shopModel.myShopM;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];

}

- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.photoView.frame.size.width-15-16-24, (38.75-24)/2, 24, 24)];
        [self.photoView addSubview:_photoImageView];
        [self.photoView bringSubviewToFront:_photoImageView];
        _photoImageView.userInteractionEnabled = YES;
        [_photoImageView setAllCorner:2];
        _photoImageView.hidden = YES;
    }
    return _photoImageView;
}

- (void)tagsClick{
    NoticeEditShopInfoController *ctl = [[NoticeEditShopInfoController alloc] init];
    ctl.shopModel = self.shopModel;
    ctl.section = 4;
    __weak typeof(self) weakSelf = self;
    ctl.refreshShopModel = ^(BOOL refresh) {
        if (weakSelf.refreshShopModel) {
            weakSelf.refreshShopModel(YES);
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)storyClick{
    NoticeEditShopInfoController *ctl = [[NoticeEditShopInfoController alloc] init];
    ctl.shopModel = self.shopModel;
    ctl.section = 3;
    __weak typeof(self) weakSelf = self;
    ctl.refreshShopModel = ^(BOOL refresh) {
        if (weakSelf.refreshShopModel) {
            weakSelf.refreshShopModel(YES);
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)photoClick{
    NoticeEditShopInfoController *ctl = [[NoticeEditShopInfoController alloc] init];
    ctl.shopModel = self.shopModel;
    ctl.section = 1;
    __weak typeof(self) weakSelf = self;
    ctl.refreshShopModel = ^(BOOL refresh) {
        if (weakSelf.refreshShopModel) {
            weakSelf.refreshShopModel(YES);
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)voiceClick{
    NoticeEditShopInfoController *ctl = [[NoticeEditShopInfoController alloc] init];
    ctl.shopModel = self.shopModel;
    ctl.section = 2;
    __weak typeof(self) weakSelf = self;
    ctl.refreshShopModel = ^(BOOL refresh) {
        if (weakSelf.refreshShopModel) {
            weakSelf.refreshShopModel(YES);
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)commentTap{
    NoticeJieYouGoodsComController *ctl = [[NoticeJieYouGoodsComController alloc] init];
    ctl.shopId = self.shopModel.myShopM.shopId;
    ctl.commentNum = self.shopModel.myShopM.comment_num;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)searTap{
    NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    
    SXVerifyShopModel *verifyModel = shopModel.myShopM.verifyModel;
    if (verifyModel.verify_status.intValue == 3) {
        if (verifyModel.authentication_type.intValue == 1) {//学历
            self.checkL.text = [NSString stringWithFormat:@"%@ %@%@",verifyModel.school_name,verifyModel.speciality_name,verifyModel.education_optionName];
        }else if (verifyModel.authentication_type.intValue == 2){
            self.checkL.text = [NSString stringWithFormat:@"%@ %@",verifyModel.industry_name,verifyModel.position_name];
        }else if (verifyModel.authentication_type.intValue == 4){
            self.checkL.text = [NSString stringWithFormat:@"%@",verifyModel.credentials_name];
        }
        self.checkL.frame = CGRectMake(20, 69, DR_SCREEN_WIDTH-125, GET_STRHEIGHT(self.checkL.text, 13, DR_SCREEN_WIDTH-125));
    }
    

    self.shopNameL.text = shopModel.myShopM.shop_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.myShopM.shop_avatar_url]];
    
    if(shopModel.myShopM.introduce_len.intValue){
        self.nodataView2.markL.text = @"";
        self.nodataView2.markImageView.image = UIImageNamed(@"cellnextbutton");
        self.playImageV.hidden = NO;
    }else{
        self.playImageV.hidden = YES;
        self.nodataView2.markImageView.image = UIImageNamed(@"sxeditshopinfo_img");
        self.nodataView2.markL.text = @"未设置";
    }
    
    if (shopModel.myShopM.tale && shopModel.myShopM.tale.length) {
        self.nodataView3.markL.text = shopModel.myShopM.tale;
        self.nodataView3.markImageView.image = UIImageNamed(@"cellnextbutton");
    }else{
        self.nodataView3.markImageView.image = UIImageNamed(@"sxeditshopinfo_img");
        self.nodataView3.markL.text = @"未添加";
    }
    
    if (shopModel.myShopM.tagsTextArr.count) {
        self.nodataView4.markL.text = shopModel.myShopM.tagString;
        self.nodataView4.markImageView.image = UIImageNamed(@"cellnextbutton");
    }else{
        self.nodataView4.markImageView.image = UIImageNamed(@"sxeditshopinfo_img");
        self.nodataView4.markL.text = @"未设置";
    }
    
    if (shopModel.myShopM.photowallArr.count) {
        self.photoImageView.hidden = NO;
        self.nodataView1.markL.text = @"";
        self.nodataView1.markImageView.image = UIImageNamed(@"cellnextbutton");
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:[shopModel.myShopM.photowallArr[0] photo_url]]];
    }else{
        _photoImageView.hidden = YES;
        self.nodataView1.markImageView.image = UIImageNamed(@"sxeditshopinfo_img");
        self.nodataView1.markL.text = @"未添加";
    }
    
    NSString *str1 = shopModel.myShopM.order_num.intValue?shopModel.myShopM.order_num:@"0";
    NSString *str2 = @"被咨询 ";
    NSString *allStr = [NSString stringWithFormat:@"%@%@",str2,str1];
    self.searvNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setSize:16 setLengthString:str1 beginSize:allStr.length-str1.length];
    
    NSString *str3 = shopModel.myShopM.comment_num.intValue?shopModel.myShopM.comment_num:@"0";
    NSString *str4 = @"评价 ";
    NSString *allStr1 = [NSString stringWithFormat:@"%@%@",str4,str3];
    self.comNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr1 setColor:[UIColor colorWithHexString:@"#5C5F66"] setSize:16 setLengthString:str3 beginSize:allStr1.length-str3.length];
}

- (void)setGoodsNum:(NSInteger)goodsNum{
    _goodsNum = goodsNum;
    NSString *str1 = [NSString stringWithFormat:@"%ld",goodsNum];
    NSString *str2 = @"咨询服务 ";
    NSString *allStr = [NSString stringWithFormat:@"%@%@",str2,str1];
    self.goodsNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setSize:16 setLengthString:str1 beginSize:allStr.length-str1.length];
}

- (SXNoDataDefaultShopInfoView *)nodataView1{
    if (!_nodataView1) {
        _nodataView1 = [[SXNoDataDefaultShopInfoView  alloc] initWithFrame:CGRectMake(80, 0, self.photoView.frame.size.width-80-15, self.photoView.frame.size.height)];
        _nodataView1.markL.text = @"未添加";
        [self.photoView addSubview:_nodataView1];
        [self.photoView sendSubviewToBack:_nodataView1];
    }
    return _nodataView1;
}

- (SXNoDataDefaultShopInfoView *)nodataView2{
    if (!_nodataView2) {
        _nodataView2 = [[SXNoDataDefaultShopInfoView  alloc] initWithFrame:CGRectMake(80, 0, self.photoView.frame.size.width-80-15, self.photoView.frame.size.height)];
        _nodataView2.markL.text = @"未设置";
        [self.voiceView addSubview:_nodataView2];
        [self.voiceView sendSubviewToBack:_nodataView2];
    }
    return _nodataView2;
}

- (SXNoDataDefaultShopInfoView *)nodataView3{
    if (!_nodataView3) {
        _nodataView3 = [[SXNoDataDefaultShopInfoView  alloc] initWithFrame:CGRectMake(80, 0, self.photoView.frame.size.width-80-15, self.photoView.frame.size.height)];
        _nodataView3.markL.text = @"未添加";
        [self.storyView addSubview:_nodataView3];
    }
    return _nodataView3;
}

- (SXNoDataDefaultShopInfoView *)nodataView4{
    if (!_nodataView4) {
        _nodataView4 = [[SXNoDataDefaultShopInfoView  alloc] initWithFrame:CGRectMake(80, 0, self.photoView.frame.size.width-80-15, self.photoView.frame.size.height)];
        _nodataView4.markL.text = @"未添加";
        [self.tagsView addSubview:_nodataView4];
    }
    return _nodataView4;
}

- (void)changeRoleTap{
    NoticeChangeShopIconController *ctl = [[NoticeChangeShopIconController alloc] init];
 
    ctl.shopId = self.shopModel.myShopM.shopId;
    ctl.url = self.shopModel.myShopM.shop_avatar_url;
 

    __weak typeof(self) weakSelf = self;
    ctl.refreshShopModel = ^(BOOL refresh) {
        if (weakSelf.refreshShopModel) {
            weakSelf.refreshShopModel(YES);
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}


@end

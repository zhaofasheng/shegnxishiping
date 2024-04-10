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
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 80, 80)];
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
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10,10, DR_SCREEN_WIDTH-30-85, 28)];
        self.shopNameL.font = XGTwentyBoldFontSize;
        self.shopNameL.textColor = [UIColor whiteColor];
        [self addSubview:self.shopNameL];
        
        self.checkL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, 49, DR_SCREEN_WIDTH-115, 18)];
        self.checkL.font = THRETEENTEXTFONTSIZE;
        self.checkL.textColor = [UIColor whiteColor];
        self.checkL.text = @"点击添加认证…";
        self.checkL.numberOfLines = 0;
        [self addSubview:self.checkL];
        self.checkL.userInteractionEnabled = YES;
        UITapGestureRecognizer *checkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkShopTap)];
        [self.checkL addGestureRecognizer:checkTap];
        
        self.goodsNumL = [[UILabel  alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(self.iconImageView.frame)+20, GET_STRWIDTH(@"咨询服务 2", 12, 19)+30, 19)];
        self.goodsNumL.font = TWOTEXTFONTSIZE;
        self.goodsNumL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.goodsNumL.text = @"咨询服务 0";
        [self addSubview:self.goodsNumL];
        
        self.searvNumL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsNumL.frame), CGRectGetMaxY(self.iconImageView.frame)+20, GET_STRWIDTH(@"被咨询 999", 12, 19)+47, 19)];
        self.searvNumL.font = TWOTEXTFONTSIZE;
        self.searvNumL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.searvNumL];
        self.searvNumL.userInteractionEnabled = YES;
        
        self.comNumL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searvNumL.frame), CGRectGetMaxY(self.iconImageView.frame)+20, GET_STRWIDTH(@"评价 9999", 12, 19)+10, 19)];
        self.comNumL.font = TWOTEXTFONTSIZE;
        self.comNumL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.comNumL];
        self.comNumL.userInteractionEnabled = YES;
        
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

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    
    SXVerifyShopModel *verifyModel = shopModel.myShopM.verifyModel;
    if (verifyModel.verify_status.intValue == 3) {
        if (verifyModel.authentication_type.intValue == 1) {//学历
            self.checkL.text = [NSString stringWithFormat:@"%@ %@%@",verifyModel.school_name,verifyModel.speciality_name,verifyModel.education_optionName];
        }else if (verifyModel.authentication_type.intValue == 2){
            self.checkL.text = [NSString stringWithFormat:@"%@ %@",verifyModel.industry_name,verifyModel.position_name];
        }else if (verifyModel.authentication_type.intValue == 3){
            self.checkL.text = [NSString stringWithFormat:@"%@",verifyModel.credentials_name];
        }
        self.checkL.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+10, 49, DR_SCREEN_WIDTH-115, GET_STRHEIGHT(self.checkL.text, 13, DR_SCREEN_WIDTH-115));
    }

    self.shopNameL.text = shopModel.myShopM.shop_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.myShopM.shop_avatar_url]];
    
    NSString *str1 = shopModel.myShopM.order_num.intValue?shopModel.myShopM.order_num:@"0";
    NSString *str2 = @"被咨询 ";
    NSString *allStr = [NSString stringWithFormat:@"%@%@",str2,str1];
    self.searvNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#FFFFFF"] setSize:16 setLengthString:str1 beginSize:allStr.length-str1.length];
    
    NSString *str3 = shopModel.myShopM.comment_num.intValue?shopModel.myShopM.comment_num:@"0";
    NSString *str4 = @"评价 ";
    NSString *allStr1 = [NSString stringWithFormat:@"%@%@",str4,str3];
    self.comNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr1 setColor:[UIColor colorWithHexString:@"#FFFFFF"] setSize:16 setLengthString:str3 beginSize:allStr1.length-str3.length];
}

- (void)setGoodsNum:(NSInteger)goodsNum{
    _goodsNum = goodsNum;
    NSString *str1 = [NSString stringWithFormat:@"%ld",goodsNum];
    NSString *str2 = @"咨询服务 ";
    NSString *allStr = [NSString stringWithFormat:@"%@%@",str2,str1];
    self.goodsNumL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#FFFFFF"] setSize:16 setLengthString:str1 beginSize:allStr.length-str1.length];
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

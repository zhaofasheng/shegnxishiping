//
//  SXWorkCheckView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXWorkCheckView.h"

@implementation SXWorkCheckView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.statusL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-20, 25)];
        self.statusL1.font = XGEightBoldFontSize;
        self.statusL1.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.statusL1.text = @"“职业认证”已通过";
        [self addSubview:self.statusL1];
        
        self.statusL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 52, DR_SCREEN_WIDTH-20, 20)];
        self.statusL2.font = FOURTHTEENTEXTFONTSIZE;
        self.statusL2.textColor = [UIColor whiteColor];
        self.statusL2.text = @"相关认证会展示在店铺中";
        [self addSubview:self.statusL2];
        
        CGFloat imageWidth = (DR_SCREEN_WIDTH- 75)/2;
        CGFloat imageHeight = imageWidth/150*92;
        
        UIView *contentView = [[UIView  alloc] initWithFrame:CGRectMake(15, 97, DR_SCREEN_WIDTH-30, 210+imageHeight+45)];
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView setAllCorner:10];
        [self addSubview:contentView];
        
        UILabel *identTitleL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 22)];
        identTitleL2.font = XGSIXBoldFontSize;
        identTitleL2.textColor = [UIColor colorWithHexString:@"#14151A"];
        identTitleL2.text = @"认证信息";
        [contentView addSubview:identTitleL2];
        
        NSArray *titleArr = @[@"姓名",@"身份证号",@"行业",@"职位"];
        CGFloat titWidth = GET_STRWIDTH(@"身份证号", 14, 32);
        for (int i = 0; i < 4; i++) {
            UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 52+32*i, titWidth, 32)];
            titleL.font = FOURTHTEENTEXTFONTSIZE;
            titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            titleL.text = titleArr[i];
            [contentView addSubview:titleL];
            
            UILabel *titleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame)+5, 52+32*i,contentView.frame.size.width-15-titWidth-20, 32)];
            titleL1.font = FOURTHTEENTEXTFONTSIZE;
            titleL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            [contentView addSubview:titleL1];
            titleL1.textAlignment = NSTextAlignmentRight;
            
            if (i == 0) {
                self.nameL = titleL1;
            }else if (i == 1){
                self.numL = titleL1;
            }else if (i == 2){
                self.hangyeL = titleL1;
            }else if (i == 3){
                self.zhiweiL = titleL1;
            }
            
            if (i < 2) {
                UIImageView *imageView = [[UIImageView  alloc] initWithFrame:CGRectZero];
                imageView.backgroundColor = [UIColor blueColor];
                if (i == 0) {
                    imageView.frame = CGRectMake(15, 210, imageWidth, imageHeight);
                    self.zmImageView = imageView;
                }else if (i == 1){
                    imageView.frame = CGRectMake(CGRectGetMaxX(self.zmImageView.frame)+15, 210, imageWidth, imageHeight);
                    self.fmImageView = imageView;
                }
                [imageView setAllCorner:4];
                [contentView addSubview:imageView];
                
                UIView *fgView = [[UIView  alloc] initWithFrame:CGRectMake(imageView.frame.origin.x-2, imageView.frame.origin.y+imageHeight/2, imageWidth+4, imageHeight/2)];
                fgView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
                [contentView addSubview:fgView];
                [fgView setCornerOnBottom:2];
            }
        }
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 97+contentView.frame.size.height);
    }
    return self;
}

- (void)setVerifyM:(SXVerifyShopModel *)verifyM{
    _verifyM = verifyM;
    self.nameL.text = verifyM.real_name;
    self.numL.text = verifyM.cert_no;
    self.hangyeL.text = verifyM.industry_name;
    self.zhiweiL.text = verifyM.position_name;
    [self.zmImageView sd_setImageWithURL:[NSURL URLWithString:verifyM.front_photo_url]];
    [self.fmImageView sd_setImageWithURL:[NSURL URLWithString:verifyM.back_photo_url]];
    
    if (verifyM.verify_status.intValue == 3) {
        self.statusL1.text = @"“职业认证”已通过";
        self.statusL2.text = @"相关认证会展示在店铺中";
    }else{
        self.statusL1.text = @"“职业认证”审核中";
        self.statusL2.text = @"认证还在人工审核中，请耐心等待";
    }
}

@end

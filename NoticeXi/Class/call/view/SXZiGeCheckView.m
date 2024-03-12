//
//  SXZiGeCheckView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXZiGeCheckView.h"

@implementation SXZiGeCheckView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.statusL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 20, DR_SCREEN_WIDTH-20, 25)];
        self.statusL1.font = XGEightBoldFontSize;
        self.statusL1.textColor = [UIColor whiteColor];
        self.statusL1.text = @"“资格证认证”审核中";
        [self addSubview:self.statusL1];
        
        self.statusL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 52, DR_SCREEN_WIDTH-20, 20)];
        self.statusL2.font = FOURTHTEENTEXTFONTSIZE;
        self.statusL2.textColor = [UIColor whiteColor];
        self.statusL2.text = @"认证还在人工审核中，请耐心等待";
        [self addSubview:self.statusL2];
        
        CGFloat imageWidth = (DR_SCREEN_WIDTH- 75)/2;
        CGFloat imageHeight = imageWidth/150*92;
        
        UIView *contentView = [[UIView  alloc] initWithFrame:CGRectMake(15, 97, DR_SCREEN_WIDTH-30, 178+imageHeight*2+45)];
        contentView.backgroundColor = [UIColor whiteColor];
        [contentView setAllCorner:10];
        [self addSubview:contentView];
        
        UILabel *identTitleL2 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, 200, 22)];
        identTitleL2.font = XGSIXBoldFontSize;
        identTitleL2.textColor = [UIColor colorWithHexString:@"#14151A"];
        identTitleL2.text = @"认证信息";
        [contentView addSubview:identTitleL2];
        
        NSArray *titleArr = @[@"姓名",@"身份证号",@"资格证全称"];
        CGFloat titWidth = GET_STRWIDTH(@"身份证号的", 14, 32);
        for (int i = 0; i < 3; i++) {
            UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 52+32*i, titWidth, 32)];
            titleL.font = FOURTHTEENTEXTFONTSIZE;
            titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            titleL.text = titleArr[i];
            [contentView addSubview:titleL];
            
            UILabel *titleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame)+5, 52+32*i,contentView.frame.size.width-15-titWidth-20, 32)];
            titleL1.font = FOURTHTEENTEXTFONTSIZE;
            titleL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            titleL1.text = @"认证的信息展示";
            [contentView addSubview:titleL1];
            titleL1.textAlignment = NSTextAlignmentRight;
            
            if (i == 0) {
                self.nameL = titleL1;
            }else if (i == 1){
                self.numL = titleL1;
            }else if (i == 2){
                self.zyL = titleL1;
            }
            
            UIImageView *imageView = [[UIImageView  alloc] initWithFrame:CGRectZero];
            imageView.backgroundColor = [UIColor blueColor];
            if (i == 0) {
                imageView.frame = CGRectMake(15, 178, imageWidth, imageHeight);
                self.zmImageView = imageView;
            }else if (i == 1){
                imageView.frame = CGRectMake(CGRectGetMaxX(self.zmImageView.frame)+15, 178, imageWidth, imageHeight);
                self.fmImageView = imageView;
            }else{
                imageView.frame = CGRectMake(15,CGRectGetMaxY(self.zmImageView.frame)+15, imageWidth, imageHeight);
                self.zgImageView = imageView;
            }
            [imageView setAllCorner:4];
            [contentView addSubview:imageView];
            
            UIView *fgView = [[UIView  alloc] initWithFrame:CGRectMake(imageView.frame.origin.x-2, imageView.frame.origin.y+imageHeight/2, imageWidth+4, imageHeight/2)];
            fgView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
            [contentView addSubview:fgView];
            [fgView setCornerOnBottom:2];
        }
        
        self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 97+contentView.frame.size.height);
    }
    return self;
}

@end

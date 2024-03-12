//
//  NoticeShopStatusView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopStatusView.h"

@implementation NoticeShopStatusView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.userInteractionEnabled = YES;
        [self setAllCorner:10];
        
        self.shopIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 64, 64)];
        self.shopIconImageView.layer.cornerRadius = 4;
        self.shopIconImageView.layer.masksToBounds = YES;
        self.shopIconImageView.image = UIImageNamed(@"setshoprole_img");
        self.shopIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRoleTap)];
        [self.shopIconImageView addGestureRecognizer:tap];
        [self addSubview:self.shopIconImageView];
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(86, 0, GET_STRWIDTH(@"店铺名称", 18, 104), 104)];
        self.shopNameL.font = XGSevenBoldFontSize;
        self.shopNameL.text = @"店铺名称";
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.shopNameL];
        self.shopNameL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopdetailTap)];
        [self.shopNameL addGestureRecognizer:tap1];
        
        self.shopDetailImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopNameL.frame), 42, 20, 20)];
        self.shopDetailImageView.userInteractionEnabled = YES;
        self.shopDetailImageView.image = UIImageNamed(@"Image_intodetail");
        [self addSubview:self.shopDetailImageView];
        self.shopDetailImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopdetailTap)];
        [self.shopDetailImageView addGestureRecognizer:tap2];
        
        
        UIButton *getButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-115-15, 32, 115, 40)];
        //渐变色
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FE827E"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#D84022"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(getButton.frame), CGRectGetHeight(getButton.frame));
        self.gradientLayer = gradientLayer;
        [getButton.layer addSublayer:self.gradientLayer];
        
        [getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        getButton.titleLabel.font = XGSIXBoldFontSize;
        [getButton setAllCorner:20];
        [getButton setTitle:@"结束营业" forState:UIControlStateNormal];
        [getButton addTarget:self action:@selector(openDoorClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:getButton];
        
        self.startGetOrderBtn = getButton;
        
        self.stopGetView = [[UIView  alloc] initWithFrame:getButton.frame];
        self.stopGetView.layer.cornerRadius = 20;
        self.stopGetView.layer.masksToBounds = YES;
        self.stopGetView.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.stopGetView.hidden = YES;
        self.stopGetView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopGetStatusTap)];
        [self.stopGetView addGestureRecognizer:tap3];
        
        self.stop1L = [[UILabel  alloc] initWithFrame:self.stopGetView.bounds];
        self.stop1L.font = THRETEENTEXTFONTSIZE;
        self.stop1L.textColor = [UIColor colorWithHexString:@"#E1E4F0"];
        self.stop1L.numberOfLines = 2;
        self.stop1L.textAlignment = NSTextAlignmentCenter;
        [self.stopGetView addSubview:self.stop1L];
        [self addSubview:self.stopGetView];
    }
    return self;
}

//店铺被暂停营业时候的点击
- (void)stopGetStatusTap{
    if (self.stopStatusBlock) {
        self.stopStatusBlock(YES);
    }

}

//开始营业或者结束营业
- (void)openDoorClick{
    if (self.openDoorBlock) {
        self.openDoorBlock(YES);
    }
}

//店铺详情
- (void)changeRoleTap{
    if (self.roleChangeBlock) {
        self.roleChangeBlock(YES);
    }
}

//店铺详情
- (void)shopdetailTap{
    if (self.detailBlock) {
        self.detailBlock(YES);
    }
}


@end

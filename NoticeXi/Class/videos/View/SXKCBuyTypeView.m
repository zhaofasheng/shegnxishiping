//
//  SXKCBuyTypeView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKCBuyTypeView.h"

@implementation SXKCBuyTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.keyView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 352)];
        self.keyView.backgroundColor = [UIColor whiteColor];
        [self.keyView setCornerOnTop:20];
        
        [self addSubview:self.keyView];
        
        UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 13, 200, 24)];
        titleL.text = @"请选择购买方式";
        titleL.font = XGEightBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.keyView addSubview:titleL];
        
        UIButton *cancelBtn = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-55, 0, 50, 50)];
        [cancelBtn setImage:UIImageNamed(@"sxbuykec_cancelimg") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.keyView addSubview:cancelBtn];
        
        for (int i = 0; i < 2; i++) {
            UIView *view = [[UIView  alloc] initWithFrame:CGRectMake(15, 70+110*i, DR_SCREEN_WIDTH-30, 90)];
            view.userInteractionEnabled = YES;
            view.backgroundColor = [UIColor colorWithHexString:i==0? @"#D8F361" : @"#F7F8FC"];
            [view setAllCorner:10];
            view.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyTap:)];
            [view addGestureRecognizer:tap];
            [self.keyView addSubview:view];
            
            UILabel *subTitleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 20, GET_STRWIDTH(@"登录声昔账号购买", 17, 22), 22)];
            subTitleL.text = i==0?@"登录声昔账号购买":@"游客购买";
            subTitleL.textColor = i == 0 ? [UIColor colorWithHexString:@"#14151A"] : [UIColor colorWithHexString:@"#5C5F66"];
            subTitleL.font = i == 0 ? XGSIXBoldFontSize : SIXTEENTEXTFONTSIZE;
            [view addSubview:subTitleL];
            
            UILabel *subTitleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(15, 50, DR_SCREEN_WIDTH-20, 20)];
            subTitleL1.text = i==0?@"跟随账号走，可在所有受支持设备享受权益":@"只能在当前设备享受对应权益，换设备或者登录新的账号权益不存在";
            subTitleL1.textColor = i == 0 ? [UIColor colorWithHexString:@"#14151A"] : [UIColor colorWithHexString:@"#8A8F99"];
            subTitleL1.font = FOURTHTEENTEXTFONTSIZE;
            [view addSubview:subTitleL1];
            
            if (i == 0) {
                UIImageView *markL = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subTitleL.frame)+4, 21, 60, 20)];
                markL.image = UIImageNamed(@"sx_makrBuytype_img");
                [view addSubview:markL];
                markL.userInteractionEnabled = YES;
                
                UIImageView *markL1 = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-32-30, 27, 32, 32)];
                markL1.image = UIImageNamed(@"sx_loginbuy_img");
                [view addSubview:markL1];
                markL1.userInteractionEnabled = YES;
            }else{
                subTitleL1.numberOfLines = 0;
                subTitleL1.frame = CGRectMake(15, 45, DR_SCREEN_WIDTH-30-20, 40);
            }
        }
        
        //
    }
    return self;
}

- (void)buyTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (self.buyTypeBlock) {
        self.buyTypeBlock(tapV.tag);
    }
    [self cancelClick];
}

- (void)showTost{
    
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+20, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end

//
//  SXShopInfoTosatView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopInfoTosatView.h"
#import "NoticeMyWallectModel.h"
#import "SXShopCheckController.h"
#import "NoticeHasServeredController.h"
#import "NoticeBuyOrderListController.h"
#import "SXLikeShopListController.h"
#import "SXShopLyStoryController.h"

@implementation SXShopInfoTosatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [self addGestureRecognizer:tap];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-255-15, NAVIGATION_BAR_HEIGHT, 255, 250+88+15)];
        [contentView setAllCorner:10];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
        [self addSubview:contentView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noClick)];
        [self.contentView addGestureRecognizer:tap1];
        
        self.shopIconImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(20, 20, 48, 48)];
        [self.shopIconImageView setAllCorner:24];
        self.shopIconImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.shopIconImageView];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
        [self.shopIconImageView addGestureRecognizer:tap2];
        
        self.intoView = [[UIView  alloc] initWithFrame:CGRectMake(78, 22, self.frame.size.width-78, 20)];
        [self.contentView addSubview:self.intoView];
        self.intoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
        [self.intoView addGestureRecognizer:tap3];
        
        self.shopNameL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        self.shopNameL.font = EIGHTEENTEXTFONTSIZE;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.intoView addSubview:self.shopNameL];
        
        self.jiantouImgv = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopNameL.frame)+4, 2, 16, 16)];
        self.jiantouImgv.image = UIImageNamed(@"sx_jiantoushop_img");
        [self.intoView addSubview:self.jiantouImgv];
        
   
        NSArray *imgArr = @[@"sxshopcheck_img",@"sxhasfuwurec_img",@"sxhasbuyrec_img",@"sx_shop_like_img",@"sx_shop_ly_img"];
        NSArray *titleArr = @[@"店铺认证",@"服务过的",@"买过的",@"收藏的店铺",@"留言记录"];
        for (int i = 0; i < 5; i++) {
            
            UIView *tapV = [[UIView  alloc] initWithFrame:CGRectMake(0, 88+50*i, self.contentView.frame.size.width, 50)];
            tapV.userInteractionEnabled = YES;
            tapV.tag = i;
            UIImageView *titleImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(20, 13, 24, 24)];
            titleImageV.userInteractionEnabled = YES;
            titleImageV.image = UIImageNamed(imgArr[i]);
            [tapV addSubview:titleImageV];
            
            UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageV.frame)+8, 0, 100, 50)];
            titleL.text = titleArr[i];
            titleL.font = XGFifthBoldFontSize;
            titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
            [tapV addSubview:titleL];
            
            [self.contentView addSubview:tapV];
            
            UITapGestureRecognizer *funTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushTap:)];
            [tapV addGestureRecognizer:funTap];
            
            if (i == 1) {
                self.severNumL = [[UILabel  alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-15-100, 0, 100, 50)];
                self.severNumL.font = XGTWOBoldFontSize;
                self.severNumL.textAlignment = NSTextAlignmentRight;
                self.severNumL.textColor = [UIColor colorWithHexString:@"#14151A"];
                self.severNumL.attributedText = [DDHAttributedMode setString:@"0单" setSize:12 setLengthString:@"单" beginSize:1];
                [tapV addSubview:self.severNumL];
            }
            
            if ( i == 2) {
                self.buyL = [[UILabel  alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-15-100, 0, 100, 50)];
                self.buyL.font = XGTWOBoldFontSize;
                self.buyL.textAlignment = NSTextAlignmentRight;
                self.buyL.textColor = [UIColor colorWithHexString:@"#14151A"];
                self.buyL.attributedText = [DDHAttributedMode setString:@"0单" setSize:12 setLengthString:@"单" beginSize:1];
                [tapV addSubview:self.buyL];
            }
        }
        
        [self getwallect];
    }
    return self;
}

- (void)pushTap:(UITapGestureRecognizer *)tap{
    UIView *tapv = (UIView *)tap.view;
    if (tapv.tag == 0) {
        if (self.noShop) {
            if (self.clickIconBlock) {
                self.clickIconBlock(YES);
            }
            [self cancelClick];
            return;
        }
        if (self.shopModel) {
            SXShopCheckController *ctl = [[SXShopCheckController alloc] init];
            ctl.shopModel = self.shopModel.myShopM;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
    }else if (tapv.tag == 1){
        if (self.noShop) {
            if (self.clickIconBlock) {
                self.clickIconBlock(YES);
            }
            return;
        }
        if (!self.shopModel) {
            [[NoticeTools getTopViewController] showToastWithText:@"当前店铺信息还没获取到，请稍等"];
            return;
        }
        NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
    else if (tapv.tag == 2){
        NoticeBuyOrderListController *ctl = [[NoticeBuyOrderListController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (tapv.tag == 3){
        SXLikeShopListController *ctl = [[SXLikeShopListController alloc] init];
        ctl.shopModel = self.shopModel;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (tapv.tag == 4){
        SXShopLyStoryController *ctl = [[SXShopLyStoryController alloc] init];
        ctl.shopModel = self.shopModel;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
    [self cancelClick];
}

- (void)iconClick{
    if (self.clickIconBlock) {
        self.clickIconBlock(YES);
    }
    [self cancelClick];
}

- (void)setNoShop:(BOOL)noShop{
    _noShop = noShop;
    if (noShop) {
        self.shopIconImageView.image = UIImageNamed(@"sxshopdefaulticon_img");
        self.shopNameL.text = @"我的店铺";
        self.shopNameL.frame = CGRectMake(0,0, GET_STRWIDTH(self.shopNameL.text, 18, 20), 20);
        self.jiantouImgv.frame = CGRectMake(CGRectGetMaxX(self.shopNameL.frame)+4, 2, 16, 16);
        self.intoView.frame = CGRectMake(78, 34, self.contentView.frame.size.width-78, 20);
        _workingView.hidden = YES;
    }
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    if (self.noShop) {
        return;
    }
    
    self.workingView.hidden = NO;
    if (shopModel.myShopM.operate_status.intValue > 1) {
        self.workV.backgroundColor = [UIColor colorWithHexString:@"#E64424"];
        self.workL.textColor = [UIColor colorWithHexString:@"#E64424"];
        self.workL.text = @"营业中";
    }else{
        self.workV.backgroundColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.workL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.workL.text = @"休息中";
    }
    
    if (!_shopModel.myShopM.order_num.intValue) {
        self.shopModel.myShopM.order_num = @"0";
    }
    self.severNumL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@单",_shopModel.myShopM.order_num] setSize:12 setLengthString:@"单" beginSize:_shopModel.myShopM.order_num.length];
    
    self.intoView.frame = CGRectMake(78, 22, self.contentView.frame.size.width-78, 20);
    self.shopNameL.text = shopModel.myShopM.shop_name;
    self.shopNameL.frame = CGRectMake(0,0, GET_STRWIDTH(self.shopNameL.text, 18, 20), 20);
    self.jiantouImgv.frame = CGRectMake(CGRectGetMaxX(self.shopNameL.frame)+4, 2, 16, 16);
    [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:_shopModel.myShopM.shop_avatar_url] placeholderImage:UIImageNamed(@"sxshopdefaulticon_img")];
    

}

- (void)getwallect{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"wallet" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            NoticeMyWallectModel *wallectM = [NoticeMyWallectModel mj_objectWithKeyValues:dict[@"data"]];
            NSString *str = @"0";
            if (!wallectM.buy_order_num.intValue || !wallectM) {
                str = @"0";
            }else{
                str = wallectM.buy_order_num;
            }
            self.buyL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@单",str] setSize:12 setLengthString:@"单" beginSize:str.length];
        
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (UIView *)workingView{
    if (!_workingView) {
        _workingView = [[UIView  alloc] initWithFrame:CGRectMake(78, 50, self.contentView.frame.size.width-78, 16)];
        self.workV = [[UIView  alloc] initWithFrame:CGRectMake(0, 4, 8, 8)];
        [self.workV setAllCorner:4];
        [_workingView addSubview:self.workV];
        
        self.workL = [[UILabel  alloc] initWithFrame:CGRectMake(12, 0, 100, 16)];
        self.workL.font = ELEVENTEXTFONTSIZE;
        [_workingView addSubview:self.workL];
        [self.contentView addSubview:_workingView];
    }
    return _workingView;
}

- (void)noClick{
    
}

- (void)cancelClick{
    
    [self removeFromSuperview];
}

- (void)showInfoView{
    [self getwallect];
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];

    [self creatShowAnimation];
}
- (void)creatShowAnimation
{
    self.contentView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}

@end

//
//  SXSpulyShopView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXSpulyShopView.h"
#import "NoticeXi-Swift.h"
#import "NoticeShopRuleController.h"
@implementation SXSpulyShopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 279)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
        
        FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 13, 24, 24)];
        [btn setImage:UIImageNamed(@"sxpaycancel_img") forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *cancelTapView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.contentView.frame.size.height)];
        cancelTapView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        cancelTapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [cancelTapView addGestureRecognizer:tap];
        [self addSubview:cancelTapView];
        
        CGFloat width = GET_STRWIDTH(@"店铺说明", 15, 21);
        UIView *ruleView = [[UIView  alloc] initWithFrame:CGRectMake(15, 50, 40+width, 21)];
        ruleView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *rtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleTap)];
        [ruleView addGestureRecognizer:rtap];
        
        UIImageView *rulimageV = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        rulimageV.image = UIImageNamed(@"sxshoprulemark_img");
        [ruleView addSubview:rulimageV];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(24, 0, width, 21)];
        markL.text = @"店铺说明";
        markL.font = FIFTHTEENTEXTFONTSIZE;
        markL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [ruleView addSubview:markL];
        
        UIImageView *rulimageV1 = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL.frame), 0, 24, 24)];
        rulimageV1.image = UIImageNamed(@"sxshopruleinto_img");
        [ruleView addSubview:rulimageV1];
        
        [self.contentView addSubview:ruleView];
        
        self.supplyButton = [[UIButton  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-218)/2, 127, 218, 48)];
        self.supplyButton.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [self.supplyButton setAllCorner:24];
        [self.supplyButton addTarget:self action:@selector(supplyClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.supplyButton];
    }
    return self;
}

- (void)setCanSupply:(BOOL)canSupply{
    _canSupply = canSupply;
    if (canSupply) {
        self.supplyButton.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [self.supplyButton setTitle:@"申请开通店铺" forState:UIControlStateNormal];
        [self.supplyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.supplyButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.supplyButton setTitle:@"等待审核" forState:UIControlStateNormal];
        [self.supplyButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }
}

- (void)supplyClick{
    if (self.canSupply) {
        [self removeFromSuperview];
        NoticeSupplyProController *ctl = [[NoticeSupplyProController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)ruleTap{
    if (self.lookRuleBlock) {
        self.lookRuleBlock(YES);
    }
    
    [self removeFromSuperview];
    NoticeShopRuleController *ctl = [[NoticeShopRuleController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+277);

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showSupplyView{
 
    NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
    if (userInfo.mobile.intValue < 1000) {
        self.supplyButton.hidden = YES;
        self.markL.hidden = NO;
    }else{
        self.supplyButton.hidden = NO;
        _markL.hidden = YES;
    }
    
    self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+279);
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-279, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT+279);
    }];
}

- (UILabel *)markL{
    if (!_markL) {
        _markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 91, DR_SCREEN_WIDTH-30, 104)];
        _markL.text  = @"申请店铺需满足“绑定手机号”";
        _markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _markL.font = FOURTHTEENTEXTFONTSIZE;
        _markL.textAlignment = NSTextAlignmentCenter;
        _markL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_markL setAllCorner:10];
        [self.contentView addSubview:_markL];
    }
    return _markL;
}

@end

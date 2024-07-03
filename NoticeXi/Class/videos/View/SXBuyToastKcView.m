//
//  SXBuyToastKcView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/3.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuyToastKcView.h"

@implementation SXBuyToastKcView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = YES;

        UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 366)];
        contentView.image = UIImageNamed(@"sx_lockkc_img");
        contentView.center = self.center;
        self.contentView = contentView;
        contentView.userInteractionEnabled = YES;
        [self addSubview:contentView];
              
        UIButton *knowBtn = [[UIButton  alloc] initWithFrame:CGRectMake(20, 366-48-30, 92, 48)];
        [knowBtn setTitle:@"取消" forState:UIControlStateNormal];
        [knowBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        knowBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        knowBtn.layer.cornerRadius = 24;
        knowBtn.layer.masksToBounds = YES;
        knowBtn.layer.borderWidth = 1;
        knowBtn.layer.borderColor = [UIColor colorWithHexString:@"#E1E2E6"].CGColor;
        [self.contentView addSubview:knowBtn];
        [knowBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *toBtn = [[UIButton  alloc] initWithFrame:CGRectMake(127, 366-48-30, 133, 48)];
        toBtn.layer.cornerRadius = 24;
        toBtn.layer.masksToBounds = YES;
        self.buyButton = toBtn;
        //渐变色
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFAA45"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#FF1F7D"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.buyButton.frame), CGRectGetHeight(self.buyButton.frame));
        [toBtn.layer addSublayer:gradientLayer];
        
        [toBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        toBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;

        [self.contentView addSubview:toBtn];
        

        [toBtn addTarget:self action:@selector(toClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)toClick{
    if (self.buyBolokc) {
        self.buyBolokc(YES);
    }
    [self cancelClick];
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)showInfoView{
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

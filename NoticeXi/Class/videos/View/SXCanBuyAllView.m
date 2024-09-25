//
//  SXCanBuyAllView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXCanBuyAllView.h"

@implementation SXCanBuyAllView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.userInteractionEnabled = YES;
        
        self.contentView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 280, 332)];
        self.contentView.center = self.center;
        self.contentView.userInteractionEnabled = YES;
        self.contentView.image = UIImageNamed(@"sx_canbuyall");
        
        [self addSubview:self.contentView];
        
        UIButton *cancelBtn = [[UIButton  alloc] initWithFrame:CGRectMake(60, 254, 160, 48)];
        cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [cancelBtn setAllCorner:24];
        [cancelBtn setTitle:@"继续购买" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        
    }
    return self;
}

- (void)cancelClick{
    if (self.buyBlock) {
        self.buyBlock(YES);
    }
    [self removeFromSuperview];
}

#pragma mark - 弹出 -
- (void)showView
{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.layer.position = self.center;
    self.contentView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

@end

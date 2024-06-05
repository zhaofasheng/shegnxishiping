//
//  SXHowToUseView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHowToUseView.h"
#import "SXUserHowController.h"
#import "NoticeLoginViewController.h"
@implementation SXHowToUseView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.userInteractionEnabled = YES;

        UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 474)];
        contentView.image = UIImageNamed(@"sx_how_use_img");
        contentView.center = self.center;
        self.contentView = contentView;
        contentView.userInteractionEnabled = YES;
        [self addSubview:contentView];
              
        UIButton *knowBtn = [[UIButton  alloc] initWithFrame:CGRectMake(20, 414, 114, 40)];
        knowBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [knowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        knowBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [knowBtn setAllCorner:20];
        [self.contentView addSubview:knowBtn];
        [knowBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *toBtn = [[UIButton  alloc] initWithFrame:CGRectMake(146, 414, 114, 40)];
        toBtn.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [toBtn setTitle:@"去看看" forState:UIControlStateNormal];
        [toBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        toBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [toBtn setAllCorner:20];
        [self.contentView addSubview:toBtn];
        [toBtn addTarget:self action:@selector(toClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)toClick{
    if ([NoticeTools getuserId]) {
        SXUserHowController *ctl = [[SXUserHowController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.needPushHowuse = YES;
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
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

//
//  NoticeKnowSendTextView.m
//  NoticeXi
//
//  Created by li lei on 2020/7/16.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeKnowSendTextView.h"
#import "NoticeWebViewController.h"
@implementation NoticeKnowSendTextView
{
    NSInteger time;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.userInteractionEnabled = YES;
        
        self.contentView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, 280, 395+24)];
        self.contentView.center = self.center;
        
        [self addSubview:self.contentView];
        
        UIButton *cancelBtn = [[UIButton  alloc] initWithFrame:CGRectMake(280-24, 0, 24, 24)];
        [cancelBtn setBackgroundImage:UIImageNamed(@"ly_xxx") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [self addGestureRecognizer:tap];
        
        self.imageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 24, 280, 395)];
        [self.contentView addSubview:self.imageView];
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpTap)];
        [self.imageView addGestureRecognizer:tap1];
    }
    return self;
}

- (void)setHuodongModel:(SXHuodonModel *)huodongModel{
    _huodongModel = huodongModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:huodongModel.popup_img_url]];
}

- (void)jumpTap{
    [self cancelClick];
    
    NSURL *taobaoUrl = [NSURL URLWithString:self.huodongModel.supply];

    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:taobaoUrl]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
         
                [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        DRLog(@"跳转成功");
                    }
                }];
            }
        } else {
            [application openURL:taobaoUrl options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    DRLog(@"跳转成功");
                }
            }];
        }
    }else{

        NoticeWebViewController *ctl = [[NoticeWebViewController alloc] init];
        ctl.url = self.huodongModel.supply;
        ctl.isFromShare = YES;
        ctl.isMerechant = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)cancelClick{
    [self removeFromSuperview];
    [SXTools setCanNotShowHuodong:self.huodongModel.huodongid];
}

#pragma mark - 弹出 -
- (void)showGetView
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

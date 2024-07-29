//
//  SXTosatView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXTosatView.h"

@implementation SXTosatView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.6];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 0, 217, 54)];
        [btn setTitle:@"已添加到缓存队列  查看" forState:UIControlStateNormal];
        btn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setImage:UIImageNamed(@"sxlooksave_img") forState:UIControlStateNormal];
        btn.buttonImagePosition = FSCustomButtonImagePositionRight;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(lookSave) forControlEvents:UIControlEventTouchUpInside];
        self.button = btn;
    }
    return self;
}

- (void)lookSave{
    [self.timer invalidate];
    self.timer = nil;
    [self removeFromSuperview];
    if (self.lookSaveListBlock) {
        self.lookSaveListBlock(YES);
    }
}

#pragma mark - 弹出 -
- (void)showSXToast
{
    self.time = 0;
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoDiss) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoDiss) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)autoDiss{
    self.time++;
    if (self.time == 2) {
        [self.timer invalidate];
        self.timer = nil;
        [self removeFromSuperview];
    }

}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}



@end

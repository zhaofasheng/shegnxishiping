//
//  NoticeShop3DListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShop3DListCell.h"

@implementation NoticeShop3DListCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        int width = arc4random() % 45+35;
        CGFloat allWidth = frame.size.width;
        self.starImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((allWidth-width)/2, (allWidth-width)/2, width, width)];
        self.starImageView.image = [UIImage imageNamed:@"circlesofociety_star_10"];
        [self.starImageView.layer addAnimation:[self opacityForever_Animation:(arc4random() % 15)%3+1] forKey:nil];
        [self addSubview:self.starImageView];
        self.starImageView.userInteractionEnabled = YES;
        
        UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(0,allWidth+2, allWidth, 16)];
        titleL.font = ELEVENTEXTFONTSIZE;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = [UIColor colorWithHexString:@"#FFF9E0"];
        [self addSubview:titleL];
        titleL.userInteractionEnabled = YES;
        [titleL.layer addAnimation:[self opacityForever_Animation:(arc4random() % 15)%3+1] forKey:nil];
        self.shopNameL = titleL;
    }
    return self;
}


-(CABasicAnimation *)opacityForever_Animation1:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.3f];
    animation.toValue = [NSNumber numberWithFloat:0.1f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    return animation;
}

-(CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:0.8f];
    animation.toValue = [NSNumber numberWithFloat:0.2f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//没有的话是均匀的动画。
    return animation;
}


@end

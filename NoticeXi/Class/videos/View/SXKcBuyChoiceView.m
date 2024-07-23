//
//  SXKcBuyChoiceView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcBuyChoiceView.h"

@implementation SXKcBuyChoiceView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
     
        
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = YES;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 322)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_contentView setCornerOnTop:20];
        [self addSubview:_contentView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-50, 0,50, 50)];
        [button setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dissMissTap) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:button];
        
        CGFloat width = (DR_SCREEN_WIDTH-45)/2;
        CGFloat height = width*195/165;
        NSArray *imgArr = @[@"sx_baom_img",@"sx_zengsong_img"];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(15+(width+15)*i, 60, width, height)];
            [button setBackgroundImage:UIImageNamed(imgArr[i]) forState:UIControlStateNormal];
            [_contentView addSubview:button];
            button.tag = i;
            [button addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.buyBtn = button;
            }
        }
    }
    return self;
}

- (void)setHasBuy:(BOOL)hasBuy{
    _hasBuy = hasBuy;
    if (hasBuy) {
        [self.buyBtn setBackgroundImage:UIImageNamed(@"sx_baom_img1") forState:UIControlStateNormal];
    }
}

- (void)typeClick:(UIButton *)btn{
    if (btn.tag == 0) {
        if (self.hasBuy) {
            return;
        }
    }
    if (self.buyTypeBolck) {
        self.buyTypeBolck(btn.tag==0?NO:YES);
    }
    [self dissMissTap];
}

- (void)show{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self->_contentView.frame.size.height, DR_SCREEN_WIDTH, self->_contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }];
    
}

- (void)dissMissTap{
 
    [UIView animateWithDuration:0.3 animations:^{
        self->_contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 263+44+44);
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
      
    }];
}

@end

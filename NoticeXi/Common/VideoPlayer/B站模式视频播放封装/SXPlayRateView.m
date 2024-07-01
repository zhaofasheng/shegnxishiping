//
//  SXPlayRateView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/1.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayRateView.h"

@implementation SXPlayRateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.contentView = [[UIView  alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 240, self.frame.size.height)];
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0.8];
        [self addSubview:self.contentView];
        
        self.buttonArr = [[NSMutableArray alloc] init];
        NSArray *arr = @[@"1.0x",@"1.25x",@"1.5x",@"2.0x"];
        for (int i = 0; i < 4; i++) {
            UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(0, (DR_SCREEN_WIDTH-44*4)/2+44*i, 240, 44)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
            button.tag = i+1;
            [button setTitle:arr[i] forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            [button addTarget:self action:@selector(rateClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArr addObject:button];
        }
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissMissView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setRate:(NSInteger)rate{
    _rate = rate;
    for (UIButton *btn in self.buttonArr) {
        if (btn.tag == rate) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#FF68A3"] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)dissMissView{
    self.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(self.frame.size.width, 0, 240, self.frame.size.height);
    }];
}

- (void)show{
    self.hidden = NO;
    self.contentView.frame = CGRectMake(self.frame.size.width, 0, 240, self.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(self.frame.size.width-240, 0, 240, self.frame.size.height);
    }];
}

- (void)rateClick:(UIButton *)button{
    if (self.rateBlock) {
        self.rateBlock(button.tag);
    }
    self.hidden = YES;
}

@end

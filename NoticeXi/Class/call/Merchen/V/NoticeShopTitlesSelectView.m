//
//  NoticeShopTitlesSelectView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopTitlesSelectView.h"

@implementation NoticeShopTitlesSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        
        self.tapView3 = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 10, 115*3, 30)];
        self.tapView3.userInteractionEnabled = YES;
        [self addSubview:self.tapView3];
        self.tapView3.image = UIImageNamed(@"yellow345");
        
        self.tapL3 = [[UILabel  alloc] initWithFrame:CGRectMake(115*2, 0, 115, self.tapView3.frame.size.height)];
        self.tapL3.textAlignment = NSTextAlignmentCenter;
        self.tapL3.font = FOURTHTEENTEXTFONTSIZE;
        self.tapL3.textColor = [UIColor whiteColor];
        [self.tapView3 addSubview:self.tapL3];
        
        
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3choice)];
        [self.tapView3 addGestureRecognizer:tap3];
        
        self.tapView2 = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 10, 115*2, 30)];
        self.tapView2.userInteractionEnabled = YES;
        self.tapView2.image = UIImageNamed(@"pink230");
        [self addSubview:self.tapView2];
        
        self.tapL2 = [[UILabel  alloc] initWithFrame:CGRectMake(115*2, 0, 115, 30)];
        self.tapL2.textAlignment = NSTextAlignmentCenter;
        self.tapL2.font = FOURTHTEENTEXTFONTSIZE;
        self.tapL2.textColor = [UIColor whiteColor];
        [self.tapView2 addSubview:self.tapL2];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2choice)];
        [self.tapView2 addGestureRecognizer:tap2];
        
        self.tapView1 = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 115, 40)];
        self.tapView1.userInteractionEnabled = YES;
        self.tapView1.image = UIImageNamed(@"white115");
        [self addSubview:self.tapView1];
        
        self.tapL1 = [[UILabel  alloc] initWithFrame:CGRectMake(115*2, 0, 115, 40)];
        self.tapL1.textAlignment = NSTextAlignmentCenter;
        self.tapL1.font = XGSIXBoldFontSize;
        self.tapL1.textColor = [UIColor blackColor];
        [self.tapView1 addSubview:self.tapL1];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1choice)];
        [self.tapView1 addGestureRecognizer:tap1];
        
        self.tapL3.frame = CGRectMake(115*2, 0, 115, self.tapView3.frame.size.height);
        self.tapL2.frame = CGRectMake(115, 0, 115, self.tapView2.frame.size.height);
        self.tapL1.frame = CGRectMake(0, 0, 115, self.tapView1.frame.size.height);
        
        self.currentIndex = 0;
    }
    return self;
}

- (void)tap1choice{
    self.currentIndex = 0;
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tapView3.frame = CGRectMake(0, 10, 115*3, 30);
        self.tapView2.frame = CGRectMake(0, 10, 115*2, 30);
        self.tapView1.frame = CGRectMake(0, 0, 115, self.frame.size.height);
        
        self.tapL3.frame = CGRectMake(115*2, 0, 115, self.tapView3.frame.size.height);
        self.tapL2.frame = CGRectMake(115, 0, 115, self.tapView2.frame.size.height);
        self.tapL1.frame = CGRectMake(0, 0, 115, self.tapView1.frame.size.height);
        
        self.tapL1.textColor = [UIColor blackColor];
        self.tapL2.textColor = [UIColor whiteColor];
        self.tapL3.textColor = [UIColor whiteColor];
        
        self.tapL1.font = XGSIXBoldFontSize;
        self.tapL2.font = FOURTHTEENTEXTFONTSIZE;
        self.tapL3.font = FOURTHTEENTEXTFONTSIZE;
        
        self.tapView1.image = UIImageNamed(@"white115");
        self.tapView2.image = UIImageNamed(@"pink230");
        self.tapView3.image = UIImageNamed(@"yellow345");
    } completion:^(BOOL finished) {
    }];
    
    if (self.viewChoiceBlock) {
        self.viewChoiceBlock(0);
    }
}

- (void)tap2choice{
    self.currentIndex = 1;
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tapView3.frame = CGRectMake(0, 10, 115*3, 30);
        self.tapView2.frame = CGRectMake(0, 0, 115*2, self.frame.size.height);
        self.tapView1.frame = CGRectMake(0, 10, 115, 30);
        
        self.tapL1.textColor = [UIColor whiteColor];
        self.tapL2.textColor = [UIColor blackColor];
        self.tapL3.textColor = [UIColor whiteColor];
        
        self.tapL1.font = FOURTHTEENTEXTFONTSIZE;
        self.tapL2.font = XGSIXBoldFontSize;
        self.tapL3.font = FOURTHTEENTEXTFONTSIZE;
        
        self.tapL3.frame = CGRectMake(115*2, 0, 115, self.tapView3.frame.size.height);
        self.tapL2.frame = CGRectMake(115, 0, 115, self.tapView2.frame.size.height);
        self.tapL1.frame = CGRectMake(0, 0, 115, self.tapView1.frame.size.height);
        
        self.tapView1.image = UIImageNamed(@"pink115");
        self.tapView2.image = UIImageNamed(@"white230");
        self.tapView3.image = UIImageNamed(@"yellow345");
    } completion:^(BOOL finished) {
    }];
    if (self.viewChoiceBlock) {
        self.viewChoiceBlock(1);
    }
}

- (void)tap3choice{
    
    self.currentIndex = 2;
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.tapView3.frame = CGRectMake(0, 0, 115*3, self.frame.size.height);
        self.tapView2.frame = CGRectMake(0, 10, 115*2, 30);
        self.tapView1.frame = CGRectMake(0, 10, 115, 30);
        
        self.tapL3.frame = CGRectMake(115*2, 0, 115, self.tapView3.frame.size.height);
        self.tapL2.frame = CGRectMake(115, 0, 115, self.tapView2.frame.size.height);
        self.tapL1.frame = CGRectMake(0, 0, 115, self.tapView1.frame.size.height);
        
        self.tapL1.textColor = [UIColor whiteColor];
        self.tapL2.textColor = [UIColor whiteColor];
        self.tapL3.textColor = [UIColor blackColor];
        
        self.tapL1.font = FOURTHTEENTEXTFONTSIZE;
        self.tapL2.font = FOURTHTEENTEXTFONTSIZE;
        self.tapL3.font = XGSIXBoldFontSize;
        
        self.tapView1.image = UIImageNamed(@"pink115");
        self.tapView2.image = UIImageNamed(@"yellow230");
        self.tapView3.image = UIImageNamed(@"white345");
    } completion:^(BOOL finished) {
    }];
    
    if (self.viewChoiceBlock) {
        self.viewChoiceBlock(2);
    }
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    for (int i = 0; i < titles.count; i++) {
        if (i == 0) {
            self.tapL1.text = titles[0];
        }else if (i == 1){
            self.tapL2.text = titles[1];
        }else if (i == 2){
            self.tapL3.text = titles[2];
        }
    }
}

- (void)refreshButton:(NSInteger)tag{
    if (self.currentIndex == tag) {
        return;
    }
    self.currentIndex = tag;
    if (tag == 0) {
        [self tap1choice];
    }else if (tag == 1){
        [self tap2choice];
    }else{
        [self tap3choice];
    }
}

@end

//
//  NoticeNewCenterNavView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewCenterNavView.h"

#import "NoticeSCListViewController.h"

@implementation NoticeNewCenterNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
      
        
        UIButton *msgBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
        [msgBtn1 setBackgroundImage:UIImageNamed(@"msgClick_img") forState:UIControlStateNormal];
        [self addSubview:msgBtn1];
        [msgBtn1 addTarget:self action:@selector(msgClick1) forControlEvents:UIControlEventTouchUpInside];
        
        self.allNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24+17,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-2, 14, 14)];
        self.allNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.allNumL.layer.cornerRadius = 7;
        self.allNumL.layer.masksToBounds = YES;
        self.allNumL.textColor = [UIColor whiteColor];
        self.allNumL.font = [UIFont systemFontOfSize:9];
        self.allNumL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.allNumL];
        self.allNumL.hidden = YES;
    }
    return self;
}


- (void)msgClick1{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSCListViewController *ctl = [[NoticeSCListViewController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
}


@end

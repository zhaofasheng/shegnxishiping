//
//  NoticeCustumeNavView.m
//  NoticeXi
//
//  Created by li lei on 2021/8/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeCustumeNavView.h"

@implementation NoticeCustumeNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(40, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-80, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        self.titleL.font = XGTwentyBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleL];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(3, STATUS_BAR_HEIGHT,50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [backBtn setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
        [self addSubview:backBtn];
        self.backButton = backBtn;
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-3-50, STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)setNeedDetailButton:(BOOL)needDetailButton{
    _needDetailButton = needDetailButton;
    if (needDetailButton) {
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-GET_STRWIDTH(@"鲸币明细", 14, 20)-15, STATUS_BAR_HEIGHT, GET_STRWIDTH(@"鲸币明细", 14, 20), NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        label.textAlignment = NSTextAlignmentRight;
        label.userInteractionEnabled = YES;
        [self addSubview:label];
        self.rightL = label;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap)];
        [label addGestureRecognizer:tap];
    }
}

- (void)rightTap{
    if (self.rightTapBlock) {
        self.rightTapBlock(YES);
    }
}

@end

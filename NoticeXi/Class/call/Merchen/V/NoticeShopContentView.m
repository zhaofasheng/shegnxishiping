//
//  NoticeShopContentView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopContentView.h"
#import "NoticeShopMyWallectController.h"
#import "NoticeHasServeredController.h"
#import "NoticeBuyOrderListController.h"

@implementation NoticeShopContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FCFCFE"].CGColor,(__bridge id)[UIColor colorWithHexString:@"#F7F8FC"].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self.layer addSublayer:gradientLayer];
        
        [self setAllCorner:10];
        
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
        self.titleImageView.userInteractionEnabled = YES;
        [self addSubview:self.titleImageView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(38,12,frame.size.width-38, 21)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.titleL];
        
        self.dataL = [[UILabel alloc] initWithFrame:CGRectMake(0,50,frame.size.width, 26)];
        self.dataL.textAlignment = NSTextAlignmentCenter;
        self.dataL.text = @"0";
        self.dataL.font = XGTwentyBoldFontSize;
        self.dataL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.dataL];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTap)];
        [self addGestureRecognizer:tap1];
    }
    return self;
}

- (void)setType:(NSInteger)type{
    _type = type;

    NSString *imgName = @"";
    NSString *title = @"";
    if (type == 1) {
        imgName = @"Image_jyorderbtn";
        title = @"服务过的订单";
    }else if (type == 2){
        imgName = @"Image_jybuybtn";
        title = @"买过的记录";
    }else if (type == 3){
        imgName = @"Image_jywalletbtn";
        title = @"我的钱包";
    }
    self.titleImageView.image = UIImageNamed(imgName);
    self.titleL.text = title;
}

- (void)contentTap{
    if (self.type == 1) {
        NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (self.type == 2){
        NoticeBuyOrderListController *ctl = [[NoticeBuyOrderListController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (self.type == 3){
        NoticeShopMyWallectController *ctl = [[NoticeShopMyWallectController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

@end

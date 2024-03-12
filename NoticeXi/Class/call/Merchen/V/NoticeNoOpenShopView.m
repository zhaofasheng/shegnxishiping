//
//  NoticeNoOpenShopView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/6.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeNoOpenShopView.h"
#import "NoticeShopRuleController.h"
@implementation NoticeNoOpenShopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self setAllCorner:10];
 
        UIView *markView = [[UIView  alloc] initWithFrame:CGRectMake(10, 10, 40+GET_STRWIDTH(@"电话亭说明", 14, 20), 20)];
        markView.backgroundColor = self.backgroundColor;
        markView.userInteractionEnabled = YES;
        [self addSubview:markView];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(markTap)];
        [markView addGestureRecognizer:tap1];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        titleImageView.userInteractionEnabled = YES;
        titleImageView.image = UIImageNamed(@"openshopmark_img");
        [markView addSubview:titleImageView];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(20,0,GET_STRWIDTH(@"电话亭说明", 14, 20), 20)];
        titleL.font = FOURTHTEENTEXTFONTSIZE;
        titleL.text = @"电话亭说明";
        titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [markView addSubview:titleL];
        
        UIImageView *titleImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20+GET_STRWIDTH(@"电话亭说明", 14, 20), 0, 20, 20)];
        titleImageView1.userInteractionEnabled = YES;
        titleImageView1.image = UIImageNamed(@"Image_intodetail");
        [markView addSubview:titleImageView1];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 48,frame.size.width, 20)];
        self.titleL.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.hidden = YES;
        self.titleL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:self.titleL];
        
        self.suppleyButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width-122)/2, 40, 122, 40)];
        self.suppleyButton.hidden = YES;
        self.suppleyButton.titleLabel.font = XGSIXBoldFontSize;
        [self.suppleyButton setAllCorner:20];
        [self.suppleyButton addTarget:self action:@selector(supplyClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.suppleyButton];
    }
    return self;
}

- (void)supplyClick{
    if (self.supplyBlock) {
        self.supplyBlock(YES);
    }
}

//电话亭说明
- (void)markTap{
    NoticeShopRuleController *ctl = [[NoticeShopRuleController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}
@end

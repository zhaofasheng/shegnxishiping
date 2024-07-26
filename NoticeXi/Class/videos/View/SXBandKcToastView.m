//
//  SXBandKcToastView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBandKcToastView.h"
#import "CMUUIDManager.h"
@implementation SXBandKcToastView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.userInteractionEnabled = YES;

        UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 440)];
        contentView.image = UIImageNamed(@"sx_lockkc_img2");
        contentView.center = self.center;
        self.contentView = contentView;
        contentView.userInteractionEnabled = YES;
        [self addSubview:contentView];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(280-50, 0, 50, 50)];
        [closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
        [self.contentView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
              
        UIButton *knowBtn = [[UIButton  alloc] initWithFrame:CGRectMake(60, 440-48-30,160, 48)];
        [knowBtn setTitle:@"绑定账号" forState:UIControlStateNormal];
        [knowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        knowBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [knowBtn setAllCorner:24];
        knowBtn.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [self.contentView addSubview:knowBtn];
        [knowBtn addTarget:self action:@selector(toClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setCanString:(NSString *)canString{
    _canString = canString;
    
    if (canString) {
        UIImageView *canImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(26, 230, 16, 16)];
        canImageV.image = UIImageNamed(@"sx_canbinddkc_img");
        [self.contentView addSubview:canImageV];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(46, 228, self.contentView.frame.size.width-46, 20)];
        label.text = @"可绑定课程";
        label.font = XGFourthBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:label];
        
        CGFloat width = GET_STRWIDTH(canString, 14, 20);
        
        UIScrollView *scrollView = [[UIScrollView  alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(label.frame)+4, self.contentView.frame.size.width-30, 20)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(width, 20);
        
        UILabel *label1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        label1.text = canString;
        label1.font = FOURTHTEENTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [scrollView addSubview:label1];
    }
    
}

- (void)setNoCanString:(NSString *)noCanString{
    _noCanString = noCanString;
    
    if (noCanString) {
        UIImageView *canImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(26, 290, 16, 16)];
        canImageV.image = UIImageNamed(@"sx_nocanbinddkc_img");
        [self.contentView addSubview:canImageV];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(46, 288, self.contentView.frame.size.width-46, 20)];
        label.text = @"不可绑定的重复课程";
        label.font = XGFourthBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:label];
        
        CGFloat width = GET_STRWIDTH(noCanString, 14, 20);
        
        UIScrollView *scrollView = [[UIScrollView  alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(label.frame)+4, self.contentView.frame.size.width-30, 20)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(width, 0);
        
        UILabel *label1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        label1.text = noCanString;
        label1.font = FOURTHTEENTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [scrollView addSubview:label1];
    }
}

- (void)toClick{
    //获得UUID存入keyChain中
    NSUUID *UUID=[UIDevice currentDevice].identifierForVendor;
    NSString *uuid = [CMUUIDManager readUUID];
    
    if (uuid==nil) {
        [CMUUIDManager deleteUUID];
        [CMUUIDManager saveUUID:UUID.UUIDString];
        uuid = UUID.UUIDString;
    }
    if (uuid) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:uuid forKey:@"uuid"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"uuid/series/bind" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEBANGDINGKECHENG" object:nil];
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"绑定成功" message:@"相应的课程权益已转移至本账号" cancleBtn:@"知道了"];
                [alerView showXLAlertView];
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }
    [self cancelClick];
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)showInfoView{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.contentView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    }];
}



@end

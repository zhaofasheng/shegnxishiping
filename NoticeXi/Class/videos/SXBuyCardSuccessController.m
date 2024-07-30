//
//  SXBuyCardSuccessController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuyCardSuccessController.h"
#import "SXKcCardDetailController.h"
#import "SXStudyBaseController.h"
@interface SXBuyCardSuccessController ()
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusL;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *markL;
@end

@implementation SXBuyCardSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat width = GET_STRWIDTH(@"交易成功", 20, 28);
    
    self.statusImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-width-8-20)/2, 40+NAVIGATION_BAR_HEIGHT, 20, 20)];
    [self.view addSubview:self.statusImageView];
    self.statusImageView.image = self.payStatusModel.pay_status.intValue == 2 ? UIImageNamed(@"sxpaysuccess_img") : UIImageNamed(@"sxpayfail_img");
    
    self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusImageView.frame)+8,36+NAVIGATION_BAR_HEIGHT,width, 28)];
    self.statusL.font = [UIFont systemFontOfSize:20];
    self.statusL.textColor = [UIColor colorWithHexString:@"#14151A"];
    [self.view addSubview:self.statusL];
    self.statusL.text = self.payStatusModel.pay_status.intValue == 2 ?@"交易成功":@"交易失败";
 
    self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-168)/2, 88+NAVIGATION_BAR_HEIGHT, 168, 223)];
    [self.coverImageView setAllCorner:2];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    [self.view addSubview:self.coverImageView];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.paySearModel.simple_cover_url]];
    
    UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-218)/2, 292+NAVIGATION_BAR_HEIGHT, 218, 56)];
    markImageV.image = UIImageNamed(@"sx_buycardmark_img");
    [self.view addSubview:markImageV];
    
    if (self.payStatusModel.pay_status.intValue == 2) {
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(markImageV.frame)+9, DR_SCREEN_WIDTH, 20)];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.text = [NSString stringWithFormat:@"1张《%@》礼品卡可在「礼品卡查看」",self.paySearModel.series_name];
        [self.view addSubview:self.markL];
    }
    
    UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(68,CGRectGetMaxY(markImageV.frame)+100,DR_SCREEN_WIDTH-68*2, 56)];
    [button setAllCorner:28];
    button.backgroundColor = [UIColor colorWithHexString:self.payStatusModel.pay_status.intValue==2?@"#14151A" : @"#FF4B98"];
    [button setTitle:self.payStatusModel.pay_status.intValue==2?@"去赠送": @"重新购买" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)lookClick{
    if (self.payStatusModel.pay_status.intValue == 2) {
        SXKcCardDetailController *ctl = [[SXKcCardDetailController alloc] init];
        ctl.cardModel = self.orderModel.cardModel;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        
        if (self.reBuyBlock) {
            self.reBuyBlock(YES);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)backClick{
    if (self.payStatusModel.pay_status.intValue == 2) {
        __block UIViewController *pushVC;
        __weak typeof(self) weakSelf = self;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[SXStudyBaseController class]]) {//返回到指定界面
                pushVC = obj;
                [weakSelf.navigationController popToViewController:pushVC animated:YES];
                return ;
            }
        }];
        return;
    }
}

@end

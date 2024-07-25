//
//  SXBuyKcCardController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuyKcCardController.h"
#import "SXBuyKcCardHeaderView.h"
#import "SXBuyCardSuccessController.h"
@interface SXBuyKcCardController ()
@property (nonatomic, strong) SXBuyKcCardHeaderView *headerView;
@property (nonatomic, strong) NSString *ordersn;

@end

@implementation SXBuyKcCardController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:@"BUYCARDSEARISSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyFaild) name:@"BUYSEARISFAILD" object:nil];
    
    self.navBarView.titleL.text = @"课程礼品卡";
    
    self.headerView = [[SXBuyKcCardHeaderView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 0)];
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.paySearModel = self.paySearModel;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    NSString *str = @"实付 ¥";
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, GET_STRWIDTH(str, 13, 50), 50)];
    markL.font = THRETEENTEXTFONTSIZE;
    markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    markL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#FF68A3"] setLengthString:@"¥" beginSize:str.length-1];
    [backView addSubview:markL];
    
    UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL.frame), 0, 100, 50)];
    priceL.font = SXNUMBERFONT(22);
    priceL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
    priceL.text = self.paySearModel.price;
    [backView addSubview:priceL];
    
    UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-122, 5, 122, 40)];
    [button setAllCorner:20];
    button.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
    [button setTitle:@"去支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [backView addSubview:button];
    [button addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)buyClick{
    [self sureApplePay];
}

- (void)sureApplePay{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

    [parm setObject:self.paySearModel.seriesId forKey:@"seriesId"];
    [parm setObject:@"3" forKey:@"payType"];
    [parm setObject:@"2" forKey:@"platformId"];
    [parm setObject:@"1" forKeyedSubscript:@"isSeriesCard"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.isBuyCard = YES;
            SXOrderStatusModel *payModel = [SXOrderStatusModel mj_objectWithKeyValues:dict[@"data"]];
            self.ordersn = payModel.sn;
            payModel.productId = self.paySearModel.product_id;
            [appdel.payManager startSearisPay:payModel];
            
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }];
}


//购买成功通知
- (void)buySuccess{
    [self getOrderStatus];
}

- (void)buyFaild{
    [self getOrderStatus];
}

- (void)getOrderStatus{
    __weak typeof(self) weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"series/order/info?sn=%@",self.ordersn];
     [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
         if (success) {
        
             SXOrderStatusModel *payStatus = [SXOrderStatusModel mj_objectWithKeyValues:dict[@"data"]];
             if (payStatus.pay_status.intValue == 2) {//支付成功
                 if (self.buySuccessBlock) {
                     self.buySuccessBlock(self.paySearModel.seriesId);
                 }
             }
        
             SXBuyCardSuccessController *ctl = [[SXBuyCardSuccessController alloc] init];
             ctl.paySearModel = self.paySearModel;
             ctl.payStatusModel = payStatus;
             
             ctl.reBuyBlock = ^(BOOL buy) {
                 [weakSelf sureApplePay];
             };
             [self.navigationController pushViewController:ctl animated:YES];
         }
     } fail:^(NSError * _Nullable error) {

     }];
}
@end

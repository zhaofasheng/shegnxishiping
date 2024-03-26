//
//  SXBuySearisController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuySearisController.h"
#import "SXSureBuySearisView.h"
#import "SXBuySearisSuccessController.h"
#import "SXGoPayView.h"
#import "WXApi.h"
@interface SXBuySearisController ()
@property (nonatomic, strong) SXSureBuySearisView *headerView;
@property (nonatomic, strong) SXGoPayView *payView;
@property (nonatomic, strong) NSString *ordersn;
@end

@implementation SXBuySearisController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.titleL.text = @"确认下单";
    
    self.headerView = [[SXSureBuySearisView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:@"BUYSEARISSUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyFaild) name:@"BUYSEARISFAILD" object:nil];
    
}

//购买成功通知
- (void)buySuccess{
    [self getOrderStatus];
}

- (void)buyFaild{
    [self getOrderStatus];
 
}

- (void)getOrderStatus{
    NSString *url = [NSString stringWithFormat:@"series/order/info?sn=%@",self.ordersn];
     [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
         if (success) {
        
             SXWeiXinPayModel *payStatus = [SXWeiXinPayModel mj_objectWithKeyValues:dict[@"data"]];
             if (payStatus.pay_status.intValue == 2) {//支付成功
                 if (self.buySuccessBlock) {
                     self.buySuccessBlock(self.paySearModel.seriesId);
                 }
             }
             SXBuySearisSuccessController *ctl = [[SXBuySearisSuccessController alloc] init];
             ctl.paySearModel = self.paySearModel;
             ctl.payStatusModel = payStatus;
             [self.navigationController pushViewController:ctl animated:YES];
         }
     } fail:^(NSError * _Nullable error) {

     }];
}

- (void)buyClick{
    self.payView.money = self.paySearModel.price;
    [self.payView showPayView];

}

- (void)sureBuyweix{
    if (![WXApi isWXAppInstalled]) {
        [self showToastWithText:@"手机没有安装微信，无法使用微信支付"];
        return;
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    
    [parm setObject:self.paySearModel.seriesId forKey:@"seriesId"];
    [parm setObject:@"1" forKey:@"payType"];
    [parm setObject:@"2" forKey:@"platformId"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            SXWeiXinPayModel *payModel = [SXWeiXinPayModel mj_objectWithKeyValues:dict[@"data"]];
            self.ordersn = payModel.ordersn;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.payManager startWeixinPay:payModel];
            
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }];
}

- (void)sureBuyAli{
    // 调用canOpenURL方法判断设备是否安装了支付宝
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
        [self showToastWithText:@"手机没有安装支付宝，无法使用支付宝支付"];
        return;
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    
    [parm setObject:self.paySearModel.seriesId forKey:@"seriesId"];
    [parm setObject:@"2" forKey:@"payType"];
    [parm setObject:@"2" forKey:@"platformId"];
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopProductOrder" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            SXWeiXinPayModel *payModel = [SXWeiXinPayModel mj_objectWithKeyValues:dict[@"data"]];
            self.ordersn = payModel.ordersn;
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdel.payManager startAliPay:payModel];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"zb.creatfail"]];
    }];

}

- (SXGoPayView *)payView{
    if (!_payView) {
        _payView = [[SXGoPayView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _payView.surePayBlock = ^(BOOL isWeixinPay) {
            if (isWeixinPay) {
                [weakSelf sureBuyweix];
            }else{
                [weakSelf sureBuyAli];
            }
        };
    }
    return _payView;
}
@end

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
#import "NoticeLoginViewController.h"
#import "SXBuyVideoTools.h"

@interface SXBuySearisController ()
@property (nonatomic, strong) SXSureBuySearisView *headerView;
@property (nonatomic, strong) NSString *ordersn;
@property (nonatomic, assign) NSInteger hasBuyNum;
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
    
    
    if (self.videoArr.count) {
        //判断是否存在单集购买过的产品
        NSInteger hasBuyVideo = 0;
        for (SXSearisVideoListModel *videoM in self.videoArr) {

            if (videoM.unLock) {
                hasBuyVideo ++;
            }
        }
        self.hasBuyNum = hasBuyVideo;
        
        if (self.hasBuyNum > 0) {
            //需要买的数量，总价减去已经购买的价钱，除单价
            NSInteger needBuy = (self.paySearModel.price.intValue-(self.paySearModel.singlePrice.intValue*self.hasBuyNum))/self.paySearModel.singlePrice.intValue;
            
            priceL.text = [NSString stringWithFormat:@"%ld",needBuy*self.paySearModel.singlePrice.integerValue];
        }else{
            priceL.text = self.paySearModel.price;
        }
      
    }else{
        priceL.text = self.paySearModel.price;
    }

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
        
             SXOrderStatusModel *payStatus = [SXOrderStatusModel mj_objectWithKeyValues:dict[@"data"]];
             if (payStatus.pay_status.intValue == 2) {//支付成功
                 if (self.buySuccessBlock) {
                     self.buySuccessBlock(self.paySearModel.seriesId);
                 }
             }
             SXBuyVideoOrderList *orderM = [SXBuyVideoOrderList mj_objectWithKeyValues:dict[@"data"]];
             orderM.cardModel.searModel = orderM.paySearModel;
             SXBuySearisSuccessController *ctl = [[SXBuySearisSuccessController alloc] init];
             ctl.paySearModel = self.paySearModel;
             ctl.payStatusModel = payStatus;
             ctl.orderModel = orderM;
             [self.navigationController pushViewController:ctl animated:YES];
         }
     } fail:^(NSError * _Nullable error) {

     }];
}

- (void)buyClick{
    [self sureApplePay];
    
}

- (void)sureApplePay{
    __weak typeof(self) weakSelf = self;
    
    if (self.videoArr.count) {
 
        if (self.hasBuyNum > 0) {
            //需要买的数量，总价减去已经购买的价钱，除单价
            NSInteger needBuy = (self.paySearModel.price.intValue-(self.paySearModel.singlePrice.intValue*self.hasBuyNum))/self.paySearModel.singlePrice.intValue;
            
            [SXBuyVideoTools buyKSyvideoseriesId:self.paySearModel.seriesId product_id:[NSString stringWithFormat:@"%@x%ld",self.paySearModel.product_id,needBuy] money:[NSString stringWithFormat:@"%ld",(long)(needBuy*self.paySearModel.singlePrice.intValue)] getOrderBlock:^(SXOrderStatusModel * _Nonnull payModel) {
                weakSelf.ordersn = payModel.sn;
            }];
        }else{
            [SXBuyVideoTools buyKcseriesId:self.paySearModel.seriesId isSeriesCard:@"0" product_id:self.paySearModel.product_id getOrderBlock:^(SXOrderStatusModel * _Nonnull payModel) {
                weakSelf.ordersn = payModel.sn;
            }];
            
        }
        return;
    }
    
    [SXBuyVideoTools buyKcseriesId:self.paySearModel.seriesId isSeriesCard:@"0" product_id:self.paySearModel.product_id getOrderBlock:^(SXOrderStatusModel * _Nonnull payModel) {
        weakSelf.ordersn = payModel.sn;
    }];
    
}


@end

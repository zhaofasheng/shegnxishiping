//
//  SXHasBuyOrderListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasBuyOrderListController.h"
#import "SXHasBuyVideoOrderListCell.h"
#import "SXBuySearisSuccessController.h"
@interface SXHasBuyOrderListController ()

@end

@implementation SXHasBuyOrderListController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = self.isSuccess?@"已购记录": @"课程订单";
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[SXHasBuyVideoOrderListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 134;
    
    [self createRefesh];
    [self request];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXBuyVideoOrderList *model = self.dataArr[indexPath.row];
    SXOrderStatusModel *payStatusM = [[SXOrderStatusModel alloc] init];
    payStatusM.sn = model.sn;
    payStatusM.pay_time = model.pay_time;
    payStatusM.pay_status = model.pay_status;
    SXBuySearisSuccessController *ctl = [[SXBuySearisSuccessController alloc] init];
    ctl.paySearModel = model.paySearModel;
    ctl.payStatusModel = payStatusM;
    model.cardModel.searModel = model.paySearModel;
    ctl.orderModel = model;
    ctl.isFromList = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)createRefesh{
    
    __weak SXHasBuyOrderListController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [UIColor colorWithHexString:@"#b7b7b7"];
    header.lastUpdatedTimeLabel.textColor = [UIColor colorWithHexString:@"#b7b7b7"];
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl request];
    }];
}

- (void)request{
    
    NSString *url = @"";
    
    url = [NSString stringWithFormat:@"series/order/list?pageNo=%ld&payStatus=%@",self.pageNo,self.isSuccess?@"2":@"0"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown == YES) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                SXBuyVideoOrderList *model = [SXBuyVideoOrderList mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
    
         
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXHasBuyVideoOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.orderListM = self.dataArr[indexPath.row];
    return cell;
}

@end

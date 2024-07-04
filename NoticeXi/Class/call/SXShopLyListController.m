//
//  SXShopLyListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopLyListController.h"
#import "SXShopsliuyanCell.h"
#import "SXShoperChatToUseController.h"
#import "NoticeAction.h"

@interface SXShopLyListController ()<NoticeReceveMessageSendMessageDelegate>

@property (nonatomic, strong) NoticeOrderListModel *liuyanModel;

@end

@implementation SXShopLyListController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.tableView registerClass:[SXShopsliuyanCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 70;
    self.navBarView.titleL.text = @"店铺留言";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.socketManager.shopOrderlistDelegate = self;
}

- (void)didReceiveShopLiuyan:(NSDictionary *)message{
    
    NoticeAction *ifDelegate = [NoticeAction mj_objectWithKeyValues:message];
    NoticeOrderListModel *shopM = [NoticeOrderListModel mj_objectWithKeyValues:message[@"data"]];
    
    if ([ifDelegate.action isEqualToString:@"delete"]) {
        return;
    }
    
    BOOL already = NO;
    for (NoticeOrderListModel *orderModel in self.dataArr) {
        if ([orderModel.orderId isEqualToString:shopM.orderId]) {
            [self.dataArr removeObject:orderModel];
            [self.dataArr insertObject:shopM atIndex:0];
            [self.tableView reloadData];
            already = YES;
            break;
        }
    }
    if (!already) {
        [self.dataArr insertObject:shopM atIndex:0];
    }
}

- (void)refreshChatList{
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

- (void)createRefesh{
    
    __weak SXShopLyListController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl request];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShoperChatToUseController *ctl = [[SXShoperChatToUseController alloc] init];
    ctl.orderModel = self.dataArr[indexPath.row];
    ctl.isbuyer = YES;
    self.liuyanModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.liuyanModel) {
        [self refreshChatList];
    }
}

- (void)request{
    
    NSString *url = @"";
    
    url = [NSString stringWithFormat:@"orderComment/list/1?pageNo=%ld",self.pageNo];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                NoticeOrderListModel *shopM = [NoticeOrderListModel mj_objectWithKeyValues:dic];
           
                [self.dataArr addObject:shopM];
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
    SXShopsliuyanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.lyModel = self.dataArr[indexPath.row];
    return cell;
}
@end

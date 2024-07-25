//
//  SXKcCardListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcCardListController.h"
#import "SXKcCardDetailController.h"
#import "SXkcCardListCell.h"
@interface SXKcCardListController ()

@end

@implementation SXKcCardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
    self.navBarView.hidden = YES;
    
    [self.tableView registerClass:[SXkcCardListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 143;
    
    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
}


- (void)createRefesh{
    
    __weak SXKcCardListController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl request];
    }];
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
    
    url = [NSString stringWithFormat:@"series/gift/card/%@?pageNo=%ld",self.isGet?@"2":@"1",self.pageNo];
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
                SXKcCardListModel *model = [SXKcCardListModel mj_objectWithKeyValues:dic];
            
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKcCardDetailController *ctl = [[SXKcCardDetailController alloc] init];
    ctl.isGet = self.isGet;
    ctl.cardModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXkcCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isGet = self.isGet;
    cell.cardModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataArr.count) {
        [self.tableView reloadData];
    }
    
}

@end

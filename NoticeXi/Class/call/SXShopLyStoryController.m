//
//  SXShopLyStoryController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopLyStoryController.h"
#import "SXShopLyStoryCell.h"
#import "SXShoperChatToUseController.h"
@interface SXShopLyStoryController ()

@end

@implementation SXShopLyStoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = @"留言记录";
    
    [self.tableView registerClass:[SXShopLyStoryCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 117;
    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
}


- (void)createRefesh{
    
    __weak SXShopLyStoryController *ctl = self;

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

- (void)request{
    
    NSString *url = @"";
    
    url = [NSString stringWithFormat:@"orderComment/list/2?pageNo=%ld",self.pageNo];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeOrderListModel *model = self.dataArr[indexPath.row];
    if (model.is_black.boolValue) {
        [self showToastWithText:@"已被对方拉黑，无法留言"];
        return;
    }
    SXShoperChatToUseController *ctl = [[SXShoperChatToUseController alloc] init];
    ctl.orderModel = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopLyStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.lyModel = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
@end

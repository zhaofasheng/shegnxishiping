//
//  SXLikeShopListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXLikeShopListController.h"
#import "SXShopLikelistCell.h"
#import "NoticdShopDetailForUserController.h"
@interface SXLikeShopListController ()

@end

@implementation SXLikeShopListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = @"收藏的店铺";
    
    [self.tableView registerClass:[SXShopLikelistCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    [self createRefesh];
    
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
    
}


- (void)createRefesh{
    
    __weak SXLikeShopListController *ctl = self;

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
    
    url = [NSString stringWithFormat:@"shopCollection?pageNo=%ld",self.pageNo];
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
                NoticeMyShopModel *shopM = [NoticeMyShopModel mj_objectWithKeyValues:dic];
                if (GET_STRWIDTH(shopM.tale, 15, 20) > (DR_SCREEN_WIDTH-30-97-15)) {
                    shopM.taleLikeHeight = 42;
                }else{
                    shopM.taleLikeHeight = 20;
                }
                if (shopM.is_stop.intValue > 1) {
                    shopM.operate_status = @"1";
                }
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


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    __weak typeof(self) weakSelf = self;
    NoticeMyShopModel *shopM= self.dataArr[indexPath.row];
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"取消收藏" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
   
        
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:shopM.shopId forKey:@"shopId"];
        [parm setObject:@"2" forKey:@"type"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopCollection/collect" Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        } fail:^(NSError * _Nullable error) {
         
        }];
        
        [weakSelf.dataArr removeObject:shopM];
        [weakSelf.tableView reloadData];
        if (!weakSelf.dataArr.count) {
            weakSelf.tableView.tableFooterView = weakSelf.defaultL;
        }
    }];
    deleteAction.backgroundColor = [UIColor colorWithHexString:@"#EBB817"];
    
    UISwipeActionsConfiguration *Configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    Configuration.performsFirstActionWithFullSwipe = NO;
    return Configuration;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMyShopModel *shopM = self.dataArr[indexPath.row];
    if (shopM.status.intValue == 2 || shopM.status.intValue==3) {
        return 112;
    }
    return  (shopM.operate_status.intValue == 1 ? 83 : 145)+shopM.taleLikeHeight+8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopLikelistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.shopM = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeMyShopModel *shopM = self.dataArr[indexPath.row];
    if (shopM.is_stop.intValue == 1 || shopM.status.intValue >= 2) {
        [self showToastWithText:@"店铺已不存在"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
    ctl.shopModel = shopM;
    ctl.currentPlayIndex = indexPath.row;
    ctl.cancelLikeBolck = ^(NSString * _Nonnull shopId) {
        for (NoticeMyShopModel *model in weakSelf.dataArr) {
            if ([model.shopId isEqualToString:shopId]) {
                [weakSelf.dataArr removeObject:model];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}


@end

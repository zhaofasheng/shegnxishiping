//
//  NoticeJieYouGoodsComController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouGoodsComController.h"
#import "NoticeShopChatCommentCell.h"
#import "NoticeOrderComDetailController.h"
@interface NoticeJieYouGoodsComController ()

@end

@implementation NoticeJieYouGoodsComController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.hidden = NO;
    self.navBarView.titleL.text = @"评价";
    if (self.commentNum.intValue) {
        self.navBarView.titleL.text = [NSString stringWithFormat:@"评价%@",self.commentNum];
    }
    self.view.backgroundColor =  [UIColor whiteColor];
    [self.tableView registerClass:[NoticeShopChatCommentCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.isDown = YES;
    self.pageNo = 1;
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self createRefesh];
    
    [self request];
}


- (void)request{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"shopGoodsOrder/getShopComment/%@?type=1&pageNo=%ld",self.shopId,self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeShopCommentModel *model = [NoticeShopCommentModel mj_objectWithKeyValues:dic];
                if (!model.marks || model.marks.length <= 0) {
                    if(model.score.intValue == 1){
                        model.marks = @"Ta觉得太治愈了";
                    }else if (model.score.intValue == 2){
                        model.marks = @"Ta觉得还可以啦";
                    }else{
                        model.marks = @"Ta觉得不太行噢";
                    }
                }
                [self.dataArr addObject:model];

            }
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.defaultL;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)createRefesh{
 
    __weak NoticeJieYouGoodsComController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo  = 1;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.pageNo++;
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopCommentModel *model = self.dataArr[indexPath.row];
    if(self.isUserLookShop && [model.user_id isEqualToString:[NoticeTools getuserId]]){
        NoticeOrderComDetailController *ctl = [[NoticeOrderComDetailController alloc] init];
        ctl.orderId = model.order_id;
        ctl.goodsUrl = model.goods_img_url;
        ctl.isVoice = model.room_id.intValue?YES:NO;
        ctl.orderName = model.goods_name;
        ctl.time = model.order_created_at;
        ctl.second = model.second;
        ctl.needDelete = YES;
        __weak typeof(self) weakSelf = self;
        ctl.hasDeleteComBlock = ^(NSString * _Nonnull orderId) {
            for (NoticeShopCommentModel *deleM in weakSelf.dataArr) {
                if ([deleM.order_id isEqualToString:orderId]) {
                    [weakSelf.dataArr removeObject:deleM];
                    [weakSelf.tableView reloadData];
                    break;
                }
            }
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if(!self.isUserLookShop){
        NoticeOrderComDetailController *ctl = [[NoticeOrderComDetailController alloc] init];
        ctl.orderId = model.order_id;
        ctl.goodsUrl = model.goods_img_url;
        ctl.isVoice = model.room_id.intValue?YES:NO;
        ctl.orderName = model.goods_name;
        ctl.time = model.order_created_at;
        ctl.second = model.second;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)refresh{
    if(!self.dataArr.count){
        self.isDown = YES;
        self.pageNo = 1;
        [self request];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopChatCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isUserView = self.isUserLookShop;
    cell.commentModel = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeShopCommentModel *model = self.dataArr[indexPath.row];

    if(self.isUserLookShop){//别人看店铺的视角
        return model.marksHeight+60+15+8;
    }else{
        return model.marksHeight+(model.labelHeight>0?(model.labelHeight+8):0)+15+57+8;
    }
    
}


@end

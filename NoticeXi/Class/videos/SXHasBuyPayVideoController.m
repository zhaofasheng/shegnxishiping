//
//  SXHasBuyPayVideoController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasBuyPayVideoController.h"
#import "SXHasGetSearisListCell.h"
#import "SXPayVideoPlayDetailBaseController.h"
#import "NoticeLoginViewController.h"
#import "SXStudyBaseController.h"

@interface SXHasBuyPayVideoController ()<UIGestureRecognizerDelegate>

@end

@implementation SXHasBuyPayVideoController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = @"我的课程";
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    [self.tableView registerClass:[SXHasGetSearisListCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 178;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"NOTICEBANGDINGKECHENG" object:nil];
    [self createRefesh];
    [self request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcomZanNotice:) name:@"SXZANKCoNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)getcomZanNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *comid = nameDictionary[@"comId"];
    NSString *iszan = nameDictionary[@"is_zan"];
    NSString *zanNum = nameDictionary[@"zan_num"];
    
    for (SXPayForVideoModel *kcModel in self.dataArr) {
        if (kcModel.remarkModel) {
            if ([kcModel.remarkModel.comId isEqualToString:comid]) {
                kcModel.remarkModel.is_zan = iszan;
                kcModel.remarkModel.zan_num = zanNum;
            }
        }
    }
    [self.tableView reloadData];
}

- (void)refreshList{
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

- (void)createRefesh{
    
    __weak SXHasBuyPayVideoController *ctl = self;

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
    if (![NoticeTools getuserId] && ![SXTools getLocalToken]) {
        self.tableView.tableFooterView = self.defaultL;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    NSString *url = @"";
    url = [NSString stringWithFormat:@"user/video/series?pageNo=%ld",self.pageNo];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
            
            NSInteger num = 0;
            for (NSDictionary *dic in dict[@"data"]) {
                SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
                model.is_bought = @"1";
                [self.dataArr addObject:model];
                num++;
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

    SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
    SXPayForVideoModel *model = self.dataArr[indexPath.row];
    ctl.paySearModel = model;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)refreshModelTime:(SXSearisVideoListModel *)model seaModel:(SXPayForVideoModel *)searisModel{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:model.schedule?model.schedule:@"0" forKey:@"schedule"];
    [parm setObject:model.is_finished?model.is_finished:@"0" forKey:@"isFinished"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"video/play/%@",model.videoId] Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    for (SXSearisVideoListModel *videoM in searisModel.searisVideoList) {
        if ([videoM.videoId isEqualToString:model.videoId]) {
            videoM.schedule = model.schedule;
            videoM.is_finished = model.is_finished;
            break;
        }
    }

    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXHasGetSearisListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.refreshComBlock = ^(BOOL isAdd, SXKcComDetailModel * _Nonnull comModel) {
        [weakSelf refreshKcCom:isAdd com:comModel];
    };
    cell.deleteScoreBlock = ^(SXKcComDetailModel * _Nonnull comM) {
        [weakSelf refreshDelete:comM];
    };
    return cell;
}

- (void)refreshDelete:(SXKcComDetailModel *)comModel{
    for (SXPayForVideoModel *kcModel in self.dataArr) {
        if ([kcModel.seriesId isEqualToString:comModel.series_id]) {
            kcModel.kcComDetailModel = comModel;
        }
    }
    [self.tableView reloadData];
}

- (void)refreshKcCom:(BOOL)isAdd com:(SXKcComDetailModel *)comModel{
    for (SXPayForVideoModel *kcModel in self.dataArr) {
        if ([kcModel.seriesId isEqualToString:comModel.series_id]) {
            if (isAdd) {
                kcModel.kcComDetailModel = comModel;
            }else{
                kcModel.kcComDetailModel = nil;
            }
        }
    }
    [self.tableView reloadData];
}



@end

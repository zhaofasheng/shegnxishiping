//
//  SXPayVideoListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayVideoListController.h"
#import "SXSearisHeaderView.h"
#import "SXHasBuySearisListCell.h"
#import "SXNoBuySearisListCell.h"
#import "NoticeLoginViewController.h"
#import "SXPayVideoPlayDetailBaseController.h"
#import "SXBandKcToAccountView.h"
@interface SXPayVideoListController ()
@property (nonatomic, strong) SXSearisHeaderView *headerView;
@property (nonatomic, strong) UIView *footView;


@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@end

@implementation SXPayVideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.headerView = [[SXSearisHeaderView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableHeaderView = self.headerView;
    
    __weak typeof(self) weakSelf = self;
    self.headerView.choiceBeforeLookBlock = ^(NSString * _Nonnull videoName) {
        for (SXSearisVideoListModel *model in weakSelf.dataArr) {
            if ([model.title isEqualToString:videoName]) {
                [weakSelf gotoPlayView:model commentId:nil];
                break;
            }
        }
    };
    
    self.navBarView.hidden = YES;


    if (self.paySearModel.published_episodes.intValue < self.paySearModel.episodes.intValue) {
        self.tableView.tableFooterView = self.footView;
    }else{
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView registerClass:[SXNoBuySearisListCell class] forCellReuseIdentifier:@"noCell"];
    [self.tableView registerClass:[SXHasBuySearisListCell class] forCellReuseIdentifier:@"cell"];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshModelTimeNotice:) name:@"SXKCVIDEOREFRESHPLAYTIME" object:nil];

    [self refreshStatus];
    
    [self request];
}


- (void)request{
    
    NSString *url = @"";
    
    url = [NSString stringWithFormat:@"series/%@/video",self.paySearModel.seriesId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.dataArr removeAllObjects];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            for (NSDictionary *dic in dict[@"data"]) {
                SXSearisVideoListModel *model = [SXSearisVideoListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)gotoPlayViewWith:(NSString *)videoId commentId:(nonnull NSString *)commentId{
    for (SXSearisVideoListModel *videoM in self.dataArr) {
        if ([videoM.videoId isEqualToString:videoId]) {
            videoM.is_new = @"0";
            [self.tableView reloadData];
            [self gotoPlayView:videoM commentId:commentId];
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.paySearModel.hasBuy) {
        if (![NoticeTools getuserId]) {
            [self bandingWith:nil];
            return;
        }
        SXSearisVideoListModel *videoM = self.dataArr[indexPath.row];
        videoM.is_new = @"0";
        [self.tableView reloadData];
        [self gotoPlayView:videoM commentId:nil];
    }
}

- (void)bandingWith:(NoticeAreaModel *)areaModel{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"未绑定账号课程易丢失，请先登录账号后进行绑定" message:nil sureBtn:@"再想想" cancleBtn:@"登录注册" right:YES];
   alerView.resultIndex = ^(NSInteger index) {
       if (index == 2) {
           NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
           [weakSelf.navigationController pushViewController:ctl animated:YES];
       }
   };
   [alerView showXLAlertView];

}

- (void)gotoPlayView:(SXSearisVideoListModel *)model commentId:(NSString *)commentId{
    SXPayVideoPlayDetailBaseController *ctl = [[SXPayVideoPlayDetailBaseController alloc] init];
    if (commentId.intValue > 0) {
        ctl.commentId = commentId;
    }
    ctl.paySearModel = self.paySearModel;
    ctl.searisArr = self.dataArr;
    ctl.currentPlayModel = model;
    __weak typeof(self) weakSelf = self;
    ctl.refreshPlayTimeBlock = ^(SXSearisVideoListModel * _Nonnull currentModel) {
        [weakSelf refreshModelTime:currentModel];
    };
    ctl.deleteClickBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
        if (weakSelf.deleteClickBlock) {
            weakSelf.deleteClickBlock(commentM);
        }
    };
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}


- (void)refreshModelTimeNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *videoid = nameDictionary[@"videoId"];
    NSString *isFinished = nameDictionary[@"is_finished"];
    NSString *schedule = nameDictionary[@"schedule"];
    for (SXSearisVideoListModel *videoM in self.dataArr) {
        if ([videoM.videoId isEqualToString:videoid]) {
            videoM.schedule = schedule;
            videoM.is_finished = isFinished;
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)upTime:(SXSearisVideoListModel *)model{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:model.schedule?model.schedule:@"0" forKey:@"schedule"];
    [parm setObject:model.is_finished?model.is_finished:@"0" forKey:@"isFinished"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"video/play/%@",model.videoId] Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)refreshModelTime:(SXSearisVideoListModel *)model{
    

    [self upTime:model];
    
    for (SXSearisVideoListModel *videoM in self.dataArr) {
        if ([videoM.videoId isEqualToString:model.videoId]) {
            videoM.schedule = model.schedule;
            videoM.is_finished = model.is_finished;
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)refreshStatus{
    self.headerView.paySearModel = self.paySearModel;
    [self.headerView refresUI];
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-((self.paySearModel.buy_card_times.intValue || self.paySearModel.is_bought.boolValue)?0:TAB_BAR_HEIGHT));
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshStatus];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.paySearModel.hasBuy? 75 : 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.paySearModel.hasBuy) {
        
        SXHasBuySearisListCell *buyedCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        buyedCell.videoModel = self.dataArr[indexPath.row];
        
        [buyedCell.backView setCornerOnTop:0];
        [buyedCell.backView setCornerOnBottom:0];
        
        if (indexPath.row == (self.dataArr.count -1)) {
            [buyedCell.backView setCornerOnBottom:8];
        }
        if (indexPath.row == 0) {
            if (![SXTools getPayPlayLastsearisId:self.paySearModel.seriesId]) {
                [buyedCell.backView setCornerOnTop:8];
            }
        }
        
        return buyedCell;
    }else{
        SXNoBuySearisListCell *noCell = [tableView dequeueReusableCellWithIdentifier:@"noCell"];
        noCell.videoModel = self.dataArr[indexPath.row];
        [noCell.backView setCornerOnTop:0];
        [noCell.backView setCornerOnBottom:0];
        if (indexPath.row == (self.dataArr.count -1)) {
            [noCell.backView setCornerOnBottom:8];
        }
        if (indexPath.row == 0) {
            [noCell.backView setCornerOnTop:8];
        }
        return noCell;
    }
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 100)];
        _footView.backgroundColor = self.view.backgroundColor;
        FSCustomButton *btn = [[FSCustomButton alloc] initWithFrame:CGRectMake(0, 40, DR_SCREEN_WIDTH, 20)];
        [btn setImage:UIImageNamed(@"sxwaitmore_img") forState:UIControlStateNormal];
        [btn setTitle:@"  更多课程敬请期待" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        btn.titleLabel.font = XGSIXBoldFontSize;
        [_footView addSubview:btn];
    }
    return _footView;
}


- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

@end

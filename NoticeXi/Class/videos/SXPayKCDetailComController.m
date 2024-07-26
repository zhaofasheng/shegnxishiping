//
//  SXPayKCDetailComController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayKCDetailComController.h"
#import "SXVideoCommentJson.h"
#import "SXKCcomCell.h"
#import "SXBuyToastKcView.h"
@interface SXPayKCDetailComController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UILabel *defaultL1;
@property (nonatomic, strong) SXBuyToastKcView *buyView;
@property (nonatomic, strong) NSString *commentCount;
@end

@implementation SXPayKCDetailComController

- (SXBuyToastKcView *)buyView{
    if (!_buyView) {
        _buyView = [[SXBuyToastKcView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _buyView.buyBolokc = ^(BOOL buy) {
            if (weakSelf.buyBlock) {
                weakSelf.buyBlock(YES);
            }
        };
    }
    return _buyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    [self createRefesh];
    self.navBarView.hidden = YES;
    [self.tableView registerClass:[SXKCcomCell class] forCellReuseIdentifier:@"cell"];
    if (!self.dataArr.count) {
        [self request];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getlikeNotice:) name:@"COMMENTLIKENotification" object:nil];
    [self refreshStatus];
}

- (void)getlikeNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *comId = nameDictionary[@"commentId"];
    NSString *isLike = nameDictionary[@"is_like"];
    NSString *zanNum = nameDictionary[@"zan_num"];
    if (self.dataArr.count && comId.intValue) {
        for (SXVideoCommentModel *comM in self.dataArr) {
            if ([comM.commentId isEqualToString:comId]) {
                comM.is_like = isLike;
                comM.zan_num = zanNum;
                [self.tableView reloadData];
                break;
            }
        }
    }
}

- (void)deleteCommentWith:(NSString *)commentModel{
    for (int i = 0; i < self.dataArr.count; i++) {
        SXVideoCommentModel *oldM = self.dataArr[i];
        if ([oldM.commentId isEqualToString:commentModel]) {
            [self.dataArr removeObject:oldM];
            [self.tableView reloadData];
            
            if (self.commentCount.intValue > 0) {
                if (self.refreshCommentCountBlock) {
                    self.refreshCommentCountBlock([NSString stringWithFormat:@"%d",self.commentCount.intValue-1]);
                }
            }else{
                if (self.refreshCommentCountBlock) {
                    self.refreshCommentCountBlock(@"0");
                }
            }
            break;
        }
    }
}

- (void)setPaySearModel:(SXPayForVideoModel *)paySearModel{
    _paySearModel = paySearModel;
    if (!self.dataArr.count) {
        self.pageNo = 1;
        self.isDown = YES;
        [self request];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoCommentModel *model = self.dataArr[indexPath.row];
    if (!self.paySearModel.is_bought.boolValue) {
        NSString *price = [NSString stringWithFormat:@"¥%@",self.paySearModel.price];
        NSString *title = [NSString stringWithFormat:@"%@ 解锁",price];
        [self.buyView.buyButton setAttributedTitle:[DDHAttributedMode setJiaCuString:title setSize:19 setColor:[UIColor whiteColor] setLengthString:price beginSize:0] forState:UIControlStateNormal];
        [self.buyView showInfoView];
        return;
    }
    if (self.clickVideoIdBlock) {
        self.clickVideoIdBlock(model.video_id,model.commentId);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoCommentModel *model = self.dataArr[indexPath.row];
    if (!self.paySearModel.is_bought.boolValue) {
        if (model.isMoreFiveLines) {
            return model.fiveTextHeight + 102;
        }
    }
    return model.firstContentHeight + 102;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKCcomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.hasBuy = self.paySearModel.is_bought.boolValue;
    cell.comModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.clickVideoIdBlock = ^(NSString * _Nonnull videoId) {
        if (weakSelf.clickVideoIdBlock) {
            weakSelf.clickVideoIdBlock(videoId,@"0");
        }
    };
    return cell;
}

- (void)createRefesh{
    
    __weak SXPayKCDetailComController *ctl = self;

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
    if (![NoticeTools getuserId]) {
        self.tableView.tableFooterView = self.defaultL1;
        _defaultL1.text = @"登录声昔账号之后才能跟用户互动哦~";
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    NSString *url = @"";
    
    url = [NSString stringWithFormat:@"videoComment/%@?pageNo=%ld",self.paySearModel.seriesId,self.pageNo];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            SXVideoCommentJson *jsonModel = [SXVideoCommentJson mj_objectWithKeyValues:dict[@"data"]];
            if (jsonModel.list.count) {
                for (NSDictionary *dic in jsonModel.list) {//普通列表
                    SXVideoCommentModel *commentM = [SXVideoCommentModel mj_objectWithKeyValues:dic];
                    if (commentM.comment_type.intValue > 1) {
                        commentM.content = @"请更新到最新版本";
                    }
                    
                    if (self.pageNo == 1) {
                        BOOL hasSave = NO;
                        for (SXVideoCommentModel *oldm in self.dataArr) {//去重
                            if ([oldm.commentId isEqualToString:commentM.commentId]) {
                                hasSave = YES;
                                break;
                            }
                        }
                        
                        if (!hasSave) {
                            [self.dataArr addObject:commentM];
                        }
                    }else{
                        [self.dataArr addObject:commentM];
                    }
                    
                    
                }
                if (self.pageNo == 1) {
                    self.commentCount = jsonModel.commentCt;
                    if (self.refreshCommentCountBlock) {
                        self.refreshCommentCountBlock(jsonModel.commentCt);
                    }
                }
            }
        
            self.tableView.tableFooterView = self.dataArr.count?nil:self.defaultL1;
            _defaultL1.text = @"还没有评论，发条评论抢占第一";
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)refreshStatus{
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-(self.paySearModel.is_bought.boolValue?0:TAB_BAR_HEIGHT));
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshStatus];
    if (!self.dataArr.count) {
        self.pageNo = 1;
        self.isDown = YES;
        [self request];
    }
}

- (UILabel *)defaultL1{
    if (!_defaultL1) {
        _defaultL1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-40-TAB_BAR_HEIGHT-(DR_SCREEN_WIDTH*9/16)-100)];
        _defaultL1.text = @"还没有评论，发条评论抢占第一";
        _defaultL1.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL1.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _defaultL1.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultL1;
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

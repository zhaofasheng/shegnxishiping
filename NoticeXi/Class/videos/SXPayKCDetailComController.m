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
@interface SXPayKCDetailComController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UILabel *defaultL1;
@end

@implementation SXPayKCDetailComController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    [self createRefesh];
    self.navBarView.hidden = YES;
    [self.tableView registerClass:[SXKCcomCell class] forCellReuseIdentifier:@"cell"];
    [self request];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoCommentModel *model = self.dataArr[indexPath.row];
    return model.firstContentHeight + 92;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKCcomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.hasBuy = self.paySearModel.is_bought.boolValue;
    cell.comModel = self.dataArr[indexPath.row];
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
                    [self.dataArr addObject:commentM];
                }
                if (self.pageNo == 1) {
                    if (self.refreshCommentCountBlock) {
                        self.refreshCommentCountBlock(jsonModel.commentCt);
                    }
                }
            }
        
            self.tableView.tableFooterView = self.dataArr.count?nil:self.defaultL1;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)refreshStatus{
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-(self.paySearModel.is_bought.boolValue?0:TAB_BAR_HEIGHT-10));
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
        _defaultL1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-40-TAB_BAR_HEIGHT-(DR_SCREEN_WIDTH*9/16))];
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

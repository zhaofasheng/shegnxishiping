//
//  SXVideoCommentMeassageController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCommentMeassageController.h"
#import "SXVideoBeReplyComCell.h"
#import "SXPlayFullListController.h"
@interface SXVideoCommentMeassageController ()

@end

@implementation SXVideoCommentMeassageController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[SXVideoBeReplyComCell class] forCellReuseIdentifier:@"cell"];
    self.navBarView.titleL.text = @"评论消息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = self.view.backgroundColor;

    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoCommentBeModel *model = self.dataArr[indexPath.row];
    if (model.sysStatus.intValue == 3) {
        [self showToastWithText:@"该内容已删除"];
        return;
    }
    SXPlayFullListController *ctl = [[SXPlayFullListController alloc] init];
    ctl.commentId = model.commentId;
    ctl.replyId = model.replyId;
    ctl.needPopCom = YES;
    ctl.modelArray = [NSMutableArray arrayWithArray:@[model.videoModel]];
    ctl.currentPlayIndex = 0;
    ctl.noRequest = YES;
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoCommentBeModel *model = self.dataArr[indexPath.row];
    if (model.sysStatus.intValue != 1) {
        return 108;
    }
    CGFloat height = 108;
    if (model.replyContent) {
        height = 88+model.replytHeight;
    }else{
        height = 88+model.commentHeight;
    }
    if (height < 108) {
        height = 108;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoBeReplyComCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.likeComM = self.dataArr[indexPath.row];
    return cell;
}

- (void)createRefesh{
    
    __weak SXVideoCommentMeassageController *ctl = self;

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
    
    url = [NSString stringWithFormat:@"messages/%@/2?pageNo=%ld",[NoticeTools getuserId],self.pageNo];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                SXVideoCommentBeModel *model = [SXVideoCommentBeModel mj_objectWithKeyValues:dic];
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


@end

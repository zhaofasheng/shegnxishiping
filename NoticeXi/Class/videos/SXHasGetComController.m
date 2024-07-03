//
//  SXHasGetComController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/3.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasGetComController.h"
#import "SXHasGetComCell.h"
#import "SXPayVideoPlayDetailBaseController.h"
@interface SXHasGetComController ()

@end

@implementation SXHasGetComController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navBarView.titleL.text = @"课程评论";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self.tableView registerClass:[SXHasGetComCell class] forCellReuseIdentifier:@"cell"];

    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXHasGetComCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.likeComM = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.goVideoBlock = ^(SXVideoCommentBeModel * _Nonnull comM) {
        [weakSelf requestSearise:comM.videoModel.series_id commentId:nil replyId:nil videoId:comM.videoModel.vid];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoCommentBeModel *model = self.dataArr[indexPath.row];
    if (model.sysStatus.intValue != 1) {
        return 168;
    }
    CGFloat height = 168;
    if (model.replyContent) {
        height = 148+model.replytHeight;
    }else{
        height = 148+model.commentHeight;
    }
    if (height < 168) {
        height = 168;
    }
    return height;
}

- (void)createRefesh{
    
    __weak SXHasGetComController *ctl = self;

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
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                self.marksL.text = @"购买课程后解锁相关消息";
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)requestSearise:(NSString *)searisId commentId:(NSString *)commentId replyId:(NSString *)replyId videoId:(NSString *)videoId{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",searisId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
            if (!searismodel) {
                return;
            }
            [self getVideosSearise:searismodel commentId:commentId replyId:replyId videoId:videoId];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)getVideosSearise:(SXPayForVideoModel *)searModel commentId:(NSString *)commentId replyId:(NSString *)replyId videoId:(NSString *)videoId{
    
    
    NSString *url = @"";
    
    [self showHUD];
    url = [NSString stringWithFormat:@"series/%@/video",searModel.seriesId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
      
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            NSMutableArray *videoList = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dict[@"data"]) {
                SXSearisVideoListModel *model = [SXSearisVideoListModel mj_objectWithKeyValues:dic];
                if (model.screen.intValue == 2) {
                    model.screen = @"1";
                }
                [videoList addObject:model];
            }
         
            if (videoList.count) {
                for (SXSearisVideoListModel *video in videoList) {
                    if ([video.videoId isEqualToString:videoId]) {
                        SXPayVideoPlayDetailBaseController *ctl = [[SXPayVideoPlayDetailBaseController alloc] init];
                        if (commentId.intValue > 0) {
                            ctl.commentId = commentId;
                        }
                        if (replyId.intValue > 0) {
                            ctl.replyId = replyId;
                        }
                        ctl.paySearModel = searModel;
                        ctl.searisArr = videoList;
                        ctl.currentPlayModel = video;

                        CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                                        withSubType:kCATransitionFromLeft
                                                                                           duration:0.3f
                                                                                     timingFunction:kCAMediaTimingFunctionLinear
                                                                                               view:self.navigationController.view];
                        [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
                        [self.navigationController pushViewController:ctl animated:NO];
                        break;
                    }
                }
                
          
            }
        }
        [self hideHUD];
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXVideoCommentBeModel *model = self.dataArr[indexPath.row];
    [self requestSearise:model.videoModel.series_id commentId:model.commentId replyId:model.replyId videoId:model.videoModel.vid];
}

@end

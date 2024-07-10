//
//  SXVideoCommentJubaoController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCommentJubaoController.h"
#import "MyCommentCell.h"
#import "SXVideoCmmentFirstCell.h"
#import "SXVideoCommentMoreView.h"
#import "SXPlayFullListController.h"
#import "SXPayVideoPlayDetailBaseController.h"
static NSString *const commentCellIdentifier = @"commentCellIdentifier";
@interface SXVideoCommentJubaoController ()
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation SXVideoCommentJubaoController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = self.videoM.series_id.intValue?@"被举报的课程评论": @"被举报的视频评论";
    
    [self.tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:commentCellIdentifier];
    [self.tableView registerClass:[SXVideoCmmentFirstCell class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    
    SXVideoCommentModel *commentM = self.reoceArr[0];
    if (commentM.firstReplyModel) {
        [commentM.replyArr addObject:commentM.firstReplyModel];
    }
    [self.tableView reloadData];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tableView.frame), 120, 40)];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"查看视频" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickFun) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-135, CGRectGetMaxY(self.tableView.frame), 120, 40)];
    button1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitle:@"删除" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(deleteFun) forControlEvents:UIControlEventTouchUpInside];
    SXVideoCommentModel *commentM1 = self.jubArr[0];
    if (commentM1.comment_status.intValue > 1) {
        [button1 setTitle:@"已删除" forState:UIControlStateNormal];
    }
    self.deleteBtn = button1;
    [self.view addSubview:button1];
}

- (void)deleteFun{
    SXVideoCommentModel *commentM = self.jubArr[0];
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定删除吗？" message:@"该内容下的回复内容也会被删除" sureBtn:@"取消" cancleBtn:@"删除" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:self.managerCode forKey:@"confirmPasswd"];
            [parm setObject:@"5" forKey:@"reportStatus"];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/reports/%@",self.jubaoId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    commentM.comment_status = @"3";
                    [weakSelf.deleteBtn setTitle:@"已删除" forState:UIControlStateNormal];
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
    
        }
    };
    [alerView showXLAlertView];
}

- (void)clickFun{
    if (self.videoM.series_id.intValue) {
        [[NoticeTools getTopViewController] showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",self.videoM.series_id] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return;
                }
                SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
                if (!searismodel) {
                    return;
                }
                [self getVideosSearise:searismodel commentId:nil replyId:nil videoId:self.videoM.vid];
            }
            
        } fail:^(NSError *error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
        return;
    }
    
    SXPlayFullListController *ctl = [[SXPlayFullListController alloc] init];
    ctl.modelArray = [NSMutableArray arrayWithArray:@[self.videoM]];
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


//获取更多回复
- (void)requestMoreReply:(SXVideoCommentModel *)commentM{
    
    if (commentM.hasGetMore) {//已经获取过更多回复，直接显示即可
        commentM.isOpen = YES;
        [self.tableView reloadData];
        return;
    }
    
    [[NoticeTools getTopViewController] showHUD];
    
    NSString *url = [NSString stringWithFormat:@"videoCommont/moreReply?parentId=%@",commentM.commentId];
  
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            for (SXVideoCommentModel *alreadM in commentM.replyArr) {//所有回复数据添加存在的数据
                [commentM.moreReplyArr addObject:alreadM];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXVideoCommentModel *replyM = [SXVideoCommentModel mj_objectWithKeyValues:dic];
                if (replyM.comment_type.intValue > 1) {
                    replyM.content = @"请更新到最新版本";
                }
                BOOL hasSave = NO;
                for (SXVideoCommentModel *oldm in commentM.moreReplyArr) {//去重
                    if ([oldm.commentId isEqualToString:replyM.commentId]) {
                        hasSave = YES;
                        break;
                    }
                }
                
                if (!hasSave) {
                    [commentM.moreReplyArr addObject: replyM];
                }
            }
            commentM.hasGetMore = YES;
            commentM.isOpen = YES;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

#pragma mark - UITableViewDataSource && UITableVideDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }
    SXVideoCommentModel *commentM = self.reoceArr[0];
    if (commentM.reply_ctnum.intValue) {
        return 34;
    }
    return 0;
}

//展开更多或者收起更多回复
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 60)];
        label.text = @"原评论";
        label.font = XGSIXBoldFontSize;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        return label;
    }
    SXVideoCommentMoreView *moreView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footView"];
    moreView.commentM = self.reoceArr[0];
    __weak typeof(self) weakSelf = self;
    moreView.moreCommentBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
        [weakSelf requestMoreReply:commentM];
    };
    moreView.closeCommentBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
        commentM.isOpen = NO;
        [weakSelf.tableView reloadData];
    };
    return moreView;
}


//一级评论列表
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        SXVideoCmmentFirstCell *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        headV.commentM = self.jubArr[0];
        return headV;
    }
    SXVideoCmmentFirstCell *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.commentM = self.reoceArr[0];

    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        SXVideoCommentModel *commentM = self.jubArr[0];
        return [self getFirstCommentHeight:commentM];
    }
    SXVideoCommentModel *commentM = self.reoceArr[0];
    return [self getFirstCommentHeight:commentM];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    SXVideoCommentModel *commentM = self.reoceArr[0];
    if (commentM.replyArr.count) {//存在回复数据
        if (commentM.isOpen) {//展开更多的时候查看全部回复
            return commentM.moreReplyArr.count;
        }else{//非查看更多的时候只显示1个回复
            return commentM.replyArr.count;
        }
    }
    return 0;
}

//二级评论或者回复
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    SXVideoCommentModel *commentM = self.reoceArr[0];
    if (commentM.isOpen) {
        cell.commentM =  commentM.moreReplyArr[indexPath.row];
    }else{
        cell.commentM =  commentM.replyArr[indexPath.row];
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SXVideoCommentModel *commentM = self.reoceArr[0];
    if (commentM.isOpen) {
        return [self getTwoCommentHeight:commentM.moreReplyArr[indexPath.row]];
    }
    return [self getTwoCommentHeight:commentM.replyArr[indexPath.row]];
}

- (CGFloat)getFirstCommentHeight:(SXVideoCommentModel *)commentModel{
    
    return 31 + 22 + (NSInteger)commentModel.firstContentHeight + ((commentModel.author_reply.boolValue || commentModel.author_zan.boolValue) ? 21 : 0)+5;
}

- (CGFloat)getTwoCommentHeight:(SXVideoCommentModel *)commentModel{
    return 30 + 22 + (NSInteger)commentModel.secondContentHeight+5;
}


@end

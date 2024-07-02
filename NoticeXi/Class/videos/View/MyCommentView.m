//
//  MyCommnetView.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "MyCommentView.h"
#import "MyCommentCell.h"
#import "SXVideoCmmentFirstCell.h"
#import "SXVideoCommentJson.h"
#import "SXVideoCommentMoreView.h"
#import "YYPersonItem.h"
#import "SXStudyBaseController.h"
#import "Masonry.h"
static NSString *const commentCellIdentifier = @"commentCellIdentifier";

@interface MyCommentView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) NSString *currentComCount;
@property (nonatomic, strong) SXVideoCommentModel *currentTopModel;//当前置顶的评论
@end

@implementation MyCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView {
    self.backgroundColor = [UIColor whiteColor];
    
    self.pageNo = 1;
    self.isDown = YES;
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
    self.closeBtn = closeBtn;
    [self.closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeComment) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-100, 50)];
    label.text = @"评论";
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.font = XGTwentyBoldFontSize;
    [self addSubview:label];
    self.titleL = label;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, DR_SCREEN_WIDTH, self.frame.size.height-50-TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];

    [self addSubview:tableView];

    
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:commentCellIdentifier];
    [tableView registerClass:[SXVideoCmmentFirstCell class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    [tableView registerClass:[SXVideoCommentMoreView class] forHeaderFooterViewReuseIdentifier:@"footView"];
    self.tableView.tableFooterView = [[UIView  alloc] initWithFrame:CGRectZero];
    
    [self createRefesh];
    [self requestCom];
    
    self.inputView = [[SXVideoComInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-44, DR_SCREEN_WIDTH, 50+44)];
    self.inputView.delegate = self;
    self.inputView.limitNum = 500;
    self.inputView.plaStr = @"成为第一条评论…";
    self.inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    
    self.markView = [[UIView  alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.tableView.frame)+5,DR_SCREEN_WIDTH-30, 40)];
    self.markView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.markView.layer.cornerRadius = 20;
    self.markView.layer.masksToBounds = YES;
    [self addSubview:self.markView];
    self.markView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendComClick)];
    [self.markView addGestureRecognizer:tap2];
    
    self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 0, 180, 40)];
    self.markL.font = FIFTHTEENTEXTFONTSIZE;
    self.markL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    self.markL.text = @"成为第一条评论…";
    [self.markView addSubview:self.markL];
}

- (void)sendComClick{
    self.inputView.plaStr = self.markL.text;
    [self.inputView showJustComment:nil];
}

- (void)refresUI{
    self.tableView.frame = CGRectMake(0, 50, DR_SCREEN_WIDTH, self.frame.size.height-50-TAB_BAR_HEIGHT);
    self.markView.frame = CGRectMake(15,CGRectGetMaxY(self.tableView.frame)+5,DR_SCREEN_WIDTH-30, 40);
}

- (void)setUpInput:(BOOL)upInput{
    _upInput = upInput;
    if (upInput) {
        self.inputView.plaStr = self.markL.text;
        [self.inputView showJustComment:nil];
    }
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    self.inputView.saveKey = [NSString stringWithFormat:@"videoLy%@%@",[NoticeTools getuserId],videoModel.vid];
    self.markL.text = videoModel.commentCt.intValue?@"说说我的想法...":@"成为第一条评论…";
    self.titleL.text = [NSString stringWithFormat:@"评论%@",videoModel.commentCt.intValue?videoModel.commentCt:@""];
    self.pageNo = 1;
    self.isDown = YES;
    [self requestCom];
}

//发送评论或者回复
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId linkArr:(nonnull NSMutableArray *)linkArr{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:comment forKey:@"content"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (YYPersonItem *item in linkArr) {
        if (item.user_id && item.name) {
            NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
            [parm1 setObject:item.user_id forKey:@"id"];
            [parm1 setObject:item.name forKey:@"name"];
            [arr addObject:parm1];
        }
    }
    
    if (arr.count) {
        [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"toSeries"];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoCommont/%@/%@",self.videoModel.vid,commentId.intValue?commentId:@"0"] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.tableView.tableFooterView = nil;
            
            self.currentComCount = [NSString stringWithFormat:@"%d",self.currentComCount.intValue+1];
            if (self.refreshCommentCountBlock) {
                self.refreshCommentCountBlock(self.currentComCount);
            }
            self.titleL.text = [NSString stringWithFormat:@"评论%@",self.currentComCount];
            
            SXVideoCommentModel *commentM = [SXVideoCommentModel mj_objectWithKeyValues:dict[@"data"]];
            if (commentM.commentId) {//评论成功且返回了数据
                if (commentM.parent_id.intValue > 0) {//属于回复
                    
                    for (SXVideoCommentModel *parModel in self.dataArr) {//从一级评论寻找当前回复的一级评论
                        
                        if ([parModel.commentId isEqualToString:commentM.parent_id]) {
                            if ([commentM.parent_id isEqualToString:commentM.post_id]) {//属于回复一级评论，直接置顶显示即可
                                [parModel.replyArr insertObject:commentM atIndex:0];
                                if (parModel.moreReplyArr.count) {
                                    [parModel.moreReplyArr insertObject:commentM atIndex:0];
                                }
                            }else{//属于回复别人的回复，那么位置放置在被回复的数据下面
                                for (int i = 0; i < parModel.replyArr.count;i++) {//从父类的二级评论数据找到下标位置
                                    SXVideoCommentModel *beReplyModel = parModel.replyArr[i];
                                    if ([beReplyModel.commentId isEqualToString:commentM.post_id]) {//找到被回复的是哪一条
                                        [parModel.replyArr insertObject:commentM atIndex:i+1];
                                    }
                                }
                                
                                if (parModel.moreReplyArr.count) {
                                    for (int i = 0; i < parModel.moreReplyArr.count;i++) {//从父类的二级评论数据找到下标位置
                                        SXVideoCommentModel *beReplyModel = parModel.moreReplyArr[i];
                                        if ([beReplyModel.commentId isEqualToString:commentM.post_id]) {//找到被回复的是哪一条
                                            [parModel.moreReplyArr insertObject:commentM atIndex:i+1];
                                        }
                                    }
                                }
                            }
                            break;
                        }
                    }
                }else{//属于评论
                    [self.dataArr insertObject:commentM atIndex:0];
                    if (self.dataArr.count > 1) {
                        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
                    }
                }
                [self.tableView reloadData];
                [[NoticeTools getTopViewController] showToastWithText:@"发送成功"];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)createRefesh{
    
    __weak MyCommentView *ctl = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl requestCom];
    }];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)requestCom{
    NSString *url = @"";
    if (!self.videoModel) {
        return;
    }
    if (self.needPopCom && self.type.intValue == 2 && (self.commentId.intValue || self.replyId.intValue)) {
        url = [NSString stringWithFormat:@"videoCommont/%@/%@?commentId=%@&replyId=%@&pageNo=%ld",self.videoModel.vid,self.type,self.commentId.intValue?self.commentId:@"0",self.replyId.intValue?self.replyId:@"0",self.pageNo];
    }else{
        url = [NSString stringWithFormat:@"videoCommont/%@/%@?commentId=%@&replyId=%@&pageNo=%ld",self.videoModel.vid,self.type,@"0",@"0",self.pageNo];
    }
  
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
    
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
            
            if (self.type.intValue == 2) {
                if (jsonModel.topList) {
                    SXVideoCommentModel *topCommentModel = [SXVideoCommentModel mj_objectWithKeyValues:jsonModel.topList];
                    if (topCommentModel.top_at.intValue) {
                        self.currentTopModel = topCommentModel;
                    }
                    if (topCommentModel.firstCommentModel) {
                        [topCommentModel.replyArr addObject:topCommentModel.firstCommentModel];
                    }
                    if (topCommentModel.firstReplyModel) {//如果存在第一条回复数据
                        [topCommentModel.replyArr addObject:topCommentModel.firstReplyModel];
                    }
                    if (topCommentModel.comment_type.intValue > 1) {
                        topCommentModel.content = @"请更新到最新版本";
                    }
                    [self.dataArr addObject:topCommentModel];
                }
            }
            
            if (jsonModel.list.count) {
                for (NSDictionary *dic in jsonModel.list) {//普通列表
                    SXVideoCommentModel *commentM = [SXVideoCommentModel mj_objectWithKeyValues:dic];
                
                    if (commentM.comment_type.intValue > 1) {
                        commentM.content = @"请更新到最新版本";
                    }
                    if (commentM.top_at.intValue) {
                        self.currentTopModel = commentM;
                    }
                    if (commentM.firstReplyModel) {//如果存在第一条回复数据
                        [commentM.replyArr addObject:commentM.firstReplyModel];
                    }
                    [self.dataArr addObject:commentM];
                }
                if (self.pageNo == 1) {
                    self.markL.text = jsonModel.commentCt.intValue?@"说说我的想法...":@"成为第一条评论…";
                    self.titleL.text = [NSString stringWithFormat:@"评论%@",jsonModel.commentCt.intValue?jsonModel.commentCt:@""];
                    self.currentComCount = jsonModel.commentCt;
                    if (self.refreshCommentCountBlock) {
                        self.refreshCommentCountBlock(jsonModel.commentCt);
                    }
                }
            }
            if (!self.dataArr.count) {
                self.titleL.text = @"评论";
                if (self.refreshCommentCountBlock) {
                    self.refreshCommentCountBlock(@"0");
                }
            }
            self.tableView.tableFooterView = self.dataArr.count?nil:self.defaultL;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
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

//收起
- (void)closeComment {
    if([self.delegate respondsToSelector:@selector(closeComment)]) {
        [self.delegate closeComment];
    }
}

#pragma mark - UITableViewDataSource && UITableVideDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SXVideoCommentModel *commentM = self.dataArr[section];
    if (commentM.reply_ctnum.intValue) {
        return 34;
    }
    return 0;
}

//展开更多或者收起更多回复
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SXVideoCommentMoreView *moreView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footView"];
    moreView.commentM = self.dataArr[section];
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

    SXVideoCmmentFirstCell *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.videoUser = self.videoUser;
    headV.commentM = self.dataArr[section];
    __weak typeof(self) weakSelf = self;
    headV.replyClickBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
        weakSelf.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",commentM.fromUserInfo.nick_name];
        [weakSelf.inputView showJustComment:commentM.commentId];
    };
    
    headV.topClickBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
  
        if (![self.currentTopModel.commentId isEqualToString:commentM.commentId]) {//如果被操作的不是当前已经置顶的评论
            self.currentTopModel.top_at = @"0";
        }
        for (int i = 0; i < weakSelf.dataArr.count; i++) {
            SXVideoCommentModel *oldM = weakSelf.dataArr[i];
            if ([oldM.commentId isEqualToString:commentM.commentId]) {
                if (commentM.top_at.intValue) {
                    [weakSelf.dataArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                }
                self.currentTopModel = commentM;
                if (self.dataArr.count > 1) {
                    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
                }
                
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    
    headV.deleteClickBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
        [weakSelf requestComCount];
        for (int i = 0; i < weakSelf.dataArr.count; i++) {
            SXVideoCommentModel *oldM = weakSelf.dataArr[i];
            if ([oldM.commentId isEqualToString:commentM.commentId]) {
                [weakSelf.dataArr removeObject:oldM];
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    
    headV.linkClickBlock = ^(NSString * _Nonnull searid) {
        [weakSelf pushSearis:searid];
    };
    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    SXVideoCommentModel *commentM = self.dataArr[section];
    return [self getFirstCommentHeight:commentM];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SXVideoCommentModel *commentM = self.dataArr[section];
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
    cell.videoUser = self.videoUser;
    SXVideoCommentModel *commentM = self.dataArr[indexPath.section];
    if (commentM.isOpen) {
        cell.commentM =  commentM.moreReplyArr[indexPath.row];
    }else{
        cell.commentM =  commentM.replyArr[indexPath.row];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.replyClickBlock = ^(SXVideoCommentModel * _Nonnull commentModel) {
        weakSelf.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",commentModel.fromUserInfo.nick_name];
        [weakSelf.inputView showJustComment:commentModel.commentId];
    };
    
    cell.deleteClickBlock = ^(SXVideoCommentModel * _Nonnull commentM) {
        [weakSelf requestComCount];
        [weakSelf replaceForDelete:commentM];
    };
    
    cell.linkClickBlock = ^(NSString * _Nonnull searId) {
        [weakSelf pushSearis:searId];
    };
    return cell;
}

- (void)pushSearis:(NSString *)searId{
 
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",searId] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
            if (!searismodel) {
                return;
            }
            SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
            ctl.paySearModel = searismodel;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

//删除回复的时候，请求接口替换一级评论
- (void)replaceForDelete:(SXVideoCommentModel *)commentM{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoCommont/info/%@",commentM.parent_id] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            SXVideoCommentModel *firstM = [SXVideoCommentModel mj_objectWithKeyValues:dict[@"data"]];
            if (firstM.top_at.intValue) {
                self.currentTopModel = firstM;
            }
            if (firstM.firstReplyModel) {//如果存在第一条回复数据
                [firstM.replyArr addObject:firstM.firstReplyModel];
            }
            for (int i = 0; i < self.dataArr.count; i++) {
                SXVideoCommentModel *oldfirstM = self.dataArr[i];
                if ([oldfirstM.commentId isEqualToString:firstM.commentId]) {//找到父类评论进行替换
                    [self.dataArr replaceObjectAtIndex:i withObject:firstM];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SXVideoCommentModel *commentM = self.dataArr[indexPath.section];
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

//获取评论数量
- (void)requestComCount{
    NSString *url = @"";
    if (!self.videoModel) {
        return;
    }
    url = [NSString stringWithFormat:@"videoCommont/%@/%@?commentId=%@&replyId=%@&pageNo=1",self.videoModel.vid,@"1",@"0",@"0"];
  
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
    
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            SXVideoCommentJson *jsonModel = [SXVideoCommentJson mj_objectWithKeyValues:dict[@"data"]];
            self.titleL.text = [NSString stringWithFormat:@"评论%@",jsonModel.commentCt.intValue?jsonModel.commentCt:@""];
            self.currentComCount = jsonModel.commentCt;
            if (self.refreshCommentCountBlock) {
                self.refreshCommentCountBlock(jsonModel.commentCt);
            }
            
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, self.tableView.frame.size.height)];
        _defaultL.text = @"还没有评论，发条评论抢占第一";
        _defaultL.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _defaultL.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultL;
}
@end

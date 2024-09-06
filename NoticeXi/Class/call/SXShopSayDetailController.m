//
//  SXShopSayDetailController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayDetailController.h"
#import "SXShopSayDetailCell.h"
#import "SXShopSayDetailSection.h"
#import "SXShopSayNavView.h"
#import "SXShopSendCommentView.h"
#import "SXVideoCommentJson.h"
#import "SXShopSayComFirstCell.h"
#import "SXShopSayComCell.h"
#import "SXShopSayComMoreView.h"
#import "SXVideoComInputView.h"
#import "NoticeXi-Swift.h"
#import "NoticeSCViewController.h"
static NSString *const commentCellIdentifier = @"commentCellIdentifier";
@interface SXShopSayDetailController ()<LCActionSheetDelegate,NoticeVideoComentInputDelegate>

@property (nonatomic, strong) SXShopSayNavView *shopInfoView;
@property (nonatomic, assign) CGFloat imageViewHeight;
@property (nonatomic, strong) SXShopSendCommentView *commentSendView;
@property (nonatomic, strong) SXShopSayDetailCell *headerView;
@property (nonatomic, strong) SXShopSayDetailSection *numberView;
@property (nonatomic, strong) SXVideoComInputView *inputView;
@property (nonatomic, strong) UILabel *defaultL1;
@property (nonatomic, assign) BOOL refresh;
@property (nonatomic, strong) NSString *currentComCount;
@property (nonatomic, strong) SXShopSayComModel *currentTopModel;//当前置顶的评论
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIButton *deleteBtn;
@end

@implementation SXShopSayDetailController

- (SXShopSayNavView *)shopInfoView{
    if (!_shopInfoView) {
        _shopInfoView = [[SXShopSayNavView  alloc] initWithFrame:CGRectMake(54, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-54-54, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        _shopInfoView.model = self.model;
        [self.navBarView addSubview:_shopInfoView];
        _shopInfoView.hidden = YES;
    }
    return _shopInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViewHeight = (DR_SCREEN_WIDTH-40)/3;
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);

    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-35,STATUS_BAR_HEIGHT, 35,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [moreBtn setImage: [UIImage imageNamed:@"img_scb_b"]  forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(actionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:moreBtn];

    if (!self.isReport) {
        __weak typeof(self) weakSelf = self;
        self.commentSendView = [[SXShopSendCommentView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, 50)];
        self.commentSendView.model = self.model;
        [self.view addSubview:self.commentSendView];
        self.commentSendView.comClickBlock = ^(BOOL click) {
            [weakSelf sendComClick];
        };
        
        self.commentSendView.upcomClickBlock = ^(BOOL click) {
            [weakSelf upView];
        };
    }

    
    //删除动态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsaydeleteNotice:) name:@"SXDeleteshopsayNotification" object:nil];
    //推荐通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsaytuijianNotice:) name:@"SXtuijianshopsayNotification" object:nil];
    
    SXShopSayDetailCell *headerView = [[SXShopSayDetailCell  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 66 + 70 + self.model.longcontentHeight + (self.model.hasImageV?(self.imageViewHeight+10):0)+40)];
    headerView.imageHeight = self.imageViewHeight;
    self.tableView.tableHeaderView = headerView;
    headerView.model = self.model;
    self.headerView = headerView;
    [self.tableView reloadData];
    
    SXShopSayDetailSection *sectionV = [[SXShopSayDetailSection  alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-40, DR_SCREEN_WIDTH, 40)];
    [self.headerView addSubview:sectionV];
    self.numL = sectionV.mainTitleLabel;
    self.numL.text = self.model.comment_num.intValue? [NSString stringWithFormat:@"%@条评论",self.model.comment_num]:@"评论";
    
    [self.tableView registerClass:[SXShopSayComCell class] forCellReuseIdentifier:commentCellIdentifier];
    [self.tableView registerClass:[SXShopSayComFirstCell class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    [self.tableView registerClass:[SXShopSayComMoreView class] forHeaderFooterViewReuseIdentifier:@"footView"];
    [self createRefesh];
    
    if (!self.isReport) {
        self.inputView = [[SXVideoComInputView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-50-44, DR_SCREEN_WIDTH, 50)];
        self.inputView.noNeedkC = YES;
        self.inputView.delegate = self;
        self.inputView.limitNum = 500;
        self.inputView.plaStr = @"成为第一条评论…";
        self.inputView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.inputView.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.inputView.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.inputView.plaL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }

    
    self.isDown = YES;
    self.pageNo = 1;
    [self requestCom];
    
    if (self.needUpCom && !self.model.comment_num.intValue) {
        [self sendComClick];
    }
    
    if (self.isReport) {
        self.navBarView.titleL.text = @"被举报的店铺动态";
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.tableView.frame), 120, 40)];
        button.layer.cornerRadius = 20;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"联系店主" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickFun) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-135, CGRectGetMaxY(self.tableView.frame), 120, 40)];
        button1.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 setTitle:@"删除" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(deleteFun) forControlEvents:UIControlEventTouchUpInside];
        if (self.model.status.intValue > 1) {
            [button1 setTitle:@"已删除" forState:UIControlStateNormal];
        }
        self.deleteBtn = button1;
        [self.view addSubview:button1];
    }
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
  
}

- (void)deleteFun{
    if (self.model.status.intValue > 1) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定删除吗？" message:@"该动态下的评论回复内容也会被删除" sureBtn:@"取消" cancleBtn:@"删除" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:self.managerCode forKey:@"confirmPasswd"];
            [parm setObject:@"5" forKey:@"reportStatus"];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/reports/%@",self.jubaoId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    weakSelf.model.status = @"3";
                    [weakSelf.deleteBtn setTitle:@"已删除" forState:UIControlStateNormal];
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
    
        }
    };
    [alerView showXLAlertView];
}

- (void)clickFun{
    NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
    vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.model.shopModel.user_id];
    vc.toUserId = self.model.shopModel.user_id;
    vc.navigationItem.title = self.model.shopModel.shop_name;
    [self.navigationController pushViewController:vc animated:YES];
}


//发送评论或者回复
- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId linkArr:(nonnull NSMutableArray *)linkArr{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:comment forKey:@"content"];

    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopDynamicCommont/%@/%@",self.model.dongtaiId,commentId.intValue?commentId:@"0"] Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            self.tableView.tableFooterView = nil;
            
            self.currentComCount = [NSString stringWithFormat:@"%d",self.currentComCount.intValue+1];
            self.model.comment_num = self.currentComCount;
            self.commentSendView.model = self.model;
            self.numL.text = self.model.comment_num.intValue? [NSString stringWithFormat:@"%@条评论",self.model.comment_num]:@"评论";
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shopSayCOMNumberNotification" object:self userInfo:@{@"dontaiId":self.model.dongtaiId,@"commentNum":self.model.comment_num}];
            SXShopSayComModel *commentM = [SXShopSayComModel mj_objectWithKeyValues:dict[@"data"]];
            if (commentM.commentId) {//评论成功且返回了数据
                if (commentM.parent_id.intValue > 0) {//属于回复
                    
                    for (SXShopSayComModel *parModel in self.dataArr) {//从一级评论寻找当前回复的一级评论
                        
                        if ([parModel.commentId isEqualToString:commentM.parent_id]) {
                            if ([commentM.parent_id isEqualToString:commentM.post_id]) {//属于回复一级评论，直接置顶显示即可
                                [parModel.replyArr insertObject:commentM atIndex:0];
                                if (parModel.moreReplyArr.count) {
                                    [parModel.moreReplyArr insertObject:commentM atIndex:0];
                                }
                            }else{//属于回复别人的回复，那么位置放置在被回复的数据下面
                                for (int i = 0; i < parModel.replyArr.count;i++) {//从父类的二级评论数据找到下标位置
                                    SXShopSayComModel *beReplyModel = parModel.replyArr[i];
                                    if ([beReplyModel.commentId isEqualToString:commentM.post_id]) {//找到被回复的是哪一条
                                        [parModel.replyArr insertObject:commentM atIndex:i+1];
                                    }
                                }
                                
                                if (parModel.moreReplyArr.count) {
                                    for (int i = 0; i < parModel.moreReplyArr.count;i++) {//从父类的二级评论数据找到下标位置
                                        SXShopSayComModel *beReplyModel = parModel.moreReplyArr[i];
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
                
                if (!commentId.intValue) {
                    [self upView];
                }
                [[NoticeTools getTopViewController] showToastWithText:@"发送成功"];
            }
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)upView{
    if (self.tableView.contentSize.height >= (self.tableView.frame.size.height + self.headerView.frame.size.height)) {
        [self.tableView setContentOffset:CGPointMake(0, self.headerView.frame.size.height-40)];
    }else if(self.tableView.contentSize.height > self.tableView.frame.size.height){
        [self.tableView setContentOffset:CGPointMake(0,self.tableView.contentSize.height-self.tableView.frame.size.height)];
    }
}

- (void)sendComClick{
    self.inputView.plaStr = self.model.comment_num.intValue?@"说说我的想法...":@"成为第一条评论…";
    [self.inputView showJustComment:nil];
}

- (void)createRefesh{
    
    __weak SXShopSayDetailController *ctl = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.pageNo = 1;
        [ctl requestCom];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        ctl.pageNo++;
        [ctl requestCom];
    }];
}


- (void)requestCom{
    NSString *url = @"";
    if (!self.model) {
        return;
    }
    if ((self.commentId.intValue || self.replyId.intValue) && self.type.intValue == 2) {
        url = [NSString stringWithFormat:@"shopDynamicComment/%@/%@?commentId=%@&replyId=%@&pageNo=%ld",self.model.dongtaiId,@"2",self.commentId.intValue?self.commentId:@"0",self.replyId.intValue?self.replyId:@"0",self.pageNo];
    }else{
        url = [NSString stringWithFormat:@"shopDynamicComment/%@/%@?commentId=%@&replyId=%@&pageNo=%ld",self.model.dongtaiId,@"1",@"0",@"0",self.pageNo];
    }
  
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
            
            if (self.type.intValue == 2) {
                if (jsonModel.topList) {
                    SXShopSayComModel *topCommentModel = [SXShopSayComModel mj_objectWithKeyValues:jsonModel.topList];
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
                 
                    if (self.pageNo == 1) {
                        BOOL hasSave = NO;
                        for (SXShopSayComModel *oldm in self.dataArr) {//去重
                            if ([oldm.commentId isEqualToString:topCommentModel.commentId]) {
                                hasSave = YES;
                                break;
                            }
                        }
                        
                        if (!hasSave) {
                            [self.dataArr addObject:topCommentModel];
                        }
                    }else{
                        [self.dataArr addObject:topCommentModel];
                    }
                }
            }
            
            if (jsonModel.list.count) {
                for (NSDictionary *dic in jsonModel.list) {//普通列表
                    SXShopSayComModel *commentM = [SXShopSayComModel mj_objectWithKeyValues:dic];
                    if (commentM.comment_type.intValue > 1) {
                        commentM.content = @"请更新到最新版本";
                    }
                    if (commentM.top_at.intValue) {
                        self.currentTopModel = commentM;
                    }
                    if (commentM.firstReplyModel) {//如果存在第一条回复数据
                        [commentM.replyArr addObject:commentM.firstReplyModel];
                    }
                    
                    if (self.pageNo == 1) {
                        BOOL hasSave = NO;
                        for (SXShopSayComModel *oldm in self.dataArr) {//去重
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
                    self.model.comment_num = jsonModel.commentCt;
                    self.currentComCount = jsonModel.commentCt;
                    self.commentSendView.model = self.model;
                    self.numL.text = self.model.comment_num.intValue? [NSString stringWithFormat:@"%@条评论",self.model.comment_num]:@"评论";
                }
            }
          
        
            self.tableView.tableFooterView = self.dataArr.count?nil:self.defaultL1;
            [self.tableView reloadData];
            
            if (self.dataArr.count && self.needUpCom) {
                self.needUpCom = NO;
                [self upView];
            }
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


//获取更多回复
- (void)requestMoreReply:(SXShopSayComModel *)commentM{
    
    if (commentM.hasGetMore) {//已经获取过更多回复，直接显示即可
        commentM.isOpen = YES;
        [self.tableView reloadData];
        return;
    }
    
    [[NoticeTools getTopViewController] showHUD];
    
    NSString *url = [NSString stringWithFormat:@"shopDynamicComment/moreReply?parentId=%@",commentM.commentId];
  
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            for (SXShopSayComModel *alreadM in commentM.replyArr) {//所有回复数据添加存在的数据
                [commentM.moreReplyArr addObject:alreadM];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXShopSayComModel *replyM = [SXShopSayComModel mj_objectWithKeyValues:dic];
                if (replyM.comment_type.intValue > 1) {
                    replyM.content = @"请更新到最新版本";
                }
                BOOL hasSave = NO;
                for (SXShopSayComModel *oldm in commentM.moreReplyArr) {//去重
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
    SXShopSayComModel *commentM = self.dataArr[section];
    if (commentM.reply_ctnum.intValue) {
        return 34;
    }
    return 0;
}

//展开更多或者收起更多回复
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SXShopSayComMoreView *moreView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footView"];
    moreView.commentM = self.dataArr[section];
    __weak typeof(self) weakSelf = self;
    moreView.moreCommentBlock = ^(SXShopSayComModel * _Nonnull commentM) {
        [weakSelf requestMoreReply:commentM];
    };
    moreView.closeCommentBlock = ^(SXShopSayComModel * _Nonnull commentM) {
        commentM.isOpen = NO;
        [weakSelf.tableView reloadData];
    };
    return moreView;
}

//一级评论列表
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    SXShopSayComFirstCell *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.shopModel = self.model.shopModel;
    headV.commentM = self.dataArr[section];
    __weak typeof(self) weakSelf = self;
    headV.replyClickBlock = ^(SXShopSayComModel * _Nonnull commentM) {
        if ([commentM.fromUserInfo.userId isEqualToString:weakSelf.model.shopModel.user_id]) {
            weakSelf.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",weakSelf.model.shopModel.shop_name];
        }else{
            weakSelf.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",commentM.fromUserInfo.nick_name];
        }
        [weakSelf.inputView showJustComment:commentM.commentId];
    };

    headV.deleteClickBlock = ^(SXShopSayComModel * _Nonnull commentM) {
    
        for (int i = 0; i < weakSelf.dataArr.count; i++) {
            SXShopSayComModel *oldM = weakSelf.dataArr[i];
            if ([oldM.commentId isEqualToString:commentM.commentId]) {
                [weakSelf.dataArr removeObject:oldM];
                [weakSelf.tableView reloadData];
                break;
            }
        }
        [weakSelf requestComCount];
    };
    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    SXShopSayComModel *commentM = self.dataArr[section];
    return [self getFirstCommentHeight:commentM];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SXShopSayComModel *commentM = self.dataArr[section];
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
    SXShopSayComCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    cell.shopModel = self.model.shopModel;
    SXShopSayComModel *commentM = self.dataArr[indexPath.section];
    if (commentM.isOpen) {
        cell.commentM =  commentM.moreReplyArr[indexPath.row];
    }else{
        cell.commentM =  commentM.replyArr[indexPath.row];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.replyClickBlock = ^(SXShopSayComModel * _Nonnull commentModel) {
        if ([commentModel.fromUserInfo.userId isEqualToString:weakSelf.model.shopModel.user_id]) {
            weakSelf.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",weakSelf.model.shopModel.shop_name];
        }else{
            weakSelf.inputView.plaStr = [NSString stringWithFormat:@"回复 %@",commentModel.fromUserInfo.nick_name];
        }
        
        [weakSelf.inputView showJustComment:commentModel.commentId];
    };
    
    cell.deleteClickBlock = ^(SXShopSayComModel * _Nonnull commentM) {
        [weakSelf requestComCount];
        [weakSelf replaceForDelete:commentM];
    };

    return cell;
}

//获取评论数量
- (void)requestComCount{
    NSString *url = @"";
    if (!self.model) {
        return;
    }
    url = [NSString stringWithFormat:@"shopDynamicComment/%@/%@?commentId=%@&replyId=%@&pageNo=%ld",self.model.dongtaiId,@"1",@"0",@"0",self.pageNo];
  
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
    
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            SXVideoCommentJson *jsonModel = [SXVideoCommentJson mj_objectWithKeyValues:dict[@"data"]];
            self.currentComCount = jsonModel.commentCt;
            self.model.comment_num = jsonModel.commentCt;
            self.commentSendView.model = self.model;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shopSayCOMNumberNotification" object:self userInfo:@{@"dontaiId":self.model.dongtaiId,@"commentNum":self.model.comment_num}];
            self.numL.text = self.model.comment_num.intValue? [NSString stringWithFormat:@"%@条评论",self.model.comment_num]:@"评论";
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

//删除回复的时候，请求接口替换一级评论
- (void)replaceForDelete:(SXShopSayComModel *)commentM{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shopDynamicComment/info/%@",commentM.parent_id] Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if (success) {
            SXShopSayComModel *firstM = [SXShopSayComModel mj_objectWithKeyValues:dict[@"data"]];
         
            if (firstM.firstReplyModel) {//如果存在第一条回复数据
                [firstM.replyArr addObject:firstM.firstReplyModel];
            }
            for (int i = 0; i < self.dataArr.count; i++) {
                SXShopSayComModel *oldfirstM = self.dataArr[i];
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
    SXShopSayComModel *commentM = self.dataArr[indexPath.section];
    if (commentM.isOpen) {
        return [self getTwoCommentHeight:commentM.moreReplyArr[indexPath.row]];
    }
    return [self getTwoCommentHeight:commentM.replyArr[indexPath.row]];
}

- (CGFloat)getFirstCommentHeight:(SXShopSayComModel *)commentModel{
    
    return 31 + 22 + (NSInteger)commentModel.firstContentHeight +5;
}

- (CGFloat)getTwoCommentHeight:(SXShopSayComModel *)commentModel{
    return 30 + 22 + (NSInteger)commentModel.secondContentHeight+5;
}

- (UILabel *)defaultL1{
    if (!_defaultL1) {
        _defaultL1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 160)];
        _defaultL1.text = @"还没有评论，发条评论抢占第一";
        _defaultL1.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL1.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _defaultL1.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultL1;
}


- (void)getsaytuijianNotice:(NSNotification*)notification{
    self.headerView.model = self.model;
    [self.tableView reloadData];
 
}

- (void)getsaydeleteNotice:(NSNotification*)notification{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionClick{
    BOOL isSelf = [self.model.shopModel.user_id isEqualToString:[NoticeTools getuserId]];
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[isSelf?@"删除": @"举报此内容",self.model.shopModel.is_recommend.boolValue?@"取消推荐此店铺":@"推荐此店铺"]];
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        BOOL isSelf = [self.model.shopModel.user_id isEqualToString:[NoticeTools getuserId]];
        if (isSelf) {
            [self deleteDt];
        }else{
            [self jubao];
        }
    }else if (buttonIndex == 2){
        [self tuijiandinapu];
    }
}

- (void)jubao{
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.model.dongtaiId;
    juBaoView.reouceType = @"152";
    [juBaoView showView];
}

- (void)deleteDt{
    [SXShopSayListModel deleteDongtai:self.model.dongtaiId];
}

- (void)tuijiandinapu{
    [SXShopSayListModel tuijiandinapu:self.model.shopModel.shopId tuijian:self.model.shopModel.is_recommend.boolValue?NO:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 56) {
        self.shopInfoView.hidden = NO;
    }else{
        self.shopInfoView.hidden = YES;
    }
}

@end

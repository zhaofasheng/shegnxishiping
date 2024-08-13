//
//  SXKcScoreListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXKcScoreListController.h"
#import "SXKcComScoreListCell.h"
#import "KMTagListView.h"
#import "NoticeComLabelModel.h"
@interface SXKcScoreListController ()<KMTagListViewDelegate>
@property (nonatomic, strong) NSString *labelTagId;
@property (nonatomic, strong) UIView *deleteView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *noDataL;
@end

@implementation SXKcScoreListController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-43);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcomZanNotice:) name:@"SXZANKCoNotification" object:nil];
    
    [self.tableView registerClass:[SXKcComScoreListCell class] forCellReuseIdentifier:@"cell"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
    
    if (self.type.intValue == 1 && self.labelArr.count) {
        KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, 0)];
        tagV.labelOneClick = YES;
        tagV.ySpace = 10;
        tagV.delegate_ = self;
        [tagV setupCustomeMoreSubViewsWithTitles:self.labelArr];
        self.tableView.tableHeaderView = tagV;
        
        CGRect rect = tagV.frame;
        rect.size.height = tagV.contentSize.height;
        tagV.frame = rect;
        [self.tableView reloadData];
    }
}


- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content{
    NoticeComLabelModel *labelM = self.labelArr[index];
    if (labelM.isChoice) {
        self.labelTagId = labelM.labelId;
    }else{
        self.labelTagId = nil;
    }
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}



- (void)createRefesh{
    
    __weak SXKcScoreListController *ctl = self;

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
    if (self.type.intValue == 1) {//全部
        url = [NSString stringWithFormat:@"videoSeriesRemark/getList/%@?pageNo=%ld&type=%@",self.paySearModel.seriesId,self.pageNo,@"1"];
        if (self.labelTagId) {
            url = [NSString stringWithFormat:@"videoSeriesRemark/getList/%@?pageNo=%ld&type=%@&labelId=%@",self.paySearModel.seriesId,self.pageNo,@"3",self.labelTagId];
        }
    }else if (self.type.intValue == 2){//我的评价
        url = [NSString stringWithFormat:@"videoSeriesRemark/getList/%@?pageNo=%ld&type=%@",self.paySearModel.seriesId,self.pageNo,@"4"];
    }else if (self.type.intValue == 3){//按照分数筛选
        url = [NSString stringWithFormat:@"videoSeriesRemark/getList/%@?pageNo=%ld&type=%@&score=%@",self.paySearModel.seriesId,self.pageNo,@"2",self.score];
    }
   
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.6+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                SXKcComDetailModel *model = [SXKcComDetailModel mj_objectWithKeyValues:dic];
                if (self.type.intValue == 2 && model.status.intValue != 1) {
                    if (!self.headerView) {
                        self.headerView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 74)];
                        self.tableView.tableHeaderView = self.headerView;
                        self.deleteView.hidden = NO;
                    }
                }else{
                    [self.dataArr addObject:model];
                }
                
            }
         
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
            }else{
                if (!self.headerView) {
                    self.tableView.tableFooterView = self.noDataL;
                }
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKcComDetailModel *model = self.dataArr[indexPath.row];
    if (model.label_info.count || model.content) {
        return 57+45+10+model.labelHeight+model.contentHeight+10;
    }else{
        return 57+45+10+20;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXKcComScoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  
    cell.comModel = self.dataArr[indexPath.row];

    return cell;
}


- (void)getcomZanNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *comid = nameDictionary[@"comId"];
    NSString *iszan = nameDictionary[@"is_zan"];
    NSString *zanNum = nameDictionary[@"zan_num"];
    
    for (SXKcComDetailModel *Model in self.dataArr) {
        if ([Model.comId isEqualToString:comid]) {
            Model.is_zan = iszan;
            Model.zan_num = zanNum;
            break;
        }
    }
    [self.tableView reloadData];
}

- (UILabel *)noDataL{
    if (!_noDataL) {
        _noDataL = [[UILabel  alloc] initWithFrame:self.tableView.bounds];
        _noDataL.text = @"还没有此类型的评价";
        _noDataL.font = FOURTHTEENTEXTFONTSIZE;
        _noDataL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _noDataL.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataL;
}

- (UIView *)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 54)];
        _deleteView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [_deleteView setAllCorner:10];
        [self.headerView addSubview:_deleteView];
        
        //头像
        UIImageView *_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 24, 24)];
        [_iconImageView setAllCorner:12];
        [_deleteView addSubview:_iconImageView];
        NoticeUserInfoModel *userInfo = [NoticeSaveModel getUserInfo];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar_url]];
        
        //昵称
        UILabel *_nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(47,16, DR_SCREEN_WIDTH-56-30, 22)];
        _nickNameL.font = XGSIXBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _nickNameL.text = @"我的评价";
        [_deleteView addSubview:_nickNameL];
        
        UILabel *_deleteL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-30-100-15,18, 100, 17)];
        _deleteL.font = TWOTEXTFONTSIZE;
        _deleteL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        _deleteL.text = @"评价已删除";
        _deleteL.textAlignment = NSTextAlignmentRight;
        [_deleteView addSubview:_deleteL];
    }
    return _deleteView;
}
@end

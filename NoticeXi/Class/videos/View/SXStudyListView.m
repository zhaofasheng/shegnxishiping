//
//  SXStudyListView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXStudyListView.h"
#import "SXStudyListCell.h"

@implementation SXStudyListView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-50, 0, 50, 50)];
        [cancelBtn setImage:UIImageNamed(@"sx_blackclose_img") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100,50)];
        contentL.font = XGEightBoldFontSize;
        contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        contentL.text = @"课程列表";
        [self.contentView addSubview:contentL];

        self.isDown = YES;
        self.pageNo = 1;
        self.dataArr = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)createRefesh{
    
    __weak SXStudyListView *ctl = self;

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
    
    url = [NSString stringWithFormat:@"video/series/list?pageNo=%ld&isLogined=%@",self.pageNo,[NoticeTools getuserId]?@"1":@"0"];
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
   
            for (NSDictionary *dic in dict[@"data"]) {
                SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
         
            }

            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.addBlock) {
        self.addBlock(self.dataArr[indexPath.row]);
    }
    [self cancelClick];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXStudyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.studyModel = self.dataArr[indexPath.row];
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

- (void)showATView{
    if (!self.dataArr.count) {
        self.isDown = YES;
        self.pageNo = 1;
        [self request];
    }else{
        [self.tableView reloadData];
    }
  

    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    }];
}

- (void)cancelClick{

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Getter and Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, DR_SCREEN_WIDTH, self.contentView.frame.size.height-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 94;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:SXStudyListCell.class forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.tableView];
    }
    return _tableView;
}




@end

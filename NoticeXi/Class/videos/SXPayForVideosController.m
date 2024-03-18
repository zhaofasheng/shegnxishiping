//
//  SXPayForVideosController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/21.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayForVideosController.h"
#import "SXPayForVideoCell.h"
#import "SXStudyBaseController.h"
#import "SXHasBuyPayVideoController.h"
#import "NoticeLoginViewController.h"
@interface SXPayForVideosController ()
@property (nonatomic, strong) UIView *footView;

@end

@implementation SXPayForVideosController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.hidden = YES;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT, (DR_SCREEN_WIDTH-30)/2, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    label.text = @"付费课程";
    label.font = XGTwentyTwoBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#14151A"];
    [self.view addSubview:label];
    
    CGFloat width = GET_STRWIDTH(@"已购", 14, 24);
    UIView *buttonView = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-width-24-15-4, (NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2+STATUS_BAR_HEIGHT, width+24+4, 24)];
    buttonView.userInteractionEnabled = YES;
    UIImageView *buttonImgV = [[UIImageView  alloc] initWithFrame:CGRectMake(2, 0, 24, 24)];
    buttonImgV.image = UIImageNamed(@"sxhasbuybtn_img");
    buttonImgV.userInteractionEnabled = YES;
    [buttonView addSubview:buttonImgV];
    
    UILabel *btnlabel = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonImgV.frame),0, width+2, 24)];
    btnlabel.text = @"已购";
    btnlabel.font = XGFourthBoldFontSize;
    btnlabel.textColor = [UIColor colorWithHexString:@"#14151A"];
    [buttonView addSubview:btnlabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hasbbuyTap)];
    [buttonView addGestureRecognizer:tap];
    
    [self.view addSubview:buttonView];
    
    self.tableView.rowHeight = 10+(DR_SCREEN_WIDTH-20)/355*232;
    
    [self.tableView registerClass:[SXPayForVideoCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = self.footView;
    

    [self createRefesh];
    
    [self request];
    
    //用户登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    //用户退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"outLoginClearDataNOTICATION" object:nil];
}

- (void)refreshList{
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

- (void)createRefesh{
    
    __weak SXPayForVideosController *ctl = self;

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
            
            NSInteger num = 0;
            for (NSDictionary *dic in dict[@"data"]) {
                SXPayForVideoModel *model = [SXPayForVideoModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
                num++;
            }
         
            if (num == 10) {
                self.tableView.tableFooterView = nil;
            }else{
                self.tableView.tableFooterView = self.footView;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
    SXPayForVideoModel *model = self.dataArr[indexPath.row];
    ctl.paySearModel = model;
    __weak typeof(self) weakSelf = self;
    ctl.buySuccessBlock = ^(NSString * _Nonnull searisID) {
        for (SXPayForVideoModel *searM in weakSelf.dataArr) {
            if ([searM.seriesId isEqualToString:searisID]) {
                searM.is_bought = @"1";
                break;
            }
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXPayForVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)hasbbuyTap{
    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    SXHasBuyPayVideoController *ctl = [[SXHasBuyPayVideoController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
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

@end

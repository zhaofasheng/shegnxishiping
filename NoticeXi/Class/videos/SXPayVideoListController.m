//
//  SXPayVideoListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayVideoListController.h"
#import "SXSearisHeaderView.h"
#import "SXHasBuySearisListCell.h"
#import "SXNoBuySearisListCell.h"
#import "SXBuySearisController.h"
#import "SXPayVideoPlayDetailBaseController.h"

@interface SXPayVideoListController ()
@property (nonatomic, strong) SXSearisHeaderView *headerView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIImageView *priceBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIView *backView;
@end

@implementation SXPayVideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.titleL.text = @"课程目录";
    
    
    self.headerView = [[SXSearisHeaderView alloc] initWithFrame:CGRectZero];
    self.headerView.paySearModel = self.paySearModel;
    self.tableView.tableHeaderView = self.headerView;
    
    __weak typeof(self) weakSelf = self;
    self.headerView.choiceBeforeLookBlock = ^(NSString * _Nonnull videoName) {
        for (SXSearisVideoListModel *model in weakSelf.dataArr) {
            if ([model.title isEqualToString:videoName]) {
                [weakSelf gotoPlayView:model];
                break;
            }
        }
    };
    
    [self.tableView reloadData];
    
    if (self.paySearModel.published_episodes.intValue < self.paySearModel.episodes.intValue) {
        self.tableView.tableFooterView = self.footView;
    }else{
        self.tableView.tableFooterView = nil;
    }
    
    [self.tableView registerClass:[SXNoBuySearisListCell class] forCellReuseIdentifier:@"noCell"];
    [self.tableView registerClass:[SXHasBuySearisListCell class] forCellReuseIdentifier:@"cell"];

    [self request];
}


- (void)request{
    
    NSString *url = @"";
    
    url = [NSString stringWithFormat:@"series/%@/video",self.paySearModel.seriesId];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.dataArr removeAllObjects];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
     
            for (NSDictionary *dic in dict[@"data"]) {
                SXSearisVideoListModel *model = [SXSearisVideoListModel mj_objectWithKeyValues:dic];
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
    if (self.paySearModel.hasBuy) {
        SXSearisVideoListModel *videoM = self.dataArr[indexPath.row];
        videoM.is_new = @"0";
        [self.tableView reloadData];
        [self gotoPlayView:videoM];
        
    }
}

- (void)gotoPlayView:(SXSearisVideoListModel *)model{
    SXPayVideoPlayDetailBaseController *ctl = [[SXPayVideoPlayDetailBaseController alloc] init];
    ctl.paySearModel = self.paySearModel;
    ctl.searisArr = self.dataArr;
    ctl.currentPlayModel = model;
    __weak typeof(self) weakSelf = self;
    ctl.refreshPlayTimeBlock = ^(SXSearisVideoListModel * _Nonnull currentModel) {
        [weakSelf refreshModelTime:currentModel];
    };
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)refreshModelTime:(SXSearisVideoListModel *)model{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:model.schedule?model.schedule:@"0" forKey:@"schedule"];
    [parm setObject:model.is_finished?model.is_finished:@"0" forKey:@"isFinished"];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"video/play/%@",model.videoId] Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
    } fail:^(NSError * _Nullable error) {
        
    }];
    
    for (SXSearisVideoListModel *videoM in self.dataArr) {
        if ([videoM.videoId isEqualToString:model.videoId]) {
            videoM.schedule = model.schedule;
            videoM.is_finished = model.is_finished;
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)refreshStatus{
    if (!self.paySearModel.hasBuy) {
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
        [self noBuyView];
    }else{
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.backView.hidden = YES;
        [self.headerView refresUI];
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshStatus];
}

- (void)buyClick{
    SXBuySearisController *ctl = [[SXBuySearisController alloc] init];
    ctl.paySearModel = self.paySearModel;
    __weak typeof(self) weakSelf = self;
    ctl.buySuccessBlock = ^(NSString * _Nonnull searisID) {
        if ([searisID isEqualToString:weakSelf.paySearModel.seriesId]) {
            weakSelf.paySearModel.is_bought = @"1";
            [weakSelf refreshStatus];
        }
        if (weakSelf.buySuccessBlock) {
            weakSelf.buySuccessBlock(searisID);
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.paySearModel.hasBuy? 85 : 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.paySearModel.hasBuy) {
        SXHasBuySearisListCell *buyedCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
        buyedCell.videoModel = self.dataArr[indexPath.row];
        return buyedCell;
    }else{
        SXNoBuySearisListCell *noCell = [tableView dequeueReusableCellWithIdentifier:@"noCell"];
        noCell.videoModel = self.dataArr[indexPath.row];
        return noCell;
    }
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


//没有购买时候的底部UI
- (void)noBuyView{
    
    UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    self.backView = backView;
    
    self.priceBtn = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2,5, 234, 40)];
    self.priceBtn.image = UIImageNamed(@"sxpricebak_img");
    [backView addSubview:self.priceBtn];
    
    NSString *price = [NSString stringWithFormat:@"¥%@",self.paySearModel.price];
    NSString *oriprice = [NSString stringWithFormat:@"¥%@",self.paySearModel.original_price];
    
    CGFloat markWidth = GET_STRWIDTH(@"专属价", 15, 40);
    CGFloat realPriceWidth = GET_STRWIDTH(price, 21, 40);
    CGFloat oriPriceWidth = GET_STRWIDTH(oriprice, 14, 40);
    CGFloat orSpace = (self.priceBtn.frame.size.width - markWidth-realPriceWidth-oriPriceWidth-2)/2;
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(orSpace, 0, markWidth, 40)];
    markL.font = FIFTHTEENTEXTFONTSIZE;
    markL.textColor = [UIColor whiteColor];
    markL.text = @"专属价";
    markL.textAlignment = NSTextAlignmentCenter;
    [self.priceBtn addSubview:markL];
    
    UILabel *realPriceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(markL.frame)+2, 0, realPriceWidth, 40)];
    realPriceL.font = SXNUMBERFONT(20);
    realPriceL.textColor = [UIColor whiteColor];
    realPriceL.text = price;
    realPriceL.textAlignment = NSTextAlignmentCenter;
    [self.priceBtn addSubview:realPriceL];
    
    UILabel *oripriceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(realPriceL.frame), 0, oriPriceWidth, 40)];
    oripriceL.font = SXNUMBERFONT(14);
    oripriceL.textColor = [UIColor whiteColor];
    oripriceL.text = oriprice;
    oripriceL.textAlignment = NSTextAlignmentCenter;
    [self.priceBtn addSubview:oripriceL];
    
    UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(0, 39/2, oriPriceWidth, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [oripriceL addSubview:line];
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-self.priceBtn.frame.origin.x-116, self.priceBtn.frame.origin.y, 116, 40)];
    [self.buyBtn setBackgroundImage:UIImageNamed(@"sxbuyBtn_img") forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buyBtn setTitle:@"立即报名" forState:UIControlStateNormal];
    [backView addSubview:self.buyBtn];
    [self.buyBtn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
}


@end

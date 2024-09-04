//
//  SXShoperSayController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShoperSayController.h"
#import "SXShopSayDetailController.h"
#import "SXShopSayHeaderSectionView.h"
#import "SXShopSayDayCell.h"
@interface SXShoperSayController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *nodataL;
@end

@implementation SXShoperSayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-40);
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[SXShopSayDayCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[SXShopSayHeaderSectionView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    self.lastId = nil;
    [self createRefesh];
    self.isDown = YES;
    [self request];
    
    //推荐通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsaytuijianNotice:) name:@"SXtuijianshopsayNotification" object:nil];
}

- (void)getsaytuijianNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *shopid = nameDictionary[@"shopId"];
    NSString *isTuiJian = nameDictionary[@"is_tuijian"];
    if ([shopid isEqualToString:self.shopModel.shopId]) {
        for (SXShopSayListModel *bigM in self.dataArr) {
            for (SXShopSayListModel *sayM in bigM.dtArr) {
                sayM.shopModel.is_recommend = isTuiJian;
                if (isTuiJian.boolValue) {
                    
                    sayM.shopModel.recommend_num = [NSString stringWithFormat:@"%d",sayM.shopModel.recommend_num.intValue+1];
                }else{
                    sayM.shopModel.recommend_num = [NSString stringWithFormat:@"%d",sayM.shopModel.recommend_num.intValue-1];
                }
            }
        }
    }
    [self.tableView reloadData];
}


- (void)createRefesh{
    
    __weak SXShoperSayController *ctl = self;

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ctl.isDown = YES;
        ctl.lastId = nil;
        [ctl request];
    }];
    // 设置颜色
    header.stateLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    header.lastUpdatedTimeLabel.textColor = [NoticeTools isWhiteTheme]? [UIColor colorWithHexString:@"#b7b7b7"] : GetColorWithName(VMainTextColor);
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}

- (void)request{
    
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"shop/dynamic/%@",self.shopModel.shopId];
    }else{
        url = [NSString stringWithFormat:@"shop/dynamic/%@?lastId=%@",self.shopModel.shopId,self.lastId];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
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
                SXShopSayListModel *sayM = [SXShopSayListModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:sayM];
            }

            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
                SXShopSayListModel *model = self.dataArr[self.dataArr.count-1];
                SXShopSayListModel *sayM = model.dtArr[model.dtArr.count-1];
                self.lastId = sayM.dongtaiId;
            }else{
                self.tableView.tableFooterView = self.nodataL;
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (UILabel *)nodataL{
    if (!_nodataL) {
        _nodataL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 200)];
        _nodataL.text = @"Ta没有留下任何信息";
        _nodataL.font = FOURTHTEENTEXTFONTSIZE;
        _nodataL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _nodataL.textAlignment = NSTextAlignmentCenter;
    }
    return _nodataL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopSayDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SXShopSayListModel *model = self.dataArr[indexPath.section];
    cell.model = model.dtArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopSayDetailController *ctl = [[SXShopSayDetailController alloc] init];
    SXShopSayListModel *model = self.dataArr[indexPath.section];
    ctl.model = model.dtArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SXShopSayListModel *model = self.dataArr[section];
    return model.dtArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    SXShopSayListModel *model = self.dataArr[indexPath.section];
    SXShopSayListModel *sayM = model.dtArr[indexPath.row];
    if (sayM.hasImageV) {
        return 92;
    }
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SXShopSayHeaderSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    SXShopSayListModel *model = self.dataArr[section];
    sectionView.mainTitleLabel.attributedText = model.timeString;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
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

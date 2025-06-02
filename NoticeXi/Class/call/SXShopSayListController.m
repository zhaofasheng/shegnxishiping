//
//  SXShopSayListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayListController.h"
#import "NoticeTextVoiceController.h"
#import "NoticeSaveVoiceTools.h"
#import "SXShopSayCell.h"
#import "SXShopSayDetailController.h"
#import "NoticeLoginViewController.h"

@interface SXShopSayListController ()

@property (nonatomic, strong) UIView *noListView;
@property (nonatomic, assign) CGFloat imageViewHeight;
@property (nonatomic, strong) UIView *sendView;
@property (nonatomic, strong) UIImageView *chchaImageView;

@end

@implementation SXShopSayListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = self.isSelfSay? NO : YES;
    self.useSystemeNav = self.isSelfSay? NO : YES;
    
    self.imageViewHeight = (DR_SCREEN_WIDTH-60)/3;
    
    
    self.sendView = [[UIView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-80)/2, (_noListView.frame.size.height-80)/2+24+20, 80, 36)];
    FSCustomButton *button = [[FSCustomButton  alloc] initWithFrame:CGRectMake(0, 0, 80, 36)];
    [button setAllCorner:18];
    button.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
    button.titleLabel.font = THRETEENTEXTFONTSIZE;
    [button setTitle:@"发动态" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.buttonImagePosition = FSCustomButtonImagePositionLeft;
    [button setImage:UIImageNamed(@"sxshopsend_img") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sendView addSubview:button];
    
    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    
    [self.tableView registerClass:[SXShopSayCell class] forCellReuseIdentifier:@"cell"];
    
    [self createRefesh];
    self.pageNo = 1;
    self.isDown = YES;
    [self request];
    
    if (self.isSelfSay) {
        self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        self.navBarView.titleL.text = @"店铺动态";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"NOTICESHOPSAYSEND" object:nil];
    //获取点赞通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsayNotice:) name:@"SXZANshopsayNotification" object:nil];
    //删除动态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsaydeleteNotice:) name:@"SXDeleteshopsayNotification" object:nil];
    //推荐通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getsaytuijianNotice:) name:@"SXtuijianshopsayNotification" object:nil];
    //拉黑通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getshoplaheiNotice:) name:@"SXlaheishopNotification" object:nil];
    //动态评论数量通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getshopComNumNotice:) name:@"shopSayCOMNumberNotification" object:nil];

}

- (void)getshopComNumNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *dtid = nameDictionary[@"dontaiId"];
    NSString *num = nameDictionary[@"commentNum"];
    for (SXShopSayListModel *sayM in self.dataArr) {
        if ([sayM.dongtaiId isEqualToString:dtid]) {
            sayM.comment_num = num;
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)getshoplaheiNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *shopid = nameDictionary[@"shopId"];
    NSArray *arr = [NSArray arrayWithArray:self.dataArr];//复制一个数组出来，避免遍历的同事进行增删操作，会闪退
    for (SXShopSayListModel *sayM in arr) {
        if ([sayM.shopModel.shopId isEqualToString:shopid]) {
            [self.dataArr removeObject:sayM];
        }
    }
    [self.tableView reloadData];
}

- (void)getsaytuijianNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *shopid = nameDictionary[@"shopId"];
    NSString *isTuiJian = nameDictionary[@"is_tuijian"];
    for (SXShopSayListModel *sayM in self.dataArr) {
        if ([sayM.shopModel.shopId isEqualToString:shopid]) {
            sayM.shopModel.is_recommend = isTuiJian;
            if (isTuiJian.boolValue) {
                
                sayM.shopModel.recommend_num = [NSString stringWithFormat:@"%d",sayM.shopModel.recommend_num.intValue+1];
            }else{
                sayM.shopModel.recommend_num = [NSString stringWithFormat:@"%d",sayM.shopModel.recommend_num.intValue-1];
            }
            
            [self.tableView reloadData];
        }
    }
}

- (void)getsaydeleteNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *dtid = nameDictionary[@"dongtaiId"];
    for (SXShopSayListModel *sayM in self.dataArr) {
        if ([sayM.dongtaiId isEqualToString:dtid]) {
            [self.dataArr removeObject:sayM];
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)getsayNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *dtid = nameDictionary[@"dongtaiId"];
    NSString *iszan = nameDictionary[@"is_zan"];
    NSString *zanNum = nameDictionary[@"zan_num"];
    for (SXShopSayListModel *sayM in self.dataArr) {
        if ([sayM.dongtaiId isEqualToString:dtid]) {
            sayM.is_zan = iszan;
            sayM.zan_num = zanNum;
            [self.tableView reloadData];
            break;
        }
    }
}

- (void)refresh{
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

- (void)createRefesh{
    
    __weak SXShopSayListController *ctl = self;

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
    
    url = self.isSelfSay? [NSString stringWithFormat:@"shop/dynamic/byUser?pageNo=%ld",self.pageNo]: [NSString stringWithFormat:@"shop/dynamic?pageNo=%ld",self.pageNo];
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
                sayM.cellHeight = 66 + 70 + sayM.contentHeight + (sayM.hasImageV?(self.imageViewHeight+10):0);
                [self.dataArr addObject:sayM];
            }
            
            [self.sendView removeFromSuperview];
            if (self.dataArr.count) {
                self.tableView.tableFooterView = nil;
                if (!self.isSelfSay) {
                    self.sendView.frame = CGRectMake(DR_SCREEN_WIDTH-80-10,CGRectGetMaxY(self.tableView.frame)-20-36-15, 80, 36);
                    [self.view addSubview:self.sendView];
                }
             
            }else{
                self.tableView.tableFooterView = self.noListView;
                self.sendView.frame = CGRectMake((DR_SCREEN_WIDTH-80)/2, (_noListView.frame.size.height-80)/2+24+20, 80, 36);
                [self.noListView addSubview:self.sendView];
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
    SXShopSayDetailController *ctl = [[SXShopSayDetailController alloc] init];
    ctl.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopSayListModel *model = self.dataArr[indexPath.row];
    return model.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopSayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.imageHeight = self.imageViewHeight;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (UIView *)noListView{
    if (!_noListView) {
        _noListView = [[UIView  alloc] initWithFrame:self.tableView.bounds];
        
        UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(0, (_noListView.frame.size.height-80)/2, DR_SCREEN_WIDTH, 20)];
        label.text = @"还没有动态，发条动态抢占第一";
        label.font = FOURTHTEENTEXTFONTSIZE;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [_noListView addSubview:label];
        
    }
    return _noListView;
}

- (UIImageView *)chchaImageView{
    if (!_chchaImageView) {
        _chchaImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(64, 0, 16, 16)];
        _chchaImageView.image = UIImageNamed(@"sxshoopsaychca_img");
        [self.sendView addSubview:_chchaImageView];
        _chchaImageView.userInteractionEnabled = YES;
    }
    return _chchaImageView;
}

- (void)sendClick{
    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
 //   if (!self.applyModel) {
//        [self showToastWithText:@"正在获取店铺信息，请稍后"];
//        return;
//    }
//    if (self.applyModel.status != 6) {//审核通过
//        [self showToastWithText:@"店主才能使用此功能"];
//        return;
//    }
    NoticeTextVoiceController *ctl = [[NoticeTextVoiceController alloc] init];
    NSMutableArray *alreadyArr = [NoticeSaveVoiceTools getVoiceArrary];
    if (alreadyArr.count) {
        ctl.saveModel = alreadyArr[0];
    }
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSMutableArray *alreadyArr = [NoticeSaveVoiceTools getVoiceArrary];
    if (alreadyArr.count) {
        self.chchaImageView.hidden = NO;
    }else{
        _chchaImageView.hidden = YES;
    }
}

@end

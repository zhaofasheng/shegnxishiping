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
#import "SXHasGetComController.h"
#import "SXKcHasGetLikeController.h"
#import "NoticeStaySys.h"
#import "CMUUIDManager.h"
@interface SXPayForVideosController ()
@property (nonatomic, strong) UIView *footView;

@property (nonatomic, strong) UIButton *hasBuyBtn;
@property (nonatomic, strong) UIButton *comBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UILabel *zanNumL;
@property (nonatomic, strong) UILabel *comNumL;
@property (nonatomic, strong) UILabel *updateL;
@end

@implementation SXPayForVideosController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestNoread];
    
    if (![NoticeTools getuserId]) {//没登录的话监测是否需要游客登录
        NSUUID *UUID=[UIDevice currentDevice].identifierForVendor;
        NSString *uuid = [CMUUIDManager readUUID];
        
        if (uuid==nil) {
            [CMUUIDManager deleteUUID];
            [CMUUIDManager saveUUID:UUID.UUIDString];
            uuid = UUID.UUIDString;
        }
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/checkUuid?uuid=%@",uuid] Accept:@"application/vnd.shengxi.v5.8.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                NoticeStaySys *regsModel = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
                if (regsModel.is_register.boolValue) {//注册过，设备登录token获取
                    DRLog(@"设备注册过");
                    [self getuuidLoginToken];
                }
            }
        } fail:^(NSError * _Nullable error) {
        }];
    }
}

- (void)getuuidLoginToken{
    //获得UUID存入keyChain中
    NSUUID *UUID=[UIDevice currentDevice].identifierForVendor;
    NSString *uuid = [CMUUIDManager readUUID];
    
    if (uuid==nil) {
        [CMUUIDManager deleteUUID];
        [CMUUIDManager saveUUID:UUID.UUIDString];
        uuid = UUID.UUIDString;
    }
    
    //设备登录
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:uuid forKey:@"uuid"];
    [parm setObject:[NoticeSaveModel getVersion] forKey:@"appVersion"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"users/loginByUuid" Accept:@"application/vnd.shengxi.v5.8.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            NoticeUserInfoModel *userM = [NoticeUserInfoModel mj_objectWithKeyValues:dict[@"data"]];
            if (userM.token && userM.token.length > 10) {
                [SXTools saveLocalToken:userM.token];
                [self refreshList];
            }
        }
    } fail:^(NSError * _Nullable error) {
    
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navBarView.hidden = YES;
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT, (DR_SCREEN_WIDTH-30)/2, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    label.text = @"课程";
    label.font = XGTwentyTwoBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#14151A"];
    [self.view addSubview:label];
    
    UIView *headerView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 80)];
    self.tableView.tableHeaderView = headerView;
    
    NSArray *titleArr = @[@"我的课程",@"课程评论",@"点赞消息"];
    NSArray *imgArr = @[@"sx_hasbuy_img1",@"sx_hasbuy_img2",@"sx_hasbuy_img3"];
    CGFloat width = (DR_SCREEN_WIDTH-44)/3;
    for (int i = 0; i < 3; i++) {
        UIButton *btns = [[UIButton  alloc] initWithFrame:CGRectMake(10+(width+12)*i, 8, width, 56)];
        [btns setAllCorner:8];
        btns.backgroundColor = [UIColor whiteColor];
        btns.tag = i;
        btns.titleLabel.font = XGFourthBoldFontSize;
        [btns setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
        [headerView addSubview:btns];
        [btns setTitle:titleArr[i] forState:UIControlStateNormal];
        [btns setImage:UIImageNamed(imgArr[i]) forState:UIControlStateNormal];
        [btns addTarget:self action:@selector(funClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            self.hasBuyBtn = btns;
        }else if (i==1){
            self.comBtn = btns;
        }else{
            self.likeBtn = btns;
        }
    }
    self.comNumL = [[UILabel  alloc] initWithFrame:CGRectZero];
    self.comNumL.layer.cornerRadius = 8;
    self.comNumL.layer.masksToBounds = YES;
    self.comNumL.textColor = [UIColor whiteColor];
    self.comNumL.font = ELEVENTEXTFONTSIZE;
    self.comNumL.textAlignment = NSTextAlignmentCenter;
    self.comNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
    [headerView addSubview:self.comNumL];
    
    self.zanNumL = [[UILabel  alloc] initWithFrame:CGRectZero];
    self.zanNumL.layer.cornerRadius = 8;
    self.zanNumL.layer.masksToBounds = YES;
    self.zanNumL.textColor = [UIColor whiteColor];
    self.zanNumL.font = ELEVENTEXTFONTSIZE;
    self.zanNumL.textAlignment = NSTextAlignmentCenter;
    self.zanNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
    [headerView addSubview:self.zanNumL];
    
    self.updateL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hasBuyBtn.frame)-46-4, self.comBtn.frame.origin.y-4, 46, 16)];
    self.updateL.layer.cornerRadius = 8;
    self.updateL.layer.masksToBounds = YES;
    self.updateL.text = @"有更新";
    self.updateL.hidden = YES;
    self.updateL.textColor = [UIColor whiteColor];
    self.updateL.font = ELEVENTEXTFONTSIZE;
    self.updateL.textAlignment = NSTextAlignmentCenter;
    self.updateL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
    [headerView addSubview:self.updateL];
    
    self.tableView.rowHeight = 10+(DR_SCREEN_WIDTH-20)/355*232;
    
    [self.tableView registerClass:[SXPayForVideoCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableFooterView = self.footView;
    
    [self createRefesh];
    
    [self request];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookKc) name:@"NOTICEFORLOOKKC" object:nil];
    //用户登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    //用户退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"outLoginClearDataNOTICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNoread) name:@"NOTICENOREADNUMMESSAGE" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"NOTICEBANGDINGKECHENG" object:nil];
}

- (void)lookKc{
    [self refreshList];
}


- (void)funClick:(UIButton *)button{
  
    if (button.tag == 0) {
        [self hasbbuyTap];
    }else if (button.tag == 1){
        if (![NoticeTools getuserId]) {
            NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        SXHasGetComController *ctl = [[SXHasGetComController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        if (![NoticeTools getuserId]) {
            NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            return;
        }
        SXKcHasGetLikeController *ctl = [[SXKcHasGetLikeController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void)requestNoread{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];

            if (stay.series_commentM.num.intValue) {
                self.comNumL.hidden = NO;
                if (stay.series_commentM.num.intValue > 99) {
                    stay.series_commentM.num = @"99+";
                }
                self.comNumL.text = stay.series_commentM.num;
              
                CGFloat width = GET_STRWIDTH(self.comNumL.text, 9, 14)+8;
                if (width < 16) {
                    width = 16;
                }
                self.comNumL.frame = CGRectMake(CGRectGetMaxX(self.comBtn.frame)-width-4, self.comBtn.frame.origin.y-4, width, 16);
            }else{
                self.comNumL.hidden = YES;
            }
            
            if (stay.series_zan_numM.num.intValue) {
                self.zanNumL.hidden = NO;
                if (stay.series_zan_numM.num.intValue > 99) {
                    stay.series_zan_numM.num = @"99+";
                }
                self.zanNumL.text = stay.series_zan_numM.num;
              
                CGFloat width = GET_STRWIDTH(self.zanNumL.text, 9, 14)+8;
                if (width < 16) {
                    width = 16;
                }
                self.zanNumL.frame = CGRectMake(CGRectGetMaxX(self.likeBtn.frame)-width-4, self.comBtn.frame.origin.y-4, width, 16);
            }else{
                self.zanNumL.hidden = YES;
            }
            
            self.updateL.hidden = stay.series_updateM.num.boolValue?NO:YES;
           
            NSString *allRedNum1 = [NSString stringWithFormat:@"%d",stay.series_updateM.num.intValue + stay.series_zan_numM.num.intValue+stay.series_commentM.num.intValue];
            if (allRedNum1.intValue) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWBUDGENOTICE" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDEBUDGENOTICE" object:nil];
            }
            //
        }
    } fail:^(NSError *error) {
    }];
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
    NSString *ifLogin = @"0";
    if ([NoticeTools getuserId]) {
        ifLogin = @"1";
    }else if ([SXTools getLocalToken] && [SXTools getLocalToken].length){
        ifLogin = @"1";
    }
    url = [NSString stringWithFormat:@"video/series/list?pageNo=%ld&isLogined=%@",self.pageNo,ifLogin];
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

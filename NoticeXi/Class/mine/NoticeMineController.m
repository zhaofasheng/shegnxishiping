//
//  NoticeMineController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeMineController.h"
#import "NoticeNewCenterNavView.h"
#import "SXUserCenterHeader.h"
#import "NoticeLoginViewController.h"
#import "SXMineSetCell.h"
#import "SXHasBuyPayVideoController.h"
#import "NoticeVoiceDownLoadController.h"
#import "NoticeMyWallectModel.h"
#import "NoticeCureentShopStatusModel.h"
#import "NoticeMyShopModel.h"
#import "NoticeMyJieYouShopController.h"
#import "SXSpulyShopView.h"
#import "NoticeHasServeredController.h"
#import "NoticeBuyOrderListController.h"
#import "SXHasBuyOrderListController.h"
#import "SXShopCheckController.h"
#import "SXSettingController.h"
#import "NoticeStaySys.h"
@interface NoticeMineController ()
@property (nonatomic, strong) NoticeNewCenterNavView *navView;
@property (nonatomic, strong) SXUserCenterHeader *headerView;

@property (nonatomic, strong) NSArray *section0imgArr;
@property (nonatomic, strong) NSArray *section0titleArr;

@property (nonatomic, strong) NSArray *section1imgArr;
@property (nonatomic, strong) NSArray *section1titleArr;

@property (nonatomic, strong) NSArray *section2imgArr;
@property (nonatomic, strong) NSArray *section2titleArr;

@property (nonatomic, strong) UIView *noLoginView;
@property (nonatomic, strong) NoticeMyWallectModel *wallectM;
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NoticeCureentShopStatusModel *applyModel;//申请状态
@property (nonatomic, assign) BOOL needAutoShowSupply;
@property (nonatomic, strong) SXSpulyShopView *supplyView;
@property (nonatomic, assign) BOOL needFirst;
@end

@implementation NoticeMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    
    self.section0titleArr = @[@"课程订单",@"已购课程",@"我的店铺",@"店铺认证"];
    self.section1titleArr = @[@"我的店铺",@"店铺认证",@"服务过的订单",@"买过的订单"];
    self.section2titleArr = @[@"缓存",@"联系客服",@"设置"];
    
    self.section0imgArr = @[@"sxorder_img",@"sxhasbuyed_img"];
    self.section1imgArr = @[@"sxMyshop_img",@"sxshopcheck_img",@"sxhasfuwurec_img",@"sxhasbuyrec_img"];
    self.section2imgArr = @[@"sxdownvideo_img",@"sxconnectkf_img",@"sxset_img"];
    
    
    NoticeNewCenterNavView *navView = [[NoticeNewCenterNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    self.navView = navView;
    [self.view addSubview:navView];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.headerView = [[SXUserCenterHeader alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 231-15)];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.rowHeight = 64;
    [self.tableView registerClass:[SXMineSetCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *footV = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 15)];
    self.tableView.tableFooterView = footV;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getStatusRequest) name:@"HASSUPPLYSHOPNOTICE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShopRequestForCheck) name:@"REFRESHMYSHOP" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getwallect) name:@"REFRESHMYWALLECT" object:nil];
    
    
    [self getwallect];
    [self getStatusRequest];
}

- (void)redCirRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.5.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success1) {
        if (success1) {
            if ([dict1[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NoticeStaySys *stay1 = [NoticeStaySys mj_objectWithKeyValues:dict1[@"data"]];
            NSString *allRedNum = [NSString stringWithFormat:@"%d",stay1.chatpriM.num.intValue + stay1.sysM.num.intValue];
            self.navView.allNumL.hidden = allRedNum.intValue?NO:YES;
            CGFloat strWidth = GET_STRWIDTH(allRedNum, 9, 14);
            if (allRedNum.intValue < 10) {
                strWidth = 14;
            }else{
                strWidth = strWidth+6;
            }
            self.navView.allNumL.text = allRedNum;
            self.navView.allNumL.frame = CGRectMake(DR_SCREEN_WIDTH-20-24+17, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-4, strWidth, 14);
        }
    } fail:^(NSError *error) {
    }];
 
}

- (void)getwallect{
    if (![NoticeTools getuserId]) {
        return;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"wallet" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            NoticeMyWallectModel *wallectM = [NoticeMyWallectModel mj_objectWithKeyValues:dict[@"data"]];
            self.wallectM = wallectM;
            NSString *allMoney = wallectM.total_balance.floatValue>0?wallectM.total_balance:@"0";
            NSString *titstr = @"鲸币";

            NSString *allStr = [NSString stringWithFormat:@"%@%@",allMoney,titstr];
            self.headerView.moneyL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#25262E"] setSize:12 setLengthString:titstr beginSize:allStr.length-2];
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
    
    [self getShopRequest];
}

- (void)getShopRequestForCheck{
    self.shopModel.myShopM.is_submit_authentication = @"1";
    [self getShopRequest];
}

//获取店铺信息和状态
- (void)getShopRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/ByUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.shopModel = [NoticeMyShopModel mj_objectWithKeyValues:dict[@"data"]];
            self.headerView.verifyModel = self.shopModel.myShopM.verifyModel;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}


//获取是否申请了店铺
- (void)getStatusRequest{
    
    if (![NoticeTools getuserId]) {
    
        return;
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/getApplyStage" Accept:@"application/vnd.shengxi.v5.3.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {

        if(success){
            self.applyModel = [NoticeCureentShopStatusModel mj_objectWithKeyValues:dict[@"data"]];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] showToastWithText:error.debugDescription];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![NoticeSaveModel getUserInfo]) {
        self.noLoginView.hidden = NO;
        self.tableView.hidden = YES;
    }else{
        _noLoginView.hidden = YES;
        self.tableView.hidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.needAutoShowSupply) {
        self.needAutoShowSupply = NO;
        [self myShopTap];
    }
    [self redCirRequest];
    [self.headerView refresh];
}

- (void)myShopTap{
    if (self.applyModel.status == 6) {//有店铺了
        NoticeMyJieYouShopController *ctl = [[NoticeMyJieYouShopController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if(self.applyModel.status == 4){//待审核
        self.supplyView.canSupply = NO;
        [self.supplyView showSupplyView];
    }else if(self.applyModel.status < 4 || self.applyModel.status == 5){//没店铺
        
        self.supplyView.canSupply = YES;
        [self.supplyView showSupplyView];
    }
}

- (SXSpulyShopView *)supplyView{
    if (!_supplyView) {
        _supplyView = [[SXSpulyShopView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _supplyView.lookRuleBlock = ^(BOOL lookRule) {
            weakSelf.needAutoShowSupply = YES;
        };
    }
    return _supplyView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            SXHasBuyPayVideoController *ctl = [[SXHasBuyPayVideoController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }else if (indexPath.row == 0){
            SXHasBuyOrderListController *ctl = [[SXHasBuyOrderListController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (!self.applyModel) {
                [self showToastWithText:@"正在获取店铺状态"];
                return;
            }
            
            [self myShopTap];
        }
        if (indexPath.row == 1) {
            if (!self.applyModel) {
                [self showToastWithText:@"正在获取店铺状态"];
                return;
            }
            if (self.applyModel.status == 6) {//有店铺了
                if (self.shopModel) {
                    SXShopCheckController *ctl = [[SXShopCheckController alloc] init];
                    ctl.shopModel = self.shopModel.myShopM;
                    [self.navigationController pushViewController:ctl animated:YES];
                }
              
            }else if(self.applyModel.status == 4){//待审核
                self.supplyView.canSupply = NO;
                [self.supplyView showSupplyView];
            }else if(self.applyModel.status < 4 || self.applyModel.status == 5){//没店铺
                
                self.supplyView.canSupply = YES;
                [self.supplyView showSupplyView];
            }
      
        }
        if (indexPath.row == 2) {
            NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
        if (indexPath.row == 3) {
            NoticeBuyOrderListController *ctl = [[NoticeBuyOrderListController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            NoticeVoiceDownLoadController *ctl = [[NoticeVoiceDownLoadController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            
            
        }else if (indexPath.row == 1){
            [NoticeComTools connectXiaoer];
          
        }else if (indexPath.row == 2){
            SXSettingController *ctl = [[SXSettingController alloc] init];
            __weak typeof(self) weakSelf = self;
            ctl.needFirstBlock = ^(BOOL needFirst) {
                weakSelf.needFirst = needFirst;
            };
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.section0imgArr.count;
    }else if (section == 1){
        return self.section1imgArr.count;
    }
    return self.section2imgArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXMineSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.subL.hidden = YES;
    [cell.backView setCornerOnTop:0];
    [cell.backView setCornerOnBottom:0];
    cell.subImageV.hidden = NO;
    if (indexPath.section == 0) {
        cell.titleImageView.image = UIImageNamed(self.section0imgArr[indexPath.row]);
        cell.titleL.text = self.section0titleArr[indexPath.row];
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:10];
        }else if(indexPath.row == self.section0imgArr.count-1){
            [cell.backView setCornerOnBottom:10];
        }
    }else if(indexPath.section == 1){
        cell.titleImageView.image = UIImageNamed(self.section1imgArr[indexPath.row]);
        cell.titleL.text = self.section1titleArr[indexPath.row];
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:10];
        }else if(indexPath.row == self.section1imgArr.count-1){
            [cell.backView setCornerOnBottom:10];
        }
        
        if (indexPath.row == 2 || indexPath.row == 3) {
            cell.subL.hidden = NO;
            cell.subImageV.hidden = YES;
            
            //服务过的订单
            if (indexPath.row == 2) {
                if (!self.shopModel) {
                    cell.subL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@单",@"0"] setSize:12 setLengthString:@"单" beginSize:1];
                }else{
                    if (!self.shopModel.myShopM.order_num.intValue) {
                        self.shopModel.myShopM.order_num = @"0";
                    }
                    cell.subL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@单",self.shopModel.myShopM.order_num] setSize:12 setLengthString:@"单" beginSize:self.shopModel.myShopM.order_num.length];
                }
            }
            if (indexPath.row == 3) {
                NSString *str = @"0";
                if (!self.wallectM.buy_order_num.intValue || !self.wallectM) {
                    str = @"0";
                }else{
                    str = self.wallectM.buy_order_num;
                }
                cell.subL.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"%@单",str] setSize:12 setLengthString:@"单" beginSize:str.length];
            }
        }
    }else{
        cell.titleImageView.image = UIImageNamed(self.section2imgArr[indexPath.row]);
        cell.titleL.text = self.section2titleArr[indexPath.row];
        if (indexPath.row == 0) {
            [cell.backView setCornerOnTop:10];
        }else if(indexPath.row == self.section2imgArr.count-1){
            [cell.backView setCornerOnBottom:10];
        }
    }
    return cell;
}


- (UIView *)noLoginView{
    if (!_noLoginView) {
        _noLoginView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT)];
        _noLoginView.backgroundColor = self.view.backgroundColor;
        
        CGFloat space = (DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-329)/2;
        
        UIImageView *nologinImageV = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-258)/2, space, 258, 212)];
        nologinImageV.image = UIImageNamed(@"sxminenologin_img");
        [_noLoginView addSubview:nologinImageV];
        
        UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-140)/2, CGRectGetMaxY(nologinImageV.frame)+69, 140, 48)];
        [button setAllCorner:24];
        button.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = EIGHTEENTEXTFONTSIZE;
        [_noLoginView addSubview:button];
        [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_noLoginView];
    }
    return _noLoginView;
}

- (void)loginClick{
    NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end

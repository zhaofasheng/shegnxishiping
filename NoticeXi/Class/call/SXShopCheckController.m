//
//  SXShopCheckController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopCheckController.h"
#import "SXShopCheckTypeCell.h"
#import "SXEducationController.h"
#import "SXWorkCheckController.h"
#import "SXZiGeCheckController.h"
#import "SXWebViewController.h"
#import "SXShopCheckWaitEdcView.h"
#import "SXZiGeCheckView.h"
#import "SXWorkCheckView.h"

@interface SXShopCheckController ()

@property (nonatomic, strong) SXShopCheckWaitEdcView *waitOrSuccessView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *xieyBtn;
@property (nonatomic, strong) SXZiGeCheckView *zigeWaitOrSuccessView;
@property (nonatomic, strong) SXWorkCheckView *workWaitOrSuccessView;

@property (nonatomic, strong) SXVerifyShopModel *verifyModel;
@property (nonatomic, assign) BOOL hasGetData;

@property (nonatomic, strong) UILabel *upDataBtn;
@end

@implementation SXShopCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = @"店铺认证";
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    self.tableView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 100)];
    UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 100-45, DR_SCREEN_WIDTH, 25)];
    titleL.font = XGEightBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
    titleL.text = @"请选择一种类型进行认证";
    titleL.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleL];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[SXShopCheckTypeCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = 130;
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame)+5, DR_SCREEN_WIDTH-40, 40)];
    [addBtn setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    [addBtn setAttributedTitle:[DDHAttributedMode setColorString:@"认证即同意《认证服务协议》" setColor:[UIColor colorWithHexString:@"#8A8F99"] setLengthString:@"认证及同意" beginSize:0] forState:UIControlStateNormal];
    addBtn.titleLabel.font = THRETEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(xieyiClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    self.xieyBtn = addBtn;
    
    if ((self.shopModel.verifyModel.verify_status.intValue > 0) || self.shopModel.is_submit_authentication.intValue == 1) {//认证通过或者提交过审核
        
        if (self.shopModel.verifyModel.verify_status.intValue != 4) {
            self.type = 9;
        }
        [self requestStatus];
    }
}

- (void)xieyiClick{//
    SXWebViewController * webctl = [[SXWebViewController alloc] init];
    webctl.url = @"http://priapi.byebyetext.com/authentication.html";
    [self.navigationController pushViewController:webctl animated:YES];
}

- (void)refresUI{
    
    if (self.type == 1 || self.type == 2) {//学历认证了
        self.tableView.tableHeaderView = self.waitOrSuccessView;
        self.waitOrSuccessView.verifyM = self.verifyModel;
        if (self.type == 2) {
            self.waitOrSuccessView.statusL1.textColor = [UIColor colorWithHexString:@"#14151A"];
            self.waitOrSuccessView.statusL2.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        }
    }
    
    if (self.type == 3 || self.type == 4) {//资格认证了
        self.tableView.tableHeaderView = self.zigeWaitOrSuccessView;
        self.zigeWaitOrSuccessView.verifyM = self.verifyModel;
        if (self.type == 4) {
            self.zigeWaitOrSuccessView.statusL1.textColor = [UIColor colorWithHexString:@"#14151A"];
            self.zigeWaitOrSuccessView.statusL2.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        }
    }
    
    if (self.type == 1 || self.type == 3) {//认证审核中
        self.backView.hidden = NO;
        self.workWaitOrSuccessView.verifyM = self.verifyModel;
        [self.navBarView.backButton setImage: UIImageNamed(@"sxwhitebackpopo_img") forState:UIControlStateNormal];
        self.navBarView.titleL.textColor = [UIColor whiteColor];
    }
    
    if (self.type == 5) {//职业认证了
        self.tableView.tableHeaderView = self.workWaitOrSuccessView;
    }

    if (self.type > 0) {
        self.xieyBtn.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)requestStatus{
    [self showHUD];
    _upDataBtn.hidden = YES;
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/authenticationInfo" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            self.verifyModel = [SXVerifyShopModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.shopModel.verifyModel.verify_status.intValue == 4) {
                return;
            }
            if (self.verifyModel.verify_status.intValue == 4 || self.verifyModel.verify_status.intValue < 2) {//审核失败或者未提交认证信息
                self.type = 0;
            }else{
                if (self.verifyModel.verify_status.intValue == 2) {//待审核
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYSHOP" object:nil];
                    if (self.verifyModel.authentication_type.intValue == 1) {//学历认证
                        self.type = 1;
                        self.waitOrSuccessView.verifyM = self.verifyModel;
                    }else if (self.verifyModel.authentication_type.intValue == 3){
                        self.zigeWaitOrSuccessView.verifyM = self.verifyModel;
                        self.type = 3;
                    }
                }else if (self.verifyModel.verify_status.intValue == 3){//审核通过
                    self.upDataBtn.hidden = NO;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYSHOP" object:nil];
                    if (self.verifyModel.authentication_type.intValue == 1) {//学历认证
                        self.waitOrSuccessView.verifyM = self.verifyModel;
                        self.type = 2;
                    }else if (self.verifyModel.authentication_type.intValue == 3){
                        self.zigeWaitOrSuccessView.verifyM = self.verifyModel;
                        self.type = 4;
                    }else if (self.verifyModel.authentication_type.intValue == 2){
                        self.workWaitOrSuccessView.verifyM = self.verifyModel;
                        self.type = 5;
                    }
                }
            }
            [self refresUI];
            [self.tableView reloadData];
        }else{
            self.type = 0;
        }
        [self.tableView reloadData];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)updataCheck{
    if (self.verifyModel.authentication_type.intValue == 1) {
        SXEducationController *ctl = [[SXEducationController alloc] init];
        ctl.verifyModel = self.verifyModel;
        ctl.shopId = self.shopModel.shopId;
        ctl.isUpdate = YES;
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.shopModel.verifyModel.verify_status = @"2";
            [weakSelf requestStatus];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (self.verifyModel.authentication_type.intValue == 2){
        SXWorkCheckController *ctl = [[SXWorkCheckController alloc] init];
        ctl.verifyModel = self.verifyModel;
        ctl.shopId = self.shopModel.shopId;
        ctl.isUpdate = YES;
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.shopModel.verifyModel.verify_status = @"2";
            [weakSelf requestStatus];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        SXZiGeCheckController *ctl = [[SXZiGeCheckController alloc] init];
        ctl.verifyModel = self.verifyModel;
        ctl.shopId = self.shopModel.shopId;
        ctl.isUpdate = YES;
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.shopModel.verifyModel.verify_status = @"2";
            [weakSelf requestStatus];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UILabel *)upDataBtn{
    if (!_upDataBtn) {
        CGFloat width = GET_STRWIDTH(@"更新认证", 14, 30);
        _upDataBtn = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-width, STATUS_BAR_HEIGHT, width, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        _upDataBtn.font = FOURTHTEENTEXTFONTSIZE;
        _upDataBtn.textColor = [UIColor colorWithHexString:@"#14151A"];
        _upDataBtn.text = @"更新认证";
        [self.navBarView addSubview:_upDataBtn];
        _upDataBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updataCheck)];
        [_upDataBtn addGestureRecognizer:tap];
    }
    return _upDataBtn;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT+97+40)];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [self.view addSubview:_backView];
        [self.view sendSubviewToBack:_backView];
    }
    return _backView;
}

- (SXShopCheckWaitEdcView *)waitOrSuccessView{
    if (!_waitOrSuccessView) {
        _waitOrSuccessView = [[SXShopCheckWaitEdcView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 300)];
    }
    return _waitOrSuccessView;
}

- (SXZiGeCheckView *)zigeWaitOrSuccessView{
    if (!_zigeWaitOrSuccessView) {
        _zigeWaitOrSuccessView = [[SXZiGeCheckView  alloc] initWithFrame:CGRectZero];
    }
    return _zigeWaitOrSuccessView;
}

- (SXWorkCheckView *)workWaitOrSuccessView{
    if (!_workWaitOrSuccessView) {
        _workWaitOrSuccessView = [[SXWorkCheckView  alloc] initWithFrame:CGRectZero];
    }
    return _workWaitOrSuccessView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SXEducationController *ctl = [[SXEducationController alloc] init];
        ctl.verifyModel = self.verifyModel;
        ctl.shopId = self.shopModel.shopId;
        if (self.shopModel.verifyModel.verify_status.intValue == 4) {
            ctl.isCheckFail = YES;
        }
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.shopModel.verifyModel.verify_status = @"2";
            [weakSelf requestStatus];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 1){
        SXWorkCheckController *ctl = [[SXWorkCheckController alloc] init];
        ctl.verifyModel = self.verifyModel;
        ctl.shopId = self.shopModel.shopId;
        if (self.shopModel.verifyModel.verify_status.intValue == 4) {
            ctl.isCheckFail = YES;
        }
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.shopModel.verifyModel.verify_status = @"2";
            [weakSelf requestStatus];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        SXZiGeCheckController *ctl = [[SXZiGeCheckController alloc] init];
        ctl.verifyModel = self.verifyModel;
        ctl.shopId = self.shopModel.shopId;
        if (self.shopModel.verifyModel.verify_status.intValue == 4) {
            ctl.isCheckFail = YES;
        }
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.shopModel.verifyModel.verify_status = @"2";
            [weakSelf requestStatus];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SXShopCheckTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.type = indexPath.row;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type) {
        return 0;
    }
    return 3;
}

@end

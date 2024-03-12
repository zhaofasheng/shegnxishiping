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
}

- (void)xieyiClick{//
    SXWebViewController * webctl = [[SXWebViewController alloc] init];
    webctl.url = @"http://priapi.byebyetext.com/authentication.html";
    [self.navigationController pushViewController:webctl animated:YES];
}

- (void)refresUI{
    
    if (self.type == 1 || self.type == 2) {
        self.tableView.tableHeaderView = self.waitOrSuccessView;
        if (self.type == 2) {
            self.waitOrSuccessView.statusL1.textColor = [UIColor colorWithHexString:@"#14151A"];
            self.waitOrSuccessView.statusL2.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        }
    }
    
    if (self.type == 3 || self.type == 4) {
        self.tableView.tableHeaderView = self.zigeWaitOrSuccessView;
        if (self.type == 4) {
            self.zigeWaitOrSuccessView.statusL1.textColor = [UIColor colorWithHexString:@"#14151A"];
            self.zigeWaitOrSuccessView.statusL2.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        }
    }
    if (self.type == 1 || self.type == 3) {
        self.backView.hidden = NO;
        [self.navBarView.backButton setImage: UIImageNamed(@"sxwhitebackpopo_img") forState:UIControlStateNormal];
        self.navBarView.titleL.textColor = [UIColor whiteColor];
    }
    
    if (self.type == 5) {
        self.tableView.tableHeaderView = self.workWaitOrSuccessView;
    }

    if (self.type > 0) {
        self.xieyBtn.hidden = YES;
    }
    [self.tableView reloadData];
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
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.type = type;
            [weakSelf refresUI];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (indexPath.row == 1){
        SXWorkCheckController *ctl = [[SXWorkCheckController alloc] init];
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.type = type;
            [weakSelf refresUI];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        SXZiGeCheckController *ctl = [[SXZiGeCheckController alloc] init];
        __weak typeof(self) weakSelf = self;
        ctl.upsuccessBlock = ^(NSInteger type) {
            weakSelf.type = type;
            [weakSelf refresUI];
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

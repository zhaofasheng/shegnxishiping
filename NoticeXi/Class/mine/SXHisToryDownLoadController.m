//
//  SXHisToryDownLoadController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHisToryDownLoadController.h"
#import "SXHistoryModel.h"
@interface SXHisToryDownLoadController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *topicField;
@end

@implementation SXHisToryDownLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.titleL.text = self.isTuikuan?@"申请退款":@"历史数据下载";
    
    UIView *headerView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 310)];
    self.tableView.tableHeaderView = headerView;
    
    UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 290)];
    backView.backgroundColor = [UIColor whiteColor];
    [backView setAllCorner:8];
    [headerView addSubview:backView];
    
    UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(20, 40, DR_SCREEN_WIDTH-70, 25)];
    titleL.font = XGEightBoldFontSize;
    titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
    [backView addSubview:titleL];
    titleL.text = self.isTuikuan?@"请输入你的支付宝账号":@"请输入你的邮箱";
    
    UILabel *titleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(20, 69, DR_SCREEN_WIDTH-70, 17)];
    titleL1.font = TWOTEXTFONTSIZE;
    titleL1.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    [backView addSubview:titleL1];
    titleL1.text = self.isTuikuan?@"审核无误，对应的金额将退至你的支付宝，注意查收！":@"你在声昔所发布过的内容稍后将发送至邮箱";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20,202,DR_SCREEN_WIDTH-80, 48);
    [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    btn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [btn setAllCorner:24];
    btn.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:1];
    [btn addTarget:self action:@selector(fifinshClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    [btn setTitle:self.isTuikuan?@"确认":@"下载" forState:UIControlStateNormal];
    
    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0,DR_SCREEN_WIDTH-90, 56)];
    self.topicField.tintColor = [UIColor colorWithHexString:@"#1FC7FF"];
    self.topicField.font = FOURTHTEENTEXTFONTSIZE;
    self.topicField.textColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:1];
    self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.isTuikuan?@"请输入支付宝账号": @"请输入邮箱" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1]}];
    [self.topicField setupToolbarToDismissRightButton];
    self.topicField.delegate = self;
    self.topicField.textAlignment = NSTextAlignmentCenter;
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[self.topicField valueForKey:@"_clearButton"] setImage:UIImageNamed(@"clear_button.png") forState:UIControlStateNormal];


    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(20, 126, DR_SCREEN_WIDTH-80, 56)];
    [backV setAllCorner:8];
    backV.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    [backV addSubview:self.topicField];
    [backView addSubview:backV];
}

- (void)fifinshClick{
    [self.topicField resignFirstResponder];
    if (!self.isTuikuan) {
        
        [self showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/historyDataDownload/info" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                
                SXHistoryModel *model = [SXHistoryModel mj_objectWithKeyValues:dict[@"data"]];
            
                if (model.isRepeated.boolValue) {
                    __weak typeof(self) weakSelf = self;
                    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"你已提交过邮箱了，要再次提交吗？" message:self.topicField.text sureBtn:@"再想想" cancleBtn:@"提交" right:YES];
                    alerView.resultIndex = ^(NSInteger index) {
                        if (index == 2) {
                            [weakSelf upEmail];
                        }
                    };
                    [alerView showXLAlertView];
                }else{
                    [self upEmail];
                }
              
            }
            
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
        
        return;
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/refund/info" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            SXHistoryModel *model = [SXHistoryModel mj_objectWithKeyValues:dict[@"data"]];
            
            if (!model.isUpgraded.boolValue) {
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"你未使用过「在线升级」，不支持退款" message:nil cancleBtn:@"知道了"];
                [alerView showXLAlertView];
                return;
            }
            
            if (model.isRepeated.boolValue) {
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"你的账号已申请过退款，不可再次申请" message:nil cancleBtn:@"知道了"];
                [alerView showXLAlertView];
                return;
            }
            [self getStatus];
        }
        
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
    
}

- (void)upEmail{
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.topicField.text forKey:@"email"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/historyDataDownload" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self showToastWithText:@"邮箱提交成功，后续系统会把您历史数据发送至您的邮箱"];
        }
        [self showHUD];
    } fail:^(NSError * _Nullable error) {
        [self showHUD];
    }];
}

- (void)getStatus{
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:self.isTuikuan?@"请核实支付宝账号":@"请核实邮箱地址" message:self.topicField.text sureBtn:@"再想想" cancleBtn:@"确认" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf backMoney];
        }
    };
    [alerView showXLAlertView];
}

- (void)backMoney{
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.topicField.text forKey:@"refund_account"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"user/refund" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self showToastWithText:@"申请成功，请耐心等待以及留意到账提醒"];
        }
        [self showHUD];
    } fail:^(NSError * _Nullable error) {
        [self showHUD];
    }];
}

@end

//
//  SXHisToryDownLoadController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHisToryDownLoadController.h"

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
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:self.isTuikuan?@"请再次核实支付宝账号":@"请再次核实邮箱地址" message:self.topicField.text sureBtn:@"再想想" cancleBtn:@"确认" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
           
        }
    };
    [alerView showXLAlertView];
}

@end

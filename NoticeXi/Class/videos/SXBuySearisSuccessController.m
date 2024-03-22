//
//  SXBuySearisSuccessController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBuySearisSuccessController.h"
#import "SXBuySearisSuccessView.h"
#import "SXStudyBaseController.h"
@interface SXBuySearisSuccessController ()
@property (nonatomic, strong) SXBuySearisSuccessView *headerView;
@end

@implementation SXBuySearisSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView = [[SXBuySearisSuccessView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.paySearModel = self.paySearModel;
    self.headerView.payStatusModel = self.payStatusModel;
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    
    if (self.payStatusModel.pay_status.intValue == 2) {
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backView];
        
        UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(20,5,DR_SCREEN_WIDTH-40, 40)];
        [button setAllCorner:20];
        button.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [button setTitle:@"查看课程" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [backView addSubview:button];
        [button addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)backClick{
    if (!self.isFromList && self.payStatusModel.pay_status.intValue == 2) {
        __block UIViewController *pushVC;
        __weak typeof(self) weakSelf = self;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[SXStudyBaseController class]]) {//返回到指定界面
                pushVC = obj;
                [weakSelf.navigationController popToViewController:pushVC animated:YES];
                return ;
            }
        }];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lookClick{
    if (self.isFromList) {
        SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
        ctl.paySearModel = self.paySearModel;
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    
    __block UIViewController *pushVC;
    __weak typeof(self) weakSelf = self;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SXStudyBaseController class]]) {//返回到指定界面
            pushVC = obj;
            [weakSelf.navigationController popToViewController:pushVC animated:YES];
            return ;
        }
    }];
}

@end

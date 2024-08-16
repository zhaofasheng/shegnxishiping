//
//  NoticeUserInfoCenterController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/25.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeUserInfoCenterController.h"
#import "NoticeSCViewController.h"
#import "SXUserCenterHeaderView.h"
#import "NoticeManagerUserAction.h"
#import "NoticeXi-Swift.h"
//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()
@interface NoticeUserInfoCenterController ()<NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeManagerUserAction *actionModel;
@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) SXUserCenterHeaderView *headerView;
@property (nonatomic, strong) NoticeManager *magager;
@end

@implementation NoticeUserInfoCenterController



- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.userId) {
        if ([self.userId isEqualToString:[NoticeTools getuserId]]) {
            self.isOther = NO;
        }else{
            self.isOther = YES;
        }
    }

    if (self.isOther) {
        self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
        UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(68, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT+(TAB_BAR_HEIGHT-50)/2, DR_SCREEN_WIDTH-68*2, 50)];
        chatBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [chatBtn setAllCorner:25];
        [chatBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        chatBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [chatBtn setTitle:@"发私信" forState:UIControlStateNormal];
        [self.view addSubview:chatBtn];
        [chatBtn addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-30,STATUS_BAR_HEIGHT, 30,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        [moreBtn setImage: [UIImage imageNamed:@"img_scb_b"]  forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(jubaoClick) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:moreBtn];
    }
    
    self.headerView = [[SXUserCenterHeaderView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.tableView.tableHeaderView = self.headerView;
    
    [self requestUserInfo];
  
}

- (void)jubaoClick{
    if ([[NoticeTools getuserId] isEqualToString:@"1"]) {
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:self.actionModel.flag.boolValue?@"解除仙人掌":@"设为仙人掌" message:nil sureBtn:@"取消" cancleBtn:@"确定" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                weakSelf.magager.type = self.actionModel.flag.boolValue?@"解除仙人掌":@"设为仙人掌";
                [weakSelf.magager show];
            }
        };
        [alerView showXLAlertView];
        return;
    }
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.userId;
    juBaoView.reouceType = @"4";
    [juBaoView showView];
}


- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}


- (void)sureManagerClick:(NSString *)code{

    [self showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:self.actionModel.flag.boolValue?@"0": @"1" forKey:@"flag"];
    [parm setObject:code forKey:@"confirmPasswd"];
    
    [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"admin/users/%@",self.userId] Accept:nil parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            self.actionModel.flag = self.actionModel.flag.boolValue?@"0": @"1";
            [self showToastWithText:@"操作已执行"];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}



- (void)chatClick{
    NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
    vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.userId];
    vc.toUserId = self.userId;
    vc.navigationItem.title = self.userM.nick_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestUserInfo{
    
    if(self.isOther){//获取用当前惩罚状态
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/getPunish/%@",self.userId] Accept:@"application/vnd.shengxi.v5.5.9+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
            if (success) {
                self.actionModel = [NoticeManagerUserAction mj_objectWithKeyValues:dict1[@"data"]];
            }
        } fail:^(NSError *error) {
            
        }];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",self.isOther?self.userId: [[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.userM = userIn;
            self.headerView.userM = self.userM;
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

@end

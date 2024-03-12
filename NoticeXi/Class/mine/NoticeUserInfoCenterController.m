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
#import "NoticeXi-Swift.h"
//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()
@interface NoticeUserInfoCenterController ()

@property (nonatomic, strong) NoticeUserInfoModel *userM;
@property (nonatomic, strong) SXUserCenterHeaderView *headerView;
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
    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
    juBaoView.reouceId = self.userId;
    juBaoView.reouceType = @"4";
    [juBaoView showView];
}

- (void)chatClick{
    NoticeSCViewController *vc = [[NoticeSCViewController alloc] init];
    vc.toUser = [NSString stringWithFormat:@"%@%@",socketADD,self.userId];
    vc.toUserId = self.userId;
    vc.navigationItem.title = self.userM.nick_name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestUserInfo{
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

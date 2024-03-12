//
//  NoticeVipCenterController.m
//  NoticeXi
//
//  Created by li lei on 2023/8/30.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipCenterController.h"
#import "NoticeMerchantController.h"
#import "NoticePayView.h"
#import "NoticeXi-Swift.h"
#import "NoticeVipQuanYiView.h"
#import "NoticeSendPointsView.h"
#import "NoticeChangeSkinListController.h"
#import "NoticeExchangeController.h"
@interface NoticeVipCenterController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NoticeVipLelveView *vipHeader;
@property (nonatomic, strong) NoticeVipQuanYiView *quanyiView;
@property (nonatomic, strong) NoticeSendPointsView *sendPointsView;
@end


@implementation NoticeVipCenterController

- (NoticeSendPointsView *)sendPointsView{
    if (!_sendPointsView) {
        _sendPointsView = [[NoticeSendPointsView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _sendPointsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-50);
    self.tableView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,self.tableView.frame.size.height)];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.vipHeader = [[NoticeVipLelveView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 97+DR_SCREEN_WIDTH-100+27)];
    [self.headerView addSubview:self.vipHeader];
  
    __weak typeof(self)weakSelf = self;
    self.vipHeader.upClickBlock = ^(BOOL up) {
        if(weakSelf.goUpLelveBlock){
            weakSelf.goUpLelveBlock(YES);
        }
    };
    
    
    CGFloat space = (DR_SCREEN_WIDTH-85)/4+15;
    self.quanyiView = [[NoticeVipQuanYiView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.vipHeader.frame), DR_SCREEN_WIDTH, 22+space*2+84+201+ (self.noSkinBlock?0: 222))];
    [self.headerView addSubview:self.quanyiView];
    self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, CGRectGetMaxY(self.quanyiView.frame));
    self.quanyiView.FunBlock = ^(NSInteger tag) {
        if (tag == 0) {
            [weakSelf.sendPointsView show];
        }else{
            NoticeExchangeController *ctl = [[NoticeExchangeController alloc] init];
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }
    };
    self.quanyiView.skinBlock = ^(NSInteger tag) {
        NoticeChangeSkinListController *ctl = [[NoticeChangeSkinListController alloc] init];
        [weakSelf.navigationController pushViewController:ctl animated:YES];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:@"REFRESHUUSERINFOFORNOTICATION" object:nil];
}

- (void)refreshUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
       
   
            if (userIn.token) {
              [NoticeSaveModel saveToken:userIn.token];
            }
            [NoticeSaveModel saveUserInfo:userIn];
            self.quanyiView.userM = userIn;
            [self.vipHeader refreshData];
        }
    } fail:^(NSError *error) {
        if([NoticeComTools pareseError:error]){
            [self.noNetWorkView show];
        }
    }];
}




@end

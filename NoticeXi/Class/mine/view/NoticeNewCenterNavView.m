//
//  NoticeNewCenterNavView.m
//  NoticeXi
//
//  Created by li lei on 2021/4/9.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeNewCenterNavView.h"
#import "NoticeManager.h"
#import "NoticeSCListViewController.h"
#import "NoticeManagerController.h"
#import "NoticeSearchPersonViewController.h"
@interface NoticeNewCenterNavView()<NoticeManagerUserDelegate>
@property (nonatomic, strong) NoticeManager *magager;
@end

@implementation NoticeNewCenterNavView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
      
        
        UIButton *msgBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
        [msgBtn1 setBackgroundImage:UIImageNamed(@"msgClick_img") forState:UIControlStateNormal];
        [self addSubview:msgBtn1];
        [msgBtn1 addTarget:self action:@selector(msgClick1) forControlEvents:UIControlEventTouchUpInside];
        
        self.allNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24+17,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-2, 14, 14)];
        self.allNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        self.allNumL.layer.cornerRadius = 7;
        self.allNumL.layer.masksToBounds = YES;
        self.allNumL.textColor = [UIColor whiteColor];
        self.allNumL.font = [UIFont systemFontOfSize:9];
        self.allNumL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.allNumL];
        self.allNumL.hidden = YES;
        
        if ([NoticeTools isManager]) {
            UIButton *manageBtn = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-100,STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
            [manageBtn setTitle:@"管理" forState:UIControlStateNormal];
            [manageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            manageBtn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
            [manageBtn addTarget:self action:@selector(managerClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:manageBtn];
            
            UIButton *manageBtn1 = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-100-55,STATUS_BAR_HEIGHT, 50, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
            [manageBtn1 setTitle:@"搜索" forState:UIControlStateNormal];
            [manageBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            manageBtn1.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
            [manageBtn1 addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:manageBtn1];
        }
    }
    return self;
}

- (void)searchClick{
    NoticeSearchPersonViewController *ctl = [[NoticeSearchPersonViewController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)managerClick{
    
    self.magager.type = @"管理员登陆";
    [self.magager show];
}


- (void)sureManagerClick:(NSString *)code{
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/users/login" Accept:nil isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            [self.magager removeFromSuperview];
            NoticeManagerController *ctl = [[NoticeManagerController alloc] init];
            ctl.mangagerCode = code;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }else{
            self.magager.markL.text = @"密码错误请重新输入";
        }
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (void)msgClick1{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:[NoticeTools getTopViewController].navigationController.view];
    [[NoticeTools getTopViewController].navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSCListViewController *ctl = [[NoticeSCListViewController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
}


@end

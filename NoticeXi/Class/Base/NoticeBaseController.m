//
//  NoticeBaseController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseController.h"

@interface NoticeBaseController ()<UIGestureRecognizerDelegate>

@end

@implementation NoticeBaseController


- (void)didReceiveMemoryWarning{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.useSystemeNav) {
        self.navBarView.hidden = NO;
        [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    }

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    // 网路改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChange) name:HWNetworkingReachabilityDidChangeNotification object:nil];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    

}

- (void)dealloc{
    DRLog(@"销毁控制器");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //加上这句话，防止回到跟视图页面卡
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
  
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = true;
       
    }

}

- (void)networkingReachabilityDidChange{
    if ([[HWNetworkReachabilityManager shareManager] networkReachabilityStatus] != AFNetworkReachabilityStatusNotReachable) {//有网络的时候自动刷新
        [self hasNetWork];
    }
}

- (void)hasNetWork{
    DRLog(@"来网络了");
}

- (void)backClick{

    [self.navigationController popViewControllerAnimated:YES];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.hidden = YES;
        _navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}



@end

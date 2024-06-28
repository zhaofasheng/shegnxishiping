//
//  SXPayVideoComController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/28.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayVideoComController.h"

@interface SXPayVideoComController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@end

@implementation SXPayVideoComController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
}

- (void)refreshStatus{

    self.tableView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-(self.paySearModel.is_bought.boolValue?0:TAB_BAR_HEIGHT));
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshStatus];
    
}


- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


@end

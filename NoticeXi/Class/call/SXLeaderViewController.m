//
//  SXLeaderViewController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/4.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXLeaderViewController.h"

@interface SXLeaderViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation SXLeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView.hidden = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH*2, DR_SCREEN_HEIGHT);
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    NSArray *imageArr = @[@"sx_shop_lead1_img",@"sx_shop_lead2_img"];
    for (int i = 0; i < 2; i++) {
        UIImageView *imagev = [[UIImageView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH*i, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        imagev.image = UIImageNamed(imageArr[i]);
        [scrollView addSubview:imagev];
        imagev.contentMode = UIViewContentModeScaleAspectFill;
        imagev.clipsToBounds = YES;
    }
    
    CGFloat controlHeight = 35.0f;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-controlHeight, DR_SCREEN_WIDTH, controlHeight)];
    self.pageControl.pageIndicatorTintColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.3];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jumpBtn.frame = CGRectMake(DR_SCREEN_WIDTH-15-70, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, 70, 32);
    [jumpBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [jumpBtn setTitle:@"跳过" forState:UIControlStateNormal];
    jumpBtn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
    jumpBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    [jumpBtn setAllCorner:16];
    [jumpBtn addTarget:self action:@selector(jumpClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];
}

- (void)jumpClick{
    [SXTools setMarkFornofirst];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;

    // 设置页码
    self.pageControl.currentPage = page;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
}

@end

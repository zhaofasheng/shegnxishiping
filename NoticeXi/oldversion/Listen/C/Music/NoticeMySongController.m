//
//  NoticeMySongController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeMySongController.h"
#import "NoticeMySongListController.h"
#import "NoticeNoticenterModel.h"
#import "NoticeMyMovieComController.h"
#import "NoticeCustumBackImageView.h"
@interface NoticeMySongController ()
@property (nonatomic, strong) NoticeMyMovieComController *vcAll;
@property (nonatomic, strong) NoticeMySongListController *vclike;
@property (nonatomic, strong) NoticeMySongListController *vcMid;
@property (nonatomic, strong) UIView *mbsView;
@property (nonatomic, strong) NoticeCustumBackImageView *backGroundImageView;
@end

@implementation NoticeMySongController

- (instancetype)init {
    if (self = [super init]) {
        self.titles = @[[NoticeTools getLocalStrWith:@"music.song"],[NoticeTools getLocalStrWith:@"movie.wantlisten"],[NoticeTools getLocalStrWith:@"movie.listened"]];
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = true;
        self.dataSource = self;
        self.delegate = self;
        self.menuView.delegate = self;
        self.progressWidth = GET_STRWIDTH([NoticeTools getLocalStrWith:@"music.song"], 20, 18);
        self.progressHeight = 2;
        self.titleSizeNormal = 17;
        self.titleSizeSelected = 17;
        self.progressViewBottomSpace = 0;
        self.progressColor = [UIColor colorWithHexString:@"#05A8FA"];
        self.titleColorNormal = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
        self.titleColorSelected = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.view.backgroundColor = [[UIColor colorWithHexString:@"#14151A"] colorWithAlphaComponent:0];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"music.my"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarView.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (NoticeCustumeNavView *)navBarView{
    if (!_navBarView) {
        _navBarView = [[NoticeCustumeNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
        [self.view addSubview:_navBarView];
        _navBarView.hidden = YES;
        _navBarView.titleL.text = self.navigationItem.title;
        [_navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBarView;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    return CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,48);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView{
    return CGRectMake(0,48+NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-48);
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return  GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.listened"], 20, 18);
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    if (self.isOther) {
        return (DR_SCREEN_WIDTH- GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.listened"], 20, 18)*2)/3;
    }
    return (DR_SCREEN_WIDTH- GET_STRWIDTH([NoticeTools getLocalStrWith:@"movie.listened"], 20, 18)*3)/4;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index{
    switch (state) {
        case WMMenuItemStateSelected: return [UIColor colorWithHexString:@"#FFFFFF"];
        case WMMenuItemStateNormal: return [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.7];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (index == 0) {
        return self.vcAll;
    }else if(index == 1){
        return self.vclike;
    }else {
        return self.vcMid;
    }
}
- (NoticeMyMovieComController *)vcAll{
    if (!_vcAll) {
        _vcAll = [[NoticeMyMovieComController alloc] init];
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _vcAll.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _vcAll.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        }
        _vcAll.type = 3;
    }
    return _vcAll;
}
- (NoticeMySongListController *)vclike{
    if (!_vclike) {
        _vclike = [[NoticeMySongListController alloc] init];
        _vclike.userId = self.userId;
        _vclike.isOther = self.isOther;
        _vclike.type = 2;
        _vclike.realisAbout = self.realisAbout;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _vclike.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _vclike.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        }
    }
    return _vclike;
}
- (NoticeMySongListController *)vcMid{
    if (!_vcMid) {
        _vcMid = [[NoticeMySongListController alloc] init];
        
        _vcMid.userId = self.userId;
        _vcMid.isOther = self.isOther;
        _vcMid.type = 3;
        _vcMid.realisAbout = self.realisAbout;
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.backImg) {
            _vcMid.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
            _vcMid.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        }
    }
    return _vcMid;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.vcAll.isReplay = YES;
    [self.vcAll.audioPlayer stopPlaying];
}
@end

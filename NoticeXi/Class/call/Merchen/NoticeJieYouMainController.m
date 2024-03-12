//
//  NoticeJieYouMainController.m
//  NoticeXi
//
//  Created by li lei on 2022/9/1.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouMainController.h"

#import "NoticeXi-Swift.h"

#import "NoticePhoneChatView.h"
#import "Notice3DshopListView.h"
#import "SPMultipleSwitch.h"

@interface NoticeJieYouMainController ()
@property (nonatomic, strong) UIImageView *nightImaegview;
@property (nonatomic, strong) UILabel *allNumL;
@property (nonatomic, strong) UIImageView *bgImaegview;
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, assign) BOOL openButton;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, strong) NSString *isExperience;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIView *markView;
@property (nonatomic, strong) UILabel *shopNumL;
@property (nonatomic, strong) Notice3DshopListView *listView;
@property (nonatomic, strong) NoticePhoneChatView *phoneChatView;
@property (nonatomic, assign) BOOL isCallPhone;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) BOOL hasClick;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *markL;
@end

@implementation NoticeJieYouMainController

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] initWithFrame:CGRectMake(60, (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-80)/2, DR_SCREEN_WIDTH-120, 80)];
        _defaultL.textAlignment = NSTextAlignmentCenter;
        _defaultL.numberOfLines = 0;
        _defaultL.font = SIXTEENTEXTFONTSIZE;
        _defaultL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _defaultL.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [_defaultL setAllCorner:10];
        _defaultL.text = @"当前没有能免费试聊的店铺\n去看看付费店铺吧～";
        [self.bgImaegview addSubview:_defaultL];
        [self.bgImaegview bringSubviewToFront:self.phoneChatView];
    }
    return _defaultL;
}


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.type = @"2";
    self.isExperience = @"1";
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
    
    self.bgImaegview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sky_13"]];
    self.bgImaegview.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT);
    self.bgImaegview.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImaegview.clipsToBounds = YES;
    [self.view addSubview: self.bgImaegview];
    self.bgImaegview.userInteractionEnabled = YES;
    
    self.nightImaegview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    self.nightImaegview.contentMode = UIViewContentModeScaleAspectFill;
    self.nightImaegview.clipsToBounds = YES;
    self.nightImaegview.image = UIImageNamed(@"yekongnightxx_img");
    self.nightImaegview.userInteractionEnabled = YES;
    [self.bgImaegview addSubview:self.nightImaegview];
    
    self.nightImaegview.frame = CGRectMake(0, 0, hypotf(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT), hypotf(DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT));
    self.nightImaegview.center = self.bgImaegview.center;
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 400;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.nightImaegview.layer addAnimation:animation forKey:nil];
    
    CGFloat imgHeight = DR_SCREEN_WIDTH * (283.33/375);
    
    UIImageView *whateImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-imgHeight-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, imgHeight)];
    whateImageView.contentMode = UIViewContentModeScaleAspectFill;
    whateImageView.clipsToBounds = YES;
    whateImageView.image = UIImageNamed(@"rainwhate_img");
    [self.bgImaegview addSubview: whateImageView];
    whateImageView.userInteractionEnabled = YES;
    
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bgImaegview.frame.size.height-158-41-30, DR_SCREEN_WIDTH, 21+22)];
    self.markView.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0];
    [self.bgImaegview addSubview:self.markView];
    
    UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH, 22)];
    markL.text = @"摘个星星 和我说说话";
    markL.font = SIXTEENTEXTFONTSIZE;
    markL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    markL.textAlignment = NSTextAlignmentCenter;
    [self.markView addSubview:markL];
    self.markL.hidden = NO;
    
    self.shopNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, DR_SCREEN_WIDTH, 17)];
    self.shopNumL.font = TWOTEXTFONTSIZE;
    self.shopNumL.textAlignment = NSTextAlignmentCenter;
    self.shopNumL.textColor = [UIColor colorWithHexString:@"#E8D5A4"];
    self.shopNumL.text = @"… 0家店铺营业中 …";
    [self.markView addSubview:self.shopNumL];
    
    self.listView = [[Notice3DshopListView  alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, self.markView.frame.origin.y-NAVIGATION_BAR_HEIGHT)];
    [self.bgImaegview addSubview:self.listView];

    self.openButton = NO;
    self.isFree = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:@"REFRESHSHOPDATANOTICETION" object:nil];

    if (!self.dataArr.count) {
        [self request];
    }
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
    [refreshButton setBackgroundImage:UIImageNamed(@"shuaxinshop_img") forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(requestShop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
    
    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[@"免费",@"付费"]];
    switch1.titleFont = FOURTHTEENTEXTFONTSIZE;
    switch1.frame = CGRectMake(20,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 140, 24);
    [switch1 addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
    switch1.titleColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    switch1.trackerColor = [UIColor colorWithHexString:@"#FFFFFF"];
    switch1.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
    [self.view addSubview:switch1];
    
    //158
    __weak typeof(self)weakSelf = self;
    self.phoneChatView = [[NoticePhoneChatView  alloc] initWithFrame:CGRectMake(0, self.bgImaegview.frame.size.height-158, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-30-TAB_BAR_HEIGHT)];
    self.isCallPhone = self.phoneChatView.isCallPhone;
    self.phoneChatView.changeStyleBlock = ^(BOOL style) {
        weakSelf.isCallPhone = style;
        if (style) {
            weakSelf.type = @"2";
        }else{
            weakSelf.type = @"1";
        }
        [weakSelf showHUD];
        [weakSelf request];
    };
    [self.bgImaegview addSubview:self.phoneChatView];
    
    if ([NoticeTools isFirstLeaderOnThisDeveice]) {
        NoticeLeaderScrollView *leaderViews = [[NoticeLeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [leaderViews showView];
    }
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.isExperience = swithbtn.selectedSegmentIndex > 0?@"2":@"1";
    [self showHUD];
    [self request];
}

- (void)requestShop{
    [self showHUD];
    [self request];
}

- (void)request{

    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/list?type=%@&isExperience=%@",self.type,self.isExperience] Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {

            [self.dataArr removeAllObjects];
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMyShopModel *model = [NoticeMyShopModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            if (self.dataArr.count) {
                self.markL.hidden = NO;
                NoticeMyShopModel *shopM = self.dataArr[0];
                self.shopNumL.text = [NSString stringWithFormat:@"… %@家店铺营业中 …",shopM.total];
                
                self.defaultL.hidden = YES;
            }else{
                self.hasClick = NO;
                self.markL.hidden = YES;
                self.shopNumL.text = @"… 0家店铺营业中 …";
                if (self.isExperience.intValue == 1) {
                    self.defaultL.hidden = NO;
                }else{
                    self.defaultL.hidden = YES;
                }
                
            }
            if (self.dataArr.count >= 10) {
                [self requestMoreTenShop];
            }else{
                self.listView.shopArr = self.dataArr;
            }
        }else{
            self.hasClick = NO;
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        self.hasClick = NO;
        self.defaultL.hidden = NO;
        [self hideHUD];
    }];
}

//继续获取下个十家店铺
- (void)requestMoreTenShop{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/list?type=%@&isExperience=%@",self.type,self.isExperience] Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMyShopModel *model = [NoticeMyShopModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
        }
        self.hasClick = NO;
        self.listView.shopArr = self.dataArr;
    } fail:^(NSError * _Nullable error) {
        self.hasClick = NO;
        self.listView.shopArr = self.dataArr;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.listView startRadi];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;
    
    [self.phoneChatView refreshShopStatus];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.listView stopRadi];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end

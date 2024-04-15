//
//  NoticeTabbarController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeTabbarController.h"
#import "BaseNavigationController.h"
#import "NoticeVideosController.h"
#import "SXTelBaseController.h"
#import "NoticeMineController.h"
#import "NoticeYunXin.h"
#import "SXPayForVideosController.h"
#import "NoticeStaySys.h"
//获取全局并发队列和主队列的宏定义
#define globalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
#define mainQueue dispatch_get_main_queue()

@interface NoticeTabbarController ()<AxcAE_TabBarDelegate>
@property (nonatomic,strong)UIButton *button;
@end

@implementation NoticeTabbarController
{
    NSInteger loginCount;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    loginCount = 0;

    [self addChildViewControllers];

    //退出登录监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectForOutLogin) name:@"GPTPFIRSTNOTICE" object:nil];
    [self redCirRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redCirRequest) name:@"NOTICENOREADNUMMESSAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redCirRequest) name:@"CHANGEROOTCONTROLLERNOTICATION" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redCirRequest) name:@"outLoginClearDataNOTICATION" object:nil];
}


- (void)changeSelectForOutLogin{
 
    [self axcAE_TabBar:self.axcTabBar selectIndex:0];
}


- (NSString *)getNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSInteger x = arc4random() % 99999999999999999;
    return  [NSString stringWithFormat:@"%@//%ld",currentTimeString,(long)x];
}


- (void)addChildViewControllers{
// 创建选项卡的数据 想怎么写看自己，这块我就写笨点了
//#import "NoticeVideosController.h"
//#import "SXTelBaseController.h"
//#import "NoticeMineController.h"

    NSArray *arr = @[[[BaseNavigationController alloc] initWithRootViewController:[[NoticeVideosController alloc] init]],
                     [[BaseNavigationController alloc] initWithRootViewController:[[SXPayForVideosController alloc] init]],
                     [[BaseNavigationController alloc] initWithRootViewController:[[SXTelBaseController alloc] init]],
                     [[BaseNavigationController alloc] initWithRootViewController:[[NoticeMineController alloc] init]]];
    
    NSArray *arr2 = @[@"视频",
                      @"课程",
                      @"咨询",
                      @"我的"];
 
    NSArray <NSDictionary *>*VCArray =
    @[@{@"vc":arr[0],@"normalImg":@"message",@"selectImg":@"btn_toolbar_bottle_selected",@"itemTitle":arr2[0]},
      @{@"vc":arr[1],@"normalImg":@"ting",@"selectImg":@"btn_toolbar_listen_selected",@"itemTitle":arr2[1]},
      @{@"vc":arr[2],@"normalImg":@"home",@"selectImg":@"btn_toolbar_voice_selected",@"itemTitle":arr2[2]},
      @{@"vc":arr[3],@"normalImg":@"me",@"selectImg":@"btn_toolbar_me_selected",@"itemTitle":arr2[3]}];
    

    // 1.遍历这个集合
    // 1.1 设置一个保存构造器的数组
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    // 1.2 设置一个保存VC的数组
    NSMutableArray *tabBarVCs = @[].mutableCopy;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2.根据集合来创建TabBar构造器
        AxcAE_TabBarConfigModel *model = [AxcAE_TabBarConfigModel new];
        model.itemLayoutStyle = AxcAE_TabBarItemLayoutStyleTitle;
        
        model.pictureWordsMargin = 0;
        // 3.item基础数据三连
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        model.normalColor = [UIColor colorWithHexString:@"#8A8F99"];
        model.interactionEffectStyle = AxcAE_TabBarInteractionEffectStyleSpring;
    
        model.selectColor = [UIColor colorWithHexString:@"2E3033"];
        // 备注 如果一步设置的VC的背景颜色，VC就会提前绘制驻留，优化这方面的话最好不要这么写
        // 示例中为了方便就在这写了
        UIViewController *vc = [obj objectForKey:@"vc"];
        // 5.将VC添加到系统控制组
        [tabBarVCs addObject:vc];
        // 5.1添加构造Model到集合
        [tabBarConfs addObject:model];
    }];
    // 使用自定义的TabBar来帮助触发凸起按钮点击事件
    TestTabBar *testTabBar = [TestTabBar new];
    testTabBar.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
    [self setValue:testTabBar forKey:@"tabBar"];
    
    self.viewControllers = tabBarVCs;

    //去掉tabBar顶部线条
    CGRect rect = CGRectMake(0, 0,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    
//    //阴影
//    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.tabBar.layer.shadowOffset = CGSizeMake(0, -6);
//    self.tabBar.layer.shadowOpacity = 0.1;

    self.axcTabBar = [AxcAE_TabBar new] ;
    self.axcTabBar.tabBarConfig = tabBarConfs;
    // 7.设置委托
    self.axcTabBar.delegate = self;
    // 8.添加覆盖到上边
    [self.tabBar addSubview:self.axcTabBar];

    self.axcTabBar.frame = self.tabBar.bounds;
    
}

- (void)redCirRequest{
    if (![NoticeTools getuserId]) {
        [self.tabBar hideBadgeOnItemIndex:4];
        return;
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.5.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success1) {
        if (success1) {
            if ([dict1[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NoticeStaySys *stay1 = [NoticeStaySys mj_objectWithKeyValues:dict1[@"data"]];
            NSString *allRedNum = [NSString stringWithFormat:@"%d",stay1.char_priM.num.intValue + stay1.sysM.num.intValue];
            if (allRedNum.intValue) {
                [self.tabBar showBadgeOnItemIndex:4];
            }else{
                [self.tabBar hideBadgeOnItemIndex:4];
            }
        }
    } fail:^(NSError *error) {
    }];
 
}

- (void)setNewSelect:(NSInteger)index{
    [self axcAE_TabBar:self.axcTabBar selectIndex:0];
}

// 9.实现代理，如下：

- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
    if (@available(iOS 13.0, *)) {
        UIImpactFeedbackGenerator *impactor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleRigid];
        [impactor impactOccurred];
    }
    // 通知 切换视图控制器
    [self setSelectedIndex:index];

}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.axcTabBar){
        self.axcTabBar.selectIndex = selectedIndex;
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
   // self.axcTabBar.selectIndex = self.oldSelectIndex;
    self.axcTabBar.frame = self.tabBar.bounds;
 
    [self.axcTabBar viewDidLayoutItems];
}

@end

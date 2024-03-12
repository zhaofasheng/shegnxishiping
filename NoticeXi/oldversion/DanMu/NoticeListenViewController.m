//
//  NoticeListenViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/10/18.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeListenViewController.h"
#import "NoticeStaySys.h"
#import "NoticeSCListViewController.h"
#import "HQCollectionViewFlowLayout.h"
#import "NoticeBokeMainCell.h"
#import "NoticeDanMuController.h"
#import "NoticeNewLeadController.h"
#import "UINavigationController+DoitAnimation.h"
#import "NoticeXi-Swift.h"
#import "ZFSDateFormatUtil.h"
#import "NoticeImageViewController.h"
#import "NoticeLeftPopMenu.h"
#import "NoticeTeamsController.h"
#import "NoticeHelpListController.h"
#import "NoticerClockController.h"
#import "NoticeReadBookController.h"
#import "NoticeBokeReusableView.h"

static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";

@interface NoticeListenViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NoticeLeftPopMenu *popMenu;
@property (nonatomic, strong) UILabel *allNumL;
@property (nonatomic, assign) BOOL needPopMenu;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastPodcastNo;
@property (nonatomic, strong) UIView *leadV;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UIImageView *threeImage;
@property (nonatomic, strong) NSMutableArray *topArr;
@end

@implementation NoticeListenViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needHideNavBar = YES;
    self.pageNo = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    [self.tableView removeFromSuperview];
    
    UIButton *msgBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2, 24, 24)];
    [msgBtn setBackgroundImage:UIImageNamed(@"msgClick_imgw") forState:UIControlStateNormal];
    [self.view addSubview:msgBtn];
    [msgBtn addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.allNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24+17,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-2, 14, 14)];
    self.allNumL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
    self.allNumL.layer.cornerRadius = 7;
    self.allNumL.layer.masksToBounds = YES;
    self.allNumL.textColor = [UIColor whiteColor];
    self.allNumL.font = [UIFont systemFontOfSize:9];
    self.allNumL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.allNumL];
    self.allNumL.hidden = YES;
    
    [self initCollectionView];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        [weakSelf requestVoice];
        [weakSelf requestTop];
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isDown = NO;
        weakSelf.pageNo++;
        [weakSelf requestVoice];
        
    }];
    self.dataArr = [[NSMutableArray alloc] init];
    self.isDown = YES;
    [self requestVoice];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curentTimeZreoY = [ZFSDateFormatUtil dateFullStringWithInterval:currentTime formatStyle:@"MM.dd"];
    //
    CGFloat width1 = GET_STRWIDTH(curentTimeZreoY, 22, 32);
    CGFloat width2 = GET_STRWIDTH([NoticeTools getLocalStrWith:@"read.title"], 14, 32);
    

    UIView *leaderView = [[UIView alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-32)/2, width1+width2+10, 32)];
    [self.view addSubview:leaderView];
    leaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leadTap)];
    [leaderView addGestureRecognizer:tap];
    self.leadV = leaderView;
    
    self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(width1, 0, width2, 32)];
    self.nickNameL.font = FOURTHTEENTEXTFONTSIZE;
    self.nickNameL.text = [NoticeTools getLocalStrWith:@"read.title"];
    self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.leadV addSubview:self.nickNameL];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width1, 32)];
    timeL.font = XGTwentyBoldFontSize;
    timeL.text = curentTimeZreoY;
    timeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    [self.leadV addSubview:timeL];
    
    self.threeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.leadV.frame.size.width-8, 12, 8, 8)];
    self.threeImage.image = UIImageNamed(@"Image_threeinto");
    [self.leadV addSubview:self.threeImage];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"RECLICKREFRESHBOKEDATA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotHelp) name:@"REFRESHHELPTIENOTICATION" object:nil];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(msgBtn.frame.origin.x-15-72, msgBtn.frame.origin.y, 72, 24)];
    [moreBtn setBackgroundImage:UIImageNamed(@"menupop_img") forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    self.topArr = [[NSMutableArray alloc] init];
    [self requestTop];
}


- (void)refreshData{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)moreClick{
    [self.popMenu showPopMenu];
}

- (NoticeLeftPopMenu *)popMenu{
    if(!_popMenu){
        __weak typeof(self) weakSelf = self;
        _popMenu = [[NoticeLeftPopMenu alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _popMenu.choiceIndexBlock = ^(NSInteger index) {
            weakSelf.needPopMenu = YES;
            if (index == 0) {
                NoticeTeamsController *ctl = [[NoticeTeamsController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:YES];
            }else if (index == 1){
                NoticeHelpListController *ctl = [[NoticeHelpListController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:YES];
            }else if (index == 2){
                NoticerClockController *ctl = [[NoticerClockController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:NO];
            }else if (index == 3){
                NoticeReadBookController *ctl = [[NoticeReadBookController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:NO];
            }else{
                NoticeNewLeadController *ctl = [[NoticeNewLeadController alloc] init];
                [weakSelf.navigationController pushViewController:ctl animated:YES];
            }
        };
    }
    return _popMenu;
}

- (void)gotHelp{
    NoticeHelpListController *ctl = [[NoticeHelpListController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)leadTap{

    NoticeImageViewController *ctl = [[NoticeImageViewController alloc] init];
    ctl.isReadEveryDay = YES;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:NO];
}

- (void)requestVoice{
    NSString *url = nil;
    if (self.isDown) {
        url = @"podcast";
    }else{
        url = [NSString stringWithFormat:@"podcast?pageNo=%ld",self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            
            [self.collectionView reloadData];
        }

    } fail:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

    }];
}

- (void)requestTop{
 
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"podcast/topIndex" Accept:@"application/vnd.shengxi.v5.5.7+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            [self.topArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeDanMuModel *model = [NoticeDanMuModel mj_objectWithKeyValues:dic];
                [self.topArr addObject:model];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError *error) {

    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
    ctl.bokeModel = self.dataArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    ctl.reloadBlock = ^(BOOL reload) {
        [weakSelf.collectionView reloadData];
    };
    ctl.likeBokeBlock = ^(NoticeDanMuModel * _Nonnull boKeModel) {
        for (NoticeDanMuModel *bokeM in weakSelf.dataArr) {
            if([bokeM.podcast_no isEqualToString:boKeModel.podcast_no]){
                bokeM.is_podcast_like = boKeModel.is_podcast_like;
                bokeM.count_like = boKeModel.count_like;
                [weakSelf.collectionView reloadData];
                break;
            }
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeBokeMainCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:DRMerchantCollectionViewCellID forIndexPath:indexPath];
    merchentCell.model = self.dataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((DR_SCREEN_WIDTH-15)/2,(DR_SCREEN_WIDTH-15)/2+13);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5,5);
}


#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回Header/Footer内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if(!self.topArr.count){
        return nil;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {          // Header视图
        // 从复用队列中获取HooterView
        NoticeBokeReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
        if (self.topArr.count) {
            headerView.cyleView.bokeArr = self.topArr;
        }
        __weak typeof(self) weakSelf = self;
        headerView.cyleView.clickBokeBlock = ^(NoticeDanMuModel *bokeM) {
            NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
       
            ctl.reloadBlock = ^(BOOL reload) {
                [weakSelf.collectionView reloadData];
            };
            ctl.bokeModel = bokeM;
            ctl.likeBokeBlock = ^(NoticeDanMuModel * _Nonnull boKeModel) {
                [weakSelf.collectionView reloadData];
            };
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        };
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.topArr.count? CGSizeMake(DR_SCREEN_WIDTH,DR_SCREEN_WIDTH*243/365) : CGSizeMake(DR_SCREEN_WIDTH, 0);
    }
    else {
        return CGSizeMake(0, 0);
    }
}



- (void)initCollectionView {
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //2.初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT -  NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[NoticeBokeMainCell class] forCellWithReuseIdentifier:DRMerchantCollectionViewCellID];
    [_collectionView registerClass:[NoticeBokeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];

    [self.view addSubview:_collectionView];
}


- (void)msgClick{
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeSCListViewController *ctl = [[NoticeSCListViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)redCirRequest{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.4.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];
            self.allNumL.hidden = stay.chatpriM.num.intValue?NO:YES;
            CGFloat strWidth = GET_STRWIDTH(stay.chatpriM.num, 9, 14);
            if (stay.chatpriM.num.intValue < 10) {
                strWidth = 14;
            }else{
                strWidth = strWidth+6;
            }
            self.allNumL.text = stay.chatpriM.num;
            self.allNumL.frame = CGRectMake(DR_SCREEN_WIDTH-20-24+17, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-24)/2-4, strWidth, 14);
        }
    } fail:^(NSError *error) {
    }];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    [self redCirRequest];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.needPopMenu){
        self.needPopMenu = NO;
        [self.popMenu fastPopMenu];
    }
}

@end

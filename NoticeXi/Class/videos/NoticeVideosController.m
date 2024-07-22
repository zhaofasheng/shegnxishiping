//
//  NoticeVideosController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeVideosController.h"
#import "NoticeVideoCollectionViewCell.h"

#import "NoticeLoginViewController.h"
#import "SXPlayFullListController.h"
#import "SXPlayDetailController.h"
#import "SXUserHowController.h"

static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";

@interface NoticeVideosController ()

@property (nonatomic, assign) NSInteger originIndex;
@property (nonatomic, assign) NSInteger currentPlayTime;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation NoticeVideosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.pageNo = 1;
    

    self.collectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-43);
    
    [self.collectionView registerClass:[NoticeVideoCollectionViewCell class] forCellWithReuseIdentifier:DRMerchantCollectionViewCellID];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        [weakSelf request];
    }];
    
    self.collectionView.mj_header = header;
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isDown = NO;
        weakSelf.pageNo++;
        [weakSelf request];
    }];
    
    [self request];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([NoticeTools getuserId]) {
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appdel.needPushHowuse) {
            SXUserHowController *ctl = [[SXUserHowController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
            appdel.needPushHowuse = NO;
        }
    }
}

- (void)hasNetWork{
    if (!self.dataArr.count) {
        self.isDown = YES;
        self.pageNo = YES;
        [self request];
    }
}

- (void)request{

    if (self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    NSString *url = @"";
    url = [NSString stringWithFormat:@"video/list?pageNo=%ld",self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXVideosModel *videoM = [SXVideosModel mj_objectWithKeyValues:dic];
                videoM.textContent = [NSString stringWithFormat:@"%@\n%@",videoM.title,videoM.introduce];
                [self.dataArr addObject:videoM];
            }
            
            self.layout.dataList = self.dataArr;
            [self.collectionView reloadData];
        }
        self.isRequesting = NO;
        
    } fail:^(NSError * _Nullable error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.isRequesting = NO;
    }];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    
//    SXPlayDetailController *ctl = [[SXPlayDetailController alloc] init];
//    ctl.currentPlayModel = self.dataArr[indexPath.row];
    
    SXPlayFullListController *ctl = [[SXPlayFullListController alloc] init];
    ctl.modelArray = self.dataArr;
    ctl.currentPlayIndex = indexPath.row;
    ctl.page = self.pageNo;
    __weak typeof(self) weakSelf = self;
    ctl.dataBlock = ^(NSInteger pageNo, NSMutableArray * _Nonnull dataArr) {
        weakSelf.pageNo = pageNo;
        weakSelf.dataArr = dataArr;
        [weakSelf.collectionView reloadData];
    };
    
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVideoCollectionViewCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:DRMerchantCollectionViewCellID forIndexPath:indexPath];
    if (self.dataArr.count > indexPath.row) {
        merchentCell.videoModel = self.dataArr[indexPath.row];
    }
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

@end

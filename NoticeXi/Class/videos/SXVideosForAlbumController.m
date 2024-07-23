//
//  SXVideosForAlbumController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideosForAlbumController.h"
#import "SXAddVideoZjView.h"
#import "NoticeVideoCollectionViewCell.h"
#import "SXPlayFullListController.h"
#import "SXAlbumReusableView.h"
#import "SYStickHeaderWaterFallLayout.h"
static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";

@interface SXVideosForAlbumController ()<LCActionSheetDelegate,SYStickHeaderWaterFallDelegate>

@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *albumL;

@property (nonatomic, assign) NSInteger originIndex;
@property (nonatomic, assign) NSInteger currentPlayTime;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation SXVideosForAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SYStickHeaderWaterFallLayout *cvLayout = [[SYStickHeaderWaterFallLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.isStickyHeader = NO;
    cvLayout.isStickyFooter = NO;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT) collectionViewLayout:cvLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self.view addSubview:self.collectionView];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-35,STATUS_BAR_HEIGHT, 35,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [moreBtn setImage: [UIImage imageNamed:@"img_scb_b"]  forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(actionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:moreBtn];
    
    self.pageNo = 1;
    
    [self.collectionView registerClass:[NoticeVideoCollectionViewCell class] forCellWithReuseIdentifier:DRMerchantCollectionViewCellID];
    [self.collectionView registerClass:[SXAlbumReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    
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
    merchentCell.showSCbutton = YES;
    if (self.dataArr.count > indexPath.row) {
        merchentCell.videoModel = self.dataArr[indexPath.row];
    }
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}


// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回Header/Footer内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {          // Header视图
        // 从复用队列中获取HooterView
        SXAlbumReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
 
        return headerView;
    }
    return nil;
}

- (void)actionClick{

    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
    } otherButtonTitleArray:@[@"修改专辑",@"删除专辑"]];
    sheet.delegate = self;
    [sheet show];
}

- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        SXAddVideoZjView *addView = [[SXAddVideoZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        addView.isChange = YES;
        addView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
          
    //        NSMutableDictionary *parm = [NSMutableDictionary new];
    //
    //        if (self.isLimt) {
    //            [parm setObject:@"0" forKey:@"bucketId"];
    //            [parm setObject:@"0000000000" forKey:@"albumCoverUri"];
    //            [parm setObject:name forKey:@"albumName"];
    //        }else{
    //            [parm setObject:name forKey:@"albumName"];
    //            [parm setObject:isOpen?@"1":@"3" forKey:@"albumType"];
    //        }
    //
    //        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isLimt?@"dialogAlbums": [NSString stringWithFormat:@"user/%@/voiceAlbum",[NoticeTools getuserId]] Accept:self.isLimt?@"application/vnd.shengxi.v4.7.6+json": @"application/vnd.shengxi.v5.0.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
    //            if (success) {
    //                [self.collectionView.mj_header beginRefreshing];
    //            }
    //
    //            [self hideHUD];
    //        } fail:^(NSError * _Nullable error) {
    //            [self hideHUD];
    //        }];
        };
        [addView show];
    }else if (buttonIndex == 2){
        __weak typeof(self) weakSelf = self;
         XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确认删除吗？" message:@"删除后，专辑下的视频将取消收藏" sureBtn:@"取消" cancleBtn:@"删除" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
            
            }
        };
        [alerView showXLAlertView];
    }

}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull SYStickHeaderWaterFallLayout *)collectionViewLayout heightForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    return [SXTools getSXvideoListHeight:self.dataArr[indexPath.row]];
}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull SYStickHeaderWaterFallLayout *)collectionViewLayout widthForItemInSection:(NSInteger)section { 
    return (DR_SCREEN_WIDTH-15)/2;
}

- (CGFloat) collectionView:(nonnull UICollectionView *)collectionView
                    layout:(nonnull SYStickHeaderWaterFallLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 95;
}

@end

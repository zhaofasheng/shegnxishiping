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
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UILabel *albumL;
@property (nonatomic, strong) SXAlbumReusableView *headerView;
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
    
    //获取点赞通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getvideoZanNotice:) name:@"SXZANvideoNotification" object:nil];
    //获取收藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getvideoscNotice:) name:@"SXCOLLECTvideoNotification" object:nil];
    
    SXAlbumReusableView *headerView = [[SXAlbumReusableView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 95)];
    headerView.albumL.text = self.zjModel.ablum_name;
    headerView.numL.text = [NSString stringWithFormat:@"%d个视频",self.zjModel.video_num.intValue];
    self.headerView = headerView;
    [self.defaultL addSubview:headerView];
}

- (void)getvideoZanNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *videoid = nameDictionary[@"videoId"];
    NSString *iszan = nameDictionary[@"is_zan"];
    NSString *zanNum = nameDictionary[@"zan_num"];
    for (SXVideosModel *videoM in self.dataArr) {
        if ([videoM.vid isEqualToString:videoid]) {
            videoM.is_zan = iszan;
            videoM.zan_num = zanNum;
            [self.collectionView reloadData];
            break;
        }
    }
}

- (void)getvideoscNotice:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *videoid = nameDictionary[@"videoId"];
    NSString *is_collection = nameDictionary[@"is_collection"];
    NSString *collection_num = nameDictionary[@"collection_num"];
    NSString *albumId = nameDictionary[@"albumId"];
    for (SXVideosModel *videoM in self.dataArr) {
        if ([videoM.vid isEqualToString:videoid]) {
            videoM.is_collection = is_collection;
            videoM.collection_num = collection_num;
            
            if (is_collection.boolValue) {
                if ([albumId isEqualToString:self.zjModel.albumId]) {
                    videoM.is_collection = @"1";
                }
            }else{
                videoM.is_collection = @"0";
            }
            [self.collectionView reloadData];
            break;
        }
    }
}

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel  alloc] initWithFrame:self.collectionView.bounds];
        _defaultL.text = @"欸 这里空空的";
        _defaultL.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _defaultL.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultL;
}

- (void)request{

    if (self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    NSString *url = @"";
    url = [NSString stringWithFormat:@"videoAblum/getVideo/%@?pageNo=%ld",self.zjModel.albumId,self.pageNo];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXVideosModel *videoM = [SXVideosModel mj_objectWithKeyValues:dic];
                if (self.videoModel) {
                    videoM.schedule = self.videoModel.schedule;
                    self.videoModel = nil;
                }
                videoM.textContent = [NSString stringWithFormat:@"%@\n%@",videoM.title,videoM.introduce];
                [self.dataArr addObject:videoM];
            }
            
            self.layout.dataList = self.dataArr;
            [self.collectionView reloadData];
            if (!self.dataArr.count) {
                [_defaultL removeFromSuperview];
                self.headerView.albumL.text = self.zjModel.ablum_name;
                self.headerView.numL.text = [NSString stringWithFormat:@"%d个视频",self.zjModel.video_num.intValue];
                [self.collectionView addSubview:self.defaultL];
            }else{
                [_defaultL removeFromSuperview];
            }
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
    merchentCell.albumId = self.zjModel.albumId;
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
        headerView.albumL.text = self.zjModel.ablum_name;
        headerView.numL.text = [NSString stringWithFormat:@"%d个视频",self.zjModel.video_num.intValue];
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
    __weak typeof(self) weakSelf = self;
    if (buttonIndex == 1) {
        SXAddVideoZjView *addView = [[SXAddVideoZjView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        addView.isChange = YES;
        addView.addBlock = ^(NSString * _Nonnull name, BOOL isOpen) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
            [parm setObject:name forKey:@"ablumName"];
            [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"videoAblum/%@",self.zjModel.albumId] Accept:@"application/vnd.shengxi.v5.8.5+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                if (success) {
                    weakSelf.zjModel.ablum_name = name;
                    weakSelf.headerView.albumL.text = weakSelf.zjModel.ablum_name;
                    weakSelf.headerView.numL.text = [NSString stringWithFormat:@"%d个视频",weakSelf.zjModel.video_num.intValue];
                    [weakSelf.collectionView reloadData];
                    if (weakSelf.nameChangeBlock) {
                        weakSelf.nameChangeBlock(YES);
                    }
                }
            } fail:^(NSError * _Nullable error) {
                
            }];
        };
        [addView show];
    }else if (buttonIndex == 2){
        
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确认删除吗？" message:@"删除后，专辑下的视频将取消收藏" sureBtn:@"取消" cancleBtn:@"删除" right:YES];
        alerView.resultIndex = ^(NSInteger index) {
            if (index == 2) {
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"videoAblum/%@",self.zjModel.albumId] Accept:@"application/vnd.shengxi.v5.8.5+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"HASDELETEZHUANJINOTICE" object:nil];
                    }
                } fail:^(NSError * _Nullable error) {
                    
                }];
                if (weakSelf.deletezjBlock) {
                    weakSelf.deletezjBlock(weakSelf.zjModel);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
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

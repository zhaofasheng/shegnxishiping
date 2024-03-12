//
//  SXPlayDetailListController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayDetailListController.h"
#import "NoticeVideoCollectionViewCell.h"

static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";

@interface SXPlayDetailListController ()

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, assign) BOOL hascClick;//防止重复点击
@end

@implementation SXPlayDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.collectionView.dataSource = self;
    self.collectionView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-STATUS_BAR_HEIGHT-(DR_SCREEN_WIDTH/16*9)-40);
    
    [self.collectionView registerClass:[NoticeVideoCollectionViewCell class] forCellWithReuseIdentifier:DRMerchantCollectionViewCellID];

    
    [self request];
}


- (void)hasNetWork{
    if (!self.dataArr.count) {
        self.isDown = YES;
        self.pageNo = YES;
        [self request];
    }
}


- (void)request{
    
    if ([[HWNetworkReachabilityManager shareManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) {//有网络的时候自动刷新
        self.hascClick = NO;
        return;
    }
    
    [self.dataArr removeAllObjects];
    NSString *url = @"";
    url = [NSString stringWithFormat:@"video/detail/%@/list",self.currentPlayModel.vid];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                SXVideosModel *videoM = [SXVideosModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:videoM];
            }
            
            [self.collectionView reloadData];
        }
        self.hascClick = NO;
    } fail:^(NSError * _Nullable error) {
        self.hascClick = NO;
    }];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    if (!self.dataArr.count) {
        return;
    }
    
    if (self.hascClick) {
        return;
    }
    
    if (indexPath.row < self.dataArr.count) {
        self.hascClick = YES;
        SXVideosModel *model = self.dataArr[indexPath.row];
        if ([model.vid isEqualToString:self.currentPlayModel.vid]) {
            return;
        }
        self.currentPlayModel = model;
        if (self.choiceVideoBlock) {
            self.choiceVideoBlock(model);
        }
        
        [self request];
    }

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

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count > indexPath.row) {
        return CGSizeMake((DR_SCREEN_WIDTH-15)/2,[SXTools getSXvideoListHeight:self.dataArr[indexPath.row]]);
    }
    return CGSizeMake((DR_SCREEN_WIDTH-15)/2,0);
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

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


@end

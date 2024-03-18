//
//  NoticeVideosController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeVideosController.h"
#import "NoticeVideoCollectionViewCell.h"
#import "SXSearchVideoController.h"
#import "SXPlayDetailController.h"
#import "NoticeLoginViewController.h"



static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";

@interface NoticeVideosController ()
@property (nonatomic, assign) NSInteger currentPlayTime;


@end

@implementation NoticeVideosController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    
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
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-36-STATUS_BAR_HEIGHT)/2, DR_SCREEN_WIDTH-30, 36)];
    [searchBtn setAllCorner:18];
    searchBtn.backgroundColor = [[UIColor colorWithHexString:@"#F0F1F5"] colorWithAlphaComponent:1];
    UIImageView *searImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 20)];
    searImg.image = UIImageNamed(@"Image_newsearchss");
    [searchBtn addSubview:searImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, searchBtn.frame.size.width-40, 36)];
    label.text = @"搜索视频";
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = [[UIColor colorWithHexString:@"#8A8F99"] colorWithAlphaComponent:1];
    [searchBtn addSubview:label];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    
    //谁在首页谁需要实现这个功能
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outLogin) name:@"outLoginClearDataNOTICATION" object:nil];
    [self request];
}

- (void)searchClick{

    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    SXSearchVideoController *ctl = [[SXSearchVideoController alloc] init];
 
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:self.navigationController.view];
    [self.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    [self.navigationController pushViewController:ctl animated:NO];
}

- (void)outLogin{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)hasNetWork{
    if (!self.dataArr.count) {
        self.isDown = YES;
        self.pageNo = YES;
        [self request];
    }
}


- (void)request{

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
                
                [self.dataArr addObject:videoM];
            }
            [self.collectionView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }

    SXPlayDetailController *ctl = [[SXPlayDetailController alloc] init];
    ctl.currentPlayModel = self.dataArr[indexPath.row];
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

@end

//
//  NoticeCollectionBoKeController.m
//  NoticeXi
//
//  Created by li lei on 2023/12/19.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeCollectionBoKeController.h"
#import "NoticeBokeMainCell.h"
#import "NoticeDanMuController.h"

static NSString *const DRMerchantCollectionViewCellID = @"DRTILICollectionViewCell";


@interface NoticeCollectionBoKeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSString *lastPodcastNo;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation NoticeCollectionBoKeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    [self initCollectionView];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        [weakSelf requestVoice];
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

    [self.view addSubview:_collectionView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NoticeDanMuController *ctl = [[NoticeDanMuController alloc] init];
    ctl.isSClist = YES;
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

- (void)requestVoice{
    NSString *url = nil;
    if (self.isDown) {
        url = @"podcastCollect?sort=2";
    }else{
        url = [NSString stringWithFormat:@"podcastCollect?pageNo=%ld&sort=2",self.pageNo];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.8+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeDanMuModel *dataModel = [NoticeDanMuModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.isDown) {
                self.isDown = NO;
                [self.dataArr removeAllObjects];
            }
            self.navBarView.titleL.text = [NSString stringWithFormat:@"已收藏(%d)",dataModel.allNum.intValue];
            
            for (NSDictionary *dic in dataModel.list) {
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


@end

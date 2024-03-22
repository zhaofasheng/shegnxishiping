//
//  SXBaseCollectionController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBaseCollectionController.h"

@interface SXBaseCollectionController ()

@end

@implementation SXBaseCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCollectionView];

    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    self.isDown = YES;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];

    
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 0;
}


- (void)initCollectionView {
    //1.初始化layout
    CYWWaterFallLayout *flowLayout = [[CYWWaterFallLayout alloc] init];
    self.layout = flowLayout;
    flowLayout.columnCount = 2;
    flowLayout.itemWidth = (DR_SCREEN_WIDTH-15)/2;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    // 垂直方向滑动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //2.初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT -  NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectioncell"];

    [self.view addSubview:_collectionView];
 
}

@end

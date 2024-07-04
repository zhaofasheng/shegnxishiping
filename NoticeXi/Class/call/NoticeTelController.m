//
//  NoticeTelController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/19.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeTelController.h"
#import "SXAskQuestionShopCell.h"
#import "NoticdShopDetailForUserController.h"
#import "NoticeLoginViewController.h"
#import "SXShopListBaseModel.h"
@interface NoticeTelController ()
@property (nonatomic, assign) BOOL canLoad;
@property (nonatomic, assign) BOOL isUpScro;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger noLoginDevice;
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, assign) CGFloat lastContentOffsetY;
@end

@implementation NoticeTelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.useSystemeNav = YES;
    
    self.layout.isFreeCall = self.isFree;
    self.layout.itemWidth = (DR_SCREEN_WIDTH-30)/2;
    self.layout.minimumLineSpacing = 10;
    self.layout.minimumInteritemSpacing = 10;
    self.layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    
    self.collectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT-(self.isFree?0:43)-44);
    [self.collectionView registerClass:[SXAskQuestionShopCell class] forCellWithReuseIdentifier:@"askCell"];
    
    self.pageNo = 1;
    self.isDown = YES;
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isDown = YES;
        weakSelf.pageNo = 1;
        self.isLoading = NO;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
        return;
    }
    
    NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
    ctl.shopModel = self.dataArr[indexPath.row];

    ctl.currentPlayIndex = indexPath.row;

    [self.navigationController pushViewController:ctl animated:YES];
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SXAskQuestionShopCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"askCell" forIndexPath:indexPath];
    merchentCell.isFree = self.isFree;
    merchentCell.shopM = self.dataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}


- (void)request{
    if (self.isLoading) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        return;
    }
    self.isLoading = YES;
    
    NSString *url = @"";

    if (![NoticeTools getuserId]) {//没登录的时候
        if (self.isDown || !self.noLoginDevice) {
            self.noLoginDevice = arc4random() % 999999956789;
        }
        url = [NSString stringWithFormat:@"shop/list?isExperience=%@&userDevice=%ld&pageNo=%ld",self.isFree?@"1":@"2",self.noLoginDevice,self.pageNo];
    }else{
        if (self.isDown) {
            url = [NSString stringWithFormat:@"shop/list?isExperience=%@&pageNo=%d",self.isFree?@"1":@"2",1];
            if (!self.isFree) {
                url = [NSString stringWithFormat:@"shop/list?isExperience=%@&pageNo=%d&categoryId=%@",self.isFree?@"1":@"2",1,self.category_Id];
            }
        }else{
            url = [NSString stringWithFormat:@"shop/list?isExperience=%@&pageNo=%ld",self.isFree?@"1":@"2",self.pageNo];
            if (!self.isFree) {
                url = [NSString stringWithFormat:@"shop/list?isExperience=%@&pageNo=%ld&categoryId=%@",self.isFree?@"1":@"2",self.pageNo,self.category_Id];
            }
        }
       
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.3+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        
        if (success) {
            
            if (self.isDown) {
                [self.dataArr removeAllObjects];
                self.isDown = NO;
            }
            
            SXShopListBaseModel *baseM = [SXShopListBaseModel mj_objectWithKeyValues:dict[@"data"]];
            if (self.pageNo == 1) {
                for (NSDictionary *dic in baseM.top_shop_list) {
                    NoticeMyShopModel *shopM = [NoticeMyShopModel mj_objectWithKeyValues:dic];
                    [self.dataArr addObject:shopM];
                }
            }
           
            for (NSDictionary *dic in baseM.shop_list) {
                NoticeMyShopModel *shopM = [NoticeMyShopModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:shopM];
            }
            self.layout.telList = self.dataArr;
            [self.collectionView reloadData];
        }
        
        if (self.dataArr.count) {
            [_defaultL removeFromSuperview];
        }else{
            [self.collectionView addSubview:self.defaultL];
        }
        self.canLoad = YES;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.isLoading = NO;
    } fail:^(NSError * _Nullable error) {
        self.isLoading = NO;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    }];
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

- (void)viewDidAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
  //  self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat hight = scrollView.frame.size.height;
       CGFloat contentOffset = scrollView.contentOffset.y;
       CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
    CGFloat offset = contentOffset - self.lastContentOffsetY;
    self.lastContentOffsetY = contentOffset;

       if (offset > 0 && contentOffset > 0) {
          DRLog(@"上拉行为");
           self.isUpScro = YES;
       }
       if (offset < 0 && distanceFromBottom > hight) {
           DRLog(@"下拉行为");
           self.isUpScro = NO;
       }
       if (contentOffset == 0) {
           DRLog(@"滑动到顶部");
           self.isUpScro = NO;
       }
       if (distanceFromBottom < hight) {
             DRLog(@"滑动到底部");
       }

}


#pragma mark - scrollView 停止滚动监测
- (void)scrollViewDidEndScroll {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = indexPaths.lastObject;
    DRLog(@"%ld===%ld",self.dataArr.count,indexPath.row);
    if (!self.dataArr.count || (indexPath.row < 3) || !self.isUpScro) {
        return;
    }
    if (self.dataArr.count - indexPath.row < 8) {
        DRLog(@"达到预加载条件");
        if (self.canLoad) {
            self.canLoad = NO;
            self.pageNo++;
            self.isDown = NO;
            [self request];
        }
    }
}


@end

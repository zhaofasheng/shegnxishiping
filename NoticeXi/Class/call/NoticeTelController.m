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

@interface NoticeTelController ()

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
    
    self.collectionView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    [self.collectionView registerClass:[SXAskQuestionShopCell class] forCellWithReuseIdentifier:@"askCell"];
    
    UIButton *refreshButton = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-56, self.collectionView.frame.size.height - 90, 56, 56)];
    [refreshButton setBackgroundImage:UIImageNamed(@"sxrefreshShop_img") forState:UIControlStateNormal];
    [self.view addSubview:refreshButton];
    [refreshButton addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    
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
    merchentCell.shopM = self.dataArr[indexPath.row];
    return merchentCell;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}


- (void)request{

    NSString *url = @"";
    url = [NSString stringWithFormat:@"shop/list?isExperience=%@",self.isFree?@"1":@"2"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.dataArr removeAllObjects];
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeMyShopModel *shopM = [NoticeMyShopModel mj_objectWithKeyValues:dic];
                [self.dataArr addObject:shopM];
            }
            
            self.layout.telList = self.dataArr;
            [self.collectionView reloadData];
     
        }
    } fail:^(NSError * _Nullable error) {
    }];
}


@end

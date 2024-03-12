//
//  NoticeChangeSkinListController.m
//  NoticeXi
//
//  Created by li lei on 2021/9/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeChangeSkinListController.h"
#import "NoticeSkinCell.h"
#import "NoticeChangeSkinReusableView.h"
#import "NoticeChangeSkinController.h"
#import "NoticeVipBaseController.h"
#import "SPMultipleSwitch.h"
@interface NoticeChangeSkinListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *localArr;
@property (nonatomic, strong) NSMutableArray *freeArr;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) SPMultipleSwitch *switchButton;
@end

@implementation NoticeChangeSkinListController

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        // 创建FlowLayout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 垂直方向滑动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 创建collectionView
        CGRect frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;// 隐藏垂直方向滚动条
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        // 注册cell
        [_collectionView registerClass:[NoticeSkinCell class] forCellWithReuseIdentifier:@"Cell"];
        [_collectionView registerClass:[NoticeChangeSkinReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        self.dataArr = [[NSMutableArray alloc] init];
    }
    
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        __weak typeof(self) weakSelf = self;
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
        if (!userM.level.intValue && indexPath.row == 1) {
            NSString *str = nil;
            if ([NoticeTools getLocalType] == 2) {
                str = [NSString stringWithFormat:@"Lv%@へのアップグレードを使用できる〜",@"1"];
            }else if ([NoticeTools getLocalType] == 1){
                str = [NSString stringWithFormat:@"Limited to Lv%@ or higher",@"1"];
            }else{
                str = [NSString stringWithFormat:@"升级至Lv%@可使用哦~",@"1"];
            }
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"main.cancel"] cancleBtn:[NoticeTools getLocalStrWith:@"recoder.golv"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    NoticeVipBaseController *ctl = [[NoticeVipBaseController alloc] init];
                    ctl.noSkinBlock = YES;
                    [weakSelf.navigationController pushViewController:ctl animated:YES];
                }
            };
            [alerView showXLAlertView];
            return;
        }
        NoticeChangeSkinController *ctl = [[NoticeChangeSkinController alloc] init];
        ctl.type = indexPath.row;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        if(self.isFree){
            if(self.freeArr.count > indexPath.row){
                NoticeChangeSkinController *ctl = [[NoticeChangeSkinController alloc] init];
                ctl.type = 3;
                ctl.isFree = self.isFree;
                ctl.skinModel = self.freeArr[indexPath.row];
                [self.navigationController pushViewController:ctl animated:YES];
            }
        }else{
            if(self.dataArr.count > indexPath.row){
                NoticeChangeSkinController *ctl = [[NoticeChangeSkinController alloc] init];
                ctl.type = 3;
                ctl.isFree = self.isFree;
                ctl.skinModel = self.dataArr[indexPath.row];
                [self.navigationController pushViewController:ctl animated:YES];
            }
        }
   
    }
}

//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeSkinCell *merchentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    merchentCell.section = indexPath.section;
    merchentCell.lockImageView.hidden = NO;
    if (indexPath.section == 0) {
        
        merchentCell.skinModel = self.localArr[indexPath.row];
        merchentCell.lockImageView.hidden = YES;
    }else{
        if(self.isFree){
            if(self.freeArr.count > indexPath.row){
                merchentCell.skinModel = self.freeArr[indexPath.row];
            }
        }else{
            if(self.dataArr.count > indexPath.row){
                merchentCell.skinModel = self.dataArr[indexPath.row];
            }
        }
        
    }
    
    return merchentCell;
}


//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((DR_SCREEN_WIDTH-70)/3,(DR_SCREEN_WIDTH-70)/3/102*150+40);
}

// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 15, 20, 15);
}

#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}


// 返回Section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// 返回Header的尺寸大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(DR_SCREEN_WIDTH, 57);
}

// 返回Header/Footer内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {          // Header视图
        // 从复用队列中获取HooterView
        NoticeChangeSkinReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.nameL.text = [NoticeTools getLocalStrWith:@"skin.gf"];
      
        }else{
            [self.switchButton removeFromSuperview];
            [headerView addSubview:self.switchButton];
            headerView.nameL.text = [NoticeTools getLocalStrWith:@"skin.sx"];
            
        }
        return headerView;
    }
    return nil;
}

- (void)changeVale:(SPMultipleSwitch *)swithbtn{
    self.isFree = swithbtn.selectedSegmentIndex==0?NO:YES;
    if(self.isFree){
        if(self.freeArr.count){
            [UIView performWithoutAnimation:^{
               //刷新界面
                [self.collectionView reloadData];
             }];
        }else{
            self.isDown = YES;
            [self request];
        }
    }else{
        if(self.dataArr.count){
            [UIView performWithoutAnimation:^{
               //刷新界面
                [self.collectionView reloadData];
             }];
        }else{
            self.isDown = YES;
            [self request];
        }
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.localArr.count;
    }
    if(self.isFree){
        return self.freeArr.count;
    }
    return self.dataArr.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFree = NO;
    [self.tableView removeFromSuperview];
    
    SPMultipleSwitch *switch1 = [[SPMultipleSwitch alloc] initWithItems:@[[NoticeTools getLocalStrWith:@"luy.tuijian"],[NoticeTools chinese:@"免费" english:@"Free" japan:@"無料"]]];
    switch1.titleFont = TWOTEXTFONTSIZE;
    switch1.frame = CGRectMake(DR_SCREEN_WIDTH-20-64*2,18,64*2,24);
    switch1.selectedTitleColor = [UIColor colorWithHexString:@"#25262E"];
    switch1.titleColor = [[UIColor colorWithHexString:@"#5C5F66"] colorWithAlphaComponent:1];
    switch1.trackerColor = [UIColor colorWithHexString:@"#FFFFFF"];
    switch1.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
    self.switchButton = switch1;
    [self.switchButton addTarget:self action:@selector(changeVale:) forControlEvents:UIControlEventTouchUpInside];
    
    self.freeArr = [[NSMutableArray alloc] init];
    self.dataArr = [[NSMutableArray alloc] init];
    [self.view addSubview:self.collectionView];
    
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"skin.gxchange"];;
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.needHideNavBar = YES;
    
    self.localArr = [[NSMutableArray alloc] init];
    
    NSArray *titleArr = @[[NoticeTools getLocalStrWith:@"skin.mr"],[NoticeTools getLocalStrWith:@"skin.zdy"]];
    NSArray *defaultArr = @[@"",@"cusoutm_skin"];//
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    for (int i = 0; i < 2; i++) {
        NoticeSkinModel *localM = [[NoticeSkinModel alloc] init];
        localM.title = titleArr[i];
        localM.defaultImg = defaultArr[i];
        if (i==0) {
            localM.image_url = userM.spec_bg_default_photo;
        }
        if (i == userM.spec_bg_type.intValue-1) {
            localM.isSelect = YES;
        }
        [self.localArr addObject:localM];
    }
    [UIView performWithoutAnimation:^{
       //刷新界面
        [self.collectionView reloadData];
     }];
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    __weak typeof(self) weakSelf = self;
    self.isDown = YES;
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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
}
  
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isDown = YES;
    self.pageNo = 1;
    [self request];
}

- (void)request{
    NSString *url = @"";
    if (self.isDown) {
        url = [NSString stringWithFormat:@"user/skin/list?pageNo=1&isFree=%d",self.isFree?1:0];
    }else{
        url = [NSString stringWithFormat:@"user/skin/list?pageNo=%ld&isFree=%d",self.pageNo,self.isFree?1:0];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (success) {
            if (self.isDown) {
                self.isDown = NO;
                if(self.isFree){
                    [self.freeArr removeAllObjects];
                }else{
                    [self.dataArr removeAllObjects];
                }
                
            }
            for (NSDictionary *dic in dict[@"data"][@"skin_list"]) {
                NoticeSkinModel *model = [NoticeSkinModel mj_objectWithKeyValues:dic];
                model.isSelect = model.is_set.boolValue;
                if(self.isFree){
                    [self.freeArr addObject:model];
                }else{
                    [self.dataArr addObject:model];
                }
                
            }
            [UIView performWithoutAnimation:^{
               //刷新界面
                [self.collectionView reloadData];
             }];
            
        }
    } fail:^(NSError * _Nullable error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

@end

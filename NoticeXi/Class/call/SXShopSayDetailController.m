//
//  SXShopSayDetailController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayDetailController.h"
#import "SXShopSayDetailCell.h"
#import "SXShopSayDetailSection.h"
#import "SXShopSayNavView.h"
@interface SXShopSayDetailController ()
@property (nonatomic, strong) SXShopSayNavView *shopInfoView;
@property (nonatomic, assign) CGFloat imageViewHeight;
@end

@implementation SXShopSayDetailController

- (SXShopSayNavView *)shopInfoView{
    if (!_shopInfoView) {
        _shopInfoView = [[SXShopSayNavView  alloc] initWithFrame:CGRectMake(54, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH-54-54, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
        _shopInfoView.model = self.model;
        [self.navBarView addSubview:_shopInfoView];
        _shopInfoView.hidden = YES;
    }
    return _shopInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViewHeight = (DR_SCREEN_WIDTH-40)/3;
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT);
    [self.tableView registerClass:[SXShopSayDetailCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[SXShopSayDetailSection class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-5-35,STATUS_BAR_HEIGHT, 35,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    [moreBtn setImage: [UIImage imageNamed:@"img_scb_b"]  forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(actionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:moreBtn];
}

- (void)actionClick{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SXShopSayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.imageHeight = self.imageViewHeight;
        cell.model = self.model;
        return cell;
    }else{
        BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SXShopSayListModel *sayM = self.model;
        return 66 + 70 + sayM.longcontentHeight + (sayM.hasImageV?(self.imageViewHeight+10):0);
    }else{
        return 0;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?0:40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SXShopSayDetailSection *sectionV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    sectionV.mainTitleLabel.text = @"123条评论";
    return sectionV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 56) {
        self.shopInfoView.hidden = NO;
    }else{
        self.shopInfoView.hidden = YES;
    }
}
@end

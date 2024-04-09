//
//  NoticeJieYouGoodsController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouGoodsController.h"
#import "NoticeAddSellMerchantController.h"
#import "NoticeChoiceJieyouChatCell.h"
#import "NoticeShopMyWallectController.h"
#import "NoticeHasServeredController.h"
#import "NoticeXi-Swift.h"
#import "NoticeShopDetailSection.h"
@interface NoticeJieYouGoodsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *freeButton;
@property (nonatomic, assign) BOOL hasFree;
@end

@implementation NoticeJieYouGoodsController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];

        _tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 123;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[NoticeChoiceJieyouChatCell class] forCellReuseIdentifier:@"cell1"];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[NoticeShopDetailSection class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    self.view.backgroundColor =  [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-50-40);

}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;

    if (!self.goodssellArr.count) {
        [self requestGoods];
    }
    [self.tableView reloadData];
}

//获取在售商品
- (void)requestGoods{
 
    if (!self.goodssellArr) {
        self.goodssellArr = [[NSMutableArray alloc] init];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shopGoods/byUser" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            for (NSDictionary *dic in dict[@"data"][@"goodsList"]) {
                NoticeGoodsModel *model = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                [self.goodssellArr addObject:model];
            }
     
            [self refreshIfHasFree];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(self.shopModel.myShopM.operate_status.integerValue == 2){
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"店铺营业中，不能更换售卖的商品哦" message:nil cancleBtn:@"知道了"];
            [alerView showXLAlertView];
            return;
        }
        [self addClick];
    }
   
}

- (void)addClick{
    if (!self.shopModel) {
        return;
    }
    NoticeAddSellMerchantController *ctl = [[NoticeAddSellMerchantController alloc] init];
    ctl.goodsModel = self.shopModel;
    __weak typeof(self) weakSelf = self;
    ctl.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
        weakSelf.goodssellArr = goodsArr;
        [weakSelf refreshIfHasFree];
    };
    ctl.changePriceBlock = ^(NSString * _Nonnull price) {
        for (NoticeGoodsModel *model in self.goodssellArr) {
            if(model.type.intValue == 2 && !model.is_experience.boolValue){
                model.price = price;
                [weakSelf.tableView reloadData];
                break;
            }
        }
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

//添加在售免费商品
- (void)addFreeClick{
    if (!self.shopModel) {
        return;
    }
    if(self.shopModel.myShopM.operate_status.integerValue == 2){
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"店铺营业中，不能更换售卖的商品哦" message:nil cancleBtn:@"知道了"];
        [alerView showXLAlertView];
        return;
    }
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/goodsList" Accept:@"application/vnd.shengxi.v5.8.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            for (NSDictionary *dic in dict[@"data"][@"goods_list"]) {
                NoticeGoodsModel *goods = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                if (goods.is_experience.boolValue) {
                    [self.goodssellArr insertObject:goods atIndex:0];
                    [self refreshSelledGoods];
                    break;
                }
            }
            [self.tableView reloadData];
        }
        [self hideHUD];
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)refreshSelledGoods{
    if (!self.goodssellArr.count) {
        return;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];


    if(self.goodssellArr.count==1){
        NoticeGoodsModel *good1 = self.goodssellArr[0];
        [parm setObject:good1.goodId forKey:@"goodsId"];
    }else if (self.goodssellArr.count == 2){
        NoticeGoodsModel *good1 = self.goodssellArr[0];
        NoticeGoodsModel *good2 = self.goodssellArr[1];
        [parm setObject:[NSString stringWithFormat:@"%@,%@",good1.goodId,good2.goodId] forKey:@"goodsId"];
    }
    __weak typeof(self) weakSelf = self;
   
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shop/setShopProduct" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [weakSelf hideHUD];
        if(success){
            [weakSelf refreshIfHasFree];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.goodssellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChoiceJieyouChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.goodModel = self.goodssellArr[indexPath.row];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.subTitleLabel.hidden = YES;
    headV.subImageView.hidden = YES;
    [_footView removeFromSuperview];
    [_freeButton removeFromSuperview];
    if (!self.goodssellArr.count) {//没有在售商品
        
        [headV addSubview:self.footView];
    }else{
        if (!self.hasFree) {
            [headV addSubview:self.freeButton];
        }
    }
    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.goodssellArr.count) {
        return self.footView.frame.size.height;
    }else{
        if (self.hasFree) {
            return 0;
        }else{
            return self.freeButton.frame.size.height;
        }
    }
}

- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, (DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)/2)];
        _footView.backgroundColor = [UIColor whiteColor];

        UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-60)/2, (_footView.frame.size.height-150)/2, 60, 60)];
        imageV.image = UIImageNamed(@"sxnogoodsshow");
        [_footView addSubview:imageV];
        
        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+12, DR_SCREEN_WIDTH, 20)];
        markL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        markL.font = FOURTHTEENTEXTFONTSIZE;
        markL.textAlignment = NSTextAlignmentCenter;
        markL.text = @"有服务商品才能开始营业噢～";
        [_footView addSubview:markL];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-93)/2, CGRectGetMaxY(markL.frame)+20, 93, 32)];
        addBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [addBtn setAllCorner:16];
        [addBtn setTitle:@"添加商品" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:addBtn];
    }
    return _footView;
}

- (UIButton *)freeButton{
    if (!_freeButton) {
        _freeButton = [[UIButton  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30)*48/345)];
        [_freeButton setBackgroundImage:UIImageNamed(@"addfreegood_img") forState:UIControlStateNormal];
        [_freeButton addTarget:self action:@selector(addFreeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _freeButton;
}

- (void)refreshIfHasFree{
    
    if (self.refreshGoodsBlock) {
        self.refreshGoodsBlock(self.goodssellArr);
    }
    
    BOOL hasFree = NO;
    for (NoticeGoodsModel * goods in self.goodssellArr) {
        if (goods.is_experience.boolValue) {
            hasFree = YES;
            break;
        }
    }

    self.hasFree = hasFree;
    [self.tableView reloadData];
}


- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}



@end

//
//  NoticeJieYouGoodsController.m
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeJieYouGoodsController.h"
#import "NoticeAddSellMerchantController.h"
#import "NoticeChatVoiceShopCell.h"
#import "NoticeShopMyWallectController.h"
#import "NoticeHasServeredController.h"
#import "NoticeXi-Swift.h"
#import "NoticeShopDetailSection.h"
#import "SXUpGoodsToSellView.h"
#import "SXAddNewGoodsController.h"
@interface NoticeJieYouGoodsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *freeButton;
@property (nonatomic, assign) BOOL hasFree;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) SXUpGoodsToSellView *sellView;
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
        [_tableView registerClass:[NoticeChatVoiceShopCell class] forCellReuseIdentifier:@"cell1"];
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
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-50-44-10);

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
 
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@/goods",self.shopModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            [self.goodssellArr removeAllObjects];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeGoodsModel *goods = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                
                if (goods.tagString) {
                    goods.nameHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-96-60 string:goods.goods_name andFirstWidth:GET_STRWIDTH(goods.tagString, 11, 20)+10+5];
                    if (goods.nameHeight < 20) {
                        goods.nameHeight = 20;
                    }
                }else{
                    goods.nameHeight = [SXTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-96-60 string:goods.goods_name isJiacu:YES];
                    if (goods.nameHeight < 20) {
                        goods.nameHeight = 20;
                    }
                }
                
                [self.goodssellArr addObject:goods];
            }
            if (self.goodssellArr.count) {
                if (self.refreshGoodsBlock) {
                    self.refreshGoodsBlock(self.goodssellArr);
                }
                [self.tableView reloadData];
            }
      
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
        
        NoticeGoodsModel *goodM = self.goodssellArr[indexPath.row];
        if (goodM.is_experience.boolValue) {
            return;
        }
        SXAddNewGoodsController *ctl = [[SXAddNewGoodsController alloc] init];
        ctl.goodsModel = self.shopModel;
        ctl.changeGoodModel = goodM;
        __weak typeof(self) weakSelf = self;
        ctl.refreshBlock = ^(BOOL refresh) {
            [weakSelf requestGoods];
        };
        [self.navigationController pushViewController:ctl animated:YES];
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
        for (int i = 0; i < weakSelf.goodssellArr.count;i++) {
            NoticeGoodsModel *goods = weakSelf.goodssellArr[i];
            if (goods.is_experience.boolValue) {
                [weakSelf.goodssellArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                break;
            }
        }
        [weakSelf.tableView reloadData];
    };
    ctl.deleteGoodMBlock = ^(NoticeGoodsModel * _Nonnull deleteModel) {
        for (NoticeGoodsModel *oldM in weakSelf.goodssellArr) {
            if ([oldM.goodId isEqualToString:deleteModel.goodId]) {
                [self.goodssellArr removeObject:oldM];
                [self.tableView reloadData];
                break;
            }
        }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.goodssellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChatVoiceShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.noneedEdit = YES;
    cell.isSelfLook = YES;
    cell.shopId = self.shopModel.myShopM.shopId;
    cell.goodModel = self.goodssellArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NoticeGoodsModel *goods = self.goodssellArr[indexPath.row];
    if (goods.is_experience.boolValue) {
        return 101+8;
    }
    return goods.nameHeight+92+15+8-45;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.subTitleLabel.hidden = YES;
    headV.subImageView.hidden = YES;
    headV.mainTitleLabel.text = @"在售服务";
    headV.mainTitleLabel.frame = CGRectMake(15,0, 200,37);
    if (!self.goodssellArr.count) {//没有在售商品
        self.tableView.tableFooterView = self.footView;
    }else{
        self.tableView.tableFooterView = nil;
    }
    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37;
}

- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, 132)];
        _footView.backgroundColor = [UIColor whiteColor];


        UILabel *markL = [[UILabel  alloc] initWithFrame:CGRectMake(0,0, DR_SCREEN_WIDTH, 132)];
        markL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        markL.font = FOURTHTEENTEXTFONTSIZE;
        markL.textAlignment = NSTextAlignmentCenter;
        markL.text = @"有服务商品才能开始营业噢～";
        [_footView addSubview:markL];
        

    }
    return _footView;
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

- (UIView *)headView{
    if (!_headView) {
        
        _headView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 100)];
        CGFloat width = (DR_SCREEN_WIDTH-45)/2;
        for (int i = 0; i < 2; i++) {
            FSCustomButton *button = [[FSCustomButton  alloc] initWithFrame:CGRectMake(15+(width+15)*i, 18, width, 64)];
            button.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            [button setAllCorner:10];
            button.titleLabel.font = XGFourthBoldFontSize;
            [button setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            [button setTitle:i==0?@"  管理服务列表":@"  上架服务" forState:UIControlStateNormal];
            button.tag = i;
            [button setImage:i==0?UIImageNamed(@"sx_managergood"):UIImageNamed(@"sx_upgoods") forState:UIControlStateNormal];
            button.buttonImagePosition = FSCustomButtonImagePositionLeft;
            [button addTarget:self action:@selector(funClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headView addSubview:button];
        }
    }
    return _headView;
}

- (void)funClick:(FSCustomButton *)button{
    if(self.shopModel.myShopM.operate_status.integerValue == 2){
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"店铺营业中，不能更换修改商品哦" message:nil cancleBtn:@"知道了"];
        [alerView showXLAlertView];
        return;
    }
    if (button.tag == 0) {
        [self addClick];
    }else{
        if(!self.goodssellArr.count){
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"请在管理列表添加收费服务" message:nil cancleBtn:@"知道了"];
            [alerView showXLAlertView];
            return;
        }
        [self.sellView showATView];
    }
}

- (SXUpGoodsToSellView *)sellView{
    if (!_sellView) {
        _sellView = [[SXUpGoodsToSellView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _sellView.goodsModel = self.shopModel;
        __weak typeof(self) weakSelf = self;
        _sellView.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
            weakSelf.goodssellArr = goodsArr;
            for (int i = 0; i < weakSelf.goodssellArr.count;i++) {
                NoticeGoodsModel *goods = weakSelf.goodssellArr[i];
                if (goods.is_experience.boolValue) {
                    [weakSelf.goodssellArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                    break;
                }
            }
            [weakSelf.tableView reloadData];
        };
    }
    return _sellView;
}
@end

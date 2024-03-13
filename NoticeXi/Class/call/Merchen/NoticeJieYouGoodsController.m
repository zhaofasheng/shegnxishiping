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
@interface NoticeJieYouGoodsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UILabel *defaultL;

@property (nonatomic, strong) UILabel *orderNumL;
@property (nonatomic, strong) UILabel *jingbNumL;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *freeButton;
@end

@implementation NoticeJieYouGoodsController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];

        _tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[NoticeChoiceJieyouChatCell class] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 123;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
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
    }else if (self.goodssellArr.count == 3){
        NoticeGoodsModel *good1 = self.goodssellArr[0];
        NoticeGoodsModel *good2 = self.goodssellArr[1];
        NoticeGoodsModel *good3 = self.goodssellArr[2];
        [parm setObject:[NSString stringWithFormat:@"%@,%@,%@",good1.goodId,good2.goodId,good3.goodId] forKey:@"goodsId"];
    }
    __weak typeof(self) weakSelf = self;
   
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shop/setShopProduct" Accept:@"application/vnd.shengxi.v5.5.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [weakSelf hideHUD];
        if(success){
            [weakSelf.tableView reloadData];
            if(self.refreshGoodsBlock){
               self.refreshGoodsBlock(self.goodssellArr);
            }
            [weakSelf refreshIfHasFree];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)addFreeClick{
    if(self.goodsModel.myShopM.operate_status.integerValue == 2){
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
        }else{
            [self hideHUD];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (UIButton *)freeButton{
    if (!_freeButton) {
        _freeButton = [[UIButton  alloc] initWithFrame:CGRectMake(15, 94, DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30)*48/345)];
        [_freeButton setBackgroundImage:UIImageNamed(@"addfreegood_img") forState:UIControlStateNormal];
        [self.backView addSubview:_freeButton];
        [_freeButton addTarget:self action:@selector(addFreeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _freeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor =  [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50-BOTTOM_HEIGHT-50-40);
    if(self.isUserLookShop){
      self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-40);
    }
    
    if (!self.isUserLookShop) {
        [self refreshBackview];
    }
 
    [self.view setCornerOnTopRight:20];
    
    if (!self.isUserLookShop) {
        [self requestGoods];
    }
   
    if (self.isUserLookShop) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestGoods) name:@"SHOPHASJUBAOEDSELFJUBAO" object:nil];//买家结束
    }
}

- (void)refreshIfHasFree{
    if (!self.isUserLookShop) {
        BOOL hasFree = NO;
        for (NoticeGoodsModel * goods in self.goodssellArr) {
            if (goods.is_experience.boolValue) {
                hasFree = YES;
                break;
            }
        }
        if (!self.goodssellArr.count) {//必须存在付费商品才提示
            hasFree = YES;
        }
        if (!hasFree) {
            self.freeButton.hidden = NO;
            self.backView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 94+self.freeButton.frame.size.height);
        }else{
            self.freeButton.hidden = YES;
            self.backView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 94);
        }
        [self.tableView reloadData];
    }

}

- (void)refreshBackview{
    if (!self.backView) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 94)];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.backView = backView;
        self.tableView.tableHeaderView = backView;
        
        for (int i = 0; i < 2; i++) {
            UIView *tapV = [[UIView alloc] initWithFrame:CGRectMake(104*i+15, 0, 104, 94)];
            tapV.tag = i;
            tapV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderTap:)];
            [tapV addGestureRecognizer:tapOrder];
            [backView addSubview:tapV];
            
            UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 104, 26)];
            numL.font = XGTwentyTwoBoldFontSize;
            numL.textColor = [UIColor colorWithHexString:@"#25262E"];
            numL.textAlignment = NSTextAlignmentCenter;
            numL.text = @"0";
            [tapV addSubview:numL];

            
            UILabel *numL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 104, 20)];
            numL1.font = FOURTHTEENTEXTFONTSIZE;
            numL1.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            numL1.textAlignment = NSTextAlignmentCenter;
            [tapV addSubview:numL1];
            
            if(i == 0){
                numL1.text = @"订单数";
                self.orderNumL = numL;
            }else{
                numL1.text = @"收入(鲸币)";
                self.jingbNumL = numL;
            }
        }
        
        UIButton *tixBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-15-60-15, 31, 60, 32)];
        tixBtn.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        tixBtn.layer.cornerRadius = 16;
        tixBtn.layer.masksToBounds = YES;
        [tixBtn setTitle:@"提现" forState:UIControlStateNormal];
        [tixBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tixBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [tixBtn addTarget:self action:@selector(tixianClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:tixBtn];
    }
}

- (void)setGoodsModel:(NoticeMyShopModel *)goodsModel{
    _goodsModel = goodsModel;
    [self refreshBackview];
    if (!self.isUserLookShop) {
        self.orderNumL.text = goodsModel.myShopM.order_num.intValue?goodsModel.myShopM.order_num:@"0";
        self.jingbNumL.text = goodsModel.myShopM.income.intValue?[NSString stringWithFormat:@"%.2f",goodsModel.myShopM.income.floatValue]:@"0";
    }
}

//提现
- (void)tixianClick{
    NoticeShopMyWallectController *ctl = [[NoticeShopMyWallectController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

//订单数量，收入
- (void)orderTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if(tapV.tag == 0){
        NoticeHasServeredController *ctl = [[NoticeHasServeredController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else{
        if(self.goodsModel.myShopM.income.intValue <= 0){
            [YZC_AlertView showViewWithTitleMessage:@"店铺还没有收入哦~"];
            return;
        }
        NoticeShopChangeRecoderController *ctl = [[NoticeShopChangeRecoderController alloc] init];
        ctl.isShouRuDetail = YES;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}


- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 112)];
        _footView.backgroundColor = [UIColor whiteColor];
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 112)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        [_footView addSubview:backV];
        
        UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, DR_SCREEN_WIDTH-30, 20)];
        numL.font = FOURTHTEENTEXTFONTSIZE;
        numL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        numL.textAlignment = NSTextAlignmentCenter;
        numL.text = @"还没上架商品噢～";
        [backV addSubview:numL];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((backV.frame.size.width-93)/2, 56, 93, 32)];
        addBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        addBtn.layer.cornerRadius = 16;
        addBtn.layer.masksToBounds = YES;
        [addBtn setTitle:@"添加商品" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [backV addSubview:addBtn];
    }
    return _footView;
}

- (void)requestGoods{
 
    if (!self.goodssellArr) {
        self.goodssellArr = [[NSMutableArray alloc] init];
    }
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:self.isUserLookShop? [NSString stringWithFormat:@"shop/%@/goods",self.shopDetailModel.myShopM.shopId] :@"shopGoods/byUser" Accept:@"application/vnd.shengxi.v5.6.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if (self.isUserLookShop) {
                [self.goodssellArr removeAllObjects];
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeGoodsModel *model = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                    [self.goodssellArr addObject:model];
                }
                if (_goodssellArr.count) {
                    self.tableView.tableHeaderView = nil;
                    if(self.refreshGoodsBlock){
                       self.refreshGoodsBlock(self.goodssellArr);
                    }
                }else{
                    self.tableView.tableHeaderView = self.defaultL;
                    self.defaultL.text = @"店铺还没有营业哦~";
                }
           
            }else{
                for (NSDictionary *dic in dict[@"data"][@"goodsList"]) {
                    NoticeGoodsModel *model = [NoticeGoodsModel mj_objectWithKeyValues:dic];
                    [self.goodssellArr addObject:model];
                }
                if (_goodssellArr.count) {
                    self.tableView.tableFooterView = nil;
                    if(self.refreshGoodsBlock){
                       self.refreshGoodsBlock(self.goodssellArr);
                    }
                }else{
                    self.tableView.tableFooterView = self.footView;
                }
                [self refreshIfHasFree];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)setShopDetailModel:(NoticeMyShopModel *)shopDetailModel{
    _shopDetailModel = shopDetailModel;

    [self requestGoods];
}

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] initWithFrame:self.tableView.bounds];
        _defaultL.textAlignment = NSTextAlignmentCenter;
        _defaultL.font = FOURTHTEENTEXTFONTSIZE;
        _defaultL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    }
    return _defaultL;
}

- (void)addClick{
    NoticeAddSellMerchantController *ctl = [[NoticeAddSellMerchantController alloc] init];
    ctl.goodsModel = self.goodsModel;
    __weak typeof(self) weakSelf = self;
    ctl.refreshGoodsBlock = ^(NSMutableArray * _Nonnull goodsArr) {
        weakSelf.goodssellArr = goodsArr;
        [weakSelf refreshIfHasFree];
        [weakSelf.tableView reloadData];
        if(weakSelf.refreshGoodsBlock){
            weakSelf.refreshGoodsBlock(weakSelf.goodssellArr);
        }
        if (goodsArr.count) {
            weakSelf.tableView.tableFooterView = nil;
        }else{
            weakSelf.tableView.tableFooterView = weakSelf.footView;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isUserLookShop){
        return;
    }
    if(self.goodsModel.myShopM.operate_status.integerValue == 2){
        XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"店铺营业中，不能更换售卖的商品哦" message:nil cancleBtn:@"知道了"];
        [alerView showXLAlertView];
        return;
    }
    [self addClick];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.goodssellArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeChoiceJieyouChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isUserLookShop = self.isUserLookShop;
    if (self.isUserLookShop) {
        __weak typeof(self) weakSelf = self;
        cell.buyGoodsBlock = ^(NoticeGoodsModel * _Nonnull buyGood) {
            if(weakSelf.buyGoodsBlock){
                weakSelf.buyGoodsBlock(buyGood);
            }
        };
    }
    cell.goodModel = self.goodssellArr[indexPath.row];
    return cell;
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

//
//  NoticeShopCardController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/8.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopCardController.h"
#import "NoticeShopDetailHeader.h"
#import "NoticeShopDetailSection.h"
#import "NoticeShopPhotosCell.h"
#import "NoticeJieYouGoodsComController.h"
#import "NoticeChoiceJieyouChatCell.h"
#import "NoticeShopChatCommentCell.h"
#import "NoticeAddSellMerchantController.h"
@interface NoticeShopCardController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NoticeShopDetailHeader *headerView;
@property (nonatomic, strong) NSMutableArray *comArr;
@property (nonatomic, strong) NSMutableArray *goodssellArr;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *freeButton;
@property (nonatomic, assign) BOOL hasFree;
@end

@implementation NoticeShopCardController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];

        _tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[NoticeShopChatCommentCell class] forCellReuseIdentifier:@"cell"];
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



- (void)request{
    NSString *url = @"";

    url = [NSString stringWithFormat:@"shopGoodsOrder/getShopComment/%@?type=1&pageNo=1",self.shopModel.myShopM.shopId];
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:@"application/vnd.shengxi.v5.5.0+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                if (self.comArr.count == 2) {
                    break;
                }
                NoticeShopCommentModel *model = [NoticeShopCommentModel mj_objectWithKeyValues:dic];
                if (!model.marks || model.marks.length <= 0) {
                    if(model.score.intValue == 1){
                        model.marks = @"Ta觉得太治愈了";
                    }else if (model.score.intValue == 2){
                        model.marks = @"Ta觉得还可以啦";
                    }else{
                        model.marks = @"Ta觉得不太行噢";
                    }
                }
                [self.comArr addObject:model];

            }
        
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-BOTTOM_HEIGHT-50-40);
  
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.view setCornerOnTopRight:20];
    
    [self.tableView registerClass:[NoticeShopDetailSection class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    
    self.headerView = [[NoticeShopDetailHeader  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH,330)];
    __weak typeof(self) weakSelf = self;
    self.headerView.refreshShopModel = ^(BOOL refresh) {
        if (weakSelf.refreshShopModel) {
            weakSelf.refreshShopModel(YES);
        }
    };
    
    self.headerView.shopModel = self.shopModel;
    self.tableView.tableHeaderView = self.headerView;
    
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
    self.headerView.goodsNum = self.goodssellArr.count;
    self.hasFree = hasFree;
    [self.tableView reloadData];
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    self.headerView.shopModel = shopModel;
    if (!self.comArr.count) {
        [self request];
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        NoticeChoiceJieyouChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.goodModel = self.goodssellArr[indexPath.row];
        return cell;
    }else{
        NoticeShopChatCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.isUserView = NO;
        cell.commentModel = self.comArr[indexPath.row];
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 123;
    }else{
        
        NoticeShopCommentModel *model = self.comArr[indexPath.row];

        return model.marksHeight+(model.labelHeight>0?(model.labelHeight+8):0)+15+57+8;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.comArr.count;
    }
    return self.goodssellArr.count;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{


    NoticeShopDetailSection *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headV.subTitleLabel.hidden = YES;
    headV.subImageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    headV.tapBlock = ^(BOOL tap) {
        if (section == 1 && weakSelf.shopModel.myShopM.comment_num.intValue) {
            NoticeJieYouGoodsComController *ctl = [[NoticeJieYouGoodsComController alloc] init];
            ctl.shopId = weakSelf.shopModel.myShopM.shopId;
            ctl.commentNum = weakSelf.shopModel.myShopM.comment_num;
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }
    };
    if (section == 0) {
        [_footView removeFromSuperview];
        [_freeButton removeFromSuperview];
        if (!self.goodssellArr.count) {//没有在售商品
            
            [headV addSubview:self.footView];
        }else{
            if (!self.hasFree) {
                [headV addSubview:self.freeButton];
            }
        }
        headV.mainTitleLabel.text = @"咨询服务";
    }else{
        headV.mainTitleLabel.text = @"评价";
        headV.subTitleLabel.hidden = NO;
        if (self.shopModel.myShopM.comment_num.intValue) {
            headV.subImageView.hidden = NO;
            headV.subTitleLabel.frame = CGRectMake(DR_SCREEN_WIDTH-15-16-200, 0, 200, 37);
            headV.subTitleLabel.text = [NSString stringWithFormat:@"全部%@条",self.shopModel.myShopM.comment_num];
        }else{
            headV.subTitleLabel.frame = CGRectMake(DR_SCREEN_WIDTH-15-200, 0, 200, 37);
            headV.subTitleLabel.text = @"还没有评价";
        }
    }
    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (!self.goodssellArr.count) {
            return 37+90;
        }else{
            if (self.hasFree) {
                return 37;
            }else{
                return 37+self.freeButton.frame.size.height;
            }
        }
    }
    return 37;
}

- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, DR_SCREEN_WIDTH, 90)];
        _footView.backgroundColor = [UIColor whiteColor];
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 90)];
        backV.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backV.layer.cornerRadius = 10;
        backV.layer.masksToBounds = YES;
        [_footView addSubview:backV];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake((backV.frame.size.width-93)/2, 29, 93, 32)];
        addBtn.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
        [addBtn setAllCorner:16];
        [addBtn setTitle:@"添加商品" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        [backV addSubview:addBtn];
    }
    return _footView;
}

- (UIButton *)freeButton{
    if (!_freeButton) {
        _freeButton = [[UIButton  alloc] initWithFrame:CGRectMake(15, 37, DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30)*48/345)];
        [_freeButton setBackgroundImage:UIImageNamed(@"addfreegood_img") forState:UIControlStateNormal];
        [self.backView addSubview:_freeButton];
        [_freeButton addTarget:self action:@selector(addFreeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _freeButton;
}

- (NSMutableArray *)comArr{
    if (!_comArr) {
        _comArr = [[NSMutableArray alloc] init];
    }
    return _comArr;
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

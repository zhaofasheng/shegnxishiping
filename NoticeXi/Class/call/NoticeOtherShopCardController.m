//
//  NoticeOtherShopCardController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/10.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeOtherShopCardController.h"

#import "NoticeShopChatCommentCell.h"
#import "NoticeShopDetailSection.h"
#import "NoticeJieYouGoodsComController.h"
#import "NoticeChatVoiceShopCell.h"
@interface NoticeOtherShopCardController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *comArr;

@property (nonatomic, strong) NSMutableArray *goodssellArr;
@end

@implementation NoticeOtherShopCardController

- (NSMutableArray *)comArr{
    if (!_comArr) {
        _comArr = [[NSMutableArray alloc] init];
    }
    return _comArr;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];

        _tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:[NoticeChatVoiceShopCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[NoticeShopChatCommentCell class] forCellReuseIdentifier:@"cell1"];
        [_tableView registerClass:[NoticeShopDetailSection class] forHeaderFooterViewReuseIdentifier:@"headerView"];
        _tableView.rowHeight = 123;

            
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestGoods) name:@"SHOPHASJUBAOEDSELFJUBAO" object:nil];//买家结束
    }
    return _tableView;
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
            ctl.isUserLookShop = YES;
            ctl.commentNum = weakSelf.shopModel.myShopM.comment_num;
            [weakSelf.navigationController pushViewController:ctl animated:YES];
        }
    };
    if (section == 0) {
        if (self.shopModel.myShopM.operate_status.intValue > 1) {
            headV.mainTitleLabel.text = @"服务";
        }else{
            headV.mainTitleLabel.text = @"";
        }
        
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
        if (self.shopModel.myShopM.operate_status.intValue > 1) {
            return 37;
        }else{
            return 0;
        }
    }

    return 37;
}

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
            if (_goodssellArr.count) {
                if(self.refreshGoodsBlock){
                   self.refreshGoodsBlock(self.goodssellArr);
                }
            }
           // self.headerView.goodsNum = self.goodssellArr.count;
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
    
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
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-40);

    self.tableView.backgroundColor = self.view.backgroundColor;

    [self.tableView reloadData];
}


- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
 
    self.tableView.hidden = NO;
    
    if (!self.goodssellArr.count) {
        [self requestGoods];
    }

    if (!self.comArr.count) {
        [self request];
    }
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        
        NoticeChatVoiceShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.noneedEdit = YES;
        cell.isOtherLook = YES;
        if (self.shopModel.myShopM.operate_status.intValue > 1) {
            cell.goodModel = self.goodssellArr[indexPath.row];
        }
   
        return cell;
        
    }else{
        NoticeShopChatCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.isUserView = YES;
        cell.commentModel = self.comArr[indexPath.row];
        return cell;
    }
}

- (void)scrolllToGoods{
//    if (self.goodssellArr.count) {
//        [self.tableView setContentOffset:CGPointMake(0, self.headerView.frame.size.height)];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NoticeGoodsModel *goodM = self.goodssellArr[indexPath.row];
        if(self.buyGoodsBlock){
            self.buyGoodsBlock(goodM);
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.comArr.count;
    }
    if (self.shopModel.myShopM.operate_status.intValue > 1) {
        return self.goodssellArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.shopModel.myShopM.operate_status.intValue > 1) {
            NoticeGoodsModel *goods = self.goodssellArr[indexPath.row];
   
            return goods.nameHeight+92+15+8-45;
        }else{
            return 0;
        }
     
    }
    NoticeShopCommentModel *model = self.comArr[indexPath.row];

    return model.marksHeight+60+15+8;
    
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

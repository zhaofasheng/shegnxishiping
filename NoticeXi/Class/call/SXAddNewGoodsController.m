//
//  SXAddNewGoodsController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAddNewGoodsController.h"
#import "SXAddNewsGoods5Cell.h"
#import "SXAddNewsGoods4Cell.h"
#import "SXAddNewsGoods3Cell.h"
#import "SXAddNewsGoods2Cell.h"
#import "SXAddNewsGoods1Cell.h"
#import "NoticeChangeShopIconController.h"
#import "KMTagListView.h"
@interface SXAddNewGoodsController ()<KMTagListViewDelegate>
@property (nonatomic, strong) KMTagListView *labeView;
@property (nonatomic, strong) UIImage *choiceImage;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@end

@implementation SXAddNewGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navBarView.titleL.text = @"服务详情";
    [self.tableView registerClass:SXAddNewsGoods1Cell.class forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:SXAddNewsGoods2Cell.class forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:SXAddNewsGoods3Cell.class forCellReuseIdentifier:@"cell3"];
    [self.tableView registerClass:SXAddNewsGoods4Cell.class forCellReuseIdentifier:@"cell4"];
    [self.tableView registerClass:SXAddNewsGoods5Cell.class forCellReuseIdentifier:@"cell5"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    

    KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,50,DR_SCREEN_WIDTH-30, 0)];
    self.labeView = tagV;
    self.labeView.isChoiceTap = YES;

    [tagV setupCustomeSubViewsWithTitles:@[@"心理咨询",@"登记费",@"MBTI",@"复健科垃圾法师",@"的的",@"心理咨询",@"登记费",@"MBTI",@"复健科垃圾法师",@"的的",@"心理咨询",@"登记费",@"MBTI",@"复健科垃圾法师",@"的的"]];
    CGRect rect = tagV.frame;
    rect.size.height = tagV.contentSize.height;
    tagV.frame = rect;
    tagV.delegate_ = self;
    [self.tableView reloadData];
}

- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeChangeShopIconController *ctl = [[NoticeChangeShopIconController alloc] init];
        ctl.isChoiceGoods = YES;
        ctl.choiceImage = self.choiceImage;
        __weak typeof(self) weakSelf = self;
        ctl.choiceBlock = ^(NSString * _Nonnull imageUrl, UIImage * _Nonnull image) {
            weakSelf.choiceImage = image;
            weakSelf.imageUrl = imageUrl;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    [self.labeView removeFromSuperview];
    if (indexPath.row == 0) {
        SXAddNewsGoods1Cell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (self.choiceImage) {
            cell1.goodsImageView.image = self.choiceImage;
        }
        return cell1;
    }else if (indexPath.row == 1){
        SXAddNewsGoods2Cell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.nameBlock = ^(NSString * _Nonnull name) {
            weakSelf.name = name;
            DRLog(@"%@",name);
        };
        return cell2;
    }else if (indexPath.row == 2){
        SXAddNewsGoods3Cell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell3.priceBlock = ^(NSString * _Nonnull price) {
            weakSelf.price = price;
            DRLog(@"%@",price);
        };
        return cell3;
    }else if (indexPath.row == 3){
        SXAddNewsGoods4Cell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        return cell4;
    }else{
        SXAddNewsGoods5Cell *cell5 = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
        [cell5.backView addSubview:self.labeView];
        cell5.backView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 50+self.labeView.frame.size.height+10);
        return cell5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 86+8;
    }else if (indexPath.row == 1){
        return 100+8;
    }else if (indexPath.row == 2){
        return 50+8;
    }else if (indexPath.row == 3){
        return 106+8;
    }else{
        return 50+8+self.labeView.frame.size.height+10;
    }
}



@end

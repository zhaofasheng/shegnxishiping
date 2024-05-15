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
#import "SXGoodsInfoModel.h"
@interface SXAddNewGoodsController ()<KMTagListViewDelegate>
@property (nonatomic, strong) KMTagListView *labeView;
@property (nonatomic, strong) UIImage *choiceImage;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) SXGoodsInfoModel *infoModel;
@property (nonatomic, strong) NSString *category_Id;
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation SXAddNewGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.navBarView.titleL.text = @"服务详情";
    [self.tableView registerClass:SXAddNewsGoods1Cell.class forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:SXAddNewsGoods2Cell.class forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:SXAddNewsGoods3Cell.class forCellReuseIdentifier:@"cell3"];
    [self.tableView registerClass:SXAddNewsGoods4Cell.class forCellReuseIdentifier:@"cell4"];
    [self.tableView registerClass:SXAddNewsGoods5Cell.class forCellReuseIdentifier:@"cell5"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self requestInfo];


    [self.tableView reloadData];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-10-40, DR_SCREEN_WIDTH-40, 40)];
    self.addButton.layer.cornerRadius = 20;
    self.addButton.layer.masksToBounds = YES;
    self.addButton.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
    [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];

    [self.addButton setTitle:@"保存" forState:UIControlStateNormal];
    self.addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.view addSubview:self.addButton];
    [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addClick{
    if (!self.imageUrl && !self.changeGoodModel) {
        [self showToastWithText:@"请添加图片"];
        return;
    }
    
    if (!self.name) {
        [self showToastWithText:@"请输入商品名称"];
        return;
    }
    
    if (self.name.length > 20) {
        [self showToastWithText:@"商品名称字数不能超过20"];
        return;
    }
    
    if (!self.price.intValue) {
        [self showToastWithText:@"请输入商品价格"];
        return;
    }
    if (!self.time.intValue) {
        [self showToastWithText:@"请选择商品时长"];
        return;
    }
    
    if (!self.category_Id) {
        [self showToastWithText:@"请选中商品属性"];
        return;
    }
    
    [self showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    if (self.imageUrl) {
        [parm setObject:self.imageUrl forKey:@"goods_img_uri"];
    }
    [parm setObject:self.name forKey:@"goods_name"];
    [parm setObject:self.price forKey:@"price"];
    [parm setObject:self.time forKey:@"duration"];
    [parm setObject:self.category_Id forKey:@"category_id"];
    
    if (self.changeGoodModel) {
        [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"shop/goods/%@",self.changeGoodModel.goodId] Accept:@"application/vnd.shengxi.v5.8.2+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.refreshBlock) {
                    self.refreshBlock(YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }else{
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"shop/%@/goods",self.goodsModel.myShopM.shopId] Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [self hideHUD];
            if (success) {
                if (self.refreshBlock) {
                    self.refreshBlock(YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } fail:^(NSError * _Nullable error) {
            [self hideHUD];
        }];
    }

}

- (void)requestInfo{
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"shop/goods/attribute" Accept:@"application/vnd.shengxi.v5.8.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            self.infoModel = [SXGoodsInfoModel mj_objectWithKeyValues:dict[@"data"]];
            if (!self.changeGoodModel) {
                self.imageUrl = self.infoModel.goods_default_img_uri;
                self.name = @"语音通话";
                self.price = @"30";
                
                for (SXGoodsInfoModel *timeM in self.infoModel.timeArr) {
                    if (timeM.time.intValue == 30) {
                        timeM.isChoice = YES;
                        self.time = @"30";
                    }
                }
            }else{
                self.category_Id = self.changeGoodModel.category_id;
                self.name = self.changeGoodModel.goods_name;
                self.price = self.changeGoodModel.price;
                for (SXGoodsInfoModel *timeM in self.infoModel.timeArr) {
                    if (timeM.time.intValue == self.changeGoodModel.duration.intValue) {
                        timeM.isChoice = YES;
                        self.time = self.changeGoodModel.duration;
                    }
                }
            }
            
            KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,50,DR_SCREEN_WIDTH-30, 0)];
            self.labeView = tagV;
            self.labeView.isChoiceTap = YES;

            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (SXGoodsInfoModel *tagM in self.infoModel.cateArr) {
                [arr addObject:tagM.category_name];
            }
            [tagV setupCustomeSubViewsWithTitles:arr defaultStr:self.changeGoodModel.category_name];
            CGRect rect = tagV.frame;
            rect.size.height = tagV.contentSize.height;
            tagV.frame = rect;
            tagV.delegate_ = self;
            
            [self.tableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)ptl_TagListView:(KMTagListView*)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content{
    if (index < self.infoModel.cateArr.count) {
        self.category_Id = [self.infoModel.cateArr[index] category_Id];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoticeChangeShopIconController *ctl = [[NoticeChangeShopIconController alloc] init];
        ctl.isChoiceGoods = YES;
        if (self.choiceImage) {
            ctl.choiceImage = self.choiceImage;
        }else if (self.changeGoodModel){
            ctl.url = self.changeGoodModel.goods_img_url;
        }else{
            ctl.url = self.infoModel.goods_default_img_url;
        }
        
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
        if (self.choiceImage) {//修改过图片
            cell1.goodsImageView.image = self.choiceImage;
        }else if (self.changeGoodModel){//修改商品的时候没修改过图片
            [cell1.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.changeGoodModel.goods_img_url]];
        }else{//默认图片
            [cell1.goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.goods_default_img_url]];
        }
        return cell1;
    }else if (indexPath.row == 1){
        SXAddNewsGoods2Cell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.nameField.text = self.name;
        NSString *allStr = [NSString stringWithFormat:@"%lu/20",self.name.length];
        cell2.numL.attributedText = [DDHAttributedMode setColorString:allStr setColor:[UIColor colorWithHexString:@"#A1A7B3"] setLengthString:@"20" beginSize:allStr.length-2];
        cell2.nameBlock = ^(NSString * _Nonnull name) {
            weakSelf.name = name;
            DRLog(@"%@",name);
        };
        return cell2;
    }else if (indexPath.row == 2){
        SXAddNewsGoods3Cell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell3.nameField.text = self.price;
        cell3.priceBlock = ^(NSString * _Nonnull price) {
            weakSelf.price = price;
            DRLog(@"%@",price);
        };
        return cell3;
    }else if (indexPath.row == 3){
        SXAddNewsGoods4Cell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        cell4.timeArr = self.infoModel.timeArr;
        cell4.timeBlock = ^(NSString * _Nonnull time) {
            weakSelf.time = time;
        };
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

- (void)backClick{
    __weak typeof(self) weakSelf = self;
     XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"内容不会保存，确定离开吗？" message:nil sureBtn:@"再想想" cancleBtn:@"离开" right:YES];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    [alerView showXLAlertView];
}
@end

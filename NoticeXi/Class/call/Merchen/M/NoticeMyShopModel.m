//
//  NoticeMyShopModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMyShopModel.h"
#import "NoticeComLabelModel.h"
@implementation NoticeMyShopModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"shopId":@"id"};
}

- (void)setShop:(NSDictionary *)shop{
    _shop = shop;
    self.myShopM = [NoticeMyShopModel mj_objectWithKeyValues:shop];
}

- (void)setShop_wall_url:(NSArray *)shop_wall_url{
    _shop_wall_url = shop_wall_url;
    self.photowallArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in shop_wall_url) {
        NoticeShopDataIdModel *dataM = [NoticeShopDataIdModel mj_objectWithKeyValues:dic];
        [self.photowallArr addObject:dataM];
    }
}

- (void)setShop_label:(NSArray *)shop_label{
    _shop_label = shop_label;
    self.tagsArr = [[NSMutableArray alloc] init];
    self.tagsTextArr = [[NSMutableArray alloc] init];

    for (NSDictionary *dic in shop_label) {
        NoticeShopDataIdModel *dataM = [NoticeShopDataIdModel mj_objectWithKeyValues:dic];
        [self.tagsArr addObject:dataM];
        [self.tagsTextArr addObject:dataM.content?dataM.content:@""];
    }
    
    if (self.tagsTextArr.count) {
        self.tagString = [self.tagsTextArr componentsJoinedByString:@" · "];
    }
}

- (void)setTale:(NSString *)tale{
    _tale = tale;
    self.taleAtstr = [NoticeTools getStringWithLineHight:4 string:tale];
    self.taleHeight = [NoticeTools getHeightWithLineHight:4 font:15 width:DR_SCREEN_WIDTH-60 string:tale];
}

- (void)setRole_list:(NSArray *)role_list{
    _role_list = role_list;
    if (role_list.count) {
        self.role_listArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in role_list) {
            NoticeMyShopModel *roleM = [NoticeMyShopModel mj_objectWithKeyValues:dic];
            [self.role_listArr addObject:roleM];
        }
    }
}

- (void)setGoods_list:(NSMutableArray *)goods_list{
    _goods_list = goods_list;
    if (goods_list.count) {
        self.goods_listArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in self.goods_list) {
            NoticeGoodsModel *goodM = [NoticeGoodsModel mj_objectWithKeyValues:dic];
            [self.goods_listArr addObject:goodM];
        }
    }
}

- (void)setTexts:(NSDictionary *)texts{
    _texts = texts;
    self.textModel = [NoticeMyShopModel mj_objectWithKeyValues:texts];
}

- (void)setLabel_list:(NSArray *)label_list{
    _label_list = label_list;
    
    if(label_list.count){
        self.labelArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in label_list) {
            NoticeComLabelModel *comM = [NoticeComLabelModel mj_objectWithKeyValues:dic];
            if(comM.num.intValue){
                comM.showStr = [NSString stringWithFormat:@"%@ +%@",comM.title,comM.num];
            }else{
                comM.showStr = comM.title;
            }
            
            comM.showStrWidth = GET_STRWIDTH(comM.showStr, 14, 20);
            [self.labelArr addObject:comM];
        }
    }
}

- (void)setGoods:(NSDictionary *)goods{
    _goods = goods;
    self.goodsM = [NoticeGoodsModel mj_objectWithKeyValues:goods];
}
@end

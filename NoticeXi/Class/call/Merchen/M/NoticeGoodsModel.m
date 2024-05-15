//
//  NoticeGoodsModel.m
//  NoticeXi
//
//  Created by li lei on 2022/7/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeGoodsModel.h"

@implementation NoticeGoodsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"goodId":@"id"};
}

- (void)setCategory_name:(NSString *)category_name{
    _category_name = category_name;
    self.tagString = category_name;
}
@end

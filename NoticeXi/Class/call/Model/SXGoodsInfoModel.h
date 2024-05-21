//
//  SXGoodsInfoModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXGoodsInfoModel : NSObject

@property (nonatomic, strong) NSString *goods_default_img_uri;
@property (nonatomic, strong) NSString *goods_default_img_url;

@property (nonatomic, strong) NSArray *durations;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, assign) BOOL isChoice;
@property (nonatomic, strong) NSString *time;

@property (nonatomic, strong) NSArray *category_list;
@property (nonatomic, strong) NSMutableArray *cateArr;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *category_Id;
@property (nonatomic, assign) NSInteger cateWidth;
@end

NS_ASSUME_NONNULL_END

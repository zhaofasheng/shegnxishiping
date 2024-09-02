//
//  SXShopSayListModel.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXShopSayListModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSAttributedString *attStr;
@property (nonatomic, assign) CGFloat longcontentHeight;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) BOOL hasImageV;

@property (nonatomic, assign) CGFloat cellHeight;

+ (void)tuijiandinapu:(NSString *)shopId;
@end

NS_ASSUME_NONNULL_END

//
//  NoticeShopDetailSection.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopDetailSection : UITableViewHeaderFooterView
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *subImageView;
@property (nonatomic, strong) UILabel *editTitleLabel;
@property (nonatomic, strong) UIView *subEditView;
@property (nonatomic, copy) void(^editShopBlock)(BOOL edit);
@property (nonatomic,copy) void(^tapBlock)(BOOL tap);

@end

NS_ASSUME_NONNULL_END

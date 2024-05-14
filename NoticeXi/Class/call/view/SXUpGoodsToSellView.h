//
//  SXUpGoodsToSellView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXUpGoodsToSellView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *voiceArr;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, copy) void(^refreshGoodsBlock)(NSMutableArray *goodsArr);
@property (nonatomic, strong) NSMutableArray *freeArr;
@property (nonatomic, strong) NSMutableArray *choiceArr;
@property (nonatomic, strong) NoticeMyShopModel *goodsModel;
@property (nonatomic, strong) UIButton *addButton;
- (void)showATView;
@end

NS_ASSUME_NONNULL_END

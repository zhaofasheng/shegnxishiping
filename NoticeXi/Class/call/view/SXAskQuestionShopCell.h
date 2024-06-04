//
//  SXAskQuestionShopCell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SXAskQuestionShopCell : UICollectionViewCell<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *callView;
@property (nonatomic, strong) UILabel *tagL;
@property (nonatomic, strong) UILabel *moneyL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nickNameL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) NoticeMyShopModel *shopM;
@property (nonatomic, assign) BOOL isFree;
@end

NS_ASSUME_NONNULL_END

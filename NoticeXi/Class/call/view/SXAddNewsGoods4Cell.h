//
//  SXAddNewsGoods4Cell.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/14.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXAddNewsGoods4Cell : BaseCell<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, copy)  void(^timeBlock)(NSString *time);
@end

NS_ASSUME_NONNULL_END

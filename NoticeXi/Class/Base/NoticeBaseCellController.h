//
//  NoticeBaseCellController.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBaseCellController : NoticeBaseController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, strong) UILabel *defaultL;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

NS_ASSUME_NONNULL_END

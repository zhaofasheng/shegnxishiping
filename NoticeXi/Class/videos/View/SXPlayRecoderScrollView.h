//
//  SXPlayRecoderScrollView.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/24.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXPlayRecoderScrollView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIView *payView;
@end

NS_ASSUME_NONNULL_END

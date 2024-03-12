//
//  NoticeShopPhotosWall.h
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeShopPhotosWall : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) BOOL canChoice;
@property (nonatomic, assign) BOOL onLookBig;
@property (nonatomic,copy) void(^choiceUrlBlock)(NSString *choiceUrl);
@end

NS_ASSUME_NONNULL_END

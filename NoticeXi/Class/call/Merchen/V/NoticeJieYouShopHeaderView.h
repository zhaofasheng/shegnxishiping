//
//  NoticeJieYouShopHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2023/4/7.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeMyShopModel.h"
#import "NoticeShopPhotosWall.h"
#import "NoticeShopDetailHeader.h"
#import "NoticerUserShopDetailHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeJieYouShopHeaderView : UIView<NoticeRecordDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NoticeMyShopModel *shopModel;
@property (nonatomic, strong) NoticeShopPhotosWall *photosWall;
@property (nonatomic, strong) NoticeShopDetailHeader *detailHeader;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, assign) BOOL isUserLookShop;//是否是用户视角看店铺
@property (nonatomic, strong) NSTimer * _Nullable timer;
@property (nonatomic,copy) void(^choiceUrlBlock)(NSString *choiceUrl);
@property (nonatomic, strong) NoticerUserShopDetailHeaderView *headerView;
@end

NS_ASSUME_NONNULL_END

//
//  NoticeMoreClickView.h
//  NoticeXi
//
//  Created by li lei on 2022/9/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeMoreClickView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UITableView *funTableView;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, assign) BOOL isShareSerise;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL isPayVideo;
@property (nonatomic, assign) BOOL isShareBoKeAndMore;
@property (nonatomic, strong) NSString *wechatShareUrl;
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *voiceUrl;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *bokeId;
@property (nonatomic, copy) void(^clickIndexBlock)(NSInteger index);
@property (nonatomic, strong) NSArray *buttonNameArr;
@property (nonatomic, strong) NSArray *buttonImgArr;

@property (nonatomic, strong) NSString *qqShareUrl;//qq分享链接
@property (nonatomic, strong) NSString *friendShareUrl;//朋友圈分享链接
@property (nonatomic, strong) NSString *appletId;//小程序Id
@property (nonatomic, strong) NSString *appletPage;//小程序跳转页面

- (void)showTost;
@end

NS_ASSUME_NONNULL_END

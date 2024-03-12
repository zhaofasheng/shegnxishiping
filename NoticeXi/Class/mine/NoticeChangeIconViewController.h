//
//  NoticeChangeIconViewController.h
//  NoticeXi
//
//  Created by li lei on 2018/10/23.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeIconViewController : NoticeBaseCellController
@property (nonatomic,copy) void (^imageBlock)(UIImage *icon);
@property (nonatomic, strong) UIImage *image;
@end

NS_ASSUME_NONNULL_END

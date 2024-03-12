//
//  NoticeCropImageView.h
//  NoticeXi
//
//  Created by li lei on 2023/8/4.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCropImageView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void(^getCropImageBlock)(UIImage *cropImage);
- (instancetype)initCropViewWithImage:(UIImage *)CropImage andToView:(UIView *)toView;

@end

NS_ASSUME_NONNULL_END

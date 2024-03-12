//
//  bannerViewCell.m
//  ADBannerScroll
//
//  Created by Temporary on 16/1/25.
//  Copyright © 2016年 jsonmess. All rights reserved.
//

#import "bannerViewCell.h"
#import <UIImageView+WebCache.h>
@implementation bannerViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.showImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.showImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.showImageView setClipsToBounds:YES];
        [self.contentView addSubview:self.showImageView];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

/**
 *  设置banner Url;
 *
 *  @param bannerUrlStr url
 */
-(void)setDataOfBanner:(NSString*)bannerUrlStr isFromLocal:(BOOL)islocal
{
    if (islocal)
    {
        //本地图片
        UIImage* image = [UIImage imageNamed:bannerUrlStr];
        //占位视图nil
        self.showImageView.image = image == nil ? nil : image;
    }
    else
    {
        SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:bannerUrlStr] placeholderImage:nil options:newOptions completed:nil];
    }
    [self layoutIfNeeded];
}

@end

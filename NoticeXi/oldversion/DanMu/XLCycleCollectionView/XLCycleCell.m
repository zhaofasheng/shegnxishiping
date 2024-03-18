//
//  XLCycleCell.m
//  XLCycleCollectionViewDemo
//
//  Created by 赵发生 on 2017/3/6.
//  Copyright © 2017年 赵发生. All rights reserved.
//

#import "XLCycleCell.h"

@interface XLCycleCell ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation XLCycleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.backImageView];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setModel:(NoticeDanMuModel *)model{
    _model = model;
    SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
  
    self.titleL.text = model.podcast_title;
    self.nameL.text = model.nick_name?model.nick_name:@"声昔官方播客";
    self.introL.text = model.podcast_intro;
    
    self.hotL.hidden = NO;
    self.likeNumL.hidden = model.count_like.intValue?NO:YES;
    self.likeNumL.text = model.count_like;
    if (model.count_like.intValue) {
        [self.likeButton setBackgroundImage:UIImageNamed(!model.is_podcast_like.boolValue?@"Image_bokxhs":@"Image_bokxhss") forState:UIControlStateNormal];
        if (model.is_podcast_like.boolValue) {
            self.likeNumL.textColor = [UIColor colorWithHexString:@"#F47070"];
        }else{
            self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        }
    }else{
        [self.likeButton setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
    }
    
    if (model.count_comment.intValue) {
        [self.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdms") forState:UIControlStateNormal];
        self.comL.text = model.count_comment;
    }else{
        [self.comBtn setBackgroundImage:UIImageNamed(@"Image_bokdm") forState:UIControlStateNormal];
        self.comL.text = @"";
    }
}

- (void)likeClick{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"podcast/%@",self.model.podcast_no] Accept:@"application/vnd.shengxi.v5.4.3+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            self.model.is_podcast_like = self.model.is_podcast_like.boolValue?@"0":@"1";
            if (self.model.is_podcast_like.boolValue) {
                self.model.count_like = [NSString stringWithFormat:@"%ld",self.model.count_like.integerValue+1];
          
            }else{
                self.model.count_like = [NSString stringWithFormat:@"%ld",self.model.count_like.integerValue-1];
            }
            
            self.likeNumL.hidden = self.model.count_like.intValue?NO:YES;
            self.likeNumL.text = self.model.count_like;
            if (self.model.count_like.intValue) {
                [self.likeButton setBackgroundImage:UIImageNamed(!self.model.is_podcast_like.boolValue?@"Image_bokxhs":@"Image_bokxhss") forState:UIControlStateNormal];
                if (self.model.is_podcast_like.boolValue) {
                    self.likeNumL.textColor = [UIColor colorWithHexString:@"#F47070"];
                }else{
                    self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
                }
            }else{
                [self.likeButton setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
            }
            
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (UILabel *)hotL{
    if (!_hotL) {
        _hotL = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, GET_STRWIDTH([NoticeTools chinese:@"官方pick" english:@"Pick" japan:@"入選"], 12, 21)+8, 21)];
        _hotL.textColor = [UIColor whiteColor];
        _hotL.font = TWOTEXTFONTSIZE;
        _hotL.textAlignment = NSTextAlignmentCenter;
        _hotL.text = [NoticeTools chinese:@"官方pick" english:@"Pick" japan:@"入選"];
        _hotL.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        _hotL.layer.cornerRadius = 2;
        _hotL.layer.masksToBounds = YES;
        [self.backImageView addSubview:_hotL];
        [self.backImageView bringSubviewToFront:_hotL];
    }
    return _hotL;
}
@end

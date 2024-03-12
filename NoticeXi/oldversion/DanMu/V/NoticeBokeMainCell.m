//
//  NoticeBokeMainCell.m
//  NoticeXi
//
//  Created by li lei on 2022/11/10.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBokeMainCell.h"

@implementation NoticeBokeMainCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.backImageView];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        self.backImageView.userInteractionEnabled = YES;
        
        UIView *mbV = [[UIView alloc] initWithFrame:self.backImageView.bounds];
        mbV.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [self.backImageView addSubview:mbV];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = mbV.bounds;
        [mbV addSubview:visualView];
        
        UIImageView *mbLayer = [[UIImageView alloc] initWithFrame:mbV.bounds];
        mbLayer.image = UIImageNamed(@"mbLayer_img");
        [mbV addSubview:mbLayer];
        
        UIImageView *whiteLayer = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        whiteLayer.image = UIImageNamed(@"img_yinyingyuan");
        [self.contentView addSubview:whiteLayer];
        
        self.smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6,6,88, 88)];
        [whiteLayer addSubview:self.smallImageView];
        self.smallImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.smallImageView.clipsToBounds = YES;
        self.smallImageView.layer.cornerRadius = 44;
        self.smallImageView.userInteractionEnabled = YES;
        
        UIImageView *smallwhiteLayer = [[UIImageView alloc] initWithFrame:CGRectMake(29, 29, 30, 30)];
        smallwhiteLayer.image = UIImageNamed(@"img_smallyinyingyuan");
        [self.smallImageView addSubview:smallwhiteLayer];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,self.frame.size.height-59,self.backImageView.frame.size.width-16,20)];
        self.titleL.font = XGFourthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.titleL];

        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, self.frame.size.height-35,self.backImageView.frame.size.width-17, 20)];
        self.nameL.font = TWOTEXTFONTSIZE;
        self.nameL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:self.nameL];
        
        UIButton *funBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-18-24,15, 24, 24)];
        [funBtn setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
        [self.contentView addSubview:funBtn];
        self.likeButton = funBtn;
        self.likeNumL = [[UILabel alloc] initWithFrame:CGRectMake(self.likeButton.frame.origin.x+14, self.likeButton.frame.origin.y-7, 30, 14)];
        self.likeNumL.font = [UIFont systemFontOfSize:10];
        self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self.contentView addSubview:self.likeNumL];
        [funBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
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

- (void)setModel:(NoticeDanMuModel *)model{
    _model = model;
    
    SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url] placeholderImage:GETUIImageNamed(@"img_empty") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
  
    self.titleL.text = model.podcast_title;
    self.nameL.text = model.nick_name?model.nick_name:@"声昔官方播客";
    
    if (model.introeHeight <= 0) {
        model.introeHeight = GET_STRHEIGHT(model.podcast_title, 14, self.backImageView.frame.size.width-16);
        if (model.introeHeight > 40) {
            model.introeHeight = 40;
        }
    }

    self.hotL.hidden = model.is_hot.intValue?NO:YES;
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
}

- (UILabel *)hotL{
    if (!_hotL) {
        _hotL = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, GET_STRWIDTH([NoticeTools chinese:@"官方推荐" english:@"Recommended" japan:@"おすすめ"], 12, 21)+8, 21)];
        _hotL.textColor = [UIColor whiteColor];
        _hotL.font = TWOTEXTFONTSIZE;
        _hotL.textAlignment = NSTextAlignmentCenter;
        _hotL.text = [NoticeTools chinese:@"官方推荐" english:@"Recommended" japan:@"おすすめ"];
        _hotL.backgroundColor = [UIColor colorWithHexString:@"#00ABE4"];
        _hotL.layer.cornerRadius = 2;
        _hotL.layer.masksToBounds = YES;
        [self.contentView addSubview:_hotL];
        [self.contentView bringSubviewToFront:_hotL];
    }
    return _hotL;
}

@end

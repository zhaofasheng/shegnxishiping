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
        self.backImageView.clipsToBounds = YES;
        [self.backImageView setAllCorner:10];
        self.backImageView.userInteractionEnabled = YES;
        
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backImageView.frame.size.height-112, self.backImageView.frame.size.width, self.backImageView.frame.size.height)];
        [self.backImageView addSubview:backView];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = backView.bounds;
        [backView addSubview:visualView];
        [visualView setCornerOnBottom:10];

        
        self.smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,72,24, 24)];
        self.smallImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.smallImageView setAllCorner:12];
        self.smallImageView.userInteractionEnabled = YES;
        [backView addSubview:self.smallImageView];
   
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,15,self.backImageView.frame.size.width-20,20)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [backView addSubview:self.titleL];
        
        self.introL = [[UILabel alloc] initWithFrame:CGRectMake(15, 40,self.backImageView.frame.size.width-20, 20)];
        self.introL.font = THRETEENTEXTFONTSIZE;
        self.introL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        [backView addSubview:self.introL];

        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(48, 74,GET_STRWIDTH(@"奇怪奇怪奇怪奇怪奇怪", 13, 20), 20)];
        self.nameL.font = THRETEENTEXTFONTSIZE;
        self.nameL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.8];
        [backView addSubview:self.nameL];
        
        UIButton *funBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-86-24,72, 24, 24)];
        [funBtn setBackgroundImage:UIImageNamed(@"Image_bokxh") forState:UIControlStateNormal];
        [backView addSubview:funBtn];
        self.likeButton = funBtn;
        self.likeNumL = [[UILabel alloc] initWithFrame:CGRectMake(self.likeButton.frame.origin.x+14, self.likeButton.frame.origin.y-7, 30, 14)];
        self.likeNumL.font = [UIFont systemFontOfSize:10];
        self.likeNumL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [backView addSubview:self.likeNumL];
        self.likeButton.userInteractionEnabled = NO;
        [funBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *comBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-30-24,72, 24, 24)];
        [backView addSubview:comBtn];
        comBtn.userInteractionEnabled = NO;
        self.comBtn = comBtn;
        self.comL = [[UILabel alloc] initWithFrame:CGRectMake(self.comBtn.frame.origin.x+14, self.comBtn.frame.origin.y-7, 30, 14)];
        self.comL.font = [UIFont systemFontOfSize:10];
        self.comL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [backView addSubview:self.comL];
        
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
        _hotL.backgroundColor = [UIColor colorWithHexString:@"#00ABE4"];
        _hotL.layer.cornerRadius = 2;
        _hotL.layer.masksToBounds = YES;
        [self.backImageView addSubview:_hotL];
        [self.backImageView bringSubviewToFront:_hotL];
    }
    return _hotL;
}
@end

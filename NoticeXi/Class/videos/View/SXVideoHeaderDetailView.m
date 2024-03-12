//
//  SXVideoHeaderDetailView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/26.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoHeaderDetailView.h"
#import "SXVideoUserCenterController.h"
@implementation SXVideoHeaderDetailView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        self.contentView = [[UIView  alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentView];
        
        self.infoView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,DR_SCREEN_WIDTH, 56)];
        [self.contentView addSubview:self.infoView];
        self.infoView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userClick)];
        [self.infoView addGestureRecognizer:userTap];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,12, 32, 32)];
        [self.iconImageView setAllCorner:16];
        [self.infoView addSubview:self.iconImageView];
        self.iconImageView.image = UIImageNamed(@"noImage_jynohe");
        self.iconImageView.userInteractionEnabled = YES;
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, self.infoView.frame.size.width-55, 56)];
        self.nameL.font = XGFifthBoldFontSize;
        self.nameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.infoView addSubview:self.nameL];

        self.titleL = [[UILabel alloc] init];
        self.titleL.font = XGSIXBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.titleL.numberOfLines = 0;
        [self.contentView addSubview:self.titleL];

        self.contentL = [[UILabel alloc] init];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
    }
    return self;
}

- (void)userClick{
    SXVideoUserCenterController *ctl = [[SXVideoUserCenterController alloc] init];
    ctl.userModel = self.videoModel.userModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    
    CGFloat videoHeaderHeight = videoModel.titleHeight+5+videoModel.introHeight+20+56;
    
    if (videoModel.screen.intValue == 2) {
        self.contentView.frame = CGRectMake(0, (DR_SCREEN_WIDTH*4/3)-(DR_SCREEN_WIDTH/16*9), DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH*4/3)-(DR_SCREEN_WIDTH/16*9)+videoHeaderHeight);
    }else{
        self.contentView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, videoHeaderHeight);
    }
    
    if (videoModel.title && (videoModel.titleHeight > 0)) {
        self.titleL.frame = CGRectMake(15, 56, DR_SCREEN_WIDTH-30, videoModel.titleHeight);
    }else{
        self.titleL.frame = CGRectMake(15, 56, DR_SCREEN_WIDTH-30, 0);
    }
    
    self.titleL.attributedText = videoModel.titleAttStr;
    
    if (videoModel.introduce && (videoModel.introHeight > 0)) {
        self.contentL.frame = CGRectMake(15, CGRectGetMaxY(self.titleL.frame)+5, DR_SCREEN_WIDTH-30, videoModel.introHeight);
    }else{
        self.contentL.frame = CGRectMake(15, CGRectGetMaxY(self.titleL.frame)+5, DR_SCREEN_WIDTH-30, 0);
    }
    
    self.contentL.attributedText = videoModel.introAttStr;
    
    self.nameL.text = videoModel.userModel.nick_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.userModel.avatar_url] placeholderImage:UIImageNamed(@"noImage_jynohe")];
    
}

- (UIView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 40)];
        UILabel *label = [[UILabel  alloc] initWithFrame:_sectionView.bounds];
        label.text = @"更多内容";
        label.font = XGFourthBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        label.textAlignment = NSTextAlignmentCenter;
        [_sectionView addSubview:label];
        
        CGFloat strwidth = GET_STRWIDTH(label.text, 15, 40);
        CGFloat linwidth = (DR_SCREEN_WIDTH-strwidth)/2-30;
        
        UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(15, 19, linwidth, 2)];
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
        
        gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#F9F9FB"] colorWithAlphaComponent:0].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#F9F9FB"] colorWithAlphaComponent:1].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(line.frame), CGRectGetHeight(line.frame));
        [line.layer addSublayer:gradientLayer];
        [_sectionView addSubview:line];
        
        UIView *line1 = [[UIView  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-linwidth, 19, linwidth, 2)];
        CAGradientLayer *gradientLayer1 = [[CAGradientLayer alloc] init];
        
        gradientLayer1.colors = @[(__bridge id)[[UIColor colorWithHexString:@"#F9F9FB"] colorWithAlphaComponent:1].CGColor,(__bridge id)[[UIColor colorWithHexString:@"#F9F9FB"] colorWithAlphaComponent:0].CGColor];
        gradientLayer1.startPoint = CGPointMake(0, 1);
        gradientLayer1.endPoint = CGPointMake(1, 1);
        gradientLayer1.frame = CGRectMake(0, 0, CGRectGetWidth(line1.frame), CGRectGetHeight(line1.frame));
        [line1.layer addSublayer:gradientLayer1];
        [_sectionView addSubview:line1];
    }
    return _sectionView;
}


@end

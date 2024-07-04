//
//  SXPlayPayVideoDetailHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayPayVideoDetailHeaderView.h"
#import "SXVideoUserCenterController.h"
#import "NoticeMoreClickView.h"
@implementation SXPlayPayVideoDetailHeaderView
{
    UIImageView *lockImageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, frame.size.height)];
        [self addSubview:self.backView];
        
        _videoNameL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(15,6,DR_SCREEN_WIDTH-25, 20)];
        _videoNameL.font = XGEightBoldFontSize;
        _videoNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_videoNameL];
        

        UILabel *payL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 50, 54, 20)];
        payL.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        payL.font = [UIFont systemFontOfSize:11];
        payL.textColor = [UIColor whiteColor];
        payL.textAlignment = NSTextAlignmentCenter;
        payL.text = @"付费课程";
        [payL setAllCorner:4];
        [self.backView  addSubview:payL];
        
        _titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(77,49,DR_SCREEN_WIDTH-77-15-22-15, 22)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView  addSubview:_titleL];
        
        UIButton *shanreBtn = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 49, 22, 22)];
        [shanreBtn setBackgroundImage:UIImageNamed(@"sx_shanrestudyvideoh_img") forState:UIControlStateNormal];
        [self.backView addSubview:shanreBtn];
        [shanreBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(15,80,0, 20)];
        _nickNameL.font = FOURTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView  addSubview:_nickNameL];
        _nickNameL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTap)];
        [self.nickNameL addGestureRecognizer:tap1];
 
        UIImageView *lockImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nickNameL.frame), 80, 20, 20)];
        lockImageV.image = UIImageNamed(@"sxpaydetailUser_img");
        lockImageV.userInteractionEnabled = YES;
        [self.backView  addSubview:lockImageV];
        lockImageView = lockImageV;
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTap)];
        [lockImageV addGestureRecognizer:tap2];
    }
    return self;
}

- (void)userTap{
    SXVideoUserCenterController *ctl = [[SXVideoUserCenterController alloc] init];
    ctl.userModel = self.videoModel.userModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)setVideoModel:(SXSearisVideoListModel *)videoModel{
    _videoModel = videoModel;
    self.videoNameL.text = videoModel.title;
    self.nickNameL.text = videoModel.userModel.nick_name;

    self.nickNameL.frame =  CGRectMake(15,80,GET_STRWIDTH(self.nickNameL.text, 14, 20), 20);
    lockImageView.frame = CGRectMake(CGRectGetMaxX(_nickNameL.frame), 80, 20, 20);
}

- (void)shareClick{
    NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    moreView.isShare = YES;
    moreView.isShareSerise = YES;
    moreView.qqShareUrl = self.model.qqShareUrl;
    moreView.wechatShareUrl = self.model.wechatShareUrl;
    moreView.friendShareUrl = self.model.friendShareUrl;
    moreView.appletId = self.model.appletId;
    moreView.appletPage = self.model.appletPage;
    moreView.share_img_url = self.model.share_img_url;
    moreView.name = [NSString stringWithFormat:@"共%@课时",self.model.episodes];
    moreView.imgUrl = self.model.carousel_images.count?self.model.carousel_images[0]: self.model.cover_url;
    moreView.title = self.model.series_name;
    [moreView showTost];
}

- (void)setModel:(SXPayForVideoModel *)model{
    _model = model;
    self.titleL.text = model.series_name;
}

@end

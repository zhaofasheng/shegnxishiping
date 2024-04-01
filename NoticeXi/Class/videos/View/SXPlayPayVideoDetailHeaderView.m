//
//  SXPlayPayVideoDetailHeaderView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayPayVideoDetailHeaderView.h"
#import "SXVideoUserCenterController.h"
@implementation SXPlayPayVideoDetailHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 118)];
        [self addSubview:self.backView];
        
        _videoNameL = [[UILabel alloc] initWithFrame:CGRectMake(15,15,DR_SCREEN_WIDTH-25, 56)];
        _videoNameL.font = XGTwentyBoldFontSize;
        _videoNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _videoNameL.numberOfLines = 0;
        [self.backView addSubview:_videoNameL];
        
        self.infoView = [[UIView  alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_videoNameL.frame)+15, DR_SCREEN_WIDTH-30, 44)];
        self.infoView .backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.infoView  setAllCorner:8];
        [self.backView addSubview:self.infoView ];
  
        UILabel *payL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 10, 54, 24)];
        payL.backgroundColor = [UIColor colorWithHexString:@"#FF68A3"];
        payL.font = [UIFont systemFontOfSize:10];
        payL.textColor = [UIColor whiteColor];
        payL.textAlignment = NSTextAlignmentCenter;
        payL.text = @"课程";
        [payL setAllCorner:4];
        [self.infoView  addSubview:payL];
        
        _titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(72,0,self.backView.frame.size.width-72-30-GET_STRWIDTH(@"十个字的昵称你你你你", 14, 44), 44)];
        _titleL.font = XGSIXBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.infoView  addSubview:_titleL];
        
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(self.infoView.frame.size.width-30-GET_STRWIDTH(@"十个字的昵称你你你你", 14, 44),0,self.backView.frame.size.width-72-30-GET_STRWIDTH(@"十个字的昵称你你你你", 14, 44), 44)];
        _nickNameL.font = FOURTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.infoView  addSubview:_nickNameL];
        _nickNameL.textAlignment = NSTextAlignmentRight;
        _nickNameL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTap)];
        [self.infoView addGestureRecognizer:tap1];
 
        UIImageView *lockImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(self.infoView.frame.size.width-30, 12, 20, 20)];
        lockImageV.image = UIImageNamed(@"sxpaydetailUser_img");
        lockImageV.userInteractionEnabled = YES;
        [self.infoView  addSubview:lockImageV];
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
    self.videoNameL.attributedText = videoModel.titleAtt;
    self.videoNameL.frame = CGRectMake(15,15,DR_SCREEN_WIDTH-25, videoModel.titleHeight);
    self.nickNameL.text = videoModel.userModel.nick_name;
    if (videoModel.screen.intValue == 2) {
        self.backView.frame = CGRectMake(0, (DR_SCREEN_WIDTH*4/3)-(DR_SCREEN_WIDTH/16*9), DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH*4/3)-(DR_SCREEN_WIDTH/16*9)+90+videoModel.titleHeight);
    }else{
        self.backView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, 90+videoModel.titleHeight);
    }
    
    self.infoView.frame = CGRectMake(15, CGRectGetMaxY(_videoNameL.frame)+15, DR_SCREEN_WIDTH-30, 44);
}

- (void)setModel:(SXPayForVideoModel *)model{
    _model = model;
    self.titleL.text = model.series_name;
}

@end

//
//  SXFullPlayInfoView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/12.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXFullPlayInfoView.h"
#import "SXVideoUserCenterController.h"
#import "SXStudyBaseController.h"

@implementation SXFullPlayInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrClose)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)openOrClose{
    if (!self.videoModel.isMoreFiveLines) {
        return;
    }
    self.isOpen = !self.isOpen;
    
    if (self.openMoreBlock) {
        self.openMoreBlock(self.isOpen);
    }
    
    if (self.isOpen) {
        self.contentL.attributedText = self.videoModel.allTextAttStr;
    }else{
        self.contentL.attributedText = self.videoModel.fiveAttTextStr;
    }
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (self.isOpen) {
            
            self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-2);
            
            if (self.videoModel.textHeight > (DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-60-TAB_BAR_HEIGHT-42)) {
                self.contentView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT+60, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-60-TAB_BAR_HEIGHT);
                self.scrollView.frame = CGRectMake(15, 56+(self.isHasStudy?46:0), DR_SCREEN_WIDTH-30, self.frame.size.height-40-56);
            }else{
                self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-56-self.videoModel.textHeight-40-(self.isHasStudy?46:0), DR_SCREEN_WIDTH, 56+self.videoModel.textHeight+40+(self.isHasStudy?46:0));
                self.scrollView.frame = CGRectMake(15, 56+(self.isHasStudy?46:0), DR_SCREEN_WIDTH-30, self.videoModel.textHeight);
            }
            
            self.contentL.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-30, self.videoModel.textHeight);
            self.scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH-30, self.videoModel.textHeight);
            
            
        }else{
            self.contentL.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-30, 42);
            self.scrollView.frame = CGRectMake(15, 56+(self.isHasStudy?46:0), DR_SCREEN_WIDTH-30, 42);
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30-107-(self.isHasStudy?46:0), DR_SCREEN_WIDTH, 107+(self.isHasStudy?46:0));
            self.contentView.frame = self.bounds;
            self.colseButton.hidden = YES;
            
            self.scrollView.contentSize = CGSizeMake(DR_SCREEN_WIDTH-30, 0);
        }
        
        self.colseButton.frame = CGRectMake(DR_SCREEN_WIDTH-15-70, self.contentView.frame.size.height-40, 70, 40);
    } completion:^(BOOL finished) {
        if (self.isOpen) {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            self.colseButton.hidden = NO;
        }
    }];
    
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;

    if (videoModel.series_name && videoModel.sell_series_id) {
        self.isHasStudy = YES;
       
        CGFloat widthStr = GET_STRWIDTH(videoModel.series_name, 15, 32);
        self.studyWidth = 111+ widthStr;
        
        
        self.studyView.frame = CGRectMake(15, 56, self.studyWidth, 32);
        self.studyView.hidden = NO;
        self.studyNameL.frame = CGRectMake(44, 0, widthStr, 32);
        self.studyNameL.text = videoModel.series_name;
        self.buyImageV.frame = CGRectMake(self.studyWidth-5-12, 10, 12, 12);
        self.buyL.frame = CGRectMake(self.studyWidth-5-12-40, 0, 40, 32);
    }else{
        _studyView.hidden = YES;
        self.isHasStudy = NO;
    }
    
    _colseButton.hidden = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.userModel.avatar_url]];
    self.nickNameL.text = videoModel.userModel.nick_name;

    if (videoModel.isMoreFiveLines) {
        self.contentL.attributedText = videoModel.fiveAttTextStr;
    }else{
        self.contentL.attributedText = videoModel.allTextAttStr;
    }
    
    self.contentL.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-30, 42);
    self.scrollView.frame = CGRectMake(15, 56+(self.isHasStudy?46:0), DR_SCREEN_WIDTH-30, 42);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30-107-(self.isHasStudy?46:0), DR_SCREEN_WIDTH, 107+(self.isHasStudy?46:0));
    self.contentView.frame = self.bounds;
    self.colseButton.hidden = YES;
}

- (UIView *)studyView{
    if (!_studyView) {
        _studyView = [[UIView  alloc] initWithFrame:CGRectMake(15, 56, self.studyWidth, 32)];
        _studyView.layer.cornerRadius = 4;
        _studyView.layer.masksToBounds = YES;
        _studyView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.1];
        [self.contentView addSubview:_studyView];
        
        _studyView.userInteractionEnabled = YES;
        
        UIImageView *markImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(8, 7, 32, 18)];
        markImageV.userInteractionEnabled = YES;
        markImageV.image = UIImageNamed(@"sx_studymarkin_img");
        [_studyView addSubview:markImageV];
        
        UIImageView *markImageV1 = [[UIImageView  alloc] initWithFrame:CGRectMake(self.studyWidth-5-12, 10, 12, 12)];
        markImageV1.userInteractionEnabled = YES;
        markImageV1.image = UIImageNamed(@"sx_tobuystudyin_img");
        [_studyView addSubview:markImageV1];
        self.buyImageV = markImageV1;
        
        self.buyL = [[UILabel  alloc] initWithFrame:CGRectMake(self.studyWidth-5-12-40, 0, 40, 32)];
        self.buyL.font = TWOTEXTFONTSIZE;
        self.buyL.textAlignment = NSTextAlignmentRight;
        self.buyL.textColor = [UIColor colorWithHexString:@"#FFE7CA"];
        self.buyL.text = @"去购买";
        [_studyView addSubview:self.buyL];
        
        self.studyNameL = [[UILabel  alloc] initWithFrame:CGRectMake(44, 0, 0, 32)];
        self.studyNameL.font = XGFourthBoldFontSize;
        self.studyNameL.textColor = [UIColor colorWithHexString:@"#FFE7CA"];
        [_studyView addSubview:self.studyNameL];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searisTap)];
        [_studyView addGestureRecognizer:tap];
    }
    return _studyView;
}

- (void)searisTap{
    if (self.videoModel.tuijianStudyModel) {
        SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
        ctl.paySearModel = self.videoModel.tuijianStudyModel;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        return;
    }
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"series/get/%@",self.videoModel.sell_series_id] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return;
            }
            SXPayForVideoModel *searismodel = [SXPayForVideoModel mj_objectWithKeyValues:dict[@"data"]];
            if (!searismodel) {
                return;
            }
            self.videoModel.tuijianStudyModel = searismodel;
            SXStudyBaseController *ctl = [[SXStudyBaseController alloc] init];
            ctl.paySearModel = searismodel;
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
      
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 12,32, 32)];
        [_iconImageView setAllCorner:16];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

- (UILabel *)nickNameL{
    if (!_nickNameL) {
        _nickNameL = [[UILabel  alloc] initWithFrame:CGRectMake(55, 12, DR_SCREEN_WIDTH-60, 32)];
        _nickNameL.font = XGFifthBoldFontSize;
        _nickNameL.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nickNameL];
    }
    return _nickNameL;
}

- (void)iconTap{
    SXVideoUserCenterController *ctl = [[SXVideoUserCenterController alloc] init];
    ctl.userModel = self.videoModel.userModel;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}


- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH-30, 42)];
        _contentL.font = FIFTHTEENTEXTFONTSIZE;
        _contentL.textColor = [UIColor whiteColor];
        _contentL.numberOfLines = 0;
        [self.scrollView addSubview:_contentL];
    }
    return _contentL;
}

- (UILabel *)colseButton{
    if (!_colseButton) {
        _colseButton = [[UILabel  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-70, self.contentView.frame.size.height-40, 70, 40)];
        _colseButton.font = XGFifthBoldFontSize;
        _colseButton.text = @"收起";
        _colseButton.textColor = [UIColor whiteColor];
        _colseButton.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_colseButton];
    }
    return _colseButton;
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 56, DR_SCREEN_WIDTH-30, 42)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self.contentView addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 107)];
        _contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addSubview:_contentView];
    }
    return _contentView;
}
@end

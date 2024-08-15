//
//  SXVideoCommentMoreView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/17.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideoCommentMoreView.h"

@implementation SXVideoCommentMoreView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
       
    }
    return self;
}

- (void)setCommentM:(SXVideoCommentModel *)commentM{
    _commentM = commentM;
    _closeL.hidden = YES;
    _moreButton.hidden = YES;
    if (commentM.reply_ctnum.intValue) {
        if (commentM.isOpen) {
            self.closeL.hidden = NO;
        }else{
            self.moreButton.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"展开%@条回复", commentM.reply_ctnum];
            CGFloat width = GET_STRWIDTH(str, 12, 24);
            [self.moreButton setTitle:str forState:UIControlStateNormal];
            self.moreButton.frame = CGRectMake(88, 5, width+16+20, 24);
        }
    }
}

- (FSCustomButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[FSCustomButton  alloc] initWithFrame:CGRectMake(88, 5, 111, 24)];
        _moreButton.layer.cornerRadius = 12;
        _moreButton.layer.masksToBounds = YES;
        _moreButton.buttonImagePosition = FSCustomButtonImagePositionRight;
        _moreButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:_moreButton];
        [_moreButton setImage:UIImageNamed(@"sx_video_comment_more") forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        _moreButton.titleLabel.font = TWOTEXTFONTSIZE;
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    }
    return _moreButton;
}

- (UILabel *)closeL{
    if (!_closeL) {
        _closeL = [[UILabel  alloc] initWithFrame:CGRectMake(88, 0, 60, 34)];
        _closeL.text = @"收起";
        _closeL.font = TWOTEXTFONTSIZE;
        _closeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _closeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
        [_closeL addGestureRecognizer:tap];
        [self.contentView addSubview:_closeL];
    }
    return _closeL;
}

- (void)moreClick{
    if (self.moreCommentBlock) {
        self.moreCommentBlock(self.commentM);
    }
}

- (void)closeTap{
    if (self.closeCommentBlock) {
        self.closeCommentBlock(self.commentM);
    }
}

@end

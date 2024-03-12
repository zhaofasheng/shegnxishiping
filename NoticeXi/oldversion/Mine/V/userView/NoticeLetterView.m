//
//  NoticeLetterView.m
//  NoticeXi
//
//  Created by li lei on 2023/12/8.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeLetterView.h"

@implementation NoticeLetterView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
  
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        self.backImageView.image = UIImageNamed(@"getmsgcontent_img");
        [self addSubview:self.backImageView];
        self.backImageView.userInteractionEnabled = YES;
        

        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-30, 28)];
        titleL.text = @"致 素未谋面的你";
        titleL.font = XGTwentyBoldFontSize;
        titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backImageView addSubview:titleL];
        
        self.canShowBottomHeight = 22+BOTTOM_HEIGHT+40+10;
        self.canShowUpHeight = NAVIGATION_BAR_HEIGHT+28+15;
        self.canShowtextHeight = DR_SCREEN_HEIGHT-self.canShowUpHeight-self.canShowBottomHeight;
        
        self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.canShowUpHeight, DR_SCREEN_WIDTH, self.canShowtextHeight)];
        [self.backImageView addSubview:self.contentView];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(30, self.canShowUpHeight, DR_SCREEN_WIDTH-60, 28)];
        self.contentL.numberOfLines = 0;
        self.contentL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:self.contentL];
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(30, self.backImageView.frame.size.height-self.canShowBottomHeight+10, DR_SCREEN_WIDTH-60, 28)];
        self.nickNameL.textAlignment = NSTextAlignmentRight;
        self.nickNameL.font = FIFTHTEENTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backImageView addSubview:self.nickNameL];
    
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [self.backImageView addGestureRecognizer:tap];
    }
    return self;
}


- (void)setLetterModel:(NoticeAllZongjieModel *)letterModel{
    _letterModel = letterModel;
    self.contentL.attributedText = [NoticeTools getStringWithLineHight:5 string:letterModel.letter_content];
    self.nickNameL.text = [NSString stringWithFormat:@"From %@%@",letterModel.letterUser.nick_name,letterModel.letterUser.frequency_no];
    CGFloat textHeight = [NoticeTools getHeightWithLineHight:5 font:15 width:DR_SCREEN_WIDTH-60 string:letterModel.letter_content];
    self.contentView.contentSize = CGSizeMake(DR_SCREEN_WIDTH-60, textHeight);
    self.contentL.frame = CGRectMake(30, 0, DR_SCREEN_WIDTH-60, textHeight);
    self.nickNameL.frame = CGRectMake(30, self.backImageView.frame.size.height-self.canShowBottomHeight+10, DR_SCREEN_WIDTH-60, 28);
}

- (void)cancelClick{
    [self removeFromSuperview];
}

- (void)showLetterView{
    
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.backImageView.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
    }];
}

@end

//
//  SXPlayBuyView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayBuyView.h"

@implementation SXPlayBuyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setImage:UIImageNamed(@"backwhties") forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        backBtn.frame = CGRectMake(10,0,44,NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
        [self addSubview:backBtn];
        
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(0, (frame.size.height-69)/2, DR_SCREEN_WIDTH, 21)];
        self.markL.textColor = [UIColor whiteColor];
        self.markL.font = FIFTHTEENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.markL];
        
        self.singleBtn = [[UIButton  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-224-32)/2, CGRectGetMaxY(self.markL.frame)+15, 112, 32)];
        self.singleBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.singleBtn setAllCorner:16];
        [self.singleBtn setTitle:@"解锁本节" forState:UIControlStateNormal];
        self.singleBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.singleBtn setTitleColor:[UIColor colorWithHexString:@"#FFE7CA"] forState:UIControlStateNormal];
        [self addSubview:self.singleBtn];
        [self.singleBtn addTarget:self action:@selector(singleClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.allButton = [[UIButton  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.singleBtn.frame)+32, CGRectGetMaxY(self.markL.frame)+15, 112, 32)];
        self.allButton.backgroundColor = [UIColor colorWithHexString:@"#FF4B98"];
        [self.allButton setAllCorner:16];
        [self.allButton setTitle:@"解锁剩余内容" forState:UIControlStateNormal];
        self.allButton.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
        [self.allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.allButton];
        [self.allButton addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setVideoArr:(NSMutableArray *)videoArr{
    _videoArr = videoArr;
    for (SXSearisVideoListModel *model in videoArr) {
        if (model.unLock) {
            self.hasBuySingle = YES;
            break;
        }
    }
}

- (void)singleClick{
    if (self.buyClickBlock) {
        self.buyClickBlock(1);
    }
}

- (void)allClick{
    if (self.buyClickBlock) {
        self.buyClickBlock(2);
    }
}

- (void)setCurrentPlayModel:(SXSearisVideoListModel *)currentPlayModel{
    _currentPlayModel = currentPlayModel;
    if (!self.paySearModel.canBuySingle) {//不能单集购买
        self.markL.text = @"本课程为付费内容，该内容还未解锁";
        self.singleBtn.hidden = YES;
        self.allButton.frame = CGRectMake((DR_SCREEN_WIDTH-112)/2, CGRectGetMaxY(self.markL.frame)+15, 112, 32);
        [self.allButton setTitle:@"解锁课程" forState:UIControlStateNormal];
        if (currentPlayModel.tryPlayTime) {
            self.markL.text = @"本课程为付费内容，试看已结束";
        }else{
            self.markL.text = @"本课程为付费内容，该内容还未解锁";
        }
    }else{//可购买单集
        if (self.hasBuySingle) {//购买过单集
            [self.allButton setTitle:@"解锁剩余内容" forState:UIControlStateNormal];
        }else{
            [self.allButton setTitle:@"解锁课程" forState:UIControlStateNormal];
        }
        if (currentPlayModel.tryPlayTime) {
            self.markL.text = @"本课程为付费内容，试看已结束";
        }else{
            self.markL.text = @"本课程为付费内容，该内容还未解锁";
        }
    }
}

- (void)backAction{
    if (self.backClickBlock) {
        self.backClickBlock(YES);
    }
}
@end

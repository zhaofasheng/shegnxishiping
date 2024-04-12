//
//  SXFullPlayCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/3/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXFullPlayCell.h"
#import "TTCCom.h"
#import "TCCommentsPopView.h"
#import "MyCommentView.h"
#import "SXVideoUserCenterController.h"

@interface SXFullPlayCell()<MyCommentViewDelegate>

@property (nonatomic, assign) CGFloat widthtoheight;//小屏幕时候的宽高比
@property (nonatomic, strong) TCCommentsPopView *popView;

@end

@implementation SXFullPlayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT)];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.coverImageView];
        self.contentView.backgroundColor = [UIColor blackColor];

        self.playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        [self.contentView addSubview:self.playerFatherView];
      
        CAGradientLayer *gradientLayer = [CAGradientLayer new];
        
        gradientLayer.frame = CGRectMake(SCREEN_WIDTH - 100 , 0, 100 , SCREEN_HEIGHT);
        //colors存放渐变的颜色的数组
        gradientLayer.colors=@[(__bridge id)RGBA(0, 0, 0, 0.5).CGColor,(__bridge id)RGBA(0, 0, 0, 0.0).CGColor];
//        gradientLayer.locations = @[@0.3, @0.5, @1.0];
        /**
         * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
         */
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(0, 0);
        //    layer.frame = self.messageLabel.bounds;
        [self.contentView.layer addSublayer:gradientLayer];
        
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;


    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.first_frame_url]];
    
    self.comButton.hidden = NO;
    
    self.fullButton.hidden = YES;
    if (self.videoModel.screen.intValue == 1) {
        self.widthtoheight = 0.5625;
        self.fullButton.hidden = NO;
    }else{
        self.widthtoheight = 0.75;
    }
    
    self.infoView.videoModel = videoModel;
    [self.contentView bringSubviewToFront:self.infoView];
}


- (SXFullPlayInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[SXFullPlayInfoView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30-107, DR_SCREEN_WIDTH, 107)];
        __weak typeof(self) weakSelf = self;
        _infoView.openMoreBlock = ^(BOOL open) {
            if (weakSelf.openMoreBlock) {
                weakSelf.openMoreBlock(open);
            }
        };
        [self.contentView addSubview:_infoView];
    }
    return _infoView;
}

- (void)fullClick{
    if (self.fullBlock) {
        self.fullBlock(YES);
    }
}

- (UIButton *)fullButton{
    if (!_fullButton) {
        _fullButton = [[UIButton  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-68)/2, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-30-107-30-28, 68, 28)];
        _fullButton.titleLabel.font = ELEVENTEXTFONTSIZE;
        _fullButton.layer.cornerRadius = 14;
        _fullButton.layer.masksToBounds = YES;
        _fullButton.layer.borderWidth = 1;
        _fullButton.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        [_fullButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fullButton setTitle:@"全屏观看" forState:UIControlStateNormal];
        [_fullButton addTarget:self action:@selector(fullClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_fullButton];
    }
    return _fullButton;
}

- (UIButton *)comButton{
    if (!_comButton) {
        _comButton = [[UIButton  alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40, (DR_SCREEN_HEIGHT-40)/2+80, 40, 40)];
        _comButton.titleLabel.font = THRETEENTEXTFONTSIZE;
        [_comButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comButton setTitle:@"评论" forState:UIControlStateNormal];
        [_comButton addTarget:self action:@selector(comClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_comButton];
    }
    return _comButton;
}



- (void)comClick{
    if (self.showComBlock) {
        self.showComBlock(YES);
    }
    self.coverImageView.hidden = YES;
    MyCommentView *commentView = [[MyCommentView alloc]init];
    commentView.delegate = self;
    self.popView = [TCCommentsPopView commentsPopViewWithFrame:[UIScreen mainScreen].bounds commentBackView:commentView withScale:self.widthtoheight];
    [self.popView showToView:[NoticeTools getTopViewController].view];
    
    __weak typeof(self) weakSelf = self;
    self.popView.showComBlock = ^(BOOL show) {
        if (!show) {
        
            [UIView animateWithDuration:0.15f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                weakSelf.playerFatherView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT);
                if (weakSelf.fatherBlock) {
                    weakSelf.fatherBlock(weakSelf.playerFatherView.bounds);
                }
            }completion:^(BOOL finished) {
                if (weakSelf.showComBlock) {
                    weakSelf.showComBlock(NO);
                }
                weakSelf.coverImageView.hidden = NO;
            }];
        }else{
            [UIView animateWithDuration:0.15f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                weakSelf.playerFatherView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*self.widthtoheight);
                if (weakSelf.fatherBlock) {
                    weakSelf.fatherBlock(weakSelf.playerFatherView.bounds);
                }
            }completion:^(BOOL finished) {
            }];
        }
    };
    
    self.popView.frameBlock = ^(CGFloat y) {
        weakSelf.playerFatherView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, y);
        if (weakSelf.fatherBlock) {
            weakSelf.fatherBlock(weakSelf.playerFatherView.bounds);
        }
    };
    
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        weakSelf.playerFatherView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*self.widthtoheight);
        if (weakSelf.fatherBlock) {
            weakSelf.fatherBlock(weakSelf.playerFatherView.bounds);
        }
    }completion:^(BOOL finished) {
        
    }];
}

#pragma mark - MyCommentViewDelegate
- (void)closeComment {
    [self.popView dismiss];
    if (self.showComBlock) {
        self.showComBlock(NO);
    }
}

@end

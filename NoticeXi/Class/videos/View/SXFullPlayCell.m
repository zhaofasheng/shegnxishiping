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

        self.playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT)];
        [self.contentView addSubview:self.playerFatherView];
      
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;

    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.first_frame_url]];
    
    self.clickView.videoModel = videoModel;
    
    self.fullButton.hidden = YES;
    if (self.videoModel.screen.intValue == 1) {
        self.widthtoheight = 0.5625;
        self.fullButton.hidden = NO;
    }else{
        self.widthtoheight = 0.75;
    }
    
    self.infoView.videoModel = videoModel;
    [self.contentView bringSubviewToFront:self.infoView];
    
    _compilationView.hidden = YES;
    if (videoModel.compilation_id.intValue > 0) {
        self.compilationView.videoModel = videoModel;
        self.compilationView.hidden = NO;
    }
    
    [self.contentView bringSubviewToFront:self.fullButton];
}

- (void)setNeedPopCom:(BOOL)needPopCom{
    _needPopCom = needPopCom;
    if (needPopCom) {
        [self comClick:NO];
    }
}

- (SXVideoCompilationView *)compilationView{
    if (!_compilationView) {
        _compilationView = [[SXVideoCompilationView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-16-32, DR_SCREEN_WIDTH, 32)];
        __weak typeof(self) weakSelf = self;
        _compilationView.choiceHeJiVideoBlock = ^(SXVideosModel * _Nonnull currentModel, NSMutableArray * _Nonnull heVideoArr) {
            if (weakSelf.choiceHeJiVideoBlock) {
                weakSelf.choiceHeJiVideoBlock(currentModel, heVideoArr);
            }
        };
        [self.contentView addSubview:_compilationView];
    }
    return _compilationView;
}

- (SXFullPlayInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[SXFullPlayInfoView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT-(self.videoModel.compilation_id.intValue?48: 30-107), DR_SCREEN_WIDTH, 107)];
        __weak typeof(self) weakSelf = self;
        _infoView.openMoreBlock = ^(BOOL open) {
            if (weakSelf.openMoreBlock) {
                weakSelf.openMoreBlock(open);
            }
            if (open) {
                [weakSelf.contentView bringSubviewToFront:weakSelf.infoView];
            }else{
                [weakSelf.contentView bringSubviewToFront:weakSelf.fullButton];
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

- (SXVideosComClickView *)clickView{
    if (!_clickView) {
        _clickView = [[SXVideosComClickView  alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT, DR_SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        [self.contentView addSubview:_clickView];
        __weak typeof(self) weakSelf = self;
        _clickView.comClickBlock = ^(BOOL click) {
            [weakSelf comClick:NO];
        };
        _clickView.upInputcomClickBlock = ^(BOOL click) {
            [weakSelf comClick:YES];
        };
    }
    return _clickView;
}

- (void)comClick:(BOOL)upInput{
    if (self.showComBlock) {
        self.showComBlock(YES);
    }
    self.coverImageView.hidden = YES;
    MyCommentView *commentView = [[MyCommentView alloc]init];
    commentView.videoUser = self.videoModel.userModel;
    if (self.needPopCom) {
        commentView.type = @"2";
    }else{
        commentView.type = @"1";
    }
    
    commentView.delegate = self;
    commentView.commentId = self.commentId;
    commentView.replyId = self.replyId;
    commentView.needPopCom = self.needPopCom;
    self.needPopCom = NO;
    commentView.videoModel = self.videoModel;
    self.popView = [TCCommentsPopView commentsPopViewWithFrame:[UIScreen mainScreen].bounds commentBackView:commentView withScale:self.widthtoheight];
    [self.popView showToView:[NoticeTools getTopViewController].view];
    commentView.upInput = upInput;
    __weak typeof(self) weakSelf = self;
    
    commentView.refreshCommentCountBlock = ^(NSString * _Nonnull commentCount) {
        weakSelf.videoModel.commentCt = commentCount;
        weakSelf.clickView.videoModel = weakSelf.videoModel;
    };
    
    self.popView.showComBlock = ^(BOOL show) {
        if (!show) {
        
            [UIView animateWithDuration:0.15f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                weakSelf.playerFatherView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-TAB_BAR_HEIGHT);
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

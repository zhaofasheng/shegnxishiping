//
//  SXVideosComClickView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideosComClickView.h"
#import "NoticeMoreClickView.h"
@implementation SXVideosComClickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        CGFloat strWidth = GET_STRWIDTH(@"评论", 14, self.frame.size.height);
        self.comNumL = [[UILabel  alloc] initWithFrame:CGRectMake(self.frame.size.width-strWidth-54, 0, strWidth, self.frame.size.height)];
        self.comNumL.font = FOURTHTEENTEXTFONTSIZE;
        self.comNumL.textColor = [UIColor whiteColor];
        [self addSubview:self.comNumL];
        self.comNumL.text = @"评论";
        self.comNumL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comClick)];
        [self.comNumL addGestureRecognizer:tap];
        
        self.comImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.comNumL.frame.origin.x-28, 8, 24, 24)];
        self.comImageView.image = UIImageNamed(@"sxvideocom_img");
        [self addSubview:self.comImageView];
        self.comImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comClick)];
        [self.comImageView addGestureRecognizer:tap1];
        
        UIButton *shareBtn = [[UIButton  alloc] initWithFrame:CGRectMake(self.frame.size.width-24-15, 8, 24, 24)];
        [shareBtn setBackgroundImage:UIImageNamed(@"sxsharevideo_img") forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
        
        self.markView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, self.comImageView.frame.origin.x-15, 40)];
        self.markView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.15];
        self.markView.layer.cornerRadius = 20;
        self.markView.layer.masksToBounds = YES;
        [self addSubview:self.markView];
        self.markView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendComClick)];
        [self.markView addGestureRecognizer:tap2];
        
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 180, 40)];
        self.markL.font = FIFTHTEENTEXTFONTSIZE;
        self.markL.textColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0.4];
        self.markL.text = @"成为第一条评论…";
        [self.markView addSubview:self.markL];
        
    }
    return self;
}

- (void)shareClick{
    if (self.videoModel.qqShareUrl && self.videoModel.qqShareUrl.length > 6) {
        [self canShare];
    }else{
        [[NoticeTools getTopViewController] showHUD];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"getShare/%@",self.videoModel.vid] Accept:@"application/vnd.shengxi.v5.8.4+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            if (success) {
                SXVideosModel *model = [SXVideosModel mj_objectWithKeyValues:dict[@"data"]];
                if (model.qqShareUrl) {
                    self.videoModel.qqShareUrl = model.qqShareUrl;
                    self.videoModel.wechatShareUrl = model.wechatShareUrl;
                    [self canShare];
                }
            }
            [[NoticeTools getTopViewController] hideHUD];
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
    }
}

- (void)canShare{
    NoticeMoreClickView *moreView = [[NoticeMoreClickView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    moreView.isShareFreeVideo = YES;
    moreView.isShare = YES;
    moreView.qqShareUrl = self.videoModel.qqShareUrl;
    moreView.wechatShareUrl = self.videoModel.wechatShareUrl;
    moreView.name =self.videoModel.introduce;
    moreView.imgUrl = self.videoModel.video_cover_url;
    moreView.title = self.videoModel.title;
    [moreView showTost];
}

- (void)comClick{
    if (self.comClickBlock) {
        self.comClickBlock(YES);
    }
}

- (void)sendComClick{
    if (self.upInputcomClickBlock) {
        self.upInputcomClickBlock(YES);
    }
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
 
    [self refreshUI];
}

- (void)sendWithComment:(NSString *)comment commentId:(NSString *)commentId{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:comment forKey:@"content"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoCommont/%@/0",self.videoModel.vid] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            
        }
    } fail:^(NSError * _Nullable error) {
        
    }];
}

- (void)refreshUI{
    self.comNumL.text = _videoModel.commentCt.intValue?_videoModel.commentCt:@"评论";
    CGFloat strWidth = GET_STRWIDTH(self.comNumL.text, 14, self.frame.size.height);
    
    self.markL.text = _videoModel.commentCt.intValue?@"说说我的想法...":@"成为第一条评论...";
    
    self.comNumL.frame = CGRectMake(self.frame.size.width-strWidth-54, 0, strWidth, self.frame.size.height);
    self.comImageView.frame = CGRectMake(self.comNumL.frame.origin.x-28, 8, 24, 24);
    self.markView.frame = CGRectMake(0, 0, self.comImageView.frame.origin.x-15, 40);
}

@end

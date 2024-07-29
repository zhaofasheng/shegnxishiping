//
//  SXVideosComClickView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXVideosComClickView.h"
#import "SXScVideoToAlbumView.h"
#import "NoticeMoreClickView.h"
#import "SXTosatView.h"
#import "SXVideosForAlbumController.h"
@interface SXVideosComClickView()

@property (nonatomic, strong) SXScVideoToAlbumView *albumView;

@end

@implementation SXVideosComClickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        

        self.markView = [[UIView  alloc] initWithFrame:CGRectMake(15, 5, DR_SCREEN_WIDTH-30-(44*4), 40)];
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
        
        NSArray *imgArr = @[@"sxvideocom_img",@"sx_videolikefull_img",@"sx_videofullsc_img",@"sxsharevideo_img"];
        NSArray *titleArr = @[@"评论",@"点赞",@"收藏",@"分享"];
        for (int i = 0; i < 4; i++) {
            UIView *tapView = [[UIView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.markView.frame)+10+44*i, 5, 44, 24+17)];
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *funTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(funTaps:)];
            [tapView addGestureRecognizer:funTap];
            
            UIImageView *tapImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(10,0, 24, 24)];
            tapImageV.userInteractionEnabled = YES;
            tapImageV.image = UIImageNamed(imgArr[i]);
            [tapView addSubview:tapImageV];
            
            UILabel *tapL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 24, 44, 17)];
            tapL.textColor = [UIColor whiteColor];
            tapL.font = TWOTEXTFONTSIZE;
            tapL.textAlignment = NSTextAlignmentCenter;
            [tapView addSubview:tapL];
            tapL.text = titleArr[i];
            
            if (i == 0) {
                self.comNumL = tapL;
            }else if (i==1){
                self.likeL = tapL;
                self.likeImageView = tapImageV;
            }else if (i == 2){
                self.collectL = tapL;
                self.collectImageView = tapImageV;
            }
            
            [self addSubview:tapView];
        }

    }
    return self;
}

- (void)funTaps:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (tapV.tag == 0) {
        [self comClick];
    }else if (tapV.tag == 1){
        [self likeClick];
    }else if (tapV.tag == 2){
        [self collectClick];
    }else{
        [self shareClick];
    }
}

- (void)likeClick{
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.videoModel.is_zan.boolValue ? @"2":@"1" forKey:@"type"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoZan/%@",self.videoModel.vid] Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            
            self.videoModel.is_zan = self.videoModel.is_zan.boolValue?@"0":@"1";
            self.videoModel.zan_num = [NSString stringWithFormat:@"%d",self.videoModel.is_zan.boolValue?(self.videoModel.zan_num.intValue+1):(self.videoModel.zan_num.intValue-1)];
            if (self.videoModel.zan_num.intValue < 0) {
                self.videoModel.zan_num = @"0";
            }
            
            [self refreshZanUI];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SXZANvideoNotification" object:self userInfo:@{@"videoId":self.videoModel.vid,@"is_zan":self.videoModel.is_zan,@"zan_num":self.videoModel.zan_num}];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}


- (void)collectClick{
    if (self.videoModel.is_collection.boolValue) {
        [[NoticeTools getTopViewController] showHUD];
        NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
        [parm setObject:@"2" forKey:@"type"];
        [parm setObject:self.videoModel.vid forKey:@"videoId"];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"video/collect" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                
                self.videoModel.is_collection = self.videoModel.is_collection.boolValue?@"0":@"1";
                self.videoModel.collection_num = [NSString stringWithFormat:@"%d",self.videoModel.is_collection.boolValue?(self.videoModel.collection_num.intValue+1):(self.videoModel.collection_num.intValue-1)];
                if (self.videoModel.collection_num.intValue < 0) {
                    self.videoModel.collection_num = @"0";
                }
           
                
                [self refreshCollectUI];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SXCOLLECTvideoNotification" object:self userInfo:@{@"videoId":self.videoModel.vid,@"is_collection":self.videoModel.is_collection,@"collection_num":self.videoModel.collection_num,@"albumId":@"0"}];
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
        return;
    }
    [self.albumView show];
}

- (void)sureSC:(SXVideoZjModel *)zjModel{
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"1" forKey:@"type"];
    [parm setObject:self.videoModel.vid forKey:@"videoId"];
    [parm setObject:zjModel.albumId forKey:@"ablumId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"video/collect" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            
            self.videoModel.is_collection = self.videoModel.is_collection.boolValue?@"0":@"1";
            self.videoModel.collection_num = [NSString stringWithFormat:@"%d",self.videoModel.is_collection.boolValue?(self.videoModel.collection_num.intValue+1):(self.videoModel.collection_num.intValue-1)];
            if (self.videoModel.collection_num.intValue < 0) {
                self.videoModel.collection_num = @"0";
            }
            
            SXTosatView *tosatView = [[SXTosatView  alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-315)/2,(DR_SCREEN_HEIGHT-54)/2-100, 315, 54)];
            
            NSString *name = zjModel.ablum_name.length > 10 ? [NSString stringWithFormat:@"%@...",[zjModel.ablum_name substringToIndex:9]] : zjModel.ablum_name;
            name = [NSString stringWithFormat:@"已收藏到”%@“  查看",name];
            CGFloat width = GET_STRWIDTH(name, 14, 54);
            tosatView.frame = CGRectMake((DR_SCREEN_WIDTH-width-16-40)/2,(DR_SCREEN_HEIGHT-54)/2-100, width+16+40, 54);
            tosatView.button.frame = tosatView.bounds;
            [tosatView.button setTitle:name forState:UIControlStateNormal];
            tosatView.lookSaveListBlock = ^(BOOL look) {
                SXVideosForAlbumController *ctl = [[SXVideosForAlbumController alloc] init];
                ctl.videoModel = self.videoModel;
                ctl.zjModel = zjModel;
                [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
            };
            [tosatView showSXToast];
            
            [self refreshCollectUI];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SXCOLLECTvideoNotification" object:self userInfo:@{@"videoId":self.videoModel.vid,@"is_collection":self.videoModel.is_collection,@"collection_num":self.videoModel.collection_num,@"albumId":zjModel.albumId}];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (SXScVideoToAlbumView *)albumView{
    if (!_albumView) {
        _albumView = [[SXScVideoToAlbumView  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self) weakSelf = self;
        _albumView.collectBlock = ^(SXVideoZjModel * _Nonnull zjModel) {
            [weakSelf sureSC:zjModel];
        };
    }
    return _albumView;
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
    [self refreshZanUI];
    [self refreshCollectUI];
}

- (void)refreshZanUI{
    self.likeImageView.image = self.videoModel.is_zan.boolValue?UIImageNamed(@"sx_likeyes_img"):UIImageNamed(@"sx_videolikefull_img");
    self.likeL.text = self.videoModel.zan_num.intValue?self.videoModel.zan_num:@"点赞";
}

- (void)refreshCollectUI{
    self.collectL.text = self.videoModel.collection_num.intValue?self.videoModel.collection_num:@"收藏";
    self.collectImageView.image = self.videoModel.is_collection.boolValue?UIImageNamed(@"sx_videofullscno_img"):UIImageNamed(@"sx_videofullsc_img");
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
    self.markL.text = _videoModel.commentCt.intValue?@"说说我的想法...":@"成为第一条评论...";

}

@end

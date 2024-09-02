//
//  SXShopSendCommentView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSendCommentView.h"

@implementation SXShopSendCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        self.markView = [[UIView  alloc] initWithFrame:CGRectMake(15, 5, DR_SCREEN_WIDTH-30-(44*2)-10, 40)];
        self.markView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [self.markView setAllCorner:20];
        [self addSubview:self.markView];
        self.markView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendComClick)];
        [self.markView addGestureRecognizer:tap2];
        
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 0, 180, 40)];
        self.markL.font = FIFTHTEENTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.markL.text = @"成为第一条评论…";
        [self.markView addSubview:self.markL];
        
        NSArray *imgArr = @[@"sxshopsaycom_img",@"sx_shopsaylikefull_img"];
        NSArray *titleArr = @[@"评论",@"点赞",];
        for (int i = 0; i < 2; i++) {
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
            tapL.textColor = [UIColor colorWithHexString:@"#14151A"];
            tapL.font = TWOTEXTFONTSIZE;
            tapL.textAlignment = NSTextAlignmentCenter;
            [tapView addSubview:tapL];
            tapL.text = titleArr[i];
            
            if (i == 0) {
                self.comNumL = tapL;
            }else if (i==1){
                self.likeL = tapL;
                self.likeImageView = tapImageV;
            }
            
            [self addSubview:tapView];
        }

    }
    return self;
}

- (void)sendComClick{
    if (self.comClickBlock) {
        self.comClickBlock(YES);
    }
}

- (void)comClick{
    if (self.upcomClickBlock) {
        self.upcomClickBlock(YES);
    }
}

- (void)funTaps:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (tapV.tag == 0) {
        [self comClick];
    }else if (tapV.tag == 1){
        [self likeClick];
    }
}

- (void)likeClick{
//    [[NoticeTools getTopViewController] showHUD];
//    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
//    [parm setObject:self.videoModel.is_zan.boolValue ? @"2":@"1" forKey:@"type"];
//    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"videoZan/%@",self.videoModel.vid] Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
//        [[NoticeTools getTopViewController] hideHUD];
//        if (success) {
//            
//            self.videoModel.is_zan = self.videoModel.is_zan.boolValue?@"0":@"1";
//            self.videoModel.zan_num = [NSString stringWithFormat:@"%d",self.videoModel.is_zan.boolValue?(self.videoModel.zan_num.intValue+1):(self.videoModel.zan_num.intValue-1)];
//            if (self.videoModel.zan_num.intValue < 0) {
//                self.videoModel.zan_num = @"0";
//            }
//            
//            [self refreshZanUI];
//            
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"SXZANvideoNotification" object:self userInfo:@{@"videoId":self.videoModel.vid,@"is_zan":self.videoModel.is_zan,@"zan_num":self.videoModel.zan_num}];
//        }
//    } fail:^(NSError * _Nullable error) {
//        [[NoticeTools getTopViewController] hideHUD];
//    }];
}


- (void)setModel:(SXShopSayListModel *)model{
    _model = model;
}
@end

//
//  SXChatEachOtherMeassageView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/4/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXChatEachOtherMeassageView.h"
#import "NoticeSysViewController.h"
#import "SXVideoCommentMeassageController.h"
#import "SXVideoCommentLikeController.h"
#import "SXShopLyListController.h"
#import "NoticeStaySys.h"

@implementation SXChatEachOtherMeassageView

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *imageName = @[@"sxmsgsys_img",@"sxvideo_com_img",@"sxvideo_like_img",@"sx_shop_lytouse_img"];
        NSArray *titleArr = @[@"系统消息",@"评论",@"点赞",@"店铺留言"];
        CGFloat space = (DR_SCREEN_WIDTH-48*4)/5;
        for (int i = 0; i < 4; i++) {
            UIView *tapView = [[UIView  alloc] initWithFrame:CGRectMake(space+(48+space)*i, 20, 50, 48+8+17)];
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            [self addSubview:tapView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
            [tapView addGestureRecognizer:tap];
            
            UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
            imageV.image = UIImageNamed(imageName[i]);
            imageV.userInteractionEnabled = YES;
            [tapView addSubview:imageV];
            
            UILabel *label = [[UILabel  alloc] initWithFrame:CGRectMake(0, 56, 48, 17)];
            label.textColor = [UIColor colorWithHexString:@"#14151A"];
            label.font = XGTWOBoldFontSize;
            label.text = titleArr[i];
            label.textAlignment = NSTextAlignmentCenter;
            [tapView addSubview:label];
            
            UILabel *label1 = [[UILabel  alloc] initWithFrame:CGRectMake(34, 0, 0, 14)];
            label1.textColor = [UIColor whiteColor];
            label1.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
            label1.layer.cornerRadius = 7;
            label1.layer.masksToBounds = YES;
            label1.hidden = YES;
            label1.font = [UIFont systemFontOfSize:9];
            label1.textAlignment = NSTextAlignmentCenter;
            [tapView addSubview:label1];
            if (i == 0) {
                self.sysL = label1;
            }else if (i == 1){
                self.comL = label1;
            }else if(i == 2){
                self.likeL = label1;
            }else{
                self.liuyL = label1;
            }
        }
    }
    return self;
}

- (void)requestNoread{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"messages/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:@"application/vnd.shengxi.v5.8.1+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            NoticeStaySys *stay = [NoticeStaySys mj_objectWithKeyValues:dict[@"data"]];

            if (stay.sysM.num.intValue) {
                self.sysL.hidden = NO;
                if (stay.sysM.num.intValue > 99) {
                    stay.sysM.num = @"99+";
                }
                self.sysL.text = stay.sysM.num;
              
                CGFloat width = GET_STRWIDTH(self.sysL.text, 9, 14)+8;
                if (width < 14) {
                    width = 14;
                }
                self.sysL.frame = CGRectMake(34, 0, width, 14);
            }else{
                self.sysL.hidden = YES;
            }
            
            if (stay.videoCommentNumM.num.intValue) {
                self.comL.hidden = NO;
                if (stay.videoCommentNumM.num.intValue > 99) {
                    stay.videoCommentNumM.num = @"99+";
                }
                self.comL.text = stay.videoCommentNumM.num;
              
                CGFloat width = GET_STRWIDTH(self.comL.text, 9, 14)+8;
                if (width < 14) {
                    width = 14;
                }
                self.comL.frame = CGRectMake(34, 0, width, 14);
            }else{
                self.comL.hidden = YES;
            }
   
            if (stay.likeModel.num.intValue) {
                self.likeL.hidden = NO;
                if (stay.likeModel.num.intValue > 99) {
                    stay.likeModel.num = @"99+";
                }
                self.likeL.text = stay.likeModel.num;
              
                CGFloat width = GET_STRWIDTH(self.likeL.text, 9, 14)+8;
                if (width < 14) {
                    width = 14;
                }
                self.likeL.frame = CGRectMake(34, 0, width, 14);
            }else{
                self.likeL.hidden = YES;
            }
            
            if (stay.orderComNum.num.intValue) {
                self.liuyL.hidden = NO;
                if (stay.orderComNum.num.intValue > 99) {
                    stay.orderComNum.num = @"99+";
                }
                self.liuyL.text = stay.orderComNum.num;
              
                CGFloat width = GET_STRWIDTH(self.liuyL.text, 9, 14)+8;
                if (width < 14) {
                    width = 14;
                }
                self.liuyL.frame = CGRectMake(34, 0, width, 14);
            }else{
                self.liuyL.hidden = YES;
            }
        }
    } fail:^(NSError *error) {
    }];
}

- (void)clickTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if (tapV.tag == 0) {
        NoticeSysViewController *ctl = [[NoticeSysViewController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (tapV.tag == 1){
        SXVideoCommentMeassageController *ctl = [[SXVideoCommentMeassageController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (tapV.tag == 2){
        SXVideoCommentLikeController *ctl = [[SXVideoCommentLikeController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }else if (tapV.tag == 3){
        SXShopLyListController *ctl = [[SXShopLyListController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)clearNum{
    
}
@end

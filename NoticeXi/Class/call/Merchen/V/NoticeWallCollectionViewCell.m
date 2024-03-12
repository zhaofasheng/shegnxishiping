//
//  NoticeWallCollectionViewCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/9.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeWallCollectionViewCell.h"

@implementation NoticeWallCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:0];
        self.userInteractionEnabled = YES;
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        _postImageView.layer.cornerRadius = 4;
        _postImageView.layer.masksToBounds = YES;
        _postImageView.contentMode = UIViewContentModeScaleAspectFill;
        _postImageView.clipsToBounds = YES;
        _postImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_postImageView];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_postImageView.frame.size.width-4-20, 4, 20, 20)];
        [closeBtn setBackgroundImage:UIImageNamed(@"ly_xxx") forState:UIControlStateNormal];
        [self.postImageView addSubview:closeBtn];
        self.closeButton  = closeBtn;
        [closeBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.addPhotosButton = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        [self.addPhotosButton setImage:UIImageNamed(@"editAddshop_img") forState:UIControlStateNormal];
        [self.addPhotosButton setAllCorner:4];
        self.addPhotosButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.contentView addSubview:self.addPhotosButton];
        self.addPhotosButton.userInteractionEnabled = NO;
    }
    return self;
}

- (void)deleteClick{
    if (!self.photoModel) {
        return;
    }
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.photoModel.dataId forKey:@"id"];
    [[DRNetWorking shareInstance] requestWithPatchPath:@"shop/wallLabel/1" Accept:@"application/vnd.shengxi.v5.6.0+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHMYWALLECT" object:nil];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)setPhotoModel:(NoticeShopDataIdModel *)photoModel{
    _photoModel = photoModel;
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:photoModel.photo_url]];
}

@end

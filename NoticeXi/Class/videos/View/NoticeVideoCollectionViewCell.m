//
//  NoticeVideoCollectionViewCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/25.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeVideoCollectionViewCell.h"
#import "NoticeLoginViewController.h"
@implementation NoticeVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.videoCoverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*3/4)];
        [self.contentView addSubview:self.videoCoverImageView];
        self.videoCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.videoCoverImageView.clipsToBounds = YES;
        
        
        self.infoView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
        [self.contentView addSubview:self.infoView];
        self.infoView.userInteractionEnabled = YES;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10, 20, 20)];
        self.iconImageView.layer.cornerRadius = 10;
        self.iconImageView.layer.masksToBounds = YES;
        [self.infoView addSubview:self.iconImageView];
        self.iconImageView.image = UIImageNamed(@"noImage_jynohe");
        self.iconImageView.userInteractionEnabled = YES;
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, self.infoView.frame.size.width-34, 40)];
        self.nickNameL.font = TWOTEXTFONTSIZE;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#41434D"];
        [self.infoView addSubview:self.nickNameL];

        UITapGestureRecognizer *userCenterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCenter)];
        [self.infoView addGestureRecognizer:userCenterTap];
        
        _likeL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 40)];
        _likeL.font = TWOTEXTFONTSIZE;
        _likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.infoView addSubview:_likeL];
        _likeL.hidden = YES;
        _likeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [_likeL addGestureRecognizer:likeTap];
        
        self.likeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.infoView.frame.size.width-8-16,12, 16, 16)];
        self.likeImageView.userInteractionEnabled = YES;
        self.likeImageView.image = UIImageNamed(@"sx_like_noimg");
        [self.infoView addSubview:self.likeImageView];
        UITapGestureRecognizer *likeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.likeImageView addGestureRecognizer:likeTap1];
        
        self.timeL = [[UILabel alloc] init];
        self.timeL.font = [UIFont systemFontOfSize:11];
        self.timeL.textColor = [UIColor whiteColor];
        self.timeL.textAlignment = NSTextAlignmentCenter;
        self.timeL.layer.cornerRadius = 2;
        self.timeL.layer.masksToBounds = YES;
        self.timeL.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [self.contentView addSubview:self.timeL];

        
        self.contentL = [[UILabel alloc] init];
        self.contentL.font = THRETEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        self.contentL.hidden = YES;
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    
    
    self.videoCoverImageView.frame = CGRectMake(0, 0, self.frame.size.width,(videoModel.screen.intValue == 2? self.frame.size.width*4/3 : self.frame.size.width*3/4));
    
    if (videoModel.title.length && videoModel.title) {
        self.contentL.frame = CGRectMake(10, CGRectGetMaxY(self.videoCoverImageView.frame)+10, self.frame.size.width-15, videoModel.nomerHeight);
        self.contentL.text = videoModel.title;
        self.contentL.hidden = NO;
    }else{
        self.contentL.hidden = YES;
    }
    
    self.nickNameL.text = self.videoModel.userModel.nick_name;
    self.infoView.frame = CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.userModel.avatar_url] placeholderImage:UIImageNamed(@"noImage_jynohe")];
 
 
    self.timeL.text = [self getMMSSFromSS:videoModel.video_len];
    CGFloat width = GET_STRWIDTH(self.timeL.text, 11, 16)+6;
    self.timeL.frame = CGRectMake(self.frame.size.width-width-8, 8, width, 16);
    [self.videoCoverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.video_cover_url]];
    
    [self refreshZanUI];
    
    _scButton.hidden = YES;
    if (self.showSCbutton) {
        self.scButton.hidden = NO;
        [self.scButton setBackgroundImage:UIImageNamed(videoModel.is_collection.boolValue? @"sx_scvideos_img":@"sx_scvideosno_img") forState:UIControlStateNormal];
    }
}

- (void)likeClick{
    if (![NoticeTools getuserId]) {
        NoticeLoginViewController *ctl = [[NoticeLoginViewController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        return;
    }
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

- (void)refreshZanUI{
    self.likeImageView.image = self.videoModel.is_zan.boolValue? UIImageNamed(@"sx_like_img") : UIImageNamed(@"sx_like_noimg");
    self.likeL.hidden = self.videoModel.zan_num.intValue?NO:YES;
    self.likeL.text = self.videoModel.zan_num;
    if (self.likeL.hidden) {
        self.likeImageView.frame = CGRectMake(self.infoView.frame.size.width-8-16,12, 16, 16);
    }else{
        self.likeL.frame = CGRectMake(self.infoView.frame.size.width-8-GET_STRWIDTH(self.likeL.text, 12, 40), 0, GET_STRWIDTH(self.likeL.text, 12, 40), 40);
        self.likeImageView.frame = CGRectMake(self.likeL.frame.origin.x-16, 12, 16, 16);
    }
}


- (UIButton *)scButton{
    if (!_scButton) {
        _scButton = [[UIButton  alloc] initWithFrame:CGRectMake(8, 8, 32, 32)];
        [self.contentView addSubview:_scButton];
        
        [_scButton setBackgroundImage:UIImageNamed(@"sx_scvideos_img") forState:UIControlStateNormal];
        [_scButton addTarget:self action:@selector(scClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scButton;
}

- (void)scClick{
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.videoModel.is_collection.boolValue?@"2" :@"1" forKey:@"type"];
    if (!self.videoModel.is_collection.boolValue) {
        [parm setObject:self.albumId forKey:@"ablumId"];
    }
    [parm setObject:self.videoModel.vid forKey:@"videoId"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"video/collect" Accept:@"application/vnd.shengxi.v5.8.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            
            self.videoModel.is_collection = self.videoModel.is_collection.boolValue?@"0":@"1";
            self.videoModel.collection_num = [NSString stringWithFormat:@"%d",self.videoModel.is_collection.boolValue?(self.videoModel.collection_num.intValue+1):(self.videoModel.collection_num.intValue-1)];
            if (self.videoModel.collection_num.intValue < 0) {
                self.videoModel.collection_num = @"0";
            }
            if (self.collectBlock) {
                self.collectBlock(self.videoModel.is_collection.boolValue);
            }
            [self.scButton setBackgroundImage:UIImageNamed(self.videoModel.is_collection.boolValue? @"sx_scvideos_img":@"sx_scvideosno_img") forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"SXCOLLECTvideoNotification" object:self userInfo:@{@"videoId":self.videoModel.vid,@"is_collection":self.videoModel.is_collection,@"collection_num":self.videoModel.collection_num,@"albumId":self.videoModel.is_collection.boolValue?self.albumId: @"0"}];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@:%@:%@",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"00",str_second.intValue?str_second:@"00"];
    }else{
        return [NSString stringWithFormat:@"%@:%@",str_minute.intValue?str_minute:@"00",str_second.intValue?str_second:@"00"];
    }
}


- (void)userCenter{
    
}


@end

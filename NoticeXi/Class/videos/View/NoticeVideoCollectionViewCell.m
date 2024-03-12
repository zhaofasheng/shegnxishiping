//
//  NoticeVideoCollectionViewCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/1/25.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeVideoCollectionViewCell.h"

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
        self.contentL.frame = CGRectMake(10, CGRectGetMaxY(self.videoCoverImageView.frame)+10, self.frame.size.width-18, videoModel.nomerHeight);
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

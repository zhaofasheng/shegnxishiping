//
//  SXHasBuySearisListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXHasBuySearisListCell.h"

@implementation SXHasBuySearisListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 75)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, self.backView.frame.size.width-15-50, 20)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.titleL];
        
        self.totalTimeL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 44, 80, 17)];
        self.totalTimeL.font = TWOTEXTFONTSIZE;
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:self.totalTimeL];
        
        self.statusL = [[UILabel  alloc] initWithFrame:CGRectMake(95, 44, 100, 20)];
        self.statusL.font = TWOTEXTFONTSIZE;
        self.statusL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:self.statusL];
        
        UIImageView *lockImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-24, 26, 24, 24)];
        lockImageV.image = UIImageNamed(@"sxNolookPayVideo_img");//
        [self.backView addSubview:lockImageV];
        self.lookImageView = lockImageV;
    }
    return self;
}

- (void)setVideoModel:(SXSearisVideoListModel *)videoModel{
    _videoModel = videoModel;
    self.titleL.text = videoModel.title;
    self.totalTimeL.text = [self getMMSSFromSS:videoModel.video_len];
    
    self.comimageV.hidden = NO;

    if (videoModel.schedule.intValue || videoModel.is_finished.boolValue) {
        self.titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.lookImageView.hidden = YES;
        self.comL.textColor = self.statusL.textColor;
        self.comimageV.image = UIImageNamed(@"sxsearcomnumh_img");
    }else{
        self.lookImageView.hidden = NO;
        
        if (self.paySearModel.hasBuy) {
            self.lookImageView.frame = CGRectMake(self.backView.frame.size.width-15-24, 26, 24, 24);
            self.lookImageView.image = UIImageNamed(@"sxNolookPayVideo_img");
        }else{
            if (videoModel.unLock || videoModel.tryPlayTime > 0) {//已经单集解锁或者可试看
                self.lookImageView.frame = CGRectMake(self.backView.frame.size.width-15-24, 26, 24, 24);
                self.lookImageView.image = UIImageNamed(@"sxNolookPayVideo_img");
            }else{
                self.lookImageView.frame = CGRectMake(self.backView.frame.size.width-15-20, 28, 20, 20);
                self.lookImageView.image = UIImageNamed(@"sxlock_img");
            }
        }
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.statusL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        
        self.comL.textColor = self.statusL.textColor;
        self.comimageV.image = UIImageNamed(@"sxsearcomnum_img");
    }
    
    self.statusL.hidden = YES;
    
    if (self.paySearModel.hasBuy || videoModel.unLock) {
        self.statusL.hidden = NO;
        if (videoModel.schedule.intValue){
            self.statusL.text = [NSString stringWithFormat:@"已观看%.f%%",((CGFloat)(videoModel.schedule.floatValue/videoModel.video_len.floatValue))*100];
        }else if (videoModel.is_finished.boolValue) {
            self.statusL.text = @"已看完";
        }else{
            self.statusL.text = @"待观看";
            self.statusL.hidden = self.paySearModel.hasBuy?NO:YES;
        }
    }
    
    if (videoModel.is_new.boolValue) {
        self.newVideoMarkL.hidden = self.paySearModel.hasBuy? NO : YES;
    }else{
        _newVideoMarkL.hidden = YES;
    }
  
    _tryL.hidden = YES;
    if (videoModel.tryPlayTime > 0 && !videoModel.unLock && !self.paySearModel.hasBuy) {
        self.tryL.hidden = NO;
        self.totalTimeL.frame = CGRectMake(CGRectGetMaxX(self.tryL.frame)+4, 44, GET_STRWIDTH(self.totalTimeL.text, 12, 17), 17);
    }else{
        self.totalTimeL.frame = CGRectMake(15, 44, GET_STRWIDTH(self.totalTimeL.text, 12, 17), 17);
    }
    self.comimageV.frame = CGRectMake(CGRectGetMaxX(self.totalTimeL.frame)+30, 46, 12, 12);
    
    self.comL.text = [NSString stringWithFormat:@"%d",videoModel.commentCt.intValue];
    self.comL.frame = CGRectMake(CGRectGetMaxX(self.comimageV.frame)+2, 44, GET_STRWIDTH(self.comL.text, 12, 17), 17);
    self.statusL.frame = CGRectMake(CGRectGetMaxX(self.comL.frame)+30, 44, 100, 17);
}

- (UILabel *)tryL{
    if (!_tryL) {
        _tryL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 44, 30, 17)];
        _tryL.font = [UIFont systemFontOfSize:10];
        _tryL.text = @"试看";
        _tryL.textColor = [UIColor whiteColor];
        _tryL.textAlignment = NSTextAlignmentCenter;
        [_tryL setAllCorner:2];
        _tryL.backgroundColor = [UIColor colorWithHexString:@"#1FC7FF"];
        [self.backView addSubview:_tryL];
    }
    return _tryL;
}

- (UIImageView *)comimageV{
    if (!_comimageV) {
        _comimageV = [[UIImageView  alloc] initWithFrame:CGRectMake(95, 46, 12, 12)];
        _comimageV.image =  UIImageNamed(@"sxsearcomnumh_img");
        [self.backView addSubview:_comimageV];
    }
    return _comimageV;
}

- (UILabel *)comL{
    if (!_comL) {
        _comL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_comimageV.frame)+2, 41, 50, 16)];
        _comL.font = TWOTEXTFONTSIZE;
        _comL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_comL];
    }
    return _comL;
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

- (UILabel *)newVideoMarkL{
    if (!_newVideoMarkL) {
        _newVideoMarkL = [[UILabel  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-60, 0, 60, 22)];
        _newVideoMarkL.textColor = [UIColor whiteColor];
        _newVideoMarkL.font = ELEVENTEXTFONTSIZE;
        _newVideoMarkL.textAlignment = NSTextAlignmentCenter;
        [_newVideoMarkL setCornerOnBottomLeft:8];
        _newVideoMarkL.text = @"NEW";
        _newVideoMarkL.backgroundColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [self.backView addSubview:_newVideoMarkL];
    }
    return _newVideoMarkL;
}

@end

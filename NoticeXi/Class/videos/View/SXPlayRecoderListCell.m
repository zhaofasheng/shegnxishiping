//
//  SXPlayRecoderListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/24.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayRecoderListCell.h"

@implementation SXPlayRecoderListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 100)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setCornerOnRight:10];
        [self addSubview:self.backView];
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 60, 80)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.backView addSubview:self.coverImageView];
        
   
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(80,15,self.backView.frame.size.width-85, 44)];
        _titleL.font = XGFifthBoldFontSize;
        _titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:_titleL];
        _titleL.numberOfLines = 2;
        
        self.subTitleL = [[UILabel  alloc] initWithFrame:CGRectMake(80, 38, self.backView.frame.size.width-85, 17)];
        self.subTitleL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.subTitleL.font = TWOTEXTFONTSIZE;
        [self.backView addSubview:self.subTitleL];
        
        _markL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-16-80,65,80, 17)];
        _markL.font = TWOTEXTFONTSIZE;
        _markL.textAlignment = NSTextAlignmentRight;
        _markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:_markL];
        _markL.numberOfLines = 0;
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(80,65,100, 17)];
        _timeL.font = ELEVENTEXTFONTSIZE;
        _timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_timeL];
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    if (videoModel.searModel) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.searModel.simple_cover_url]];
        self.titleL.frame = CGRectMake(80,15,self.backView.frame.size.width-85,20);
        self.titleL.text = videoModel.searModel.series_name;
        self.subTitleL.hidden = NO;
        self.subTitleL.text = videoModel.title;
    }else{
        self.subTitleL.hidden = YES;
        self.titleL.text = videoModel.title;
        if (GET_STRWIDTH(self.titleL.text, 16, 20) > self.titleL.frame.size.width) {
            self.titleL.frame = CGRectMake(85, 15, self.backView.frame.size.width-85, 40);
        }
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.video_cover_url]];
    }
    
    self.timeL.text = [self getMMSSFromSS:videoModel.video_len];
    if (videoModel.schedule.intValue) {
        self.markL.text = [NSString stringWithFormat:@"已观看%.f%%",((CGFloat)(videoModel.schedule.floatValue/videoModel.video_len.floatValue))*100];
    }else if (videoModel.is_finished.boolValue){
        self.markL.text = @"已看完";
    }else{
        self.markL.text = @"待观看";
    }
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

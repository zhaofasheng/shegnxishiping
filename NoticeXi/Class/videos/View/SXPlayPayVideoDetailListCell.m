//
//  SXPlayPayVideoDetailListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayPayVideoDetailListCell.h"

@implementation SXPlayPayVideoDetailListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 65)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [self.contentView addSubview:self.backView];
        
        self.titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 12, self.backView.frame.size.width-15-50, 20)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.titleL];
        
        self.totalTimeL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 36, 80, 17)];
        self.totalTimeL.font = TWOTEXTFONTSIZE;
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:self.totalTimeL];
        
        self.statusL = [[UILabel  alloc] initWithFrame:CGRectMake(95, 36, 100, 17)];
        self.statusL.font = TWOTEXTFONTSIZE;
        self.statusL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.backView addSubview:self.statusL];
        
        self.fgView = [[UIView  alloc] initWithFrame:CGRectMake(15, 55, DR_SCREEN_WIDTH-30, 10)];
        self.fgView.backgroundColor = self.backView.backgroundColor;
        [self.contentView addSubview:self.fgView];
        self.fgView.hidden = YES;
        
        self.fgView1 = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 10)];
        self.fgView1.backgroundColor = self.backView.backgroundColor;
        [self.contentView addSubview:self.fgView1];
        self.fgView1.hidden = YES;
    }
    return self;
}

- (void)setVideoModel:(SXSearisVideoListModel *)videoModel{
    _videoModel = videoModel;
    self.titleL.text = videoModel.title;
    self.totalTimeL.text = [self getMMSSFromSS:videoModel.video_len];

    if ([videoModel.videoId isEqualToString:self.currentVideo.videoId]) {
        self.titleL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
        self.statusL.textColor = [UIColor colorWithHexString:@"#FF68A3"];
    }
    else if (videoModel.schedule.intValue || videoModel.is_finished.boolValue) {
        self.titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.statusL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    
    }else{
   
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.statusL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
    }
    
    if ([videoModel.videoId isEqualToString:self.currentVideo.videoId]) {
        self.statusL.text = @"观看中";
    }
    else if (videoModel.is_finished.boolValue) {
        self.statusL.text = @"已看完";
    }else if (videoModel.schedule.intValue){
        self.statusL.text = [NSString stringWithFormat:@"已观看%.f%%",((CGFloat)(videoModel.schedule.floatValue/videoModel.video_len.floatValue))*100];
    }else{
        self.statusL.text = @"待观看";
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

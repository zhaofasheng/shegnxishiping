//
//  SXCompilationCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXCompilationCell.h"



@implementation SXCompilationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(0, 10, DR_SCREEN_WIDTH, 80)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 10, 60, 80)];
        [self.coverImageView setAllCorner:2];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
        self.nameL = [[UILabel  alloc] initWithFrame:CGRectMake(85, 22, DR_SCREEN_WIDTH-90, 22)];
        self.nameL.font = XGSIXBoldFontSize;
        self.nameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.contentView addSubview:self.nameL];
        
        self.timeL = [[UILabel  alloc] initWithFrame:CGRectMake(85, CGRectGetMaxY(self.nameL.frame)+17, 60, 17)];
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.timeL.font = TWOTEXTFONTSIZE;
        [self.contentView addSubview:self.timeL];
        
        UIImageView *likeImgV = [[UIImageView  alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(self.nameL.frame)+20, 12, 12)];
        [self.contentView addSubview:likeImgV];
        likeImgV.image = UIImageNamed(@"sx_like_noimgs1");
        
        self.likeL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(likeImgV.frame)+3, CGRectGetMaxY(self.nameL.frame)+17, 30, 17)];
        self.likeL.font = TWOTEXTFONTSIZE;
        self.likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:self.likeL];
        
        UIImageView *comImgV = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.likeL.frame)+2, CGRectGetMaxY(self.nameL.frame)+20, 12, 12)];
        [self.contentView addSubview:comImgV];
        comImgV.image = UIImageNamed(@"sx_com_markimg1");
        
        self.comL = [[UILabel  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(comImgV.frame)+3, CGRectGetMaxY(self.nameL.frame)+17, 30, 17)];
        self.comL.font = TWOTEXTFONTSIZE;
        self.comL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        
        [self.contentView addSubview:self.comL];
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.video_cover_url]];
    self.nameL.text = videoModel.title;
    self.likeL.text = [NSString stringWithFormat:@"%d",videoModel.zan_num.intValue];
    self.comL.text = [NSString stringWithFormat:@"%d",videoModel.commentCt.intValue];
    
    self.timeL.text = [self getMMSSFromSS:videoModel.video_len];
    
    self.backView.backgroundColor = [UIColor whiteColor];
    if ([videoModel.vid isEqualToString:self.currentVideoId]) {
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
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

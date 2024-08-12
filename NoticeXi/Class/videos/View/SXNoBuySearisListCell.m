//
//  SXNoBuySearisListCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/29.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXNoBuySearisListCell.h"

@implementation SXNoBuySearisListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 72)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.titleL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, self.backView.frame.size.width-15-45, 20)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:self.titleL];
        
        UIImageView *lockImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-20, 25, 20, 20)];
        lockImageV.image = UIImageNamed(@"sxlock_img");
        [self.backView addSubview:lockImageV];
        
        self.totalTimeL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 40, 80, 17)];
        self.totalTimeL.font = TWOTEXTFONTSIZE;
        self.totalTimeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:self.totalTimeL];
    }
    return self;
}

- (void)setVideoModel:(SXSearisVideoListModel *)videoModel{
    _videoModel = videoModel;
    self.titleL.text = videoModel.title;
    self.totalTimeL.text = [self getMMSSFromSS:videoModel.video_len];
    self.comimageV.hidden = NO;
    self.comL.text = [NSString stringWithFormat:@"%d",videoModel.commentCt.intValue];
}

- (UIImageView *)comimageV{
    if (!_comimageV) {
        _comimageV = [[UIImageView  alloc] initWithFrame:CGRectMake(95, 42, 12, 12)];
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

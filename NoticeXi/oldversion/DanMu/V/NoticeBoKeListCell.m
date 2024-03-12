//
//  NoticeBoKeListCell.m
//  NoticeXi
//
//  Created by li lei on 2022/9/8.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeListCell.h"

@implementation NoticeBoKeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.titleL = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(50, 15,DR_SCREEN_WIDTH-55, 21)];
        self.titleL.font = XGFifthBoldFontSize;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.titleL];
        
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,50, 72)];
        self.numberL.font = FOURTHTEENTEXTFONTSIZE;
        self.numberL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:self.numberL];
        self.numberL.textAlignment = NSTextAlignmentCenter;
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(50, 40,66, 17)];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.contentView addSubview:self.timeL];
        

        self.userInteractionEnabled = YES;
        
        UIView *comView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-60, 40, 60, 16)];
        comView.userInteractionEnabled = YES;
        [self.contentView addSubview:comView];
        
        self.comImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        self.comImageView.image = UIImageNamed(@"bokeCom_img");
        [comView addSubview:self.comImageView];
        self.comImageView.userInteractionEnabled = YES;
        
        self.comL = [[UILabel alloc] initWithFrame:CGRectMake(16, 0,60-16, 16)];
        self.comL.font = TWOTEXTFONTSIZE;
        self.comL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [comView addSubview:self.comL];
        

        UIView *likeView = [[UIView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-60-60, 40, 60, 16)];
        likeView.userInteractionEnabled = YES;
        [self.contentView addSubview:likeView];
        
        self.zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        self.zanImageView.image = UIImageNamed(@"bokeLike_img");
        [likeView addSubview:self.zanImageView];
        self.zanImageView.userInteractionEnabled = YES;
        
        self.zanL = [[UILabel alloc] initWithFrame:CGRectMake(16, 0,60-16, 16)];
        self.zanL.font = TWOTEXTFONTSIZE;
        self.zanL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [likeView addSubview:self.zanL];
        
  
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:line];
    }
    return self;
}


- (void)setModel:(NoticeDanMuModel *)model{
    _model = model;
    self.titleL.text = model.podcast_title;
    self.timeL.text = [self getMMSSFromSS:model.total_time.integerValue];
    self.zanL.text = model.count_like.intValue?model.count_like:@"";
    self.comL.text = model.count_comment.intValue?model.count_comment:@"";
    
    if(self.isNew){
        self.numberL.text = [NSString stringWithFormat:@"%ld",30*(self.currentPageNo-1)+self.currentIndex+1];
    }else{
        self.numberL.text = [NSString stringWithFormat:@"%ld",30*(self.currentPageNo-1) + self.allCount-self.currentIndex];
    }
}

-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    
    NSInteger seconds = totalTime;
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    if (seconds <0) {
        return format_time = @"00:00";
    }
    return format_time;
}


- (void)setIsChoice:(BOOL)isChoice{
    _isChoice = isChoice;

    self.titleL.textColor = [UIColor colorWithHexString:isChoice?@"#00ABE4":@"#25262E"];
    self.numberL.textColor = [UIColor colorWithHexString:isChoice?@"#00ABE4":@"#5C5F66"];
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

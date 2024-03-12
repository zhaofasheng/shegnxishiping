//
//  NoticeChengJiuCell.m
//  NoticeXi
//
//  Created by li lei on 2023/12/1.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChengJiuCell.h"

@implementation NoticeChengJiuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.backImageView];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    
    self.view0.hidden = index == 0 ? NO : YES;
    self.view1.hidden = index == 1 ? NO : YES;
    self.view2.hidden = index == 2 ? NO : YES;
    self.view3.hidden = index == 3 ? NO : YES;
    self.view4.hidden = index == 4 ? NO : YES;
}


- (UIView *)view0{
    if(!_view0){
        _view0 = [[UIView alloc] initWithFrame:self.backImageView.bounds];
        _view0.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.backImageView addSubview:_view0];
       
        NSString *str = @"我们又相处了一年啦\n在这里想告诉你一些关于我的秘密";
        CGFloat height = [NoticeTools getHeightWithLineHight:4 font:16 width:DR_SCREEN_WIDTH-50 string:str];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, NAVIGATION_BAR_HEIGHT+56, DR_SCREEN_WIDTH-50, height)];
        label.attributedText = [NoticeTools getStringWithLineHight:4 string:str];
        label.font = SIXTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        label.numberOfLines = 0;
        [_view0 addSubview:label];
        
        self.peopleL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+11, DR_SCREEN_WIDTH-30, 37)];
        self.peopleL.font = SIXTEENTEXTFONTSIZE;
        self.peopleL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view0 addSubview:self.peopleL];
        
        self.useL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.peopleL.frame)+5, DR_SCREEN_WIDTH-30, 37)];
        self.useL.font = SIXTEENTEXTFONTSIZE;
        self.useL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view0 addSubview:self.useL];
        
        self.storyL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.useL.frame)+5, DR_SCREEN_WIDTH-30, 37)];
        self.storyL.font = SIXTEENTEXTFONTSIZE;
        self.storyL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view0 addSubview:self.storyL];
    }
    return _view0;
}

- (UIView *)view1{
    if(!_view1){
        _view1 = [[UIView alloc] initWithFrame:self.backImageView.bounds];
        _view1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.backImageView addSubview:_view1];
       
        NSString *str = @"在过去的365天里";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, NAVIGATION_BAR_HEIGHT+56, DR_SCREEN_WIDTH-50, 22)];
        label.text = str;
        label.font = SIXTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view1 addSubview:label];
        
        self.hereL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+3, DR_SCREEN_WIDTH-30, 37)];
        self.hereL.font = SIXTEENTEXTFONTSIZE;
        self.hereL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view1 addSubview:self.hereL];
        
        NSString *str1 = @"谢谢你让我觉得不孤独";
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.hereL.frame)+6, DR_SCREEN_WIDTH-50, 22)];
        label1.text = str1;
        label1.font = SIXTEENTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view1 addSubview:label1];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.hereL.frame)+51, DR_SCREEN_WIDTH-30, 37)];
        self.timeL.font = SIXTEENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        self.timeL.numberOfLines = 0;
        [_view1 addSubview:self.timeL];
        
        self.withL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.timeL.frame), DR_SCREEN_WIDTH-30, 37)];
        self.withL.font = SIXTEENTEXTFONTSIZE;
        self.withL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view1 addSubview:self.withL];
    }
    return _view1;
}

- (UIView *)view2{
    if(!_view2){
        _view2 = [[UIView alloc] initWithFrame:self.backImageView.bounds];
        _view2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.backImageView addSubview:_view2];
      
        NSString *str = @"今年你的小铺";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, NAVIGATION_BAR_HEIGHT+56, DR_SCREEN_WIDTH-50, 22)];
        label.text = str;
        label.font = SIXTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view2 addSubview:label];
        
        self.jiedaiL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+3, DR_SCREEN_WIDTH-30, 37)];
        self.jiedaiL.font = SIXTEENTEXTFONTSIZE;
        self.jiedaiL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view2 addSubview:self.jiedaiL];
        
        self.zhiyuL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.jiedaiL.frame)+5, DR_SCREEN_WIDTH-30, 37)];
        self.zhiyuL.font = SIXTEENTEXTFONTSIZE;
        self.zhiyuL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view2 addSubview:self.zhiyuL];
        
        self.andL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.zhiyuL.frame)+25, DR_SCREEN_WIDTH-30, 37)];
        self.andL.font = SIXTEENTEXTFONTSIZE;
        self.andL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view2 addSubview:self.andL];
        
        self.andView = [[UIView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.zhiyuL.frame)+17, DR_SCREEN_WIDTH-30, 78)];
        self.andView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [_view2 addSubview:self.andView];
        
        NSString *str1 = @"其中和";
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GET_STRWIDTH(str1, 16, 56), 56)];
        label1.text = str1;
        label1.font = SIXTEENTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [self.andView addSubview:label1];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame)+24, 0, 56, 56)];
        self.iconImageView.layer.cornerRadius = 28;
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.iconImageView.layer.borderWidth = 1;
        [self.andView addSubview:self.iconImageView];
        
        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame),59,104, 16)];
        self.nickNameL.font = ELEVENTEXTFONTSIZE;
        self.nickNameL.textAlignment = NSTextAlignmentCenter;
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#508FD4"];
        [self.andView addSubview:self.nickNameL];
        
        NSString *str2 = @"羁绊最深";
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+24, 0, GET_STRWIDTH(str2, 16, 56), 56)];
        label2.text = str2;
        label2.font = SIXTEENTEXTFONTSIZE;
        label2.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [self.andView addSubview:label2];
    }
    return _view2;
}

- (void)setDataModel:(NoticeAllZongjieModel *)dataModel{
    _dataModel = dataModel;
    
    
    if(self.index == 0){
        NSString *str1 = @"今年有 ";
        NSString *str = [NSString stringWithFormat:@"%@%@ 人来了声昔",str1,dataModel.user_num];
        self.peopleL.attributedText = [DDHAttributedMode setString:str setSize:26 setLengthString:dataModel.user_num beginSize:str1.length];
        
        NSString *str2 = [NSString stringWithFormat:@"%@ 人在这里留下了自己的印迹",dataModel.use_user_num];
        self.useL.attributedText = [DDHAttributedMode setString:str2 setSize:26 setLengthString:dataModel.use_user_num beginSize:0];
        
        NSString *str3 = @"声昔今年储存了 ";
        NSString *str4 = [NSString stringWithFormat:@"%@%@ 个故事",str3,dataModel.story_num];
        self.storyL.attributedText = [DDHAttributedMode setString:str4 setSize:26 setLengthString:dataModel.story_num beginSize:str3.length];
    }else if (self.index == 1){
        NSString *str1 = @"你有 ";
        NSString *str = [NSString stringWithFormat:@"%@%@ 天都在这里",str1,dataModel.online_days];
        self.hereL.attributedText = [DDHAttributedMode setString:str setSize:26 setLengthString:dataModel.online_days beginSize:str1.length];
        
        if(dataModel.latest_time && dataModel.latest_time.length > 6){
            NSString *str2 = @"最晚 ";
            NSString *str3 = [NSString stringWithFormat:@"%@%@ 还在声昔",str2,dataModel.latest_time];
            self.timeL.attributedText = [DDHAttributedMode setString:str3 setSize:26 setLengthString:dataModel.latest_time beginSize:str2.length];
            
            NSString *str4 = @"有 ";
            NSString *str5 = [NSString stringWithFormat:@"%@%@ 个寂静的夜晚 我们都在互相陪伴",str4,dataModel.night_online_days];
            self.withL.attributedText = [DDHAttributedMode setString:str5 setSize:26 setLengthString:dataModel.night_online_days beginSize:str4.length];
        }else{
            NSString *str = @"我们的孤独就像天空中漂浮的城市\n仿佛是一个秘密 却无从述说";
            self.timeL.attributedText = [NoticeTools getStringWithLineHight:3 string:str];
            self.timeL.frame = CGRectMake(25, CGRectGetMaxY(self.hereL.frame)+51, DR_SCREEN_WIDTH-30, [NoticeTools getHeightWithLineHight:3 font:16 width:DR_SCREEN_WIDTH-30 string:str]);
            
            self.withL.text = @"—《天空之城》";
            self.withL.textAlignment = NSTextAlignmentRight;
            CGFloat width = GET_STRWIDTH(@"我们的孤独就像天空中漂浮的城市", 16, 22);
            self.withL.frame = CGRectMake(25, CGRectGetMaxY(self.timeL.frame)+10, width, 22);
        }
    }else if (self.index == 2){
        if(dataModel.had_shop.intValue){//有店铺
            self.andView.hidden = NO;
            self.andL.hidden = YES;
            self.nickNameL.text = dataModel.userM.nick_name;
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.userM.avatar_url]];
            
            NSString *str2 = @"接待了 ";
            NSString *str3 = [NSString stringWithFormat:@"%@%@ 个订单",str2,dataModel.order_num];
            self.jiedaiL.attributedText = [DDHAttributedMode setString:str3 setSize:26 setLengthString:dataModel.order_num beginSize:str2.length];
            
            NSString *str4 = @"治愈了 ";
            NSString *str5 = [NSString stringWithFormat:@"%@%@ 人",str4,dataModel.cure_num];
            self.zhiyuL.attributedText = [DDHAttributedMode setString:str5 setSize:26 setLengthString:dataModel.cure_num beginSize:str4.length];
        }else{
            self.andView.hidden = YES;
            self.andL.hidden = NO;
            NSString *str2 = @"发起了 ";
            NSString *str3 = [NSString stringWithFormat:@"%@%@ 个订单",str2,dataModel.order_num];
            self.jiedaiL.attributedText = [DDHAttributedMode setString:str3 setSize:26 setLengthString:dataModel.order_num beginSize:str2.length];
            

            if(dataModel.order_num.intValue){
                NSString *str6 = @"其中和 ";
                NSString *str7 = [NSString stringWithFormat:@"%@%@ 这个店铺羁绊最深",str6,dataModel.most_shop_name];
                self.andL.attributedText = [DDHAttributedMode setString:str7 setSize:26 setLengthString:dataModel.most_shop_name beginSize:str6.length];
                NSString *str5 = [NSString stringWithFormat:@"%@%@时间段使用频率最高",dataModel.time_periodName,dataModel.time_Range];
                self.zhiyuL.attributedText = [DDHAttributedMode setString:str5 setSize:26 setLengthString:dataModel.time_periodName beginSize:0];
            }else{
                self.andL.text = @"";
            }
        
        }
    }else if (self.index == 3){
        if(dataModel.most_topic_id.intValue){//有话题
            self.topicL.text = [NSString stringWithFormat:@"#%@#",dataModel.most_topic_name];
            self.topicMarkL.text = @"有没有发现自己的这些小习惯呢";
        }else{
            self.topicL.text = @"没…没有？";
        }
    }
}


- (UIView *)view3{
    if(!_view3){
        _view3 = [[UIView alloc] initWithFrame:self.backImageView.bounds];
        _view3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.backImageView addSubview:_view3];
        
        NSString *str = @"一年又一年，今年";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, NAVIGATION_BAR_HEIGHT+56+30, DR_SCREEN_WIDTH-30, 22)];
        label.text = str;
        label.font = SIXTEENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view3 addSubview:label];
        
        NSString *str1 = @"经常使用的话题";
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+12, DR_SCREEN_WIDTH-30, 22)];
        label1.text = str1;
        label1.font = SIXTEENTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view3 addSubview:label1];

        self.topicL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label1.frame)+4, DR_SCREEN_WIDTH-30, 37)];
        self.topicL.font = XGTwentyFifBoldFontSize;
        self.topicL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view3 addSubview:self.topicL];
        
        self.topicMarkL = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(self.topicL.frame)+20, DR_SCREEN_WIDTH-30, 44)];
        self.topicMarkL.font = SIXTEENTEXTFONTSIZE;
        self.topicMarkL.numberOfLines = 0;
        self.topicMarkL.text = @"怎么会怎么会这样，那我这里的文案要怎么写\n求求了明年用一用好吗？";
        self.topicMarkL.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view3 addSubview:self.topicMarkL];
    }
    return _view3;
}

- (UIView *)view4{
    if(!_view4){
        _view4 = [[UIView alloc] initWithFrame:self.backImageView.bounds];
        _view4.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self.backImageView addSubview:_view4];
       
        NSString *str = @"hey～亲爱的小伙伴们，今年我们想要做一个有趣的活动“和声昔鹅er交换信件”，信件寄出后将和其他寄信人随机交换信件。\n\n·寄信时间：1月1日00:00-1月7日24:00\n·收信时间：1月8日12:00";
        CGFloat height = [NoticeTools getHeightWithLineHight:3 font:16 width:DR_SCREEN_WIDTH-50 string:str];
        
        NSString *str1 = @"·每人只能寄一封信\n·信件中附带寄信人的声昔学号";
        CGFloat height1 = [NoticeTools getHeightWithLineHight:3 font:14 width:DR_SCREEN_WIDTH-50 string:str];
        
        CGFloat allHeight = height+height1+16+37+16;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, (DR_SCREEN_HEIGHT-allHeight)/2-30, DR_SCREEN_WIDTH-30, 37)];
        label.text = str;
        label.font = XGTwentyFifBoldFontSize;
        label.numberOfLines = 0;
        label.text = @"祝福素未谋面的Ta";
        label.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view4 addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+15, DR_SCREEN_WIDTH-50, height)];
        label1.text = str;
        label1.font = SIXTEENTEXTFONTSIZE;
        label1.numberOfLines = 0;
        label1.attributedText = [NoticeTools getStringWithLineHight:3 string:str];
        label1.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view4 addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(25,CGRectGetMaxY(label1.frame)+16, DR_SCREEN_WIDTH-50, height1)];
        label2.font = FOURTHTEENTEXTFONTSIZE;
        label2.numberOfLines = 0;
        label2.attributedText = [NoticeTools getStringWithLineHight:3 string:str1];
        label2.textColor = [UIColor colorWithHexString:@"#ABCEFF"];
        [_view4 addSubview:label2];
    }
    return _view4;
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

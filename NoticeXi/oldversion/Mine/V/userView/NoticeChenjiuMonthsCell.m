//
//  NoticeChenjiuMonthsCell.m
//  NoticeXi
//
//  Created by li lei on 2023/12/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChenjiuMonthsCell.h"

@implementation NoticeChenjiuMonthsCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.masksToBounds = YES;
        self.backImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.backImageView];
        self.backImageView.userInteractionEnabled = YES;
        self.dataView.hidden = NO;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width-50, 120)];
        self.titleL.textColor = [UIColor whiteColor];
        self.titleL.adjustsFontSizeToFitWidth = YES;
        self.titleL.font = [UIFont fontWithName:@"zihunxinquhei" size:90];
        self.titleL.text = @"20";
        [self.backImageView addSubview:self.titleL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width-60, self.frame.size.height)];
        self.markL.textColor = [UIColor whiteColor];
        self.markL.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.markL.font = EIGHTEENTEXTFONTSIZE;
       
        self.markL.numberOfLines = 0;
        [self.backImageView addSubview:self.markL];
    }
    return self;
}

- (void)setMonthsModel:(NoticeChengjiuMonths *)monthsModel{
    _monthsModel = monthsModel;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:monthsModel.cover_url]];
    self.dataView.hidden = NO;
    self.markL.hidden = YES;
    if(monthsModel.given_month.intValue == 0){//年终总结
        self.titleL.text = monthsModel.given_year;
    }else if (monthsModel.given_month.intValue == 99){
        self.titleL.text = @"";
        self.dataView.hidden = YES;
        if(!monthsModel.is_click.intValue){//如果是不可点击
            self.markL.hidden = NO;
            self.markL.attributedText = [NoticeTools getStringWithLineHight:3 string:[NSString stringWithFormat:@"%@声昔年终活动\n将于%d-01-01 00:00:00开启",monthsModel.given_year,monthsModel.given_year.intValue+1]];
        }
    }else{
        self.titleL.text = monthsModel.given_month;
    }
    
    if (monthsModel.dataModel.voiceLen.integerValue < 60) {
        self.voiceL.text = [NSString stringWithFormat:@"%d秒",monthsModel.dataModel.voiceLen.intValue];
    }else {
        self.voiceL.text = [NSString stringWithFormat:@"%d分钟",monthsModel.dataModel.voiceLen.intValue/60];
    }
    
    if (monthsModel.dataModel.podcastLen.integerValue < 60) {
        self.bokeL.text = [NSString stringWithFormat:@"%d秒",monthsModel.dataModel.podcastLen.intValue];
    }else {
        self.bokeL.text = [NSString stringWithFormat:@"%d分钟",monthsModel.dataModel.podcastLen.intValue/60];
    }
    self.textL.text = [NSString stringWithFormat:@"%d字",monthsModel.dataModel.textLen.intValue];
    
    self.commentimgView.hidden = YES;
    self.commentL.hidden = YES;
    self.commentView.hidden = YES;
    if(monthsModel.dataModel.type.intValue > 0){
        self.commentView.hidden = NO;
        if(monthsModel.dataModel.contentType.intValue == 1){
            self.commentL.hidden = NO;
            self.commentL.text = monthsModel.dataModel.content;
            self.commentL.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, GET_STRHEIGHT(self.commentL.text, 14, self.scrollView.frame.size.width));
            self.scrollView.contentSize = CGSizeMake(0, self.commentL.frame.size.height);
        }else{
            self.commentimgView.hidden = NO;
            [self.commentimgView sd_setImageWithURL:[NSURL URLWithString:monthsModel.dataModel.content]];
        }
        if(monthsModel.dataModel.type.intValue == 1){
            self.commentFromL.text = @"热门留言来自心情";
        }else if(monthsModel.dataModel.type.intValue == 2){
            self.commentFromL.text = @"热门留言来自播客";
        }else if(monthsModel.dataModel.type.intValue == 3){
            self.commentFromL.text = @"热门留言来自求助帖";
        }else if(monthsModel.dataModel.type.intValue == 4){
            self.commentFromL.text = @"热门留言来自配音";
        }
        self.commentFromL.frame = CGRectMake(self.commentView.frame.size.width-GET_STRWIDTH(self.commentFromL.text, 14, 17)-25, self.commentView.frame.size.height-32, GET_STRWIDTH(self.commentFromL.text, 14, 17), 17);
        self.fromLine.frame = CGRectMake(self.commentFromL.frame.origin.x-53, self.commentFromL.frame.origin.y+15/2, 50, 2);
    }
    
    if((monthsModel.given_year.intValue == monthsModel.currentYear.intValue) && monthsModel.given_month.intValue != 99){//如果查看的是当前年份且不是年终活动，就对比当前月份
        if(monthsModel.given_month.intValue == 0){//年终结
            self.markL.attributedText = [NoticeTools getStringWithLineHight:3 string:@"年总结，将在1月1日开启\n敬请期待"];
            self.markL.hidden = NO;
            self.dataView.hidden = YES;
        }else{//月总结
            if(monthsModel.given_month.intValue >= monthsModel.currentMonth.intValue){//如果月份大于等于当前月份
                self.markL.hidden = NO;
                self.dataView.hidden = YES;
                if(monthsModel.given_month.intValue == 12){//如果是12月
                    self.markL.attributedText = [NoticeTools getStringWithLineHight:3 string:@"12月小结，将在1月1日开启\n敬请期待"];
                }else{
                    self.markL.attributedText = [NoticeTools getStringWithLineHight:3 string:[NSString stringWithFormat:@"%@月小结，将在%02d月1日开启\n敬请期待",monthsModel.given_month,monthsModel.given_month.intValue+1]];
                }
            }
        }

    }
    
    self.markL.textAlignment = NSTextAlignmentCenter;
}

- (UIView *)dataView{
    if(!_dataView){
        
        _dataView = [[UIView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_dataView];
        
        _dataView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0];
        
        CGFloat width = GET_STRWIDTH(@"语音心情的", 16, 22);
        NSArray *arr = @[@"语音心情",@"文字心情",@"播客记录"];
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 120+15+32*i, width, 22)];
            label.font = SIXTEENTEXTFONTSIZE;
            label.textColor = [UIColor whiteColor];
            label.text = arr[i];
            [_dataView addSubview:label];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-40-width, 120+15+32*i, width, 22)];
            label1.font = SIXTEENTEXTFONTSIZE;
            label1.textColor = [UIColor whiteColor];
    
            label.textAlignment = NSTextAlignmentRight;
            [_dataView addSubview:label1];
            if(i == 0){
                self.voiceL = label1;
            }else if (i == 1){
                self.textL = label1;
            }else{
                self.bokeL = label1;
            }
        }
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.bokeL.frame)+30, self.frame.size.width-40, self.frame.size.height-CGRectGetMaxY(self.bokeL.frame)-30-65)];
        commentView.layer.borderColor = [UIColor whiteColor].CGColor;
        commentView.layer.borderWidth = 1;
        commentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [_dataView addSubview:commentView];
        self.commentView = commentView;
        
        UIImageView *leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 14.33, 9.92)];
        leftImgV.image = UIImageNamed(@"leftyinhao_img");
        [commentView addSubview:leftImgV];
        
        UIImageView *rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(commentView.frame.size.width-14.33-12, commentView.frame.size.height-40-9.92, 14.33, 9.92)];
        rightImgV.image = UIImageNamed(@"rightyinhao_img");
        [commentView addSubview:rightImgV];
        
        self.commentFromL = [[UILabel alloc] initWithFrame:CGRectMake(commentView.frame.size.width-GET_STRWIDTH(@"热门留言来自播客", 12, 17)-25, commentView.frame.size.height-32, GET_STRWIDTH(@"热门留言来自播客", 12, 17), 17)];
        self.commentFromL.textColor = [UIColor whiteColor];
        self.commentFromL.font = FOURTHTEENTEXTFONTSIZE;
        self.commentFromL.text = @"热门留言来自播客";
        [commentView addSubview:self.commentFromL];
        
        self.fromLine = [[UIView alloc] initWithFrame:CGRectMake(self.commentFromL.frame.origin.x-53, self.commentFromL.frame.origin.y+15/2, 50, 2)];
        self.fromLine.backgroundColor = [UIColor whiteColor];
        [commentView addSubview:self.fromLine];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 30, commentView.frame.size.width-50, rightImgV.frame.origin.y-35)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [commentView addSubview:self.scrollView];
        
        self.commentL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.commentL.numberOfLines = 0;
        self.commentL.textColor = [UIColor whiteColor];
        self.commentL.font = FOURTHTEENTEXTFONTSIZE;
        [self.scrollView addSubview:self.commentL];
        
        self.commentimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.height, self.scrollView.frame.size.height)];
        self.commentFromL.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:self.commentimgView];
    }
    return _dataView;
}

@end

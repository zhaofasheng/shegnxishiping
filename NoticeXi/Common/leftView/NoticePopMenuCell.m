//
//  NoticePopMenuCell.m
//  NoticeXi
//
//  Created by li lei on 2023/10/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticePopMenuCell.h"

@implementation NoticePopMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, DR_SCREEN_WIDTH-90, (DR_SCREEN_WIDTH-90)*135/285)];
        
        [self.contentView addSubview:self.backView];
        
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 44, 32)];
        [self.backView addSubview:self.titleImageView];
        
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(60, 18, self.backView.frame.size.width-60, 17)];
        self.numberL.font = TWOTEXTFONTSIZE;
        self.numberL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.numberL];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height)];
        self.titleL.font = [UIFont fontWithName:@"zihunxinquhei" size:24];;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.titleL];
        self.titleL.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    
    if(index == 0){
        self.backView.frame = CGRectMake(10, 0, DR_SCREEN_WIDTH-90, (DR_SCREEN_WIDTH-90)*135/285);
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFD43D"];
        self.titleL.text = [NoticeTools chinese:@"声昔小社团" english:@"Group" japan:@"群"];
        if([NoticeTools getLocalType] == 1){
            self.numberL.text = [NSString stringWithFormat:@"%d New",self.numberModel.massChatLogCount.intValue];
        }else if ([NoticeTools getLocalType] == 2){
            self.numberL.text = [NSString stringWithFormat:@"%d メッセージ",self.numberModel.massChatLogCount.intValue];
        }else{
            self.numberL.text = [NSString stringWithFormat:@"今日新增%d条消息",self.numberModel.massChatLogCount.intValue];
        }
        
        
    }else if (index == 1){
        self.backView.frame = CGRectMake(10, 0, DR_SCREEN_WIDTH-90, (DR_SCREEN_WIDTH-90)*135/285);
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#41D7F5"];
        self.titleL.text = [NoticeTools getLocalStrWith:@"help.qiuz"];
        
        if([NoticeTools getLocalType] == 1){
            self.numberL.text = [NSString stringWithFormat:@"%d New",self.numberModel.invitationCount.intValue];
        }else if ([NoticeTools getLocalType] == 2){
            self.numberL.text = [NSString stringWithFormat:@"%d 投稿",self.numberModel.invitationCount.intValue];
        }else{
            self.numberL.text = [NSString stringWithFormat:@"今日新增%d个帖子",self.numberModel.invitationCount.intValue];
        }
    }else if (index == 2){
        self.backView.frame = CGRectMake(10, 0, DR_SCREEN_WIDTH-90, (DR_SCREEN_WIDTH-90)*135/285);
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#C481FF"];
        self.titleL.text = [NoticeTools getLocalStrWith:@"py.py"];
        
        if([NoticeTools getLocalType] == 1){
            self.numberL.text = [NSString stringWithFormat:@"%d New",self.numberModel.dubbingCount.intValue];
        }else if ([NoticeTools getLocalType] == 2){
            self.numberL.text = [NSString stringWithFormat:@"%d 吹き替え音",self.numberModel.dubbingCount.intValue];
        }else{
            self.numberL.text = [NSString stringWithFormat:@"今日新增%d条配音",self.numberModel.dubbingCount.intValue];
        }
    }else if (index == 3){
        self.backView.frame = CGRectMake(10, 0, DR_SCREEN_WIDTH-90, (DR_SCREEN_WIDTH-90)*135/285);
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#CFEF49"];
        self.titleL.text = [NoticeTools getLocalStrWith:@"message.artcle"];
        self.numberL.text = self.numberModel.existNewHtml.intValue? [NoticeTools chinese:@"有新文章" english:@"New" japan:@"新しい"] : @"";
    }else{
        self.backView.frame = CGRectMake(10, 0, DR_SCREEN_WIDTH-90, 80);
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        self.titleL.text = [NoticeTools chinese:@"新手指南" english:@"Guide" japan:@"ガイド"];
        self.numberL.text = @"";
    }
    self.titleL.textColor = [UIColor colorWithHexString:index == 4?@"#FFFFFF": @"#25262E"];
    NSString *imgName = [NSString stringWithFormat:@"popmenu_listimg%ld",index];
    self.titleImageView.image = UIImageNamed(imgName);
    self.titleL.frame = CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height);
    [self.backView setAllCorner:15];
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

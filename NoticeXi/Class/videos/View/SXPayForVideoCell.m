//
//  SXPayForVideoCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPayForVideoCell.h"

@implementation SXPayForVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-20, (DR_SCREEN_WIDTH-20)/355*232)];
        [self.contentView addSubview:self.coverImageView];
        self.coverImageView.image = UIImageNamed(@"sxpayvideocover_img");
        self.coverImageView.userInteractionEnabled = YES;
        
        CGFloat orignX = self.coverImageView.frame.size.width*139/355;
        CGFloat orginY = self.coverImageView.frame.size.height*82/232;
        CGFloat numHeight = self.coverImageView.frame.size.height-orginY-35;
        CGFloat space = (numHeight-80)/3;
        if (space > 8) {
            space = 8;
        }
        
        self.label1 = [[UILabel  alloc] initWithFrame:CGRectMake(orignX, orginY, self.coverImageView.frame.size.width-orignX-5, 20)];
        self.label1.font = XGTHREEBoldFontSize;
        self.label1.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.coverImageView addSubview:self.label1];
        self.label1.hidden = YES;
        
        self.label2 = [[UILabel  alloc] initWithFrame:CGRectMake(orignX, CGRectGetMaxY(self.label1.frame)+space, self.coverImageView.frame.size.width-orignX-5, 20)];
        self.label2.font = XGTHREEBoldFontSize;
        self.label2.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.coverImageView addSubview:self.label2];
        self.label2.hidden = YES;
        
        self.label3 = [[UILabel  alloc] initWithFrame:CGRectMake(orignX, CGRectGetMaxY(self.label2.frame)+space, self.coverImageView.frame.size.width-orignX-5, 20)];
        self.label3.font = XGTHREEBoldFontSize;
        self.label3.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.coverImageView addSubview:self.label3];
        self.label3.hidden = YES;
        
        self.label4 = [[UILabel  alloc] initWithFrame:CGRectMake(orignX, CGRectGetMaxY(self.label3.frame)+space, self.coverImageView.frame.size.width-orignX-5, 20)];
        self.label4.font = XGTHREEBoldFontSize;
        self.label4.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.coverImageView addSubview:self.label4];
        self.label4.hidden = YES;
        
        self.label5 = [[UILabel  alloc] initWithFrame:CGRectMake(orignX, self.coverImageView.frame.size.height-32, self.coverImageView.frame.size.width-orignX-5, 17)];
        self.label5.font = TWOTEXTFONTSIZE;
        self.label5.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.coverImageView addSubview:self.label5];
        
        self.buyNumL = [[UILabel  alloc] initWithFrame:CGRectMake(self.coverImageView.frame.size.width-165, self.coverImageView.frame.size.height-32, 150, 17)];
        self.buyNumL.font = TWOTEXTFONTSIZE;
        self.buyNumL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        self.buyNumL.textAlignment = NSTextAlignmentRight;
        [self.coverImageView addSubview:self.buyNumL];
    }
    return self;
}

- (void)setModel:(SXPayForVideoModel *)model{
    _model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    self.label1.hidden = YES;
    self.label2.hidden = YES;
    self.label3.hidden = YES;
    self.label4.hidden = YES;
    
    if (model.videosArr.count) {
        for (int i = 0; i < model.videosArr.count; i++) {
            SXVideosModel *video = model.videosArr[i];
            if (i == 0) {
                self.label1.hidden = NO;
                self.label1.text = video.title;
            }else if ( i == 1){
                self.label2.hidden = NO;
                self.label2.text = video.title;
            }else if ( i == 2){
                self.label3.hidden = NO;
                self.label3.text = video.title;
            }else if ( i == 3){
                self.label4.hidden = NO;
                self.label4.text = video.title;
            }
        }
    }
    self.buyNumL.text = [NSString stringWithFormat:@"%d人已报名",model.buy_users_num.intValue];
    self.label5.text = [NSString stringWithFormat:@"共%@课时",model.episodes];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

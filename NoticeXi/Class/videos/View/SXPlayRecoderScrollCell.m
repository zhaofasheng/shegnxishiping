//
//  SXPlayRecoderScrollCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/24.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXPlayRecoderScrollCell.h"

@implementation SXPlayRecoderScrollCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = self.backgroundColor;
        

        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 0, 75, 100)];
        [self.coverImageView setAllCorner:4];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImageView];
        
   
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,104,75, 17)];
        _titleL.font = TWOTEXTFONTSIZE;
        _titleL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.contentView addSubview:_titleL];
        
   
    }
    return self;
}

- (void)setVideoModel:(SXVideosModel *)videoModel{
    _videoModel = videoModel;
    if (videoModel.searModel) {
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.searModel.simple_cover_url]];
    }else{
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.video_cover_url]];
    }
    self.titleL.text = videoModel.title;
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

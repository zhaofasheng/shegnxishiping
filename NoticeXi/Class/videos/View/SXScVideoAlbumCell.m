//
//  SXScVideoAlbumCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/23.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXScVideoAlbumCell.h"

@implementation SXScVideoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-30, 100)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.backView setAllCorner:10];
        [self.contentView addSubview:self.backView];
        
        self.coverImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 10, 60, 80)];
        self.coverImageView.layer.cornerRadius = 4;
        self.coverImageView.layer.masksToBounds = YES;
        self.coverImageView.clipsToBounds = YES;
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView addSubview:self.coverImageView];
        
        self.fgView = [[UIView  alloc] initWithFrame:self.coverImageView.bounds];
        self.fgView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.coverImageView addSubview:self.fgView];
        
        self.albumL = [[UILabel  alloc] initWithFrame:CGRectMake(80, 23, DR_SCREEN_WIDTH-30-85, 22)];
        self.albumL.font = SIXTEENTEXTFONTSIZE;
        self.albumL.textColor = [UIColor colorWithHexString:@"#14151A"];
  
        [self.backView addSubview:self.albumL];
        
        self.numL = [[UILabel  alloc] initWithFrame:CGRectMake(80,57, DR_SCREEN_WIDTH-30-85, 22)];
        self.numL.font = FOURTHTEENTEXTFONTSIZE;
        self.numL.textColor = [UIColor colorWithHexString:@"#5C5F66"];

        [self.backView addSubview:self.numL];
    }
    return self;
}

- (void)setZjModel:(SXVideoZjModel *)zjModel{
    _zjModel = zjModel;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:zjModel.ablum_img]];
    self.albumL.text = zjModel.ablum_name;
    self.numL.text = [NSString stringWithFormat:@"%d个视频",zjModel.video_num.intValue];
    self.fgView.hidden = zjModel.ablum_img.length > 10?YES:NO;
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

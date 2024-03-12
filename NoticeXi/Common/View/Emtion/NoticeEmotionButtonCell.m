//
//  NoticeEmotionButtonCell.m
//  NoticeXi
//
//  Created by li lei on 2023/8/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeEmotionButtonCell.h"

@implementation NoticeEmotionButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [tapView setAllCorner:20];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageV.userInteractionEnabled = YES;
        tapView.userInteractionEnabled = YES;
        [tapView addSubview:imageV];
        self.tapView  = tapView;
        self.choiceImageView = imageV;
        
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.backgroundColor = self.contentView.backgroundColor;
        
        [self.contentView addSubview:self.tapView];
    }
    return self;
}

- (void)setButtonModel:(NoticeEmotionModel *)buttonModel{
    _buttonModel = buttonModel;
    
    if(buttonModel.localImg){
        self.choiceImageView.image = UIImageNamed(buttonModel.localImg);
    }else{
        SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
        [self.choiceImageView sd_setImageWithURL:[NSURL URLWithString:buttonModel.icon_url] placeholderImage:nil options:newOptions completed:nil];
 
    }
    self.tapView.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:buttonModel.isChoice?1:0];
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

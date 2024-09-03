//
//  SXShopSayDetailCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/9/2.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayDetailCell.h"

@implementation SXShopSayDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backcontentView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 0)];
     
        [self addSubview:self.backcontentView];
        self.backcontentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 36, 36)];
        [self.iconImageView setAllCorner:18];
        self.iconImageView.userInteractionEnabled = YES;
        [self.backcontentView addSubview:self.iconImageView];

        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(44, 22, DR_SCREEN_WIDTH-150, 22)];
        self.shopNameL.font = XGSIXBoldFontSize;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backcontentView addSubview:self.shopNameL];
        self.shopNameL.text = @"店铺名称";
        
        self.funView = [[UIView  alloc] initWithFrame:CGRectMake(0, self.backcontentView.frame.size.height-60, self.backcontentView.frame.size.width, 60)];
        [self.backcontentView addSubview:self.funView];
        
        UIView *line = [[UIView  alloc] initWithFrame:CGRectMake(0, 59, DR_SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [self.funView addSubview:line];
        
        self.timeL = [[UILabel  alloc] initWithFrame:CGRectMake(self.backcontentView.frame.size.width-100, 0, 100, 60)];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.timeL.textAlignment = NSTextAlignmentRight;
     
        [self.funView addSubview:self.timeL];
    }
    return self;
}

- (void)setModel:(SXShopSayListModel *)model{
    _model = model;
    [self refreshRemove];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.shopModel.shop_avatar_url]];
    self.shopNameL.text = model.shopModel.shop_name;
    self.shopNameL.frame = CGRectMake(44, 22, GET_STRWIDTH(model.shopModel.shop_name, 17, 22), 22);
    self.timeL.text = model.created_atTime;
    //是否有认证
    if (model.shopModel.is_certified.boolValue) {//认证过
        self.markImageView.hidden = NO;
    }
    
    //是否有性别
    if (model.shopModel.sex.intValue) {
        self.sexImageView.hidden = NO;
        if (model.shopModel.is_certified.boolValue) {
            self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.markImageView.frame), 25, 16, 16);
        }else{
            self.sexImageView.frame = CGRectMake(CGRectGetMaxX(self.shopNameL.frame), 25, 16, 16);
        }
        self.sexImageView.image = model.shopModel.sex.intValue == 1? UIImageNamed(@"sx_shop_male") : UIImageNamed(@"sx_shop_fale");//sx_shop_fale女
    }
    
    
    //是否有文案
    if (model.contentHeight > 0 && model.content) {
        self.contentL.hidden = NO;
        self.contentL.attributedText = model.attStr;
        self.contentL.frame = CGRectMake(0, 66, DR_SCREEN_WIDTH-30, model.longcontentHeight);
    }
    
    //是否存在图片
    if (model.hasImageV) {
        if (model.img_list.count) {
            self.sayImageView1.hidden = NO;
            self.sayImageView1.frame = CGRectMake(0, 66+self.model.longcontentHeight+10, self.imageHeight, self.imageHeight);
            [self.sayImageView1 sd_setImageWithURL:[NSURL URLWithString:model.img_list[0]]];
        }
        if (model.img_list.count >= 2) {
            self.sayImageView2.hidden = NO;
            self.sayImageView2.frame = CGRectMake(CGRectGetMaxX(self.sayImageView1.frame)+5, 66+self.model.longcontentHeight+10, self.imageHeight, self.imageHeight);
            [self.sayImageView2 sd_setImageWithURL:[NSURL URLWithString:model.img_list[1]]];
        }
        if (model.img_list.count >= 3) {
            self.sayImageView3.hidden = NO;
            self.sayImageView3.frame = CGRectMake(CGRectGetMaxX(self.sayImageView2.frame)+5, 66+self.model.longcontentHeight+10, self.imageHeight, self.imageHeight);
            [self.sayImageView3 sd_setImageWithURL:[NSURL URLWithString:model.img_list[2]]];
        }
    }
    
    if (model.shopModel.recommend_num.intValue) {
        self.tuijianImageV.hidden = NO;
        self.tuijianL.hidden = NO;
        if (model.shopModel.is_recommend.boolValue) {//自己推荐过
            if ((model.shopModel.recommend_num.intValue - 1) > 0) {
                self.tuijianL.text = [NSString stringWithFormat:@"我和%d人推荐此店铺",model.shopModel.recommend_num.intValue-1];
            }else{
                self.tuijianL.text = @"我推荐此店铺";
            }
        }else{
            self.tuijianL.text = [NSString stringWithFormat:@"%d人推荐此店铺",model.shopModel.recommend_num.intValue];
        }
    }
    

    self.backcontentView.frame = CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 66+60+(model.hasImageV?(self.imageHeight+10):0)+model.longcontentHeight);
    self.funView.frame = CGRectMake(0, self.backcontentView.frame.size.height-60, self.backcontentView.frame.size.width, 60);
}

- (UIImageView *)tuijianImageV{
    if (!_tuijianImageV) {
        _tuijianImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 18, 24, 24)];
        _tuijianImageV.image = UIImageNamed(@"sxshopsaybetui_img");
        [self.funView addSubview:_tuijianImageV];
    }
    return _tuijianImageV;
}

- (void)refreshRemove{
    _markImageView.hidden = YES;
    _sexImageView.hidden = YES;
    _contentL.hidden = YES;
    _sayImageView1.hidden = YES;
    _tuijianImageV.hidden = YES;
    _tuijianL.hidden = YES;
}


- (UILabel *)tuijianL{
    if (!_tuijianL) {
        _tuijianL = [[UILabel  alloc] initWithFrame:CGRectMake(24, 21, 120, 18)];
        _tuijianL.font = THRETEENTEXTFONTSIZE;
        _tuijianL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _tuijianL.text = @"120人推荐此店铺";
        [self.funView addSubview:_tuijianL];
    }
    return _tuijianL;
}

- (UIImageView *)markImageView{
    if (!_markImageView) {
        _markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxY(self.shopNameL.frame), 25, 16, 16)];
        _markImageView.image = UIImageNamed(@"sxrenztub_img");
        [self.backcontentView addSubview:_markImageView];
    }
    return _markImageView;
}
- (UIImageView *)sexImageView{
    if (!_sexImageView) {
        _sexImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shopNameL.frame)+2, 25,16, 16)];
        _sexImageView.image = UIImageNamed(@"sx_shop_male");//sx_shop_fale女
        [self.backcontentView addSubview:_sexImageView];
    }
    return _sexImageView;
}

- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 66, DR_SCREEN_WIDTH-50, 0)];
        _contentL.numberOfLines = 0;
        _contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _contentL.font = FIFTHTEENTEXTFONTSIZE;
        [self.backcontentView addSubview:_contentL];
    }
    return _contentL;
}

- (UIImageView *)sayImageView1{
    if (!_sayImageView1) {
        _sayImageView1 = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 66+self.model.longcontentHeight+10, self.imageHeight, self.imageHeight)];
        _sayImageView1.layer.cornerRadius = 4;
        _sayImageView1.layer.masksToBounds = YES;
        _sayImageView1.contentMode = UIViewContentModeScaleAspectFill;
        _sayImageView1.clipsToBounds = YES;
        [self.backcontentView addSubview:_sayImageView1];
        _sayImageView1.userInteractionEnabled = YES;
        _sayImageView1.tag = 0;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
        [_sayImageView1 addGestureRecognizer:tap1];
    }
    return _sayImageView1;
}

- (UIImageView *)sayImageView2{
    if (!_sayImageView2) {
        _sayImageView2 = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sayImageView1.frame)+5, 66+self.model.longcontentHeight+10, self.imageHeight, self.imageHeight)];
        _sayImageView2.layer.cornerRadius = 4;
        _sayImageView2.layer.masksToBounds = YES;
        _sayImageView2.contentMode = UIViewContentModeScaleAspectFill;
        _sayImageView2.clipsToBounds = YES;
        [self.backcontentView addSubview:_sayImageView2];
        _sayImageView2.userInteractionEnabled = YES;
        _sayImageView2.tag = 1;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
        [_sayImageView2 addGestureRecognizer:tap1];
    }
    return _sayImageView2;
}

- (UIImageView *)sayImageView3{
    if (!_sayImageView3) {
        _sayImageView3 = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sayImageView2.frame)+5, 66+self.model.longcontentHeight+10, self.imageHeight, self.imageHeight)];
        _sayImageView3.layer.cornerRadius = 4;
        _sayImageView3.layer.masksToBounds = YES;
        _sayImageView3.contentMode = UIViewContentModeScaleAspectFill;
        _sayImageView3.clipsToBounds = YES;
        [self.backcontentView addSubview:_sayImageView3];
        _sayImageView3.userInteractionEnabled = YES;
        _sayImageView3.tag = 2;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
        [_sayImageView3 addGestureRecognizer:tap1];
    }
    return _sayImageView3;
}


- (void)imgTap:(UITapGestureRecognizer *)tap{
    UIImageView *imageV = (UIImageView *)tap.view;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.model.img_list.count; i++) {
        NSArray *array = [self.model.img_list[i] componentsSeparatedByString:@"?"];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        if (i == 0) {
            item.thumbView = self.sayImageView1;
        }else if (i == 1){
            item.thumbView = self.sayImageView2;
        }else{
            item.thumbView = self.sayImageView3;
        }
        item.largeImageURL     = [NSURL URLWithString:array[0]];
        [photos addObject:item];
    }
 
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:photos];
    UIView *toView         = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view presentFromImageView:imageV
                   toContainer:toView
                      animated:YES completion:nil];
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

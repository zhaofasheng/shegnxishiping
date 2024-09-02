//
//  SXShopSayCell.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopSayCell.h"
#import "SXShopSayDetailController.h"
@implementation SXShopSayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = self.backgroundColor;
        
        self.backcontentView = [[UIView  alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-20, 0)];
        self.backcontentView.layer.cornerRadius = 10;
        self.backcontentView.layer.masksToBounds = YES;
        [self addSubview:self.backcontentView];
        self.backcontentView.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 36, 36)];
        [self.iconImageView setAllCorner:18];
        self.iconImageView.userInteractionEnabled = YES;
        [self.backcontentView addSubview:self.iconImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconTap)];
        [self.iconImageView addGestureRecognizer:tap];
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(59, 22, DR_SCREEN_WIDTH-150, 22)];
        self.shopNameL.font = XGSIXBoldFontSize;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backcontentView addSubview:self.shopNameL];
        self.shopNameL.text = @"店铺名称";
        
        self.funView = [[UIView  alloc] initWithFrame:CGRectMake(0, self.backcontentView.frame.size.height-60, self.backcontentView.frame.size.width, 60)];
        [self.backcontentView addSubview:self.funView];
        
        _comNumL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        _comNumL.font = TWOTEXTFONTSIZE;
        _comNumL.text = @"评论";
        _comNumL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.funView addSubview:_comNumL];
        _comNumL.userInteractionEnabled = YES;
        UITapGestureRecognizer *comTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comClick)];
        [_comNumL addGestureRecognizer:comTap];
        
        self.comImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(_comNumL.frame.origin.x-22, 0, 20, 20)];
        self.comImageView.userInteractionEnabled = YES;
        self.comImageView.image = UIImageNamed(@"sx_com_markimg");
        [self.funView addSubview:self.comImageView];
        UITapGestureRecognizer *comTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comClick)];
        [_comImageView addGestureRecognizer:comTap1];
        
        _likeL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
        _likeL.font = TWOTEXTFONTSIZE;
        _likeL.text = @"点赞";
        _likeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.funView addSubview:_likeL];
        _likeL.userInteractionEnabled = YES;
        UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [_likeL addGestureRecognizer:likeTap];
        
        self.likeImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(self.likeL.frame.origin.x-22, 0, 20, 20)];
        self.likeImageView.userInteractionEnabled = YES;
        self.likeImageView.image = UIImageNamed(@"sx_like_noimgs");
        [self.funView addSubview:self.likeImageView];
        UITapGestureRecognizer *likeTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeClick)];
        [self.likeImageView addGestureRecognizer:likeTap1];
    }
    return self;
}

- (void)setModel:(SXShopSayListModel *)model{
    _model = model;
    [self refreshRemove];
    
    //是否有认证
    
    //是否有性别
    
    //是否有文案
    if (model.contentHeight > 0 && model.content) {
        self.contentL.hidden = NO;
        self.contentL.attributedText = model.attStr;
        self.contentL.frame = CGRectMake(15, 66, DR_SCREEN_WIDTH-50, model.contentHeight);
        self.contentL.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    //是否存在图片
    if (model.hasImageV) {
        
    }
    
    //是否有人推荐
    self.tuijianImageV.hidden = NO;
    self.tuijianL.hidden = NO;
    
    //点赞评论数量
    //UIImageNamed(@"sx_like_imgs");UIImageNamed(@"sx_like_noimgs");
    self.likeL.frame = CGRectMake(self.backcontentView.frame.size.width-15-GET_STRWIDTH(self.likeL.text, 12, 60), 0, GET_STRWIDTH(self.likeL.text, 12, 60), 60);
    self.likeImageView.frame = CGRectMake(self.likeL.frame.origin.x-22, 20, 20, 20);
    
    self.comNumL.frame = CGRectMake(self.likeImageView.frame.origin.x-22-GET_STRWIDTH(self.comNumL.text, 12, 60), 0, GET_STRWIDTH(self.comNumL.text, 12, 60), 60);
    self.comImageView.frame = CGRectMake(self.comNumL.frame.origin.x-22, 20, 20, 20);
    
    self.backcontentView.frame = CGRectMake(10, 10, DR_SCREEN_WIDTH-20, 66+60+(model.hasImageV?(self.imageHeight+10):0)+model.contentHeight);
    self.funView.frame = CGRectMake(0, self.backcontentView.frame.size.height-60, self.backcontentView.frame.size.width, 60);
}

- (void)iconTap{
    
}

- (void)likeClick{
    
}

- (void)comClick{
    SXShopSayDetailController *ctl = [[SXShopSayDetailController alloc] init];
    ctl.model = self.model;
    ctl.needUpCom = YES;
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (UIImageView *)tuijianImageV{
    if (!_tuijianImageV) {
        _tuijianImageV = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 18, 24, 24)];
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
    _sayImageView2.hidden = YES;
    _sayImageView3.hidden = YES;
    _tuijianImageV.hidden = YES;
    _tuijianL.hidden = YES;
}

- (UIImageView *)markImageView{
    if (!_markImageView) {
        _markImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxY(self.shopNameL.frame), 25, 16, 16)];
        _markImageView.image = UIImageNamed(@"sxrenztub_img");
        [self.backcontentView addSubview:_markImageView];
    }
    return _markImageView;
}

- (UILabel *)tuijianL{
    if (!_tuijianL) {
        _tuijianL = [[UILabel  alloc] initWithFrame:CGRectMake(39, 21, 120, 18)];
        _tuijianL.font = THRETEENTEXTFONTSIZE;
        _tuijianL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        _tuijianL.text = @"120人推荐此店铺";
        [self.funView addSubview:_tuijianL];
    }
    return _tuijianL;
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
        _contentL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 66, DR_SCREEN_WIDTH-50, 0)];
        _contentL.numberOfLines = 0;
        _contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        _contentL.font = FIFTHTEENTEXTFONTSIZE;
        [self.backcontentView addSubview:_contentL];
    }
    return _contentL;
}

- (UIImageView *)sayImageView1{
    if (!_sayImageView1) {
        _sayImageView1 = [[UIImageView  alloc] initWithFrame:CGRectMake(15, 66+self.model.contentHeight+10, self.imageHeight, self.imageHeight)];
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
        _sayImageView2 = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sayImageView1.frame)+5, 66+self.model.contentHeight+10, self.imageHeight, self.imageHeight)];
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
        _sayImageView3 = [[UIImageView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sayImageView2.frame)+5, 66+self.model.contentHeight+10, self.imageHeight, self.imageHeight)];
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

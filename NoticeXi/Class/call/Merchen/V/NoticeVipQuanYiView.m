//
//  NoticeVipQuanYiView.m
//  NoticeXi
//
//  Created by li lei on 2023/8/31.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipQuanYiView.h"
#import "NoticeVipImageLabelView.h"
#import "NoticeVipIdentifyCell.h"
@interface NoticeVipQuanYiView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *markL;
@property (nonatomic, strong) NSArray *textArr;
@property (nonatomic, strong) NSMutableArray *identArr;
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UIView *skinView;
@end

@implementation NoticeVipQuanYiView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0,GET_STRWIDTH(@"已解锁 0项 权益", 16, 22)+5, 22)];
        self.titleL.font = SIXTEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.titleL];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleL.frame)+4,3 ,self.frame.size.width-20-self.titleL.frame.size.width-4, 17)];
        self.markL.font = TWOTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:self.markL];
        self.markL.text = [NoticeTools chinese:@"升级至Lv1可解锁6项特权" english:@"6 rights at lv1" japan:@"Lv1に6つの特典"];
        self.markL.hidden = YES;
        
        self.buttonArr = [[NSMutableArray alloc] init];
        CGFloat width = (DR_SCREEN_WIDTH-85)/4;
        CGFloat space = width+15;
        self.textArr = @[[NoticeTools chinese:@"身份标识" english:@"Icon" japan:@"アイコン"],[NoticeTools chinese:@"背景换肤" english:@"Wallpaper" japan:@"壁紙"],[NoticeTools chinese:@"背景音乐" english:@"BGM" japan:@"BGM"],[NoticeTools chinese:@"下载音频" english:@"Download" japan:@"チャット"],[NoticeTools chinese:@"录音变声" english:@"Edit" japan:@"音声変更"],[NoticeTools chinese:@"VIP群聊" english:@"Chat" japan:@"VIP群聊"],[NoticeTools chinese:@"点亮声昔" english:@"Our Thanks" japan:@"私たちの感謝"],[NoticeTools chinese:@"点亮声昔" english:@"Our Thanks" japan:@"私たちの感謝"]];
        for (int i = 0; i < 8; i++) {
            NoticeVipImageLabelView *imageView = [[NoticeVipImageLabelView alloc] initWithFrame:CGRectMake(20+(i<4?(i*space):(i-4)*space), CGRectGetMaxY(self.titleL.frame)+(i < 4 ? 15 : (space+15)), width, width)];
            imageView.label.text = self.textArr[i];
            [self addSubview:imageView];
            [self.buttonArr addObject:imageView];

        }
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleL.frame)+space*2+24, DR_SCREEN_WIDTH-40, 60)];
        [buttonView setAllCorner:8];
        buttonView.backgroundColor = [UIColor whiteColor];
        [self addSubview:buttonView];
        
        for (int i = 0; i < 2; i++) {
            FSCustomButton *funBtn = [[FSCustomButton alloc] initWithFrame:CGRectMake(buttonView.frame.size.width/2*i, 0, buttonView.frame.size.width/2, 60)];
            funBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [funBtn setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            [funBtn setTitle:i==0?[NoticeTools chinese:@"给好友升级" english:@"Gift" japan:@"贈り"]:[NoticeTools chinese:@"兑换发电值"  english:@"Redeem" japan:@"交換"]forState:UIControlStateNormal];
            funBtn.tag = i;
            [funBtn setImage:UIImageNamed(i==0?@"sendfriend_hart_img":@"change_power_img") forState:UIControlStateNormal];
            [funBtn addTarget:self action:@selector(funClick:) forControlEvents:UIControlEventTouchUpInside];
            funBtn.buttonImagePosition = FSCustomButtonImagePositionLeft;
            [buttonView addSubview:funBtn];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((buttonView.frame.size.width-1)/2, (60-16)/2, 1, 16)];
        line.backgroundColor = [UIColor colorWithHexString:@"#979797"];
        [buttonView addSubview:line];
        
        self.userM = [NoticeSaveModel getUserInfo];
        
        UILabel *titleL1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(buttonView.frame)+30,DR_SCREEN_WIDTH-20, 22)];
        titleL1.font = SIXTEENTEXTFONTSIZE;
        titleL1.text = [NoticeTools chinese:@"身份标识" english:@"Icon" japan:@"アイコン"];
        titleL1.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:titleL1];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(0,CGRectGetMaxY(titleL1.frame)+15,DR_SCREEN_WIDTH-20, 107);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.movieTableView.showsHorizontalScrollIndicator = NO;
        self.movieTableView.showsVerticalScrollIndicator = NO;
        [self.movieTableView registerClass:[NoticeVipIdentifyCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 108;
        [self addSubview:self.movieTableView];

        self.skinView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.movieTableView.frame)+24, DR_SCREEN_WIDTH, 222)];
        [self addSubview:self.skinView];
        
        UILabel *titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(20,0,DR_SCREEN_WIDTH-20, 22)];
        titleL2.font = SIXTEENTEXTFONTSIZE;
        titleL2.text = [NoticeTools chinese:@"背景换肤" english:@"Wallpaper" japan:@"壁紙"];
        titleL2.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.skinView addSubview:titleL2];
        
        CGFloat skinWidth = (DR_SCREEN_WIDTH-70)/3;
        NSArray *arr = @[[NoticeTools chinese:@"默认皮肤" english:@"Default" japan:@"デフォルト"],[NoticeTools chinese:@"自定义皮肤" english:@"Choose Photo" japan:@"カスタム"],[NoticeTools chinese:@"声昔专属" english:@"From Us" japan:@"私たちから"]];
        NSArray *imgArr = @[@"defaultImage_skin",@"cusoutm_skin",@"onlyyou_skin"];
        for (int i = 0; i < 3; i++) {
            UIButton *skinBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+(skinWidth+15)*i, CGRectGetMaxY(titleL2.frame)+15, skinWidth, 150)];
            skinBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
            [skinBtn setTitle:arr[i] forState:UIControlStateNormal];
            [skinBtn setBackgroundImage:UIImageNamed(imgArr[i]) forState:UIControlStateNormal];
            [skinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            skinBtn.tag = i;
            [skinBtn addTarget:self action:@selector(skinClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.skinView addSubview:skinBtn];
        }
    }
    return self;
}

- (void)setNoSkinBlock:(BOOL)noSkinBlock{
    _noSkinBlock = noSkinBlock;
    self.skinView.hidden = noSkinBlock?YES:NO;
}

- (void)skinClick:(UIButton *)btn{
    if(self.skinBlock){
        self.skinBlock(btn.tag);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVipIdentifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.transform=CGAffineTransformMakeRotation(M_PI / 2);
    cell.index = indexPath.row;
    return cell;
}

- (void)setUserM:(NoticeUserInfoModel *)userM{
    _userM = userM;
 
    NSString *numLimit = @"0";
    if (userM.isSendVip) {//如果是体验版会员
        self.markL.hidden = NO;
        numLimit = @"5";
        for (int i = 0; i < self.buttonArr.count; i++) {
            NoticeVipImageLabelView *imageView = self.buttonArr[i];
            imageView.label.text = self.textArr[i];
            if(i < 5){
                NSString *imgName = [NSString stringWithFormat:@"quanyi_imgy_%d",i];
                imageView.image = UIImageNamed(imgName);
                imageView.label.textColor = [UIColor colorWithHexString:@"#25262E"];
            }else{
                NSString *imgName = [NSString stringWithFormat:@"quanyi_imgn_%d",i];
                imageView.image = UIImageNamed(imgName);
                imageView.label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
            }
            
            if(i == 7){
                imageView.hidden = YES;
            }
        }
    }else{
        if(userM.level.intValue){
            self.markL.hidden = YES;
            numLimit = @"6";
            for (int i = 0; i < self.buttonArr.count; i++) {
                NoticeVipImageLabelView *imageView = self.buttonArr[i];
                imageView.label.text = self.textArr[i];
                if(i < 7){
                    NSString *imgName = [NSString stringWithFormat:@"quanyi_imgy_%d",i];
                    imageView.image = UIImageNamed(imgName);
                    imageView.label.textColor = [UIColor colorWithHexString:@"#25262E"];
                }else{
                    imageView.image = UIImageNamed(@"quanyi_imgn_6");
                    imageView.label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
                }
                if(i == 6){
                    if([NoticeTools getLocalType] == 1){
                        imageView.label.text = [NSString stringWithFormat:@"Thanks %@",userM.level];
                    }else if ([NoticeTools getLocalType]==2){
                        imageView.label.text = [NSString stringWithFormat:@"%@回の感謝",userM.level];
                    }else{
                        imageView.label.text = [NSString stringWithFormat:@"点亮%@次",userM.level];
                    }
                }
                if(i == 7){
                    if([NoticeTools getLocalType] == 1){
                        imageView.label.text = [NSString stringWithFormat:@"Thanks %d",userM.level.intValue+1];
                    }else if ([NoticeTools getLocalType]==2){
                        imageView.label.text = [NSString stringWithFormat:@"%d回の感謝",userM.level.intValue+1];
                    }else{
                        imageView.label.text = [NSString stringWithFormat:@"点亮%d次",userM.level.intValue+1];
                    }
                }
            }
        }else{
            self.markL.hidden = NO;
            numLimit = @"0";
            for (int i = 0; i < self.buttonArr.count; i++) {
                NoticeVipImageLabelView *imageView = self.buttonArr[i];
                NSString *imgName = [NSString stringWithFormat:@"quanyi_imgn_%d",i];
                imageView.image = UIImageNamed(imgName);
                imageView.label.textColor = [UIColor colorWithHexString:@"#25262E"];
                
                if(i == 7){
                    imageView.hidden = YES;
                }
            }
        }
    }
    
    if([NoticeTools getLocalType] == 1){
        self.titleL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ Gift",numLimit] setColor:[UIColor colorWithHexString:@"#00ABE4"] setLengthString:numLimit beginSize:0];
    }else if ([NoticeTools getLocalType] == 2){
        self.titleL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@ 特典",numLimit] setColor:[UIColor colorWithHexString:@"#00ABE4"] setLengthString:numLimit beginSize:0];
    }else{
        NSString *str = [NSString stringWithFormat:@"已解锁 %@项 权益",numLimit];
        self.titleL.attributedText = [DDHAttributedMode setColorString:str setColor:[UIColor colorWithHexString:@"#00ABE4"] setLengthString:@"0项" beginSize:4];
    }
}

- (void)funClick:(FSCustomButton *)btn{
    if(self.FunBlock){
        self.FunBlock(btn.tag);
    }
}

@end

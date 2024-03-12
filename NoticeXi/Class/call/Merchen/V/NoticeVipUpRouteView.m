//
//  NoticeVipUpRouteView.m
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipUpRouteView.h"
#import "NoticeVipUpRouteCell.h"
#import "NoticeVipUpRuleController.h"
@interface NoticeVipUpRouteView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *movieTableView;
@property (nonatomic, strong) UILabel *myNumberL;
@property (nonatomic, strong) UILabel *nextNumberL;
@property (nonatomic, strong) UILabel *needNumberL;
@property (nonatomic, strong) UIView *prossView;
@property (nonatomic, strong) UIView *prossView1;
@property (nonatomic, strong) UILabel *todayNumberL;
@property (nonatomic, strong) NSMutableArray *cardArr;
@property (nonatomic, strong) NoticeVipDataModel *vipModel;
@end

@implementation NoticeVipUpRouteView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        self.userInteractionEnabled = YES;
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, DR_SCREEN_WIDTH-20, (DR_SCREEN_WIDTH-20)/335*137)];
        imageView1.image = UIImageNamed(@"vipRouteimg1");
        [self addSubview:imageView1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 31,imageView1.frame.size.width-30-70, 16)];
        label.text = [NoticeTools chinese:@"我的贡献值" english:@"My Points" japan:@"私の貢献ポイント"];
        label.font = ELEVENTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [imageView1 addSubview:label];
        
        self.myNumberL = [[UILabel alloc] initWithFrame:CGRectMake(30, 46,imageView1.frame.size.width-30-70, 40)];
        self.myNumberL.text = @"0";
        self.myNumberL.font = XGTwentyEigthBoldFontSize;
        self.myNumberL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [imageView1 addSubview:self.myNumberL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, imageView1.frame.size.height-4-30, 235, 4)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [line setAllCorner:2];
        [imageView1 addSubview:line];
        
        self.prossView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 4)];
        self.prossView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [line addSubview:self.prossView];
        
        self.needNumberL = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(line.frame)+4,170, 16)];
        self.needNumberL.font = ELEVENTEXTFONTSIZE;
        self.needNumberL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [imageView1 addSubview:self.needNumberL];
        
        self.nextNumberL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)-60, CGRectGetMaxY(line.frame)+4,60, 16)];
        self.nextNumberL.font = ELEVENTEXTFONTSIZE;
        self.nextNumberL.textAlignment = NSTextAlignmentRight;
        self.nextNumberL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [imageView1 addSubview:self.nextNumberL];
        
        NSString *strAll = [NoticeTools chinese:@"贡献值福利Lv1(体验版)" english:@"Gift Lv1(Limited)" japan:@"特典Lv1(体験版)"];
        NSString *str1 = [NoticeTools chinese:@"贡献值福利" english:@"Gift " japan:@"特典"];;
        NSString *str2 = [NoticeTools chinese:@"Lv1(体验版)" english:@"Lv1(Limited)" japan:@"Lv1(体験版)"];
        UILabel *titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(imageView1.frame)+24,DR_SCREEN_WIDTH-20, 22)];
        titleL2.font = SIXTEENTEXTFONTSIZE;
        titleL2.attributedText = [DDHAttributedMode setString:strAll setSize:12 setLengthString:str2 beginSize:str1.length];
        titleL2.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:titleL2];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(10,CGRectGetMaxY(titleL2.frame)+10,DR_SCREEN_WIDTH-20, 152);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [[UIColor colorWithHexString:@"#1D1E24"] colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.movieTableView.showsHorizontalScrollIndicator = NO;
        
        self.movieTableView.showsVerticalScrollIndicator = NO;
        [self.movieTableView registerClass:[NoticeVipUpRouteCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 126;
        [self addSubview:self.movieTableView];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.movieTableView.frame)+20, DR_SCREEN_WIDTH,115+(DR_SCREEN_WIDTH-20)*327/335)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [backView setAllCorner:20];
        [self addSubview:backView];
        backView.userInteractionEnabled = YES;
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, DR_SCREEN_WIDTH-40, 65)];
        imageView2.image = UIImageNamed(@"vipRouteimg2");
        [backView addSubview:imageView2];
        
        UILabel *titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(15,10,DR_SCREEN_WIDTH-120, 20)];
        titleL3.font = FOURTHTEENTEXTFONTSIZE;
        titleL3.text = [NoticeTools chinese:@"每日贡献值上限" english:@"Daily point limit" japan:@"1日の貢献ポイント制限"];
        titleL3.textColor = [UIColor colorWithHexString:@"#4E918A"];
        [imageView2 addSubview:titleL3];
        
        self.todayNumberL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40-60-15, 10,60, 16)];
        self.todayNumberL.attributedText = [DDHAttributedMode setColorString:@"0/50" setColor:[UIColor colorWithHexString:@"#4E918A"] setLengthString:@"0" beginSize:0];
        self.todayNumberL.font = TWOTEXTFONTSIZE;
        self.todayNumberL.textAlignment = NSTextAlignmentRight;
        self.todayNumberL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [imageView2 addSubview:self.todayNumberL];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, 42, DR_SCREEN_WIDTH-80, 8)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [line1 setAllCorner:2];
        [imageView2 addSubview:line1];
        
        self.prossView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 8)];
        self.prossView1.backgroundColor = [UIColor colorWithHexString:@"#82D2CA"];
        [line1 addSubview:self.prossView1];
        
        UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(imageView2.frame)+10, DR_SCREEN_WIDTH-40, (DR_SCREEN_WIDTH-20)*327/335)];
        imageView3.image = UIImageNamed([NoticeTools chinese:@"vipRouteimg3" english:@"vipRouteimg3en" japan:@"vipRouteimg3ja"]);
        [backView addSubview:imageView3];
        
        UILabel *titleL4 = [[UILabel alloc] initWithFrame:CGRectMake(imageView3.frame.size.width-15-78,15,78, 20)];
        titleL4.font = TWOTEXTFONTSIZE;
        titleL4.text = [NoticeTools chinese:@"规则说明" english:@"Instruction" japan:@"ルールの説明"];
        titleL4.textColor = [UIColor colorWithHexString:@"#25262E"];
        [imageView3 addSubview:titleL4];
        titleL4.textAlignment = NSTextAlignmentRight;
        imageView3.userInteractionEnabled = YES;
        titleL4.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruluTap)];
        [titleL4 addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:@"REFRESHUUSERINFOFORNOTICATION" object:nil];
        [self request];
    }
    return self;
}

- (NSMutableArray *)cardArr{
    if(!_cardArr){
        _cardArr = [[NSMutableArray alloc] init];
    }
    return _cardArr;
}

- (void)request{
    
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"userContributeCard" Accept:@"application/vnd.shengxi.v5.5.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.vipModel = [NoticeVipDataModel mj_objectWithKeyValues:dict[@"data"]];
            self.myNumberL.text = [NSString stringWithFormat:@"%d",self.vipModel.contribute_score.intValue];
            self.nextNumberL.text = [NSString stringWithFormat:@"%d",self.vipModel.card_score.intValue];
            self.needNumberL.text = [NSString stringWithFormat:@"还差%d可领取下一个福利",self.vipModel.distance_score.intValue];
            if([NoticeTools getLocalType] == 1){
                self.needNumberL.text = [NSString stringWithFormat:@"%d points to next",self.vipModel.distance_score.intValue];
            }else if ([NoticeTools getLocalType] == 2){
                self.needNumberL.text = [NSString stringWithFormat:@"次の特典までにまだ %d",self.vipModel.distance_score.intValue];
            }
            self.todayNumberL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%d/50",self.vipModel.day_score.intValue] setColor:[UIColor colorWithHexString:@"#4E918A"] setLengthString:[NSString stringWithFormat:@"%d",self.vipModel.day_score.intValue] beginSize:0];
            
            CGFloat blili1 = self.vipModel.contribute_score.floatValue/self.vipModel.card_score.floatValue;
            self.prossView.frame = CGRectMake(0, 0, 235*blili1, 4);
            
            CGFloat blili2 = self.vipModel.day_score.floatValue/50.0;
            self.prossView1.frame = CGRectMake(0, 0, (DR_SCREEN_WIDTH-80)*blili2, 8);
        }
    } fail:^(NSError * _Nullable error) {
    }];
    
    [self.cardArr removeAllObjects];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"userContributeCard/list" Accept:@"application/vnd.shengxi.v5.5.5+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVipDataModel *model = [NoticeVipDataModel mj_objectWithKeyValues:dic];
                [self.cardArr addObject:model];
            }
            [self.movieTableView reloadData];
        }
    } fail:^(NSError * _Nullable error) {
    }];
}

- (void)ruluTap{
    NoticeVipUpRuleController *ctl = [[NoticeVipUpRuleController alloc] init];
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeVipUpRouteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.transform=CGAffineTransformMakeRotation(M_PI / 2);
    cell.vipModel = self.cardArr[indexPath.row];
    return cell;
}

@end

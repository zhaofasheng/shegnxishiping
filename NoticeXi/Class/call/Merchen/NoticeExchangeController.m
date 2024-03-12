//
//  NoticeExchangeController.m
//  NoticeXi
//
//  Created by li lei on 2021/8/5.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeExchangeController.h"

#import "NoticeRecoderStoryController.h"
#import "NoticeHasOrNoBuyTostView.h"

@interface NoticeExchangeController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *currentNumL;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) UILabel *erroL;
@property (nonatomic, strong) NSString *points;

@property (nonatomic, strong) UILabel *levleL;
@end

@implementation NoticeExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NoticeTools getLocalStrWith:@"zb.duih"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
 
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.navBarView.rightButton.frame = CGRectMake(DR_SCREEN_WIDTH-70-15, STATUS_BAR_HEIGHT, 70, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT);
    [self.navBarView.rightButton setTitle:[NoticeTools getLocalStrWith:@"zb.duihjilu"] forState:UIControlStateNormal];
    [self.navBarView.rightButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    self.navBarView.rightButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [self.navBarView.rightButton addTarget:self action:@selector(storyClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    self.tableView.tableHeaderView = self.headerView;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.tableView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];

    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
}

- (void)storyClick{
    NoticeRecoderStoryController *ctl = [[NoticeRecoderStoryController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(BOOL)isChinese:(NSString *) str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4E00 && a < 0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}

- (void)changeClick{
    
    self.erroL.text = @"";
    if (!self.numField.text.length) {
        self.erroL.text = [NoticeTools getLocalStrWith:@"zb.t1"];
        return;
    }
    if ([self isChinese:self.numField.text]) {
        self.erroL.text = [NoticeTools getLocalStrWith:@"zb.t2"];
        return;
    }
    [self showHUD];
    NSString *str = [NSString stringWithFormat:@"exchangeCode/check?code=%@",self.numField.text];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:str Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:NO needMsg:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            
            __weak typeof(self) weakSelf = self;
            NoticeAbout *aboutM = [NoticeAbout mj_objectWithKeyValues:dict[@"data"]];
            self.points = aboutM.points;
            NSString *str = [NoticeTools getLocalType]?[NSString stringWithFormat:@"%@ EP included, sure to redeem it?",aboutM.points]:[NSString stringWithFormat:@"包含%@点发电值\n确认兑换吗？",aboutM.points];
            XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:str message:nil sureBtn:[NoticeTools getLocalStrWith:@"groupManager.rethink"] cancleBtn:[NoticeTools getLocalStrWith:@"zb.t3"] right:YES];
            alerView.resultIndex = ^(NSInteger index) {
                if (index == 2) {
                    NSMutableDictionary *parm = [NSMutableDictionary new];
                    [parm setObject:weakSelf.numField.text forKey:@"code"];
                    [weakSelf showHUD];
                    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"exchangeCode/convert" Accept:@"application/vnd.shengxi.v5.1.0+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                        if (success) {
                            [weakSelf requestUserInfo];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHUUSERINFOFORNOTICATION" object:nil];
                        }
                        [weakSelf hideHUD];
                    } fail:^(NSError * _Nullable error) {
                        [weakSelf hideHUD];
                    }];
                }
            };
            [alerView showXLAlertView];
        }else{
            self.erroL.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",dict[@"msg"]]];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)requestUserInfo{
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"users/%@",[[NoticeSaveModel getUserInfo] user_id]] Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict1, BOOL success) {
        if (success) {
            NoticeUserInfoModel *userIn = [NoticeUserInfoModel mj_objectWithKeyValues:dict1[@"data"]];
            self.currentNumL.text =[NSString stringWithFormat:@"%ld", userIn.points.integerValue];
            NoticeHasOrNoBuyTostView *tostView = [[NoticeHasOrNoBuyTostView alloc] initWithShowUser:userIn points:self.points];
            [tostView showChoiceView];
        }
        
    } fail:^(NSError *error) {
    }];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 367)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-335)/2, 20,335, 347)];
        backImageView.userInteractionEnabled = YES;
        [_headerView addSubview:backImageView];
        backImageView.image = UIImageNamed(@"Image_bigbackcode");
        
        NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];

                
        self.levleL = [[UILabel alloc] initWithFrame:CGRectMake(30, 40,60, 42)];
        self.levleL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        self.levleL.text = [NSString stringWithFormat:@"%d",userM.points.intValue];
        self.levleL.textAlignment = NSTextAlignmentCenter;
        self.levleL.font = XGTwentyTwoBoldFontSize;
        [backImageView addSubview:_levleL];

        UILabel *markL = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.levleL.frame),120, 17)];
        markL.font = TWOTEXTFONTSIZE;
        markL.textAlignment = NSTextAlignmentCenter;
        markL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        markL.text = [NSString stringWithFormat:@"%@%@",[NoticeTools chinese:@"我的" english:@"My " japan:@"私の"],[NoticeTools getLocalStrWith:@"zb.fdz"]];
        [backImageView addSubview:markL];
        
        self.numField = [[UITextField alloc] initWithFrame:CGRectMake(30, 177, 335-60, 50)];
        self.numField.layer.cornerRadius = 8;
        self.numField.layer.masksToBounds = YES;
        self.numField.keyboardType = UIKeyboardTypeEmailAddress;
        self.numField.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        self.numField.font = FIFTHTEENTEXTFONTSIZE;
        self.numField.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.numField.textAlignment = NSTextAlignmentCenter;
        [backImageView addSubview:self.numField];
        self.numField.delegate = self;
        self.numField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"zb.guakai"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[NoticeTools getLocalType]?10:13],NSForegroundColorAttributeName:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5]}];
        
        self.erroL = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.numField.frame)+4, 335-30, 17)];
        self.erroL.textColor = [UIColor colorWithHexString:@"#DB6E6E"];
        self.erroL.font = TWOTEXTFONTSIZE;
        [backImageView addSubview:self.erroL];
        
        UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.numField.frame)+30, 335-60, 50)];
        changeBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [changeBtn setTitle:[NoticeTools getLocalType]?[NoticeTools getLocalStrWith:@"sure.comgir"]:@"确认兑换" forState:UIControlStateNormal];
        [changeBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        changeBtn.titleLabel.font = XGEightBoldFontSize;
        changeBtn.layer.cornerRadius = 8;
        changeBtn.layer.masksToBounds = YES;
        [backImageView addSubview:changeBtn];
        [changeBtn addTarget:self action:@selector(changeClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _headerView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

@end

//
//  NoticeSendVipCardView.m
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSendVipCardView.h"
#import "NoticeFriendAcdModel.h"
@implementation NoticeSendVipCardView

- (NoticeSureSendUserTostView *)sureView{
    if (!_sureView) {
        _sureView = [[NoticeSureSendUserTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    }
    return _sureView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 303)];
        [self.backView setCornerOnTop:20];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
        self.markL.textColor = [UIColor colorWithHexString:@"#E5749D"];
        self.markL.font = FOURTHTEENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.markL];
        
        self.userInteractionEnabled = YES;
        self.backView.userInteractionEnabled = YES;

        
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-24, 12, 24, 24)];
        [cancelBtn setImage:UIImageNamed(@"Image_blackX") forState:UIControlStateNormal];
        [self.backView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        
    
        UIView *inputBackView = [[UIView alloc] initWithFrame:CGRectMake(15,64, DR_SCREEN_WIDTH-30, 50)];
        inputBackView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        inputBackView.layer.cornerRadius = 8;
        inputBackView.layer.masksToBounds = YES;
        [_backView addSubview:inputBackView];
        
        UILabel *sendL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,70, 50)];
        sendL.textAlignment = NSTextAlignmentCenter;
        sendL.font = FIFTHTEENTEXTFONTSIZE;
        sendL.textColor = [UIColor colorWithHexString:@"#25262E"];
        sendL.text = [NoticeTools getLocalStrWith:@"lelve.sendto"];
        [inputBackView addSubview:sendL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(70, 15, 1, 20)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E1E4F0"];
        [inputBackView addSubview:line];
        
        self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+5, 0, inputBackView.frame.size.width-CGRectGetMaxX(line.frame)-5, 50)];
        self.phoneView.keyboardType = UIKeyboardTypePhonePad;
        [self.phoneView setupToolbarToDismissRightButton];
        self.phoneView.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.phoneView.font = FIFTHTEENTEXTFONTSIZE;
        self.phoneView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
        self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"lelve.intonum"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
        [inputBackView addSubview:self.phoneView];
   
        self.phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.nimingButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(inputBackView.frame)+30, DR_SCREEN_WIDTH-30, 30)];
        [self.nimingButton setTitle:[NoticeTools chinese:@"匿名赠送，提示对方“有人赠送了你x天会员”" english:@"Gift anonymously" japan:@"匿名で贈る"] forState:UIControlStateNormal];
        self.nimingButton.titleLabel.font = THRETEENTEXTFONTSIZE;
        [self.nimingButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        [self.nimingButton setImage:UIImageNamed(@"Image_agreereg_nomol") forState:UIControlStateNormal];
        [self.backView addSubview:self.nimingButton];
        [self.nimingButton addTarget:self action:@selector(nimingClick) forControlEvents:UIControlEventTouchUpInside];
        

        UIButton *goTbBtn = [[UIButton alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-240)/2,CGRectGetMaxY(self.nimingButton.frame)+12,240, 50)];
        goTbBtn.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [goTbBtn setAllCorner:25];
        [goTbBtn setTitle:[NoticeTools getLocalStrWith:@"chant.sendss"] forState:UIControlStateNormal];
        [goTbBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        goTbBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [goTbBtn addTarget:self action:@selector(gotoClick) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:goTbBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}


-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    

    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height, DR_SCREEN_WIDTH, self.backView.frame.size.height);

}


- (void)gotoClick{
    if (!self.phoneView.text.length) {
        self.markL.text = [NoticeTools getLocalStrWith:@"lelve.intonum"];
        return;
    }
    
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if ([userM.frequency_no isEqualToString:self.phoneView.text]) {
        
        if ([NoticeTools getLocalType] == 1) {
            self.markL.text = @"For others only";
        }else if ([NoticeTools getLocalType] == 2){
            self.markL.text = @"他人専用";
        }else{
            self.markL.text = @"获赠人不可以是自己哦~";
        }
        return;
    }

    [self.phoneView resignFirstResponder];
    NSString *url = nil;
    url = [NSString stringWithFormat:@"users/search?searchValue=%@",[self.phoneView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
    
        if (success) {
            
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFriendAcdModel *model = [NoticeFriendAcdModel mj_objectWithKeyValues:dic];
                [arr addObject:model];
            }
            
            if (arr.count) {
                NoticeFriendAcdModel *userM = arr[0];
                [self.sureView.iconImageView sd_setImageWithURL:[NSURL URLWithString:userM.avatar_url]];
                self.sureView.nameL.text = userM.nick_name;
                self.sureView.numL.text = [NSString stringWithFormat:@"学号：%@",self.phoneView.text];
                [self.sureView show];
                __weak typeof(self) weakSelf = self;
                self.sureView.sureBlock = ^(BOOL sure) {
                    if(weakSelf.sureSendBlock){
                        weakSelf.sureSendBlock(weakSelf.phoneView.text,weakSelf.isNiming);
                    }
                    weakSelf.phoneView.text = @"";
                    [weakSelf backClick];
                };
            }else{
                self.markL.text = [NoticeTools chinese:@"没有搜索到该学号，请核对学号" english:@"Can't find user" japan:@"見つかりません"];
            }
        }
    } fail:^(NSError *error) {
    }];
}

- (void)backClick{
    [self removeFromSuperview];
    [self.phoneView resignFirstResponder];
}

- (void)nimingClick{
    self.isNiming = !self.isNiming;
    [self.nimingButton setImage:UIImageNamed(!self.isNiming?@"Image_agreereg_nomol":@"Image_choiceadd_b") forState:UIControlStateNormal];
}

- (void)show{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [self.phoneView becomeFirstResponder];
}
@end

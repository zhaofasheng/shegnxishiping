//
//  SXBandKcToAccountView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/7/22.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXBandKcToAccountView.h"
#import "NoticeAreaViewController.h"
@implementation SXBandKcToAccountView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

        self.userInteractionEnabled = YES;

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH,360)];
        self.backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.backView];
        self.backView.userInteractionEnabled = YES;
        self.backView.layer.cornerRadius = 20;
        self.backView.layer.masksToBounds = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-100, 50)];
        label.text = @"请绑定手机号";
        label.font = XGEightBoldFontSize;
        label.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.backView addSubview:label];

     
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
        

        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(68,245,DR_SCREEN_WIDTH-68*2,56)];
        [sendBtn setAllCorner:28];
        sendBtn.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [sendBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:sendBtn];
        self.sendButton = sendBtn;
        
        self.markL = [[UILabel  alloc] initWithFrame:CGRectMake(20, sendBtn.frame.origin.y-30, 200, 30)];
        self.markL.font = ELEVENTEXTFONTSIZE;
        self.markL.textColor = [UIColor colorWithHexString:@"#EE4B4E"];
        [self.backView addSubview:self.markL];
    
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50,0, 50, 50)];
        [cancelBtn setImage:UIImageNamed(@"Image_closechange") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:cancelBtn];
       
        for (int i = 0; i < 2; i++) {
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 20+(56+15)*i+50, DR_SCREEN_WIDTH-40, 56)];
            backView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
            backView.layer.cornerRadius = 8;
            backView.layer.masksToBounds = YES;
            [self.backView addSubview:backView];
            
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 69, 56)];
            titleL.font = XGSIXBoldFontSize;
            titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
            titleL.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:titleL];
            if (i == 0) {
                titleL.text = @"手机号";
                
                self.areaBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 58, 56)];
                self.areaBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
                [self.areaBtn setTitleColor:[UIColor colorWithHexString:@"#14151A"] forState:UIControlStateNormal];
                [backView addSubview:self.areaBtn];
                [self.areaBtn addTarget:self action:@selector(choiceArea) forControlEvents:UIControlEventTouchUpInside];
                self.areaModel = [NoticeSaveModel getArea];
                [self.areaBtn setTitle:[NSString stringWithFormat:@"+%@",self.areaModel.phone_code] forState:UIControlStateNormal];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.areaBtn.frame), 17, 1, 22)];
                line.backgroundColor = [[UIColor colorWithHexString:@"#E1E4F0"] colorWithAlphaComponent:1];
                [backView addSubview:line];
                
                self.phoneView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame)+5, 0, backView.frame.size.width-CGRectGetMaxX(line.frame)-5, 56)];
                self.phoneView.keyboardType = UIKeyboardTypePhonePad;
                self.phoneView.textColor = [UIColor colorWithHexString:@"#14151A"];
                self.phoneView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
                self.phoneView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
                [backView addSubview:self.phoneView];
              
                self.phoneView.clearButtonMode = UITextFieldViewModeWhileEditing;
            }else{
                titleL.text = @"验证码";
                self.codeView = [[UITextField alloc] initWithFrame:CGRectMake(74, 0,160, 56)];
                self.codeView.keyboardType = UIKeyboardTypePhonePad;
                self.codeView.textColor = [UIColor colorWithHexString:@"#14151A"];
                self.codeView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
                self.codeView.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
                [backView addSubview:self.codeView];
                
                self.getCodeBtn = [[CQCountdownButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-100, 0, 100, 56)];
                [self.getCodeBtn setAction];
                self.getCodeBtn.titleLabel.font = TWOTEXTFONTSIZE;
                [self.getCodeBtn setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
                [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.getCodeBtn.dataSource = self;
                self.getCodeBtn.delegate = self;
                [backView addSubview:self.getCodeBtn];
                
            }
        }
    }
    return self;
}

- (void)choiceArea {
    [self regFirst];
    [self removeFromSuperview];
    if (self.choiceAreaBolck) {
        self.choiceAreaBolck(YES);
    }

}

// 倒计时按钮点击
- (void)countdownButtonDidClick:(CQCountdownButton *)countdownButton {
    
    if (!self.phoneView.text.length) {
        self.markL.text = @"请输入手机号";
        return;
    }

  
    // 按钮点击后将enabled设置为NO
    countdownButton.enabled = NO;
    // 请求短信验证码
    [countdownButton startCountDown];
    [self sendSMS:nil key:nil];
}

- (void)sendSMS:(NSString *)code key:(NSString *)key{
    NSString *url = [NSString stringWithFormat:@"code/%@/%@/1",self.areaModel.area_code,self.phoneView.text];
    NSString *accept = nil;
    if(![self.areaModel.area_code isEqualToString:@"CN"]){
        url = [NSString stringWithFormat:@"code/%@/%@/1?captchaCode=%@&captchaKey=%@",self.areaModel.area_code,self.phoneView.text,code,key];
        accept = @"application/vnd.shengxi.v5.5.1+json";
    }
  
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:accept isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
      
        if (success) {
      
        }else{
 
          
        }
    } fail:^(NSError *error) {
   
    }];
}

- (void)checkIsAlready:(CQCountdownButton *)countdownButton smscode:(NSString *)code key:(NSString *)key{

    // 按钮点击后将enabled设置为NO
    countdownButton.enabled = NO;
    // 请求短信验证码
    [countdownButton startCountDown];
   
}

// 倒计时进行中
- (void)countdownButtonDidCountdown:(CQCountdownButton *)countdownButton withRestCountdownNum:(NSInteger)restCountdownNum {

    NSString *title = [NSString stringWithFormat:@"%lds%@", (long)restCountdownNum,[NoticeTools getLocalStrWith:@"bdphone."]];
    [countdownButton setAttributedTitle:[DDHAttributedMode setColorString:title setColor:[UIColor colorWithHexString:@"#8A8F99"] setLengthString:[NSString stringWithFormat:@"s%@",[NoticeTools getLocalStrWith:@"bdphone."]] beginSize:[[NSString stringWithFormat:@"%ld", (long)restCountdownNum] length]] forState:UIControlStateNormal];

}

// 倒计时结束
- (void)countdownButtonDidEndCountdown:(CQCountdownButton *)countdownButton {
    [countdownButton setAttributedTitle:[DDHAttributedMode setColorString:[NoticeTools getLocalStrWith:@"Login.getsmsCode"] setColor:[UIColor colorWithHexString:@"#1FC7FF"] setLengthString:[NoticeTools getLocalStrWith:@"Login.getsmsCode"] beginSize:0] forState:UIControlStateNormal];
    [countdownButton setTitleColor:[UIColor colorWithHexString:@"#1FC7FF"] forState:UIControlStateNormal];
    countdownButton.enabled = YES;
}
// 设置倒计时总秒数
- (NSInteger)startCountdownNumOfCountdownButton:(CQCountdownButton *)countdownButton {
    return 60;
}


-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.backView.frame.size.height+20, DR_SCREEN_WIDTH, self.backView.frame.size.height);
   
}

- (void)keyboardDiddisss{
    
    self.backView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.backView.frame.size.height);
}

- (void)keyboardDidHide{

    [self removeFromSuperview];
}

- (void)sendClick{
    if (!self.phoneView.text.length) {
        self.markL.text = @"请输入手机号";
        return;
    }
    
    if (!self.codeView.text.length) {
        self.markL.text = @"请输入验证码";
        return;
    }
}

- (void)regFirst{
    [self.phoneView resignFirstResponder];
    [self.codeView resignFirstResponder];
}

- (void)showView{
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    if (!self.areaModel) {
        self.areaModel = [[NoticeAreaModel alloc] init];
        self.areaModel.phone_code = @"86";
        self.areaModel.area_code = @"CN";
        self.areaModel.area_name = @"中国大陆";
    }
    [self.areaBtn setTitle:[NSString stringWithFormat:@"+%@",self.areaModel.phone_code] forState:UIControlStateNormal];
    [self.phoneView becomeFirstResponder];
}

- (void)cancelClick{
    [self removeFromSuperview];
    [self.phoneView resignFirstResponder];
    [self.codeView resignFirstResponder];

}

@end

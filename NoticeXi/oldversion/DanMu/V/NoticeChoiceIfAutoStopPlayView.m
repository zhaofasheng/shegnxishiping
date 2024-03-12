//
//  NoticeChoiceIfAutoStopPlayView.m
//  NoticeXi
//
//  Created by li lei on 2023/12/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceIfAutoStopPlayView.h"
#import "NoticePlayBokeTimeSetView.h"

@implementation NoticeChoiceIfAutoStopPlayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 160+BOTTOM_HEIGHT)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.keyView];
        [self.keyView setCornerOnTop:20];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,100, DR_SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.keyView addSubview:line];
       
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *titleArr = @[@"不开启",@"自定义"];
        
        for (int i = 0; i < 2; i++) {
            UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, DR_SCREEN_WIDTH, 50)];
            tapView.userInteractionEnabled = YES;
            tapView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceTap:)];
            [tapView addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH/2, 50)];
            label.font = XGSIXBoldFontSize;
            label.textColor = [UIColor colorWithHexString:@"#25262E"];
            label.text = titleArr[i];
            [tapView addSubview:label];
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40, 15, 20, 20)];
            imageV.userInteractionEnabled = YES;
            [tapView addSubview:imageV];
            if(i == 0){
                self.closeImgeView = imageV;
            }else{
                self.openImgeView = imageV;
                self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-48-GET_STRWIDTH(@"关闭时间 21:45:00", 14, 50), 0, GET_STRWIDTH(@"关闭时间 21:45:00", 14, 50), 50)];
                self.timeL.font = FOURTHTEENTEXTFONTSIZE;
                self.timeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
                self.timeL.textAlignment = NSTextAlignmentRight;
                [tapView addSubview:self.timeL];
            }
            [self.keyView addSubview:tapView];
        }
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0,49.5, DR_SCREEN_WIDTH, 1)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.keyView addSubview:line1];
    }
    return self;
}

- (void)choiceTap:(UITapGestureRecognizer *)tap{
    UIView *tapV = (UIView *)tap.view;
    if(tapV.tag == 0){
        self.closeImgeView.image = UIImageNamed(@"Image_choiceadd_b");
        self.openImgeView.image = UIImageNamed(@"Image_nochoice");
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.floatView.stopBoKeTime = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPLAYBOKETIME" object:nil];
        [self cancelClick];
    }else{

        __weak typeof(self) weakSelf = self;
        NoticePlayBokeTimeSetView *datepicker = [[NoticePlayBokeTimeSetView alloc] initWithcompleteBlock:^(NSString *date) {
            
            DRLog(@"%@",date);
        }];
        datepicker.choiceTimeBlock = ^(NSString * _Nonnull formtTime, NSString * _Nonnull hour, NSString * _Nonnull min, NSInteger time) {
            
            NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
            if(currentTime < time){
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appdel.floatView.stopBoKeTime = time;
                weakSelf.timeL.text = [NSString stringWithFormat:@"关闭时间 %@",formtTime];
                appdel.floatView.stopBoKeFormortTime = formtTime;
                weakSelf.openImgeView.image = UIImageNamed(@"Image_choiceadd_b");
                weakSelf.closeImgeView.image = UIImageNamed(@"Image_nochoice");
                XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:[NSString stringWithFormat:@"播客将会在%@自动停止播放，停止播放后您可以手动点击重新播放，仅生效一次，之后有需要可以继续设定停止播放时间",formtTime] message:nil cancleBtn:@"知道了"];
                [alerView showXLAlertView];
                [weakSelf cancelClick];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPLAYBOKETIME" object:nil];
            }else{
                [[NoticeTools getTopViewController] showToastWithText:@"选择的时间要大于当前时间哦~"];
            }
        };
     
        [datepicker show];
    }
}

- (void)showTost{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(currentTime < appdel.floatView.stopBoKeTime){
        self.openImgeView.image = UIImageNamed(@"Image_choiceadd_b");
        self.closeImgeView.image = UIImageNamed(@"Image_nochoice");
        self.timeL.text = [NSString stringWithFormat:@"关闭时间 %@",appdel.floatView.stopBoKeFormortTime];
    }else{
        self.closeImgeView.image = UIImageNamed(@"Image_choiceadd_b");
        self.openImgeView.image = UIImageNamed(@"Image_nochoice");
    }
    
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    }];
}

- (void)cancelClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end

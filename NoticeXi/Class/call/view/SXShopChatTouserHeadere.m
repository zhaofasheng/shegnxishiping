//
//  SXShopChatTouserHeadere.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/6/5.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXShopChatTouserHeadere.h"
#import "NoticeOrderDetailController.h"
@implementation SXShopChatTouserHeadere

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *backView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 107)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [backView setAllCorner:10];
        [self addSubview:backView];
        
        self.orderL = [[UILabel  alloc] initWithFrame:CGRectMake(10, 10, DR_SCREEN_WIDTH-30-10, 17)];
        self.orderL.font = TWOTEXTFONTSIZE;
        self.orderL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:self.orderL];
        
        self.iconImageView = [[UIImageView  alloc] initWithFrame:CGRectMake(10, 37, 60, 60)];
        self.iconImageView.userInteractionEnabled = YES;
        [self.iconImageView setAllCorner:4];
        [backView addSubview:self.iconImageView];
        
        self.shopNameL = [[UILabel  alloc] initWithFrame:CGRectMake(80, 43, DR_SCREEN_WIDTH-30-80,21)];
        self.shopNameL.font = FIFTHTEENTEXTFONTSIZE;
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [backView addSubview:self.shopNameL];
        
        self.timeL = [[UILabel  alloc] initWithFrame:CGRectMake(80, 72, DR_SCREEN_WIDTH-30-80,18)];
        self.timeL.font = THRETEENTEXTFONTSIZE;
        self.timeL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [backView addSubview:self.timeL];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailtap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)detailtap{
    NoticeOrderDetailController *ctl = [[NoticeOrderDetailController alloc] init];
    ctl.orderM = self.orderModel;

    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)setOrderModel:(NoticeOrderListModel *)orderModel{
    _orderModel = orderModel;
    self.orderL.text = [NSString stringWithFormat:@"订单编号：%@",orderModel.sn];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.goods_img_url]];
    self.shopNameL.text = orderModel.goods_name;
    self.timeL.text = [self getMMSSFromSS:orderModel.voice_duration];
}


-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@时%@分%@秒",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@分%@秒",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
        }else{
            return [NSString stringWithFormat:@"%@秒",str_second.intValue?str_second:@"0"];
        }
    }
 
}
@end

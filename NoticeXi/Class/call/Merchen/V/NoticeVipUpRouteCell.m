//
//  NoticeVipUpRouteCell.m
//  NoticeXi
//
//  Created by li lei on 2023/9/5.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeVipUpRouteCell.h"
#import "NoticeGetVipCardView.h"
#import "NoticeGetVipRecoderController.h"
@implementation NoticeVipUpRouteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
       
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 116, 152)];
        backView.backgroundColor = [UIColor whiteColor];
        [backView setAllCorner:10];
        [self.contentView addSubview:backView];
        
        self.cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, backView.frame.size.width-12, 72)];
        self.cardImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cardImageView.clipsToBounds = YES;
        [backView addSubview:self.cardImageView];
        
    
        self.numberL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cardImageView.frame)+4,backView.frame.size.width, 20)];
        self.numberL.font = XGFourthBoldFontSize;
        self.numberL.textAlignment = NSTextAlignmentCenter;
        self.numberL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.numberL];
        
        self.getButton = [[UIButton alloc] initWithFrame:CGRectMake(22, backView.frame.size.height-34, backView.frame.size.width-44, 24)];
        self.getButton.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self.getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.getButton setAllCorner:12];
        self.getButton.titleLabel.font = ELEVENTEXTFONTSIZE;
        [self.getButton addTarget:self action:@selector(getClick) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:self.getButton];
    }
    return self;
}

- (void)setVipModel:(NoticeVipDataModel *)vipModel{
    _vipModel = vipModel;
    self.numberL.text = [NSString stringWithFormat:@"%d%@",vipModel.score.intValue,[NoticeTools chinese:@"贡献值" english:@"Points" japan:@"貢献ポイント"]];
    SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:vipModel.img_url] placeholderImage:UIImageNamed(@"Image_pubumoren") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    }];
    //vipId 是20代表升一级
    if(vipModel.type.intValue == 3){//未达成
        self.getButton.backgroundColor = [UIColor colorWithHexString:@"#A1A7B3"];
        [self.getButton setTitle:[NoticeTools chinese:@"未达成" english:@"Locked" japan:@"ロック"] forState:UIControlStateNormal];
        [self.getButton setTitleColor:[UIColor colorWithHexString:@"#E1E4F0"] forState:UIControlStateNormal];
    }else if (vipModel.type.intValue == 0){//待领取
        self.getButton.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        [self.getButton setTitle:[NoticeTools chinese:@"领取" english:@"Get" japan:@"受け取る"] forState:UIControlStateNormal];
        [self.getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (vipModel.type.intValue == 1){//已领取
        self.getButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.getButton setTitle:[NoticeTools chinese:@"已领取" english:@"Received" japan:@"受け取った"] forState:UIControlStateNormal];
        [self.getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (vipModel.type.intValue == 2){//已赠送
        self.getButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.getButton setTitle:[NoticeTools chinese:@"已赠送" english:@"Gifted" japan:@"成功"] forState:UIControlStateNormal];
        [self.getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)getClick{
    if (self.vipModel.type.intValue == 0) {
        __weak typeof(self)weakSelf = self;
        NoticeGetVipCardView *getView = [[NoticeGetVipCardView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        if([NoticeTools getLocalType] == 1){
            getView.numberL.text = [NSString stringWithFormat:@"%@ days Pro！",self.vipModel.days];
        }else if ([NoticeTools getLocalType] == 2){
            getView.numberL.text = [NSString stringWithFormat:@"%@ 日メンバー！",self.vipModel.days];
        }else{
            getView.numberL.text = [NSString stringWithFormat:@"恭喜解锁%@天会员卡",self.vipModel.days];
        }
        SDWebImageOptions newOptions = SDWebImageAvoidDecodeImage | SDWebImageScaleDownLargeImages;
        [getView.cardImageView sd_setImageWithURL:[NSURL URLWithString:_vipModel.img_url] placeholderImage:UIImageNamed(@"Image_pubumoren") options:newOptions completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        getView.getOrSendBlock = ^(BOOL isGet) {
            if(!isGet){
                [weakSelf.sendCardView show];
            }else{
                [weakSelf getCard];
            }
        };
        [getView showGetView];
    }
    if(self.vipModel.type.intValue == 1 || self.vipModel.type.intValue == 2){
        NoticeGetVipRecoderController *ctl = [[NoticeGetVipRecoderController alloc] init];
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)getCard{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"userContributeCard/giveCard/%@/1",self.vipModel.cardId] Accept:@"application/vnd.shengxi.v5.5.5+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.vipModel.type = @"1";
            self.getButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
            [self.getButton setTitle:[NoticeTools chinese:@"已领取" english:@"Received" japan:@"受け取った"] forState:UIControlStateNormal];
            [self.getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)sendCard:(NSString *)xuehao isniming:(BOOL)isNiMing{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:xuehao forKey:@"frequencyNo"];
    [parm setObject:isNiMing?@"1":@"0" forKey:@"isAnonymous"];
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"userContributeCard/giveCard/%@/2",self.vipModel.cardId] Accept:@"application/vnd.shengxi.v5.5.5+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if(success){
            self.vipModel.type = @"2";
            self.getButton.backgroundColor = [UIColor colorWithHexString:@"#5C5F66"];
            [self.getButton setTitle:[NoticeTools chinese:@"已赠送" english:@"Gifted" japan:@"成功"] forState:UIControlStateNormal];
            [self.getButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (NoticeSendVipCardView *)sendCardView{
    if(!_sendCardView){
        _sendCardView = [[NoticeSendVipCardView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        __weak typeof(self)weakSelf = self;
        _sendCardView.sureSendBlock = ^(NSString * _Nonnull frequencyNo, BOOL isNiming) {
            [weakSelf sendCard:frequencyNo isniming:isNiming];
        };
    }
    return _sendCardView;
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

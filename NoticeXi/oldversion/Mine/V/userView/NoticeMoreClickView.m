//
//  NoticeMoreClickView.m
//  NoticeXi
//
//  Created by li lei on 2022/9/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeMoreClickView.h"
#import "NoticeUserShareCell.h"
#import "NoticeMyBookController.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import <AVKit/AVKit.h>
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
@implementation NoticeMoreClickView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.userInteractionEnabled = YES;
        self.keyView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 140+BOTTOM_HEIGHT+20+10)];
        self.keyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self addSubview:self.keyView];
        self.keyView.layer.cornerRadius = 20;
        self.keyView.layer.masksToBounds = YES;
        
    
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10-10, DR_SCREEN_WIDTH, 10)];
        line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.keyView addSubview:line];
        self.line = line;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10, DR_SCREEN_WIDTH, 50)];
        [cancelBtn setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.keyView addSubview:cancelBtn];
        self.cancelBtn = cancelBtn;
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.movieTableView = [[UITableView alloc] init];
        self.movieTableView.delegate = self;
        self.movieTableView.dataSource = self;
        self.movieTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
        self.movieTableView.frame = CGRectMake(20,20,DR_SCREEN_WIDTH-40, 70);
        _movieTableView.showsVerticalScrollIndicator = NO;
        self.movieTableView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
        self.movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.movieTableView registerClass:[NoticeUserShareCell class] forCellReuseIdentifier:@"cell"];
        self.movieTableView.rowHeight = 70;
        [self.keyView addSubview:self.movieTableView];
        self.dataArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setIsShareBoKeAndMore:(BOOL)isShareBoKeAndMore{
    _isShareBoKeAndMore = isShareBoKeAndMore;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.movieTableView.frame)+20, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.keyView addSubview:line];

    self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 140+BOTTOM_HEIGHT+20+10+50+41+70+12);
    self.line.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10-10, DR_SCREEN_WIDTH, 10);
    self.cancelBtn.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10, DR_SCREEN_WIDTH, 50);
    
    self.funTableView = [[UITableView alloc] init];
    self.funTableView.delegate = self;
    self.funTableView.dataSource = self;
    self.funTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.funTableView.frame = CGRectMake(0,CGRectGetMaxY(line.frame)+20,DR_SCREEN_WIDTH, 70);
    _funTableView.showsVerticalScrollIndicator = NO;
    self.funTableView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0];
    self.funTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.funTableView registerClass:[NoticeUserShareCell class] forCellReuseIdentifier:@"cell1"];
    self.funTableView.rowHeight = 70;
    [self.keyView addSubview:self.funTableView];
    [self.funTableView reloadData];
}



- (void)setIsShare:(BOOL)isShare{
    _isShare = isShare;
    self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 140+BOTTOM_HEIGHT+20+10+50);
    self.line.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10-10, DR_SCREEN_WIDTH, 10);
    self.cancelBtn.frame = CGRectMake(0,self.keyView.frame.size.height-BOTTOM_HEIGHT-50-10, DR_SCREEN_WIDTH, 50);
    self.movieTableView.frame = CGRectMake(0,20+40,DR_SCREEN_WIDTH, 70);
    self.movieTableView.rowHeight = DR_SCREEN_WIDTH/4;
    self.imgArr = @[@"Image_shareweix",@"Image_sharepyq",@"Image_shareQQ",@"Image_sharewb"];
    self.titleArr = @[[NoticeTools getLocalStrWith:@"shanrev.wx"],[NoticeTools getLocalStrWith:@"shanrev.pyq"],@"QQ",[NoticeTools getLocalStrWith:@"shanrev.wb"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = XGTwentyBoldFontSize;
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.text = [NoticeTools getLocalStrWith:@"group.shareto"];
    [self.keyView addSubview:label];
    
    [self.movieTableView reloadData];
}

- (void)setIsVideo:(BOOL)isVideo{
    _isVideo = isVideo;
    if (self.isPayVideo) {
        //1.判断是否支持画中画功能
        if ([AVPictureInPictureController isPictureInPictureSupported]) {
            self.imgArr = @[@"sxjubaovideo_img",@"sxpicinpic_img"];
            self.titleArr = @[@"举报",@"窗口播放"];
        }else{
            self.imgArr = @[@"sxjubaovideo_img"];
            self.titleArr = @[@"举报"];
        }
      
    }else{
        self.imgArr = @[@"sxjubaovideo_img", @"sxhuancun_img",[NoticeTools voicePlayRate] > 1?@"sxbeisuplays_img": @"sxbeisuplay_img"];
        NSString *beisu = @"倍速";
       if ([NoticeTools voicePlayRate] == 2){
            beisu = @"1.25x";
        }else if ([NoticeTools voicePlayRate] == 3){
            beisu = @"1.5x";
        }else if ([NoticeTools voicePlayRate] == 4){
            beisu = @"2.0x";
        }
        self.titleArr = @[@"举报",@"缓存",beisu];
    }
    [self.movieTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self removeFromSuperview];
    
    if(tableView == self.funTableView || self.isVideo){
        if(self.clickIndexBlock){
            self.clickIndexBlock(indexPath.row);
        }
        return;
    }
    
    if (self.isShareSerise) {
        if(indexPath.row == 0){

            /**
             v4.1.2 为微信小程序分享增加
              title 标题
              description 详细说明
              webpageUrl 网址（6.5.6以下版本微信会自动转化为分享链接 必填）
              path 跳转到页面路径
              thumbImage 缩略图 , 旧版微信客户端（6.5.8及以下版本）小程序类型消息卡片使用小图卡片样式 要求图片数据小于32k
              hdThumbImage 高清缩略图，建议长宽比是 5:4 ,6.5.9及以上版本微信客户端小程序类型分享使用 要求图片数据小于128k
              userName 小程序的userName （必填）
              withShareTicket 是否使用带 shareTicket 的转发
              type 分享小程序的版本（0-正式，1-开发，2-体验）
              platformSubType 分享自平台 微信小程序暂只支持 SSDKPlatformSubTypeWechatSession（微信好友分享)
             */
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:self.title description:self.name webpageUrl:[NSURL URLWithString:@"www.baidu.com"] path:self.appletPage thumbImage:nil hdThumbImage:self.share_img_url userName:self.appletId withShareTicket:YES miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];

            [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                if (state == SSDKResponseStateSuccess) {
                  //  [nav.topViewController showToastWithText:@"分享成功"];
                }
            }];
            
        }else if(indexPath.row == 1){
            [NoticeShareView shareWithurl:self.friendShareUrl type:SSDKPlatformSubTypeWechatTimeline title:self.title?self.title:@"" name:self.name?self.name:@"" imageUrl:self.imgUrl];
        }else if(indexPath.row == 2){
            [NoticeShareView shareWithurl:self.qqShareUrl type:SSDKPlatformSubTypeQQFriend title:self.title?self.title:@"" name:self.name?self.name:@"" imageUrl:self.imgUrl];
        }
        return;
    }
    
    if (self.isShare) {
        if(indexPath.row == 0){
            [NoticeShareView shareWithurl:self.wechatShareUrl type:SSDKPlatformSubTypeWechatSession title:self.title?self.title:@"" name:self.name?self.name:@"" imageUrl:self.imgUrl];
        }else if(indexPath.row == 1){
            [NoticeShareView shareWithurl:self.wechatShareUrl type:SSDKPlatformSubTypeWechatTimeline title:self.title?self.title:@"" name:self.name?self.name:@"" imageUrl:self.imgUrl];
        }else if(indexPath.row == 2){
            [NoticeShareView shareWithurl:self.shareUrl type:SSDKPlatformSubTypeQQFriend title:self.title?self.title:@"" name:self.name?self.name:@"" imageUrl:self.imgUrl];
        }
        return;
    }
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    BaseNavigationController *nav = nil;
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        nav = tabBar.selectedViewController;//获取到当前视图的导航视图
    }
    CATransition *test = (CATransition *)[CoreAnimationEffect showAnimationType:@"fade"
                                                                    withSubType:kCATransitionFromLeft
                                                                       duration:0.3f
                                                                 timingFunction:kCAMediaTimingFunctionLinear
                                                                           view:nav.topViewController.navigationController.view];
    [nav.topViewController.navigationController.view.layer addAnimation:test forKey:@"pushanimation"];
    NoticeMyBookController *ctl = [[NoticeMyBookController alloc] init];
    [nav.topViewController.navigationController pushViewController:ctl animated:NO];
}

#pragma mark - UIDocumentInteractionControllerDelegate
-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller{
    return [NoticeTools getTopViewController];
}

-(UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return [NoticeTools getTopViewController].view;
}

-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return [NoticeTools getTopViewController].view.frame;
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls {
    [[NoticeTools getTopViewController] showToastWithText:@"保存成功"];
     //保存成功
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    [[NoticeTools getTopViewController] showToastWithText:@"保存失败"];
     //取消保存
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.funTableView){
        return self.buttonNameArr.count;
    }
    if (self.isVideo) {
        return self.titleArr.count;
    }
    return self.isShare? 3: 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.funTableView){
        NoticeUserShareCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell1.moreL.hidden = YES;
        cell1.nameL.text = self.buttonNameArr[indexPath.row];
        cell1.iconImageView.image = UIImageNamed(self.buttonImgArr[indexPath.row]);
        cell1.iconImageView.frame = CGRectMake((DR_SCREEN_WIDTH/4-44)/2, 0, 44, 44);
        cell1.nameL.frame = CGRectMake(0,CGRectGetMaxY(cell1.iconImageView.frame)+3,DR_SCREEN_WIDTH/4,17);
        cell1.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        return cell1;
    }
    NoticeUserShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.isShare || self.isVideo) {
        cell.moreL.hidden = YES;
        cell.nameL.text = self.titleArr[indexPath.row];
        cell.iconImageView.image = UIImageNamed(self.imgArr[indexPath.row]);
        cell.iconImageView.frame = CGRectMake((DR_SCREEN_WIDTH/4-44)/2, 0, 44, 44);
        cell.nameL.frame = CGRectMake(0,CGRectGetMaxY(cell.iconImageView.frame)+3,DR_SCREEN_WIDTH/4,17);
        cell.nameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        if (self.isVideo && indexPath.row == 2 && [NoticeTools voicePlayRate] > 1) {
            cell.nameL.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        }
    }else{
        cell.moreL.hidden = YES;
        cell.nameL.text = [NoticeTools getLocalType]==1?@"Past": ([NoticeTools getLocalType]==2?@"過去": @"书影音画");
        cell.iconImageView.image = UIImageNamed(@"Image_syydra");
    }

    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (void)showTost{
    
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.keyView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.keyView.frame.size.height+20, DR_SCREEN_WIDTH, self.keyView.frame.size.height);
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

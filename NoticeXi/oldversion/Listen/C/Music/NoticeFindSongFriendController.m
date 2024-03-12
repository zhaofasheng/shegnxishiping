//
//  NoticeFindSongFriendController.m
//  NoticeXi
//
//  Created by li lei on 2019/4/15.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeFindSongFriendController.h"
#import "NoticeFindSameCell.h"
#import "NoticeSameLikeSongController.h"
#import "NoticeNoDataView.h"
@interface NoticeFindSongFriendController ()
@property (nonatomic, strong) NoticeNoDataView *footView;
@property (nonatomic, strong) UIView *backView;
@end

@implementation NoticeFindSongFriendController

{
    UILabel *_label;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"找同好";
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44);
    self.tableView.rowHeight = 54;
    [self.tableView registerClass:[NoticeFindSameCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-44-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,44)];
    view.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,-5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3
    view.backgroundColor = GetColorWithName(VBackColor);
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    _backView = view;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-44-BOTTOM_HEIGHT-NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FOURTHTEENTEXTFONTSIZE;
    label.textColor = GetColorWithName(VDarkTextColor);
    label.text = [NoticeTools isSimpleLau]?@"记录你最爱的歌，帮你发现更多同好!":@"記錄妳最愛的歌，幫妳發現更多同好!";
    _label = label;
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    self.dataArr = [NSMutableArray new];
    [self requestData];
    
    [self.view bringSubviewToFront:self.line];
}

- (void)requestData{
    
    [self showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"hobby/common/3" Accept:@"application/vnd.shengxi.v3.2+json" isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self hideHUD];
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeFindSame *model = [NoticeFindSame mj_objectWithKeyValues:dic];
                [self.dataArr addObject:model];
            }
            if (!self.dataArr.count) {
                self.tableView.tableFooterView = self.footView;
                self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
            }else{
                self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT-44);
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self hideHUD];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeSameLikeSongController *ctl = [[NoticeSameLikeSongController alloc] init];
    NoticeFindSame *model = self.dataArr[indexPath.row];
    ctl.name = model.nick_name;
    ctl.withUserId = model.userId;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeFindSameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.isSong = YES;
    cell.sameModel = self.dataArr[indexPath.row];
    if (indexPath.row == self.dataArr.count-1) {
        cell.line.hidden = YES;
    }else{
        cell.line.hidden = NO;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NoticeNoDataView *)footView{
    if (!_footView) {//
        _footView = [[NoticeNoDataView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        _footView.titleImageV.image = UIImageNamed(@"Image_nosong");
        _footView.titleImageV.frame = CGRectMake((DR_SCREEN_WIDTH-80)/2, 150,80, 80);
        _footView.backgroundColor = GetColorWithName(VBackColor);
        NSString *str = [NoticeTools isSimpleLau]?@"还没找到最爱同一首歌的小伙伴哦\n记录最爱的歌发现更多同好!":@"還沒找到最愛同壹首歌的小夥伴哦\n記錄最愛的歌發現更多同好!";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        _footView.titleL.attributedText = attributedString;
        _footView.titleL.textAlignment = NSTextAlignmentCenter;
        _footView.titleL.frame = CGRectMake(35, CGRectGetMaxY(_footView.titleImageV.frame)+61, DR_SCREEN_WIDTH-70, GET_STRHEIGHT(str, 15, DR_SCREEN_WIDTH-70)+20);
        _footView.actionButton.hidden = YES;
        
    }
    return _footView;
}
@end

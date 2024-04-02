//
//  NoticeSearchPersonViewController.m
//  NoticeXi
//
//  Created by li lei on 2018/11/1.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSearchPersonViewController.h"
#import "NoticeUserInfoCenterController.h"
#import "NoticeMineViewController.h"
#import "NoticeNearSearchPersonCell.h"
#import "DDHAttributedMode.h"
#import "NoticeNearViewController.h"
#import "NoticeCarePeopleCell.h"
#import "NoticeLocalTopicCell.h"
@interface NoticeSearchPersonViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *backViews;
@property (nonatomic, strong) NSString *lastId;
@property (nonatomic, strong) UILabel *scanL;
@property (nonatomic, assign) BOOL hasCreate;  //YES  下拉
@property (nonatomic, assign) BOOL hasSearch;  //已经搜索过人
@property (nonatomic, strong) UITextField *topicField;
@property (nonatomic, strong) NSMutableArray *careArr;
@property (nonatomic, strong) NSMutableArray *localArr;
@property (nonatomic, strong) UIView *headerSectionView;
@property (nonatomic, strong) UIButton *moreButton;
@end

@implementation NoticeSearchPersonViewController
{
    UIButton *_beizhuBtn;
    BOOL _isMore;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);

    [self.tableView registerClass:[NoticeNearSearchPersonCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[NoticeCarePeopleCell class] forCellReuseIdentifier:@"cell2"];
    [self.tableView registerClass:[NoticeLocalTopicCell class] forCellReuseIdentifier:@"cell3"];
    self.navBarView.hidden = YES;
    self.tableView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT+40, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40);

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20,STATUS_BAR_HEIGHT+(NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-36)/2, DR_SCREEN_WIDTH-20-20-GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.cancel"], 16, 30)-5, 36)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    backView.layer.cornerRadius = 18;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    UIImageView *searchImageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
    searchImageV.image = UIImageNamed(@"Image_newsearchss");
    [backView addSubview:searchImageV];
    
    self.topicField = [[UITextField alloc] initWithFrame:CGRectMake(42, 0,DR_SCREEN_WIDTH-20-67-42, 36)];
    self.topicField.tintColor = GetColorWithName(VMainThumeColor);
    self.topicField.font = SIXTEENTEXTFONTSIZE;
    self.topicField.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.topicField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.topicField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NoticeTools getLocalStrWith:@"yl.searchs"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A1A7B3"]}];
    [self.topicField setupToolbarToDismissRightButton];
    self.topicField.delegate = self;
    self.topicField.returnKeyType = UIReturnKeySearch;
    [backView addSubview:self.topicField];
    
    UILabel *backL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-20-GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.cancel"], 16, 30), STATUS_BAR_HEIGHT, GET_STRWIDTH([NoticeTools getLocalStrWith:@"main.cancel"], 16, 30), NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT)];
    backL.backgroundColor = self.view.backgroundColor;
    backL.font = SIXTEENTEXTFONTSIZE;
    backL.textColor = [UIColor colorWithHexString:@"#41434D"];
    backL.text = [NoticeTools getLocalStrWith:@"main.cancel"];
    backL.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:backL];
    backL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
    [backL addGestureRecognizer:tap];
    
  
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH-20,40)];
    label.font = ELEVENTEXTFONTSIZE;
    label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
    label.text = [NoticeTools getLocalStrWith:@"yl.marks"];

}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchClick{
    if (!self.topicField.text.length) {
        return;
    }
    self.tableView.tableHeaderView = nil;
    [self sarchPerson:self.topicField.text];
}

- (void)createRefesh{
    self.hasCreate = YES;
    __weak NoticeSearchPersonViewController *ctl = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉
        ctl.isDown = NO;
        [ctl request];
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NoticeNearPerson *person = self.dataArr[indexPath.row];
    if ([person.user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        ctl.userId = person.user_id;
        ctl.isOther = YES;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 65;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.hasSearch) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NoticeNearSearchPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];

    cell.person = self.dataArr[indexPath.row];

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    if (textField.text && textField.text.length) {
        [self searchClick];
    }
    
    return YES;
}

- (void)textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    if (!_field.text.length) {
        return;
    }
    self.isDown = YES;
    [self request];
}

- (void)sarchPerson:(NSString *)name{
    self.name = name;

    self.isDown = YES;
    [self request];
}

- (void)request{
    NSString *url = nil;
    if (!self.isDown) {
        url = [NSString stringWithFormat:@"users/search?searchValue=%@&lastId=%@",[self.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]],self.lastId];
    }else{
        url = [NSString stringWithFormat:@"users/search?searchValue=%@",[self.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<>"]]];
    }
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        [self.tableView.mj_footer endRefreshing];
        if (success) {
            
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            if (self.isDown) {
              self.dataArr = [NSMutableArray new];
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeNearPerson *person = [NoticeNearPerson mj_objectWithKeyValues:dic];
                [self.dataArr addObject:person];
            }
            self.hasSearch = YES;
            if (self.dataArr.count) {
                self.lastId = [self.dataArr[self.dataArr.count-1] user_id];
                if (!self.hasCreate) {
                    [self createRefesh];
                }
                self.tableView.tableFooterView = nil;
            }
            
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
}

@end

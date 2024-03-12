//
//  NoticeBaseCellController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/2/20.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "NoticeBaseCellController.h"
#import "BaseCell.h"
@interface NoticeBaseCellController ()

@end

@implementation NoticeBaseCellController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.pageNo = 1;
    self.isDown = YES;
    
    self.tableView = [[UITableView alloc] init];

    self.tableView.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0,self.useSystemeNav?0: NAVIGATION_BAR_HEIGHT,DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-BOTTOM_HEIGHT);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[BaseCell class] forCellReuseIdentifier:@"basecell"];
    self.tableView.rowHeight = 65;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    if (@available(iOS 15.0, *)) {

    _tableView.sectionHeaderTopPadding = 0;

    }
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basecell"];
    return cell;
}

- (UILabel *)defaultL{
    if (!_defaultL) {
        _defaultL = [[UILabel alloc] initWithFrame:self.tableView.bounds];

        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-125)/2, (_defaultL.frame.size.height-125)/2-14-16, 125, 125)];
        imageV.image = UIImageNamed(@"sxnodata_img");
        [_defaultL addSubview:imageV];
        
        UILabel *labelL = [[UILabel  alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame)+16, DR_SCREEN_WIDTH, 16)];
        labelL.textAlignment = NSTextAlignmentCenter;
        labelL.font = FOURTHTEENTEXTFONTSIZE;
        labelL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        labelL.text = @"欸 这里空空的";
        [_defaultL addSubview:labelL];
    }
    return _defaultL;
}
@end

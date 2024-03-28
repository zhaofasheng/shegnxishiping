//
//  MyCommnetView.m
//  DouYinCComment
//
//  Created by 唐天成 on 2019/4/10.
//  Copyright © 2019 唐天成. All rights reserved.
//

#import "MyCommentView.h"
#import "MyCommentCell.h"
#import "Masonry.h"

static NSString *const commentCellIdentifier = @"commentCellIdentifier";

@interface MyCommentView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self setupBaseView];
    }
    return self;
}

- (void)setupBaseView {
    self.backgroundColor = [UIColor whiteColor];
    

    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50, 0, 50, 50)];
    self.closeBtn = closeBtn;
    [self.closeBtn setImage:UIImageNamed(@"Image_blackclose") forState:UIControlStateNormal];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeComment) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, DR_SCREEN_WIDTH-100, 50)];
    label.text = @"评论";
    label.textColor = [UIColor colorWithHexString:@"#25262E"];
    label.font = XGTwentyBoldFontSize;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.titleL = label;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.with.offset(0);
        make.top.with.offset(50);
    }];
    
    tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:commentCellIdentifier];
}

- (void)closeComment {
    if([self.delegate respondsToSelector:@selector(closeComment)]) {
        [self.delegate closeComment];
    }
}

#pragma mark - UITableViewDataSource && UITableVideDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

@end

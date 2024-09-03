//
//  SXAboutShoperController.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/8/30.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXAboutShoperController.h"

@interface SXAboutShoperController ()
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UIImageView *yhImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tagsL;
@property (nonatomic, strong) UILabel *stroryL;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *nodataL;
@end

@implementation SXAboutShoperController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarView.hidden = YES;
    self.tableView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-40);
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self refreshUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
}

- (void)refreshUI{
    if (self.shopModel.tale && self.shopModel.tale.length && self.shopModel.tagsTextArr.count) {//故事和标签都存在
        
        CGFloat tagHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:self.shopModel.tagString isJiacu:NO];
        CGFloat taleHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:self.shopModel.tale isJiacu:NO];
        
        self.contentView.frame = CGRectMake(15, 10, DR_SCREEN_WIDTH-30, tagHeight+taleHeight+60);
        
        
        self.tagsL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, tagHeight);
        self.tagsL.attributedText = [SXTools getStringWithLineHight:3 string:self.shopModel.tagString];
        
        self.lineView.hidden = NO;
        self.lineView.frame = CGRectMake(15, CGRectGetMaxY(self.tagsL.frame)+15, DR_SCREEN_WIDTH-60, 1);
        
        self.stroryL.frame = CGRectMake(15, CGRectGetMaxY(self.lineView.frame)+15, DR_SCREEN_WIDTH-60, taleHeight);
        self.stroryL.attributedText = [SXTools getStringWithLineHight:3 string:self.shopModel.tale];
        
    }else{
        if (self.shopModel.tagsTextArr.count) {//有标签
            CGFloat tagHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:self.shopModel.tagString isJiacu:NO];
            
            self.contentView.hidden = NO;
            self.contentView.frame = CGRectMake(15, 10, DR_SCREEN_WIDTH-30, tagHeight+30);
            
            self.tagsL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, tagHeight);
            self.tagsL.attributedText = [SXTools getStringWithLineHight:3 string:self.shopModel.tagString];
            self.lineView.hidden = YES;
            
        }else if (self.shopModel.tale && self.shopModel.tale.length){
            CGFloat taleHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:self.shopModel.tale isJiacu:NO];
            self.contentView.hidden = NO;
            self.contentView.frame = CGRectMake(15,10, DR_SCREEN_WIDTH-30, taleHeight+30);
            self.lineView.hidden = YES;
            self.stroryL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, taleHeight);
            self.stroryL.attributedText = [SXTools getStringWithLineHight:3 string:self.shopModel.tale];
        }
    }
    
    if (_contentView.hidden || self.shopModel.is_black.boolValue) {
        self.tableView.tableHeaderView =self.shopModel.is_black.boolValue?nil: self.nodataL;
    }else{
        self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.contentView.frame.size.height+10);
        self.tableView.tableHeaderView = self.headerView;
    }
    [self.tableView reloadData];
}

- (void)setShopModel:(NoticeMyShopModel *)shopModel{
    _shopModel = shopModel;
    
    if (shopModel.tale && shopModel.tale.length && shopModel.tagsTextArr.count) {//故事和标签都存在
        
        CGFloat tagHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tagString isJiacu:NO];
        CGFloat taleHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tale isJiacu:NO];
        
        self.contentView.frame = CGRectMake(15, 10, DR_SCREEN_WIDTH-30, tagHeight+taleHeight+60);
        
        
        self.tagsL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, tagHeight);
        self.tagsL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tagString];
        
        self.lineView.hidden = NO;
        self.lineView.frame = CGRectMake(15, CGRectGetMaxY(self.tagsL.frame)+15, DR_SCREEN_WIDTH-60, 1);
        
        self.stroryL.frame = CGRectMake(15, CGRectGetMaxY(self.lineView.frame)+15, DR_SCREEN_WIDTH-60, taleHeight);
        self.stroryL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tale];
        
    }else{
        if (shopModel.tagsTextArr.count) {//有标签
            CGFloat tagHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tagString isJiacu:NO];
            
            self.contentView.hidden = NO;
            self.contentView.frame = CGRectMake(15, 10, DR_SCREEN_WIDTH-30, tagHeight+30);
            
            self.tagsL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, tagHeight);
            self.tagsL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tagString];
            self.lineView.hidden = YES;
            
        }else if (shopModel.tale && shopModel.tale.length){
            CGFloat taleHeight = [SXTools getHeightWithLineHight:3 font:15 width:DR_SCREEN_WIDTH-60 string:shopModel.tale isJiacu:NO];
            self.contentView.hidden = NO;
            self.contentView.frame = CGRectMake(15,10, DR_SCREEN_WIDTH-30, taleHeight+30);
            self.lineView.hidden = YES;
            self.stroryL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-60, taleHeight);
            self.stroryL.attributedText = [SXTools getStringWithLineHight:3 string:shopModel.tale];
        }
    }
    
    if (_contentView.hidden || shopModel.is_black.boolValue) {
        self.tableView.tableHeaderView = nil;
    }else{
        self.headerView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, self.contentView.frame.size.height+10);
        self.tableView.tableHeaderView = self.headerView;
    }
    [self.tableView reloadData];
   
}

- (UIView *)contentView{
    if (!_contentView) {
        
        self.headerView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        _contentView = [[UIView  alloc] initWithFrame:CGRectMake(15, 10, DR_SCREEN_WIDTH-30, 0)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        
        self.tagsL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-60, 0)];
        self.tagsL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.tagsL.font = FIFTHTEENTEXTFONTSIZE;
        self.tagsL.numberOfLines = 0;
        [_contentView addSubview:self.tagsL];
        
        self.stroryL = [[UILabel  alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-60, 0)];
        self.stroryL.textColor = [UIColor colorWithHexString:@"#14151A"];
        self.stroryL.font = FIFTHTEENTEXTFONTSIZE;
        self.stroryL.numberOfLines = 0;
        [_contentView addSubview:self.stroryL];
        
        self.lineView = [[UIView  alloc] initWithFrame:CGRectZero];
        self.lineView.backgroundColor = [UIColor colorWithHexString:@"#F0F1F5"];
        [_contentView addSubview:self.lineView];
        
        [self.headerView addSubview:self.contentView];
        
        UIImageView *imageV = [[UIImageView  alloc] initWithFrame:CGRectMake(15,0, 24, 18)];
        imageV.image = UIImageNamed(@"introYinhao_img");
        self.yhImageView = imageV;
        [self.headerView addSubview:self.yhImageView];
    }
    return _contentView;
}

- (UILabel *)nodataL{
    if (!_nodataL) {
        _nodataL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 200)];
        _nodataL.text = @"Ta没有留下任何信息";
        _nodataL.font = FOURTHTEENTEXTFONTSIZE;
        _nodataL.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        _nodataL.textAlignment = NSTextAlignmentCenter;
    }
    return _nodataL;
}

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

@end

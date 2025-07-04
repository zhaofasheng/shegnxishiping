//
//  LCActionSheet.m
//  LCActionSheet
//
//  Created by Leo on 2015/4/27.
//
//  Copyright (c) 2015-2017 Leo <leodaxia@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "LCActionSheet.h"
#import "LCActionSheetCell.h"
#import "LCActionSheetViewController.h"
#import "UIImage+LCActionSheet.h"
#import "UIDevice+LCActionSheet.h"
#import "Masonry.h"
#import "DDHAttributedMode.h"
@interface LCActionSheet () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *otherButtonTitles;

@property (nonatomic, assign) CGSize titleTextSize;
@property (nonatomic, strong) UIView *racView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIVisualEffectView *blurEffectView;
@property (nonatomic, weak) UIView *darkView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *divisionView;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) UIView *whiteBgView;

@property (nonatomic, weak) UIView *lineView;

@property (nullable, nonatomic, strong) UIWindow *window;

@end

@implementation LCActionSheet

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sheetWithTitle:(NSString *)title delegate:(id<LCActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempOtherButtonTitles = nil;
    if (otherButtonTitles) {
        tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempOtherButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    return [[self alloc] initWithTitle:title
                              delegate:delegate
                     cancelButtonTitle:cancelButtonTitle
                 otherButtonTitleArray:tempOtherButtonTitles];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(LCActionSheetClickedHandler)clickedHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempOtherButtonTitles = nil;
    if (otherButtonTitles) {
        tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempOtherButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                               clicked:clickedHandler
                 otherButtonTitleArray:tempOtherButtonTitles];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle didDismiss:(LCActionSheetDidDismissHandler)didDismissHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempOtherButtonTitles = nil;
    if (otherButtonTitles) {
        tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
        va_start(argumentList, otherButtonTitles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempOtherButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                            didDismiss:didDismissHandler
                 otherButtonTitleArray:tempOtherButtonTitles];
}

+ (instancetype)sheetWithTitle:(NSString *)title delegate:(id<LCActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    
    return [[self alloc] initWithTitle:title
                              delegate:delegate
                     cancelButtonTitle:cancelButtonTitle
                 otherButtonTitleArray:otherButtonTitleArray];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(LCActionSheetClickedHandler)clickedHandler otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                               clicked:clickedHandler
                 otherButtonTitleArray:otherButtonTitleArray];
}

+ (instancetype)sheetWithTitle:(NSString *)title cancelButtonTitle:(nullable NSString *)cancelButtonTitle didDismiss:(nullable LCActionSheetDidDismissHandler)didDismissHandler otherButtonTitleArray:(nullable NSArray<NSString *> *)otherButtonTitleArray {
    
    return [[self alloc] initWithTitle:title
                     cancelButtonTitle:cancelButtonTitle
                            didDismiss:didDismissHandler
                 otherButtonTitleArray:otherButtonTitleArray];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LCActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        [self config:LCActionSheetConfig.config];
        
        id eachObject;
        va_list argumentList;
        NSMutableArray *tempOtherButtonTitles = nil;
        if (otherButtonTitles) {
            tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [tempOtherButtonTitles addObject:eachObject];
            }
            va_end(argumentList);
        }
        
        self.title             = title;
        self.delegate          = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = tempOtherButtonTitles;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(LCActionSheetClickedHandler)clickedHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        [self config:LCActionSheetConfig.config];
        
        id eachObject;
        va_list argumentList;
        NSMutableArray *tempOtherButtonTitles = nil;
        if (otherButtonTitles) {
            tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [tempOtherButtonTitles addObject:eachObject];
            }
            va_end(argumentList);
        }
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.clickedHandler    = clickedHandler;
        self.otherButtonTitles = tempOtherButtonTitles;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle didDismiss:(LCActionSheetDidDismissHandler)didDismissHandler otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        [self config:LCActionSheetConfig.config];
        
        id eachObject;
        va_list argumentList;
        NSMutableArray *tempOtherButtonTitles = nil;
        if (otherButtonTitles) {
            tempOtherButtonTitles = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [tempOtherButtonTitles addObject:eachObject];
            }
            va_end(argumentList);
        }
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.didDismissHandler = didDismissHandler;
        self.otherButtonTitles = tempOtherButtonTitles;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LCActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    if (self = [super init]) {
        [self config:LCActionSheetConfig.config];
        
        self.title             = title;
        self.delegate          = delegate;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonTitleArray;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle clicked:(LCActionSheetClickedHandler)clickedHandler otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    if (self = [super init]) {
        [self config:LCActionSheetConfig.config];
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.clickedHandler    = clickedHandler;
        self.otherButtonTitles = otherButtonTitleArray;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle isWhiteclicked:(LCActionSheetClickedHandler)clickedHandler otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    if (self = [super init]) {
        [self config:LCActionSheetConfig.config];
        self.isWhite = YES;
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.clickedHandler    = clickedHandler;
        self.otherButtonTitles = otherButtonTitleArray;
        
        [self setupView];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle didDismiss:(LCActionSheetDidDismissHandler)didDismissHandler otherButtonTitleArray:(NSArray<NSString *> *)otherButtonTitleArray {
    if (self = [super init]) {
        [self config:LCActionSheetConfig.config];
        
        self.title             = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.didDismissHandler = didDismissHandler;
        self.otherButtonTitles = otherButtonTitleArray;
        
        
        
        [self setupView];
    }
    return self;
}

- (instancetype)config:(LCActionSheetConfig *)config {
    _title                     =  config.title;
    _cancelButtonTitle         = config.cancelButtonTitle;
    _destructiveButtonIndexSet = config.destructiveButtonIndexSet;
    _destructiveButtonColor    = config.destructiveButtonColor;
    _titleColor                = config.titleColor;
    _buttonColor               = config.buttonColor;
    _titleFont                 = config.titleFont;
    _buttonFont                = config.buttonFont;
    _buttonHeight              = config.buttonHeight;
    _scrolling                 = config.canScrolling;
    _visibleButtonCount        = config.visibleButtonCount;
    _animationDuration         = config.animationDuration;
    _darkOpacity               = config.darkOpacity;
    _darkViewNoTaped           = config.darkViewNoTaped;
    _unBlur                    = config.unBlur;
    _blurEffectStyle           = config.blurEffectStyle;
    _titleEdgeInsets           = config.titleEdgeInsets;
    _separatorColor            = [UIColor colorWithHexString:@"#383A42"];
    _blurBackgroundColor       = config.blurBackgroundColor;
    _autoHideWhenDeviceRotated = config.autoHideWhenDeviceRotated;
    _numberOfTitleLines        = config.numberOfTitleLines;

    _buttonEdgeInsets          = config.buttonEdgeInsets;
    _destructiveButtonBgColor  = config.destructiveButtonBgColor;
    _cancelButtonColor         = config.cancelButtonColor;
    _cancelButtonBgColor       = config.cancelButtonBgColor;
    _buttonBgColor             = GetColorWithName(VlineColor);
    _buttonCornerRadius        = config.buttonCornerRadius;

    return self;
}

- (void)setupView {
    UIView *fgView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-30-BOTTOM_HEIGHT, DR_SCREEN_WIDTH,BOTTOM_HEIGHT+30)];
    fgView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self addSubview:fgView];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(handleDidChangeStatusBarOrientation)
                               name:UIApplicationDidChangeStatusBarOrientationNotification
                             object:nil];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        
        CGFloat height =
        (self.title.length > 0 ? self.titleTextSize.height + 2.0f + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom) : 0) +
        (self.otherButtonTitles.count > 0 ? (self.canScrolling ? MIN(self.visibleButtonCount, self.otherButtonTitles.count) : self.otherButtonTitles.count) * self.buttonHeight : 0) +
        (self.cancelButtonTitle.length > 0 ? 5.0f + self.buttonHeight : 0) + BOTTOM_HEIGHT;
        
        make.height.equalTo(@(height));
        make.bottom.equalTo(self).offset(height);
    }];
    
    self.bottomView = bottomView;
    self.bottomView.layer.cornerRadius = 20;
    self.bottomView.layer.masksToBounds = YES;
    
    UIView *darkView                = [[UIView alloc] init];
    darkView.userInteractionEnabled = NO;
    darkView.backgroundColor        = [UIColor clearColor];
    [self addSubview:darkView];
    [darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).priorityLow();
        make.bottom.equalTo(bottomView.mas_top);
    }];
    self.darkView = darkView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(darkViewClicked)];
    [darkView addGestureRecognizer:tap];
   
    UILabel *titleLabel      = [[UILabel alloc] init];
    titleLabel.font          = FIFTHTEENTEXTFONTSIZE;
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];

    
    titleLabel.text          = self.title;
    titleLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(self.title.length > 0 ? self.titleEdgeInsets.top : 0);
        make.left.equalTo(bottomView).offset(self.titleEdgeInsets.left);
        make.right.equalTo(bottomView).offset(-self.titleEdgeInsets.right);
        CGFloat height = self.title.length > 0 ? self.titleTextSize.height + 2.0f : 0;  // Prevent omit
        make.height.equalTo(@(height));
    }];
    self.titleLabel = titleLabel;
    
    UITableView *tableView    = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    tableView.dataSource      = self;
    tableView.delegate        = self;
    [bottomView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
        CGFloat height = self.otherButtonTitles.count * self.buttonHeight;
        make.height.equalTo(@(height));
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
            
    UIView *lineView  = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    lineView.contentMode   = UIViewContentModeBottom;
    lineView.clipsToBounds = YES;
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.bottom.equalTo(tableView.mas_top);
        make.height.equalTo(@0.5f);
    }];
    
    self.lineView = lineView;
    self.lineView.hidden = !self.title || self.title.length == 0;
    
    UIView *divisionView         = [[UIView alloc] init];
    divisionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bottomView addSubview:divisionView];
    [divisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(tableView.mas_bottom);
        
        CGFloat height = self.cancelButtonTitle.length > 0 ? 8.0f : 0;
        make.height.equalTo(@(height));
    }];
    
    self.divisionView = divisionView;
    UIButton *cancelButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    cancelButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage lc_imageWithColor:[UIColor colorWithHexString:@"#F7F8FC"]]
                            forState:UIControlStateHighlighted];
    [cancelButton addTarget:self
                     action:@selector(cancelButtonClicked)
           forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.bottom.equalTo(bottomView).offset(-BOTTOM_HEIGHT);

        CGFloat height = self.cancelButtonTitle.length > 0 ? self.buttonHeight-3 : 0;
        make.height.equalTo(@(height));
    }];
    self.cancelButton = cancelButton;
    

}

- (void)appendButtonsWithTitles:(NSString *)titles, ... {
    id eachObject;
    va_list argumentList;
    NSMutableArray *tempButtonTitles = nil;
    if (titles) {
        tempButtonTitles = [[NSMutableArray alloc] initWithObjects:titles, nil];
        va_start(argumentList, titles);
        while ((eachObject = va_arg(argumentList, id))) {
            [tempButtonTitles addObject:eachObject];
        }
        va_end(argumentList);
    }
    
    self.otherButtonTitles = [self.otherButtonTitles arrayByAddingObjectsFromArray:tempButtonTitles];
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
}

- (void)appendButtonWithTitle:(NSString *)title atIndex:(NSInteger)index {
#ifdef DEBUG
    NSAssert(index != 0, @"Index 0 is cancel button");
    NSAssert(index <= self.otherButtonTitles.count + 1, @"Index crossed");
#endif
    
    NSMutableArray<NSString *> *arrayM = [NSMutableArray arrayWithArray:self.otherButtonTitles];
    [arrayM insertObject:title atIndex:index - 1];
    self.otherButtonTitles = [NSArray arrayWithArray:arrayM];
    
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
}

- (void)appendButtonsWithTitles:(NSArray<NSString *> *)titles atIndexes:(NSIndexSet *)indexes {
#ifdef DEBUG
    NSAssert(titles.count == indexes.count, @"Count of titles differs from count of indexs");
#endif
    
    NSMutableIndexSet *indexSetM = [[NSMutableIndexSet alloc] init];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
#ifdef DEBUG
        NSAssert(idx != 0, @"Index 0 is cancel button");
        NSAssert(idx <= self.otherButtonTitles.count + indexes.count, @"Index crossed");
#endif
        
        [indexSetM addIndex:idx - 1];
    }];
    
    NSMutableArray<NSString *> *arrayM = [NSMutableArray arrayWithArray:self.otherButtonTitles];
    [arrayM insertObjects:titles atIndexes:indexSetM];
    self.otherButtonTitles = [NSArray arrayWithArray:arrayM];
    
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
}
    
- (void)handleDidChangeStatusBarOrientation {
    if (self.autoHideWhenDeviceRotated) {
        [self hideWithButtonIndex:self.cancelButtonIndex];
    }
}

- (void)blurBottomBgView {
    self.whiteBgView.hidden = YES;
    
    if (!self.blurEffectView) {
        UIBlurEffect *blurEffect           = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.backgroundColor     = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.bottomView addSubview:blurEffectView];
        [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bottomView);
        }];
        self.blurEffectView = blurEffectView;
        
        [self.bottomView sendSubviewToBack:blurEffectView];
    }
}

- (void)unBlurBottomBgView {
    self.whiteBgView.hidden = NO;
    
    if (self.blurEffectView) {
        [self.blurEffectView removeFromSuperview];
        self.blurEffectView = nil;
    }
}

#pragma mark - Setter & Getter

- (void)setTitle:(NSString *)title {
    _title = [title copy];

    [self updateTitleLabel];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
    }];
    
    self.lineView.hidden = !self.title || self.title.length == 0;
}

- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle {
    _cancelButtonTitle = [cancelButtonTitle copy];
    
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self updateCancelButton];
}

- (void)setDestructiveButtonIndexSet:(NSIndexSet *)destructiveButtonIndexSet {
    _destructiveButtonIndexSet = destructiveButtonIndexSet;
    [self.tableView reloadData];
}

- (void)setUnBlur:(BOOL)unBlur {
    _unBlur = unBlur;
    
    if (unBlur) {
        [self unBlurBottomBgView];
    } else {
        [self blurBottomBgView];
    }
}

- (void)setBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle {
    _blurEffectStyle = blurEffectStyle;
    
    [self unBlurBottomBgView];
    [self blurBottomBgView];
}

- (void)setButtonHeight:(CGFloat)aButtonHeight {
    _buttonHeight = aButtonHeight;
    
    [self.tableView reloadData];
    [self updateBottomView];
    [self updateTableView];
    [self updateCancelButton];
}

- (NSInteger)cancelButtonIndex {
    return 0;
}

- (void)setScrolling:(BOOL)scrolling {
    _scrolling = scrolling;
    
    [self updateBottomView];
    [self updateTableView];
}

- (void)setVisibleButtonCount:(CGFloat)visibleButtonCount {
    _visibleButtonCount = visibleButtonCount;
    
    [self updateBottomView];
    [self updateTableView];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    _titleEdgeInsets = titleEdgeInsets;
    
    [self updateBottomView];
    [self updateTitleLabel];
    [self updateTableView];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = self.isWhite?[UIColor colorWithHexString:@"#FFFFFF"] :  GetColorWithName(VlineColor);
    
    self.lineView.backgroundColor =self.isWhite?[UIColor colorWithHexString:@"#FFFFFF"] :   GetColorWithName(VlineColor);
    self.divisionView.backgroundColor = self.isWhite?[UIColor colorWithHexString:@"#FFFFFF"] :  GetColorWithName(VlineColor);
    [self.cancelButton setBackgroundImage:[UIImage lc_imageWithColor:self.isWhite?[UIColor whiteColor]: GetColorWithName(VBackColor)]
                                 forState:UIControlStateHighlighted];
    [self.tableView reloadData];
}

- (void)setNumberOfTitleLines:(NSInteger)numberOfTitleLines {
    _numberOfTitleLines = numberOfTitleLines;
    
    [self updateBottomView];
    [self updateTitleLabel];
    [self updateTableView];
}

- (CGSize)titleTextSize {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width -
                             (self.titleEdgeInsets.left + self.titleEdgeInsets.right),
                             MAXFLOAT);
    
    NSStringDrawingOptions opts =
    NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    
    NSDictionary *attrs = @{NSFontAttributeName : self.titleFont};
    
    _titleTextSize =
    [self.title boundingRectWithSize:size
                             options:opts
                          attributes:attrs
                             context:nil].size;
    if (self.numberOfTitleLines != 0) {
      // with no attribute string use 'lineHeight' to acquire single line height.
      _titleTextSize.height = MIN(_titleTextSize.height, self.titleFont.lineHeight * self.numberOfTitleLines);
    }
    return _titleTextSize;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    NSString *buttonTitle = nil;
    if (index == 0) {
        buttonTitle = self.cancelButtonTitle;
    } else {
        buttonTitle = self.otherButtonTitles[index - 1];
    }
    return buttonTitle;
}

#pragma mark - Update Views

- (void)updateBottomView {
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height =
        (self.title.length > 0 ? self.titleTextSize.height + 2.0f + (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom) : 0) +
        (self.otherButtonTitles.count > 0 ? (self.canScrolling ? MIN(self.visibleButtonCount, self.otherButtonTitles.count) : self.otherButtonTitles.count) * self.buttonHeight : 0) +
        (self.cancelButtonTitle.length > 0 ? 5.0f + self.buttonHeight : 0) +
        (ISIPHONEXORLATER ? BOTTOM_HEIGHT : 0);
        make.height.equalTo(@(height));
    }];
}

- (void)updateTitleLabel {
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(self.title.length > 0 ? self.titleEdgeInsets.top : 0);
        make.left.equalTo(self.bottomView).offset(self.titleEdgeInsets.left);
        make.right.equalTo(self.bottomView).offset(-self.titleEdgeInsets.right);
        
        CGFloat height = self.title.length > 0 ? self.titleTextSize.height + 2.0f : 0;  // Prevent omit
        make.height.equalTo(@(height));
    }];
}

- (void)updateTableView {
    if (!self.canScrolling) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.otherButtonTitles.count * self.buttonHeight));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
        }];
    } else {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(MIN(self.visibleButtonCount, self.otherButtonTitles.count) * self.buttonHeight));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(self.title.length > 0 ? self.titleEdgeInsets.bottom : 0);
        }];
    }
}

- (void)updateCancelButton {
    [self.divisionView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = self.cancelButtonTitle.length > 0 ? 5.0f : 0;
        make.height.equalTo(@(height));
    }];
    
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = self.cancelButtonTitle.length > 0 ? self.buttonHeight : 0;
        make.height.equalTo(@(height));
    }];
}

#pragma mark - Show & Hide

- (void)show {
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [self.delegate willPresentActionSheet:self];
    }
    
    if (self.willPresentHandler) {
        self.willPresentHandler(self);
    }
    
    LCActionSheetViewController *viewController = [[LCActionSheetViewController alloc] init];
    viewController.statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    viewController.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([UIDevice currentDevice].systemVersion.intValue == 9) { // Fix bug for keyboard in iOS 9
        window.windowLevel = CGFLOAT_MAX;
    } else {
        window.windowLevel = UIWindowLevelAlert;
    }
    window.rootViewController = viewController;
    [window makeKeyAndVisible];
    self.window = window;
    
    [viewController.view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view);
    }];
    
    [self.window layoutIfNeeded];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.darkView.userInteractionEnabled = !strongSelf.darkViewNoTaped;
        
        [strongSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(strongSelf);
        }];
        
        [strongSelf layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([strongSelf.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
            [strongSelf.delegate didPresentActionSheet:strongSelf];
        }
        
        if (strongSelf.didPresentHandler) {
            strongSelf.didPresentHandler(strongSelf);
        }
    }];
}

- (void)hideWithButtonIndex:(NSInteger)buttonIndex {
  
    
    if (self.willDismissHandler) {
        self.willDismissHandler(self, buttonIndex);
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.darkView.alpha = 0;
        strongSelf.darkView.userInteractionEnabled = NO;
        
        [strongSelf.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = (strongSelf.title.length > 0 ? strongSelf.titleTextSize.height + 2.0f + (strongSelf.titleEdgeInsets.top + strongSelf.titleEdgeInsets.bottom) : 0) + (strongSelf.otherButtonTitles.count > 0 ? (strongSelf.canScrolling ? MIN(strongSelf.visibleButtonCount, strongSelf.otherButtonTitles.count) : strongSelf.otherButtonTitles.count) * strongSelf.buttonHeight : 0) + (strongSelf.cancelButtonTitle.length > 0 ? 5.0f + strongSelf.buttonHeight : 0) + ([[UIDevice currentDevice] lc_isX] ? 34.0 : 0);
            make.bottom.equalTo(strongSelf).offset(height);
        }];
        
        [strongSelf layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeFromSuperview];
        
        
        if ([strongSelf.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
            [strongSelf.delegate actionSheet:strongSelf willDismissWithButtonIndex:buttonIndex];
        }
        
        
        strongSelf.window.rootViewController = nil;
        strongSelf.window.hidden = YES;
        strongSelf.window = nil;
        
        if ([strongSelf.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
            [strongSelf.delegate actionSheet:strongSelf didDismissWithButtonIndex:buttonIndex];
        }
        
        if (strongSelf.didDismissHandler) {
            strongSelf.didDismissHandler(strongSelf, buttonIndex);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.canScrolling) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - LCActionSheet & UITableView Delegate

- (void)darkViewClicked {
    [self cancelButtonClicked];
}

- (void)cancelButtonClicked {
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
    
    if (self.clickedHandler) {
        self.clickedHandler(self, 0);
    }
    
    [self hideWithButtonIndex:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row + 1];
    }
    
    if (self.clickedHandler) {
        self.clickedHandler(self, indexPath.row + 1);
    }
    
    [self hideWithButtonIndex:indexPath.row + 1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherButtonTitles.count;
}

- (void)setNeedSelect:(BOOL)needSelect{
    _needSelect = needSelect;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LCActionSheetCell";
    LCActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LCActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellID];
    }

    [cell setButtonEdgeInsets:self.buttonEdgeInsets];
    cell.titleLabel.font      = SIXTEENTEXTFONTSIZE;
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    if (self.needSelect) {
        if (indexPath.row == ([NoticeTools voicePlayRate]-1)) {
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        }else{
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
        }
    }
    
    if (self.needSelectkc) {
        if (indexPath.row == (self.rate-1)) {
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#1FC7FF"];
        }else{
            cell.titleLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
        }
    }
    
    cell.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    cell.titleLabel.text = self.otherButtonTitles[indexPath.row];
    
    cell.titleLabel.layer.cornerRadius = self.buttonCornerRadius;
    [cell.titleLabel.layer setMasksToBounds:YES];

    cell.cellSeparatorColor =[UIColor colorWithHexString:@"#FFFFFF"];
    
//    cell.lineView.hidden = indexPath.row == MAX(self.otherButtonTitles.count - 1, 0);
    
    if (indexPath.row == MAX(self.otherButtonTitles.count - 1, 0)) {
        cell.tag = LC_ACTION_SHEET_CELL_HIDDE_LINE_TAG;
    } else {
        cell.tag = LC_ACTION_SHEET_CELL_NO_HIDDE_LINE_TAG;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.buttonHeight;
}

@end

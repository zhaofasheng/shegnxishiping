//
//  NoticePlayBokeTimeSetView.m
//  NoticeXi
//
//  Created by li lei on 2023/12/13.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticePlayBokeTimeSetView.h"
#import "CXDatePickerConfig.h"
#import "ZFSDateFormatUtil.h"

typedef void(^doneBlock)(NSString *date);

@interface NoticePlayBokeTimeSetView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) NSInteger firstComponetRow;
@property (nonatomic, assign) NSInteger secComponetRow;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, copy) doneBlock doneBlock;
@property (nonatomic, strong) UILabel *backYearView;
@property (nonatomic, weak) UILabel *headerTitleLabel;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, strong) NSString *ymdStr;
@property (nonatomic, strong) NSString *min;
@property (nonatomic, strong) NSString *hour;

@end

@implementation NoticePlayBokeTimeSetView


- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(PickerPointX, PickerPointY, PickerWeight, PickerHeight)];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
        _datePicker.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return _datePicker;
}

- (UILabel *)backYearView {
    if (!_backYearView) {
        _backYearView = [[UILabel alloc] initWithFrame:CGRectMake(PickerPointX, PickerPointY, PickerWeight, PickerHeight)];
        _backYearView.textAlignment = NSTextAlignmentCenter;
        _backYearView.font = [UIFont systemFontOfSize:110];
        _backYearView.textColor =  RGB(228, 232, 239);
    }
    return _backYearView;
}

- (instancetype)initWithcompleteBlock:(void(^)(NSString *date))completeBlock {
    if (self = [super init]) {
        self.firstComponetRow = 0;
        self.secComponetRow = 0;
 
        self.manager = [[NoticeRiLiManager alloc] init];
        [self.manager refreshPlayDays];
    
        [self setupUI];
        
        //  设置默认选中日期
        [self.datePicker selectRow:0 inComponent:0 animated:YES];
        [self.datePicker selectRow:0 inComponent:1 animated:YES];
        [self.datePicker selectRow:0 inComponent:2 animated:YES];
        
        if (completeBlock) {
            
            self.doneBlock = ^(NSString *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}


- (void)setupUI {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
    self.showAnimationTime = 0.25;
    self.shadeViewAlphaWhenShow = ShadeViewAlphaWhenShow;
    self.datePickerColor = [UIColor blackColor];
    self.datePickerFont = [UIFont systemFontOfSize:15];
    self.topViewHeight = PickerHeaderHeight;
    self.pickerRowHeight = PickerRowHeight;
    self.pickerViewHeight = PickerHeight;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT-30, DR_SCREEN_WIDTH, 30)];
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    
    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(PickerBackViewPointX,
                                                               PickerBackViewPointYWhenHide,
                                                               PickerBackViewWeight,
                                                               PickerBackViewHeight)
                       ];
    self.buttomView.backgroundColor = [UIColor colorWithHexString:@"#292B33"];
    
    [self addSubview:self.buttomView];
    

    
    [self.buttomView addSubview:self.backYearView];
    [self.buttomView addSubview:self.datePicker];
    

    [self initPickerHeaderView];
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [self layoutIfNeeded];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

- (void)initPickerHeaderView {
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PickerBackViewWeight, PickerHeaderHeight)];
    _headerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.buttomView addSubview:_headerView];
    
    self.buttomView.layer.cornerRadius = 20;
    self.buttomView.layer.masksToBounds = YES;
    

    CGRect cancelButtonFrame  = CGRectMake(15, 0, 60, PickerHeaderHeight);
    CGRect confirmButtonFrame = CGRectMake(PickerBackViewWeight - 60 - 15, 0, 60, PickerHeaderHeight);
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    [cancelButton setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
    self.cancelButton = cancelButton;
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:cancelButton];
    
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:confirmButtonFrame];
    self.confirmButton = confirmButton;
    [confirmButton setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#00ABE4"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:confirmButton];
}

#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:self.showAnimationTime animations:^{
        CGFloat buttomViewHeight = self.pickerViewHeight + self.topViewHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight - buttomViewHeight, kScreenWidth, buttomViewHeight);
        self.backgroundColor = RGBA(0, 0, 0, self.shadeViewAlphaWhenShow);
        [self layoutIfNeeded];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:self.showAnimationTime animations:^{
        CGFloat buttomViewHeight = self.pickerViewHeight + self.topViewHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, buttomViewHeight);
        self.backgroundColor = RGBA(0, 0, 0, ShadeViewAlphaWhenHide);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)confirm {
    NSInteger row1 = [self.datePicker selectedRowInComponent:0];
    NSInteger row2 = [self.datePicker selectedRowInComponent:1];
    NSInteger row3 = [self.datePicker selectedRowInComponent:2];
    
    NoticeRiLiForWeekModel *choiceM = self.manager.daysArr[row1];
    self.ymdStr = [NSString stringWithFormat:@"%@-%02d-%02d",choiceM.year,choiceM.month.intValue,choiceM.day.intValue];
    
    if(self.firstComponetRow == 0){
        NoticeRiLiForWeekModel *hourModel = self.manager.todayHoursArr[row2];
        self.hour = hourModel.hour;
    }else{
        NoticeRiLiForWeekModel *hourModel = self.manager.nextDayHoursArr[row2];
        self.hour = hourModel.hour;
    }
    
    if(self.firstComponetRow == 0 && self.secComponetRow == 0){
        NoticeRiLiForWeekModel *minModel = self.manager.todayMinsArr[row3];
        self.min = minModel.min;
    }else{
        NoticeRiLiForWeekModel *minModel = self.manager.otherMinsArr[row3];
        self.min = minModel.min;
    }
    
    
    if(self.choiceTimeBlock){
        self.choiceTimeBlock([NSString stringWithFormat:@"%02d:%02d:00",self.hour.intValue,self.min.intValue], [NSString stringWithFormat:@"%02d",self.hour.intValue], [NSString stringWithFormat:@"%02d",self.min.intValue],[ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ %02d:%02d:00",self.ymdStr,self.hour.intValue,self.min.intValue] style:@"yyyy-MM-dd HH:mm:ss"]);
    }
    if (self.doneBlock) {
        self.doneBlock([NSString stringWithFormat:@"%@ %02d:%02d:00",self.ymdStr,self.hour.intValue,self.min.intValue]);
    }
    [self dismiss];
}

- (void)cancel {
    [self dismiss];
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return self.manager.daysArr.count;
    }else if (component == 1){
        if(self.firstComponetRow == 0){
            return self.manager.todayHoursArr.count;
        }else{
            return self.manager.nextDayHoursArr.count;
        }
    }else{
        if(self.firstComponetRow == 0 && self.secComponetRow == 0){
            return self.manager.todayMinsArr.count;
        }
        return self.manager.otherMinsArr.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _pickerRowHeight;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    NSString *title;

    if(component == 0){
        NoticeRiLiForWeekModel *dayModel = self.manager.daysArr[row];
        title = dayModel.daysName;
    }else if (component == 1){
        if(self.firstComponetRow == 0){
            NoticeRiLiForWeekModel *hourModel = self.manager.todayHoursArr[row];
            title = hourModel.hourName;
        }else{
            NoticeRiLiForWeekModel *hourModel = self.manager.nextDayHoursArr[row];
            title = hourModel.hourName;
        }
   
    }
    else if (component == 2){
        if(self.firstComponetRow == 0 && self.secComponetRow == 0){
            if(row <= self.manager.todayMinsArr.count-1){
                NoticeRiLiForWeekModel *minModel = self.manager.todayMinsArr[row];
                title = minModel.minName;
            }
            
        }else{
            NoticeRiLiForWeekModel *minModel = self.manager.otherMinsArr[row];
            title = minModel.minName;
        }
       
    }
    
    customLabel.text = title;
    customLabel.textColor = self.datePickerColor;
    customLabel.font = self.datePickerFont;

    
    for (UIView *view in self.datePicker.subviews) {
        if (view.frame.size.height <= 1) {
            view.backgroundColor = [UIColor colorWithHexString:@"#383A42"];
        }
    }
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    if (component == 0) {
        self.firstComponetRow = row;
    }

    if(component == 1){
        self.secComponetRow = row;
    }
    [self.datePicker reloadAllComponents];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.buttomView]) {
        return NO;
    }
    return YES;
}

@end

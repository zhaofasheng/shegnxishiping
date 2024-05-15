//
//  SXChoiceShopOpenTimeView.m
//  NoticeXi
//
//  Created by 赵小二 on 2024/5/15.
//  Copyright © 2024 zhaoxiaoer. All rights reserved.
//

#import "SXChoiceShopOpenTimeView.h"

@interface SXChoiceShopOpenTimeView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) NSArray *oneArr;
@property (nonatomic, strong) NSArray *twoArr;
@property (nonatomic, strong) NSArray *threeArr;
@end


@implementation SXChoiceShopOpenTimeView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        self.oneArr = @[@"每天"];
        self.twoArr = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        self.threeArr = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 438)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView setCornerOnTop:20];
        [self addSubview:self.contentView];
        
        [self.datePicker selectRow:0 inComponent:0 animated:YES];
        [self.datePicker selectRow:0 inComponent:1 animated:YES];
        [self.datePicker selectRow:0 inComponent:2 animated:YES];
        
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, DR_SCREEN_WIDTH-120,50)];
        contentL.font = XGEightBoldFontSize;
        contentL.textColor = [UIColor colorWithHexString:@"#14151A"];
        contentL.text = @"设置营业时间";
        contentL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:contentL];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
        [cancelBtn setImage:UIImageNamed(@"sx_blackclose1_img") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
                

        self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 360, DR_SCREEN_WIDTH-30, 44)];
        self.addButton.layer.cornerRadius = 22;
        self.addButton.layer.masksToBounds = YES;
        self.addButton.backgroundColor = [UIColor colorWithHexString:@"#14151A"];
        [self.addButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];

        [self.addButton setTitle:@"确认修改为：每天00:00-23:55营业" forState:UIControlStateNormal];
        self.addButton.titleLabel.font = SIXTEENTEXTFONTSIZE;
        [self.contentView addSubview:self.addButton];
        [self.addButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.isStart = YES;
        
        CGFloat space = (DR_SCREEN_WIDTH-136*2)/3;
        
        self.startView = [[UIView  alloc] initWithFrame:CGRectMake(space, 74, 136, 72)];
        self.startView.layer.cornerRadius = 8;
        self.startView.layer.masksToBounds = YES;
        self.startView.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
        self.startView.layer.borderWidth = 2;
        self.startView.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.1];
        [self.contentView addSubview:self.startView];
        
        UILabel *titleL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 12, 136, 18)];
        titleL.font = THRETEENTEXTFONTSIZE;
        titleL.text = @"开始时间";
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.startView addSubview:titleL];
        
        self.startTimeL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 38, 136, 18)];
        self.startTimeL.font = XGFifthBoldFontSize;
        self.startTimeL.text = @"00:00";
        self.startTimeL.textAlignment = NSTextAlignmentCenter;
        self.startTimeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.startView addSubview:self.startTimeL];
        
        self.startView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTap)];
        [self.startView addGestureRecognizer:tap];
        
        self.endView = [[UIView  alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.startView.frame)+space, 74, 136, 72)];
        self.endView.layer.cornerRadius = 8;
        self.endView.layer.masksToBounds = YES;
        self.endView.layer.borderColor = [UIColor colorWithHexString:@"#F0F1F5"].CGColor;
        self.endView.layer.borderWidth = 1;
        self.endView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:self.endView];
        
        UILabel *titleL1 = [[UILabel  alloc] initWithFrame:CGRectMake(0, 12, 136, 18)];
        titleL1.font = THRETEENTEXTFONTSIZE;
        titleL1.text = @"结束时间";
        titleL1.textAlignment = NSTextAlignmentCenter;
        titleL1.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.endView addSubview:titleL1];
        
        self.endTimeL = [[UILabel  alloc] initWithFrame:CGRectMake(0, 38, 136, 18)];
        self.endTimeL.font = XGFifthBoldFontSize;
        self.endTimeL.text = @"23:55";
        self.endTimeL.textAlignment = NSTextAlignmentCenter;
        self.endTimeL.textColor = [UIColor colorWithHexString:@"#14151A"];
        [self.endView addSubview:self.endTimeL];
        
        self.endView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTap)];
        [self.endView addGestureRecognizer:tap1];
        

    }
    return self;
}

- (void)startTap{
    self.isStart = YES;
    self.startView.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    self.startView.layer.borderWidth = 2;
    self.startView.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.1];
    
    self.endView.layer.borderColor = [UIColor colorWithHexString:@"#F0F1F5"].CGColor;
    self.endView.layer.borderWidth = 1;
    self.endView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
}

- (void)endTap{
    self.isStart = NO;
    self.endView.layer.borderColor = [UIColor colorWithHexString:@"#1FC7FF"].CGColor;
    self.endView.layer.borderWidth = 2;
    self.endView.backgroundColor = [[UIColor colorWithHexString:@"#1FC7FF"] colorWithAlphaComponent:0.1];
    
    self.startView.layer.borderColor = [UIColor colorWithHexString:@"#F0F1F5"].CGColor;
    self.startView.layer.borderWidth = 1;
    self.startView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
}

- (void)saveClick{
    [self cancelClick];
}


- (void)showATView{
    [self.datePicker reloadAllComponents];
    UIWindow *rootWindow = [SXTools getKeyWindow];
    [rootWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.contentView.frame.size.height, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    }];
}

- (void)cancelClick{

    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,182, DR_SCREEN_WIDTH, 360-182)];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
        _datePicker.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_datePicker];
    }
    return _datePicker;
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return self.oneArr.count;
    }else if (component == 1){
        return self.twoArr.count;
    }else{
        return self.threeArr.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 37;
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
        title = @"每天";
    }else if (component == 1){
        title = [NSString stringWithFormat:@"%@点",self.twoArr[row]];
    }
    else if (component == 2){
        title = [NSString stringWithFormat:@"%@分",self.threeArr[row]];
    }
    
    customLabel.text = title;
    customLabel.textColor = [UIColor colorWithHexString:@"#14151A"];
    customLabel.font = XGEightBoldFontSize;

    
    for (UIView *view in self.datePicker.subviews) {
        if (view.frame.size.height <= 1) {
            view.backgroundColor = [UIColor colorWithHexString:@"#383A42"];
        }
    }
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger row2 = [self.datePicker selectedRowInComponent:1];
    NSInteger row3 = [self.datePicker selectedRowInComponent:2];
    if (self.isStart) {
        self.startTimeL.text = [NSString stringWithFormat:@"%@:%@",self.twoArr[row2],self.threeArr[row3]];
    }else{
        self.endTimeL.text = [NSString stringWithFormat:@"%@:%@",self.twoArr[row2],self.threeArr[row3]];
    }
 
    [self.datePicker reloadAllComponents];
}

@end

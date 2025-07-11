//
//  CustomPickerView.h
//  eCamera
//
//  Created by wsg on 2017/4/18.
//  Copyright © 2017年 wsg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyPickerViewDelegate <NSObject>

@optional

/**
 pickerView选中item代理
 @param row 选中的row
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row;
- (void)selectTitlt:(NSString *)str tag:(NSInteger)tag;
///** PickerView 开始滚动 */
//- (void)pickerViewBeginScroll;
@end

@interface CustomPickerView : UIView
@property (nonatomic, assign) BOOL isNomerData;
/** PickerView 数据源 */
@property (nonatomic,strong) NSMutableArray *dataModel;
/** 当前选择器选择的元素 （NSDictionary 类型， name：选择元素名称  index：选择元素位置）*/
@property (nonatomic,strong,readonly) NSDictionary *selectedItem;
/** 滑动到指定位置 */
@property (nonatomic,assign,setter=scrollToIndex:) NSInteger scrollToIndex;
/** pickerView代理 */
@property (nonatomic,weak) id<MyPickerViewDelegate> delegate;

- (void)reloadData;
@end

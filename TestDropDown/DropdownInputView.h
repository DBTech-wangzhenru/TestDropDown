//
//  DropdownInputView.h
//  TestDropDown
//
//  Created by wzr on 2024/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DropdownInputView : UIView

@property (nonatomic, strong) NSArray<NSString *> *options;     // 下拉选项
@property (nonatomic, assign) NSInteger selectedIndex;          // 默认选中项索引
@property (nonatomic, copy) void (^onOptionSelected)(NSString *selectedOption); // 回调函数

- (instancetype)initWithFrame:(CGRect)frame options:(NSArray<NSString *> *)options;

@end

NS_ASSUME_NONNULL_END

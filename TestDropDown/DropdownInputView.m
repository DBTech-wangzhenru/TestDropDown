//
//  DropdownInputView.m
//  TestDropDown
//
//  Created by wzr on 2024/12/11.
//

#import "DropdownInputView.h"

@interface DropdownInputView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *containerView;       // 容器视图
@property (nonatomic, strong) UITextField *inputField;     // 输入框
@property (nonatomic, strong) UIButton *dropdownIcon;      // 下拉图标按钮
@property (nonatomic, strong) UITableView *dropdownTable;  // 下拉菜单
@property (nonatomic, assign) BOOL isDropdownVisible;      // 下拉菜单是否可见

@end

@implementation DropdownInputView

- (instancetype)initWithFrame:(CGRect)frame options:(NSArray<NSString *> *)options {
    self = [super initWithFrame:frame];
    if (self) {
        self.options = options;
        self.selectedIndex = 0; // 默认选中第一个
        self.isDropdownVisible = NO;
        
        // 创建容器视图
        self.containerView = [[UIView alloc] initWithFrame:self.bounds];
        self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.containerView.layer.borderWidth = 1.0;
        self.containerView.layer.cornerRadius = 8;
        self.containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.containerView];
        
        // 创建输入框
        self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 40, 30)];
        self.inputField.text = self.options[self.selectedIndex]; // 设置默认选中项
        self.inputField.borderStyle = UITextBorderStyleNone;
        self.inputField.enabled = NO; // 禁用手动输入
        [self.containerView addSubview:self.inputField];
        
        // 创建下拉图标按钮
        self.dropdownIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        self.dropdownIcon.frame = CGRectMake(frame.size.width - 30, 10, 20, 30);
        [self.dropdownIcon setImage:[UIImage systemImageNamed:@"chevron.down"] forState:UIControlStateNormal];
        [self.dropdownIcon addTarget:self action:@selector(toggleDropdown) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.dropdownIcon];
        
        // 创建下拉菜单
        self.dropdownTable = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + frame.size.height, frame.size.width, 0)];
        self.dropdownTable.delegate = self;
        self.dropdownTable.dataSource = self;
        self.dropdownTable.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.dropdownTable.layer.borderWidth = 1.0;
        self.dropdownTable.layer.cornerRadius = 8;
        self.dropdownTable.clipsToBounds = YES;
    }
    return self;
}

// 显示或隐藏下拉菜单
- (void)toggleDropdown {
    UIWindow *keyWindow = nil;
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] &&
            scene.activationState == UISceneActivationStateForegroundActive) {
            keyWindow = scene.windows.firstObject;
            break;
        }
    }

    CGRect tableFrame = [self.containerView convertRect:self.containerView.bounds toView:keyWindow];
    
    if (self.isDropdownVisible) {
        // 隐藏菜单
        self.isDropdownVisible = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.dropdownTable.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y + tableFrame.size.height, tableFrame.size.width, 0);
        } completion:^(BOOL finished) {
            [self.dropdownTable removeFromSuperview];
        }];
    } else {
        // 显示菜单
        self.isDropdownVisible = YES;
        if (![keyWindow.subviews containsObject:self.dropdownTable]) {
            [keyWindow addSubview:self.dropdownTable];
        }
        self.dropdownTable.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y + tableFrame.size.height, tableFrame.size.width, 0);
        
        CGFloat dropdownHeight = MIN(self.options.count * 44, 150); // 动态计算高度
        [UIView animateWithDuration:0.3 animations:^{
            self.dropdownTable.frame = CGRectMake(tableFrame.origin.x, tableFrame.origin.y + tableFrame.size.height, tableFrame.size.width, dropdownHeight);
        }];
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DropdownCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.options[indexPath.row];
    
    // 高亮当前选中项
    if (indexPath.row == self.selectedIndex) {
        cell.textLabel.textColor = [UIColor systemBlueColor];
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    } else {
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    self.inputField.text = self.options[self.selectedIndex]; // 更新输入框内容
    self.isDropdownVisible = NO;
    
    // 回调选中的选项
    if (self.onOptionSelected) {
        self.onOptionSelected(self.options[self.selectedIndex]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.dropdownTable.frame = CGRectMake(self.dropdownTable.frame.origin.x, self.dropdownTable.frame.origin.y, self.dropdownTable.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.dropdownTable removeFromSuperview];
        [self.dropdownTable reloadData]; // 重新加载以更新高亮状态
    }];
}

@end


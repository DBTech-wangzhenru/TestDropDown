//
//  ViewController.m
//  TestDropDown
//
//  Created by wzr on 2024/12/11.
//

#import "ViewController.h"
#import "DropdownInputView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建第一个下拉组件
    DropdownInputView *dropdown1 = [[DropdownInputView alloc] initWithFrame:CGRectMake(50, 100, 250, 50) options:@[@"Option A", @"Option B", @"Option C"]];
    dropdown1.onOptionSelected = ^(NSString *selectedOption) {
        NSLog(@"Selected: %@", selectedOption);
    };
    [self.view addSubview:dropdown1];
    
    // 创建第二个下拉组件
    DropdownInputView *dropdown2 = [[DropdownInputView alloc] initWithFrame:CGRectMake(50, 200, 250, 50) options:@[@"Apple", @"Banana", @"Cherry"]];
    dropdown2.selectedIndex = 1; // 设置默认选中项
    dropdown2.onOptionSelected = ^(NSString *selectedOption) {
        NSLog(@"Selected: %@", selectedOption);
    };
    [self.view addSubview:dropdown2];
}

@end


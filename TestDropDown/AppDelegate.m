//
//  AppDelegate.m
//  TestDropDown
//
//  Created by wzr on 2024/12/11.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 日期字符串数组
            NSArray *dateStrings = @[
                @"令和元年1月31日",
                @"平成15年8月2日",
                @"1987年6月27日",
                @"1987年6月27日生"
            ];
            
            // 正则表达式，支持和历与西历格式
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?:(令和|平成|昭和|大正|明治)|(\\d+))((元|\\d+)?)年(\\d+)月(\\d+)日" options:0 error:nil];
            
            for (NSString *dateString in dateStrings) {
                NSTextCheckingResult *match = [regex firstMatchInString:dateString options:0 range:NSMakeRange(0, dateString.length)];
                
                if (match) {
                    NSString *era = nil;
                    NSString *year = nil;
                    NSString *month = nil;
                    NSString *day = nil;
                    
                    // 提取年号或西历年
                    if ([match rangeAtIndex:1].location != NSNotFound) { // 和历年号
                        era = [dateString substringWithRange:[match rangeAtIndex:1]];
                    } else if ([match rangeAtIndex:2].location != NSNotFound) { // 西历
                        year = [dateString substringWithRange:[match rangeAtIndex:2]];
                    }
                    
                    // 提取和历的年份或元年处理
                    if ([match rangeAtIndex:3].location != NSNotFound && era) {
                        NSString *yearPart = [dateString substringWithRange:[match rangeAtIndex:3]];
                        if ([yearPart isEqualToString:@"元"]) {
                            year = @"1"; // 元年处理为 1
                        } else {
                            year = yearPart;
                        }
                    }
                    
                    // 提取月和日
                    if ([match rangeAtIndex:5].location != NSNotFound) {
                        month = [dateString substringWithRange:[match rangeAtIndex:5]];
                    }
                    if ([match rangeAtIndex:6].location != NSNotFound) {
                        day = [dateString substringWithRange:[match rangeAtIndex:6]];
                    }
                    
                    // 打印提取结果
                    if (era) {
                        NSLog(@"Date String: %@, Era: %@, Year: %@, Month: %@, Day: %@", dateString, era, year, month, day);
                    } else {
                        NSLog(@"Date String: %@, Year: %@, Month: %@, Day: %@", dateString, year, month, day);
                    }
                } else {
                    NSLog(@"未匹配日期字符串: %@", dateString);
                }
            }
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

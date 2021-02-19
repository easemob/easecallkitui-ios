//
//  UIStoryboard+Category.m
//  EaseCallDemo
//
//  Created by 杜洁鹏 on 2021/2/19.
//

#import "UIStoryboard+Category.h"

@implementation UIStoryboard (Category)
+ (UIViewController *)loadViewControllerWithClassName:(NSString *)aClassName {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:aClassName];
    if (!vc) {
        vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ErrorViewController"];
    }
    return vc;
}
@end

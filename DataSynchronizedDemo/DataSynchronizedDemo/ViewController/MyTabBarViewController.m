//
//  MyTabBarViewController.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/6.
//  Copyright © 2019 piu. All rights reserved.
//

#import "MyTabBarViewController.h"

@interface MyTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
//    for (UIViewController *vc in self.viewControllers) {
//        [vc view];
//    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    CATransition *animation =[CATransition animation];
    [animation setDuration:0.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setSubtype:kCATransitionFade];
    [tabBarController.view.layer addAnimation:animation forKey:@"reveal"];
    return YES;
}

@end

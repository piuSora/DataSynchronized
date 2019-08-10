//
//  MyTabBarViewController.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/6.
//  Copyright © 2019 piu. All rights reserved.
//

#import "MyTabBarViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIViewController *vc in self.viewControllers) {
        [vc view];
    }

}

@end

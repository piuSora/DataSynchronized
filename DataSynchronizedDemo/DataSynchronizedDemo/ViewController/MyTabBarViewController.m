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
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

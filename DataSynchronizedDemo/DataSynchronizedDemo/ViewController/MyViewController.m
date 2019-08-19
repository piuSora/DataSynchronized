//
//  MyViewController.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/13.
//  Copyright © 2019 piu. All rights reserved.
//

#import "MyViewController.h"
#import "DataSynchronized.h"
#import "MyModel.h"

@interface MyViewController ()

@property (nonatomic, strong) MyModel *data;

@end

@implementation MyViewController

- (void)viewDidLoad {
    self.view.backgroundColor = UIColor.orangeColor;
    [super viewDidLoad];
    [self testing];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:true completion:nil];
    });
}

- (void)dealloc{
    
}

- (void)testing{
    self.data = [[MyModel alloc] initWithMyID:@"0" myName:@"0" isFollow:false];
    [self.data addDataSynchronizedKeyPath:@"myName" IDPath:@"myID" onChange:^(id  _Nonnull model) {
    }];
}

@end

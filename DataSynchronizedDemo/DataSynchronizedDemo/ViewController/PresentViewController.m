//
//  PresentViewController.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/9.
//  Copyright © 2019 piu. All rights reserved.
//

#import "PresentViewController.h"
#import "DataSynchronized.h"
#import "MyModel.h"

@interface PresentViewController ()

@property (nonatomic, strong) MyModel *data;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self data];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (MyModel *)data{
    if (!_data) {
        _data = [[MyModel alloc] initWithMyID:@"4" myName:@"PresentVC" isFollow:true];
    }
    [_data addDataSynchronizedKeyPath:@"myName" IDPath:@"myID" onChange:nil];
    return _data;
}

@end

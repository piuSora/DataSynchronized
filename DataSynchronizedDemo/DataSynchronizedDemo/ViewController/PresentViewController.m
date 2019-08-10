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

@property (nonatomic, strong) NSArray *data;

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
- (NSArray *)data{
    if (!_data) {
        NSMutableArray *d = @[].mutableCopy;
        for (int i = 0; i < 1000; i++) {
            MyModel *tmp = [[MyModel alloc] initWithMyID:@"4" myName:@"PresentVC" isFollow:true];
            [d addObject:tmp];
        }
        _data = [NSArray arrayWithArray:d];
    }
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
//    [_data addDataSynchronizedKeyPath:@"myName" IDPath:@"myID" onChange:nil];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"耗时::::>%.4f",end - start);
    return _data;
}

@end

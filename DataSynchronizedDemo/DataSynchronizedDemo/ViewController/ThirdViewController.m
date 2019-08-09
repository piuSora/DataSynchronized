//
//  ThirdViewController.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/5.
//  Copyright © 2019 piu. All rights reserved.
//

#import "ThirdViewController.h"
#import "DataSynchronized.h"
#import "MyModel.h"
#import "OtherModel.h"

@interface ThirdViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) OtherModel *data;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
//    for (int i = 0; i < 10000; i++) {
//        [self testing];
//    }
}

- (void)testing{
    MyModel *model = [[MyModel alloc] initWithMyID:@"3" myName:@"Jason" isFollow:true];
    [model addDataSynchronizedKeyPath:@"myName" IDPath:@"myID" onChange:nil];
}

#pragma mark - UI

- (void)configView{
//    self.textField.text = self.data.otherName;
//    self.textField.delegate = self;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self.view addGestureRecognizer:tap];
}

- (void)tapAction{
    [self.textField resignFirstResponder];
}

#pragma mark - delegate & datasource

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.data.otherName = textField.text;
}

#pragma mark - action

#pragma mark - method & utils

#pragma mark - net request

#pragma mark - setter & getter

- (OtherModel *)data{
    if (!_data) {
        _data = [[OtherModel alloc] initWithID:@"0" name:@"name"];
    }
    __weak typeof(self)weakSelf = self;
    [_data bindingDataSynchronizedTo:MyModel.class keyPaths:@{@"myName":@"otherName",@"myInfo":@"otherName"} IDPath:@"otherID" onChange:^(OtherModel * _Nonnull model) {
        weakSelf.textField.text = model.otherName;
    }];
    return _data;
}

@end

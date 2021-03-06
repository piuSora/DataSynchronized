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
}

#pragma mark - UI

- (void)configView{
    self.textField.text = self.data.otherName;
    self.textField.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
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
    /*
     把data(OtherModel)绑定到MyModel类上
     data.otherName与MyModel.myName绑定
     将data.othrID作为绑定的改变标识符
     */
    [_data bindingDataSynchronizedTo:MyModel.class keyPaths:@{@"myName":@"otherName"} IDPath:@"otherID" onChange:^(OtherModel * _Nonnull model) {
        weakSelf.textField.text = model.otherName;
    }];
    return _data;
}

@end

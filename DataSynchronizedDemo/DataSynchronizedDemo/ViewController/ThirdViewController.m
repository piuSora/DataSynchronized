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
    // Do any additional setup after loading the view.
}

#pragma mark - UI

- (void)configView{
    self.textField.text = self.data.otherName;
    self.textField.delegate = self;
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
    [_data bindingDataSynchronizedTo:MyModel.class keyPath:@"otherName" IDPath:@"otherID" onChange:^(OtherModel *  _Nonnull model) {
        weakSelf.textField.text = model.otherName;
    }];
    return _data;
}

@end

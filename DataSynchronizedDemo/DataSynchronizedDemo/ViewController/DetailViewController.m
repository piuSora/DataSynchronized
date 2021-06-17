//
//  DetailViewController.m
//  DataSynchronizedDemo
//
//  Created by iOSzhang Inc on 21/6/17.
//  Copyright © 2021 piu. All rights reserved.
//

#import "DetailViewController.h"
#import "DataSyncAdd.h"

@interface DetailViewController ()<UITextFieldDelegate>

/// <#Description#>
@property (nonatomic, strong) SubModel *subModel;

/// <#Description#>
@property (nonatomic, strong) UILabel *idLabel;

/// <#Description#>
@property (nonatomic, strong) UITextField *nameTF;

/// <#Description#>
@property (nonatomic, strong) UITextField *infoTF;

/// <#Description#>
@property (nonatomic, strong) UIButton *followButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.idLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 300, 30)];
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.idLabel.frame)+8, 300, 30)];
    self.nameTF.delegate = self;
    self.infoTF = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.nameTF.frame)+8, 300, 30)];
    self.infoTF.delegate = self;
    self.followButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.infoTF.frame)+8, 80, 30)];
    [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.followButton setTitle:@"UnFollow" forState:UIControlStateSelected];
    [self.followButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.idLabel];
    [self.view addSubview:self.nameTF];
    [self.view addSubview:self.infoTF];
    [self.view addSubview:self.followButton];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.subModel) {
        self.subModel = [[SubModel alloc] initWithMyID:self.orignModel.myID myName:self.orignModel.myName isFollow:self.orignModel.isFollow];
        self.idLabel.text = self.subModel.myID;
        self.nameTF.text = self.subModel.myName;
        self.infoTF.text = self.subModel.detailInfo;
        self.followButton.selected = self.subModel.isFollow;
        __weak typeof(self) weakSelf = self;
        [self.subModel addDataSynchronizedKeyPath:@"myName,myInfo,isFollow" IDPath:@"myID" isPenetrate:true onChange:^(SubModel * _Nonnull model) {
            weakSelf.idLabel.text = model.myID;
            weakSelf.nameTF.text = model.myName;
            weakSelf.infoTF.text = model.detailInfo;
            weakSelf.followButton.selected = model.isFollow;
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.nameTF resignFirstResponder];
    [self.infoTF resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.infoTF]) {
        return true;
    }
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.nameTF]) {
        self.subModel.myName = textField.text;
    } else if ([textField isEqual:self.infoTF]) {
        self.subModel.detailInfo = textField.text;
    }
}

- (IBAction)followButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.subModel.isFollow = sender.selected;
}


@end

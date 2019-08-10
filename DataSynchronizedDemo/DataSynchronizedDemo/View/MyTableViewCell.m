//
//  MyTableViewCell.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/5.
//  Copyright © 2019 piu. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;

@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameField.delegate = self;
    // Initialization code
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.model.myName = textField.text;
    self.model.otherModel.otherName = textField.text;
    return true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MyModel *)model{
    _model = model;
    self.nameField.text = model.myName;
    self.followBtn.selected = model.isFollow;
    self.IDLabel.text = model.myID;
}

- (IBAction)followAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.model.isFollow = sender.isSelected;
}

@end

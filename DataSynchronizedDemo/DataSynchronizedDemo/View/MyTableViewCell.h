//
//  MyTableViewCell.h
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/5.
//  Copyright © 2019 piu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) MyModel *model;

@end

NS_ASSUME_NONNULL_END

//
//  MyModel.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/5.
//  Copyright © 2019 piu. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel

- (instancetype)initWithMyID:(NSString *)ID myName:(NSString *)name isFollow:(BOOL)isFollow{
    if (self = [super init]) {
        _myID = ID;
        _myName = name;
        _isFollow = isFollow;
    }
    return self;
}


@end

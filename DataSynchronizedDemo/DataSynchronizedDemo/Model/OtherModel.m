//
//  OtherModel.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/6.
//  Copyright © 2019 piu. All rights reserved.
//

#import "OtherModel.h"

@implementation OtherModel

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name{
    if (self = [super init]) {
        _otherID = ID;
        _otherName = name;
    }
    return self;
}

@end

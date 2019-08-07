//
//  DataSyncModel.m
//  AhaIt
//
//  Created by 呼哈哈 on 2019/7/31.
//  Copyright © 2019 zlee. All rights reserved.
//

#import "DataSyncModel.h"


@implementation DataSyncModel

- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                        IDPath:(NSString *)IDPath
                      onChange:(OnChange)onChange{
    if (self = [super init]) {
        _object = object;
        _keyPath = keyPath;
        _IDPath = IDPath;
        _onChange = onChange;
    }
    return self;
}

@end

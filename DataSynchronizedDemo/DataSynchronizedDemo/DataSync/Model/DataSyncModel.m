//
//  DataSyncModel.m
//  AhaIt
//
//  Created by 呼哈哈 on 2019/7/31.
//  Copyright © 2019 zlee. All rights reserved.
//

#import "DataSyncModel.h"
#import "DataSynchronized.h"


@implementation DataSyncModel

- (instancetype)initWithObject:(id)object
                       keyPaths:(NSDictionary *)keyPaths
                        IDPath:(NSString *)IDPath
                      onChange:(OnChange)onChange{
    if (self = [super init]) {
        _object = object;
        _keyPaths = keyPaths;
        _IDPath = IDPath;
        _onChange = onChange;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"SyncModel dealloc");
}

@end

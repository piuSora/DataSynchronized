//
//  DataSyncInfo.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/7/31.
//  Copyright © 2019 piu. All rights reserved.
//

#import "DataSyncInfo.h"
#import "DataSynchronizedBase.h"


@implementation DataSyncInfo

- (instancetype)initWithObject:(id)object
                       keyPaths:(NSDictionary *)keyPaths
                        IDPath:(NSString *)IDPath
                      onChange:(OnChange)onChange{
    return [self initWithObject:object keyPaths:keyPaths IDPath:IDPath isPenetrate:true onChange:onChange];
}

- (instancetype)initWithObject:(id)object keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath isPenetrate:(BOOL)isPenetrate onChange:(OnChange)onChange {
    if (self = [super init]) {
        _object = object;
        _keyPaths = keyPaths;
        _IDPath = IDPath;
        _isPenetrate = isPenetrate;
        _onChange = onChange;
    }
    return self;
}
@end

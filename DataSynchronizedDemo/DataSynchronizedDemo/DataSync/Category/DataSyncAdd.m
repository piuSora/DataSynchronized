//
//  DataSyncAdd.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/7/29.
//  Copyright © 2019 piu. All rights reserved.
//

#import "DataSyncAdd.h"
#import <objc/runtime.h>

@implementation NSArray (DataSynchronized)

- (void)addDataSynchronizedKeyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    for (id object in self) {
        [object addDataSynchronizedKeyPath:keyPath IDPath:IDPath onChange:onChange];
    }
}

- (void)bindingDataSynchronizedTo:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    for (id object in self) {
        [object bindingDataSynchronizedTo:cls keyPaths:keyPaths IDPath:IDPath onChange:onChange];
    }
}

@end

@interface NSObject ()
@property (nonatomic, strong) DataSynchronizedManager *yf_ds_manager;
@end

@implementation NSObject (DataSynchronized)

- (void)addDataSynchronizedKeyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    [self.yf_ds_manager addDataSynchronizedWith:self keyPath:keyPath IDPath:IDPath onChange:onChange];
}

- (void)bindingDataSynchronizedTo:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    [self.yf_ds_manager bindingDataSynchronizedObject:self toClass:cls keyPaths:keyPaths IDPath:IDPath onChange:onChange];
}

#pragma mark - setter & getter

- (void)setYf_ds_manager:(DataSynchronizedManager *)yf_ds_manager{
    objc_setAssociatedObject(self, @selector(yf_ds_manager), yf_ds_manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DataSynchronizedManager *)yf_ds_manager{
    DataSynchronizedManager *manager = objc_getAssociatedObject(self, @selector(yf_ds_manager));
    if (!manager) {
        manager = [[DataSynchronizedManager alloc] init];
        [self setYf_ds_manager:manager];
    }
    return manager;
}

@end


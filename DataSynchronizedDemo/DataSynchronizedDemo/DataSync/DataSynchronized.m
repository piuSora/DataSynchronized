//
//  DataSynchronized.m
//  AhaIt
//
//  Created by 呼哈哈 on 2019/7/29.
//  Copyright © 2019 zlee. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DataSynchronized.h"
#import <malloc/malloc.h>

@interface DataSynchronized ()

@property (nonatomic, strong) NSMutableDictionary *observerData;
@property (nonatomic, assign) BOOL kvoLock;

@end

@implementation DataSynchronized

static DataSynchronized *_shared = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:nil] init];
    });
    return _shared;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [DataSynchronized sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone{
    return _shared;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return _shared;
}

#pragma mark ---

- (void)addDataSynchronizedWith:(id)object keyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    [self bindingDataSynchronizedObject:object toClass:[object class] keyPath:keyPath IDPath:IDPath onChange:onChange];
}

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    NSString *cacheKey = NSStringFromClass(cls);
    NSString *IDKey = [object valueForKeyPath:IDPath];
    NSMutableDictionary *subIdMap = self.observerData[cacheKey];
    NSMutableArray <DataSyncModel *>*dataArray = subIdMap[IDKey];
    if (!subIdMap) {
        subIdMap = @{}.mutableCopy;
        self.observerData[cacheKey] = subIdMap;
    }
    if (!dataArray) {
        dataArray = @[].mutableCopy;
        subIdMap[IDKey] = dataArray;
    }
    if ([self checkDuplicate:dataArray object:object]) {
        return;
    }
    DataSyncModel *data = [[DataSyncModel alloc] initWithObject:object keyPath:keyPath IDPath:IDPath onChange:onChange];
    [dataArray addObject:data];
    
    NSDictionary *dic = @{@"KvoIdentifier":_shared,@"CacheKey":cacheKey,@"IDKey":IDKey};
    
    NSArray *keyPaths = [data.keyPath componentsSeparatedByString:@","];
    
    for (NSString *keyPath in keyPaths) {
        [data addObserver:self forKeyPath:[NSString stringWithFormat:@"object.%@",keyPath] options:NSKeyValueObservingOptionNew context:(__bridge_retained void*)dic];
    }
}

- (void)cleanZombieObjectWithCacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey{
    NSMutableArray <DataSyncModel *>*dataMap = self.observerData[cacheKey][IDKey];
    for (int i = 0; i < dataMap.count; i++) {
        if (!dataMap[i].object) {
            [dataMap removeObjectAtIndex:i];
        }
    }
}

- (BOOL)checkDuplicate:(NSMutableArray <DataSyncModel *>*)array object:(id)object{
    for (DataSyncModel *model in array) {
        if (model.object == object) {
            return true;
        }
    }
    return false;
}

- (void)checkZombieObject{
    [self.observerData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableDictionary *  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSMutableArray *  _Nonnull obj, BOOL * _Nonnull stop) {
            for (DataSyncModel *model in obj) {
                if (!model.object) {
                    NSLog(@"FIND ZOMBIE OBJECT:%@",key);
                }
            }
        }];
    }];
    NSLog(@"Check Finished");
}

//observe implementation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(DataSyncModel *)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSDictionary *info = (__bridge NSDictionary*)context;
    if (info[@"KvoIdentifier"] == _shared) {//prevent super-class observe called
        NSString *cacheKey = info[@"CacheKey"];
        NSString *IDKey = info[@"IDKey"];
        if (!self.kvoLock && cacheKey.length && IDKey.length) {
            for (DataSyncModel *model in self.observerData[cacheKey][IDKey]) {
                self.kvoLock = true;//prevent recursive lock
                //TODO:似乎应该设置model.keyPath。。数据绑定的时候再测试吧
                NSArray *dataKeys = [object.keyPath componentsSeparatedByString:@","];
                NSMutableArray *fullKeys = @[].mutableCopy;
                for (NSString *key in dataKeys) {
                     [fullKeys addObject:[NSString stringWithFormat:@"object.%@",key]];
                }
                if ([fullKeys containsObject:keyPath]) {
                    [model setValue:change[NSKeyValueChangeNewKey] forKeyPath:model.keyPath];
                }
                if (model.onChange) {
                    model.onChange(object.object);
                }
                self.kvoLock = false;
            }
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - setter & getter
- (NSMutableDictionary *)observerData{
    if (!_observerData) {
        _observerData = @{}.mutableCopy;
    }
    return _observerData;
}

@end

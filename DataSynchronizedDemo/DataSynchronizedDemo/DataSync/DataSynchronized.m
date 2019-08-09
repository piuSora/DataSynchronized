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
    NSArray *paths = [keyPath componentsSeparatedByString:@","];
    NSMutableDictionary *keyPaths = @{}.mutableCopy;
    for (NSString *val in paths) {
        keyPaths[val] = val;
    }
    [self bindingDataSynchronizedObject:object toClass:[object class] keyPaths:[NSDictionary dictionaryWithDictionary:keyPaths] IDPath:IDPath onChange:onChange];
}

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
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
    
    NSMutableDictionary *handledKeys = @{}.mutableCopy;
    
    [keyPaths enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        handledKeys[[NSString stringWithFormat:@"object.%@",key]] = [NSString stringWithFormat:@"object.%@",obj];
    }];
    keyPaths = handledKeys.copy;
    
    DataSyncModel *data = [[DataSyncModel alloc] initWithObject:object keyPaths:keyPaths IDPath:IDPath onChange:onChange];
    [dataArray addObject:data];
    NSDictionary *dic = @{@"KvoIdentifier":_shared,@"CacheKey":cacheKey,@"IDKey":IDKey};
    [keyPaths enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        [data addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew context:(__bridge_retained void *)dic];
    }];
}

- (void)cleanDataSyncKVOWithCacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey{
    NSMutableArray <DataSyncModel *>*dataMap = self.observerData[cacheKey][IDKey];
    for (int i = 0; i < dataMap.count; i++) {
        [dataMap[i].keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [dataMap[i] removeObserver:self forKeyPath:obj];
        }];
    }
}

-(void)cleanZombieObject:(id)object CacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey{
    NSMutableArray <DataSyncModel *>*dataMap = self.observerData[cacheKey][IDKey];
    for (int i = 0; i < dataMap.count; i++) {
        if (!dataMap[i].object) {
            //if crash here, you didn't clean the observance correctly,please call cleanDataSyncKVO method
            [dataMap[i].keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [dataMap[i] removeObserver:self forKeyPath:obj];
            }];
            [dataMap removeObjectAtIndex:i];
        }
    }
}

- (void)cleanZombieObjectWithCacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey{
    NSMutableArray <DataSyncModel *>*dataMap = self.observerData[cacheKey][IDKey];
    for (int i = 0; i < dataMap.count; i++) {
        if (!dataMap[i].object) {
            //if crash here, you didn't clean the observance correctly,please call cleanDataSyncKVO method
            [dataMap[i].keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [dataMap[i] removeObserver:self forKeyPath:obj];
            }];
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

//observe implementation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(DataSyncModel *)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSDictionary *info = (__bridge NSDictionary*)context;
    if (info[@"KvoIdentifier"] == _shared) {//prevent super-class observe called
        NSString *cacheKey = info[@"CacheKey"];
        NSString *IDKey = info[@"IDKey"];
        NSArray *bindingPaths = [object.keyPaths allKeysForObject:keyPath];
        if (!self.kvoLock && cacheKey.length && IDKey.length) {
            //遍历所有绑定对象
            for (DataSyncModel *model in self.observerData[cacheKey][IDKey]) {
                self.kvoLock = true;//prevent recursive lock
                //遍历绑定对象的所有结点
                [model.keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    //多个key绑定同个数据源的情况不处理了 减少复杂度
                    if ([bindingPaths containsObject:key]) {
                        [model setValue:change[NSKeyValueChangeNewKey] forKeyPath:model.keyPaths[key]];
                        if (model.onChange) {
                            model.onChange(model.object);
                        }
                    }
                }];
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

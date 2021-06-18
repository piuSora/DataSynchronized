//
//  DataSynchronizedBase.m
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/7/29.
//  Copyright © 2019 piu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DataSynchronizedBase.h"

@interface DataSynchronizedBase ()

@property (nonatomic, strong) NSMutableDictionary *observerData;
@property (nonatomic, assign) BOOL kvoLock;
@property (nonatomic, strong) NSMutableDictionary *contextInfo;//kvo context

@end

@implementation DataSynchronizedBase

static DataSynchronizedBase *_shared = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[super allocWithZone:nil] init];
    });
    return _shared;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [DataSynchronizedBase sharedInstance];
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
    NSMutableArray <DataSyncInfo *>*dataArray = subIdMap[IDKey];
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
    
    DataSyncInfo *data = [[DataSyncInfo alloc] initWithObject:object keyPaths:keyPaths IDPath:IDPath onChange:onChange];
    [dataArray addObject:data];
    NSMutableDictionary *dic = @{@"KvoIdentifier":_shared,@"CacheKey":cacheKey,@"IDKey":IDKey}.mutableCopy;
    [keyPaths enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        dic[@"SyncData"] = data;
        NSValue *value = [NSValue valueWithNonretainedObject:object];
        [self.contextInfo setObject:dic forKey:value];
        [data.object addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew context:nil];
    }];
}

- (void)addDataSynchronizedWith:(id)object
                        keyPath:(NSString *)keyPath
                         IDPath:(NSString *)IDPath
                    isPenetrate:(BOOL)isPenetrate
                       onChange:(OnChange)onChange {
    NSArray *paths = [keyPath componentsSeparatedByString:@","];
    NSMutableDictionary *keyPaths = @{}.mutableCopy;
    for (NSString *val in paths) {
        keyPaths[val] = val;
    }
    [self bindingDataSynchronizedObject:object toClass:[object class] keyPaths:[NSDictionary dictionaryWithDictionary:keyPaths] IDPath:IDPath isPenetrate:isPenetrate onChange:onChange];
}

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath isPenetrate:(BOOL)isPenetrate onChange:(OnChange)onChange {
    NSString *cacheKey = NSStringFromClass(cls);
    NSString *IDKey = [object valueForKeyPath:IDPath];
    NSMutableDictionary *subIdMap = self.observerData[cacheKey];
    NSMutableArray <DataSyncInfo *>*dataArray = subIdMap[IDKey];
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
    
    DataSyncInfo *data = [[DataSyncInfo alloc] initWithObject:object keyPaths:keyPaths IDPath:IDPath isPenetrate:isPenetrate onChange:onChange];
    [dataArray addObject:data];
    NSMutableDictionary *dic = @{@"KvoIdentifier":_shared,@"CacheKey":cacheKey,@"IDKey":IDKey}.mutableCopy;
    [keyPaths enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        dic[@"SyncData"] = data;
        NSValue *value = [NSValue valueWithNonretainedObject:object];
        [self.contextInfo setObject:dic forKey:value];
        [data.object addObserver:self forKeyPath:obj options:NSKeyValueObservingOptionNew context:nil];
    }];
}

-(void)cleanZombieObject:(id)object CacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey{
    NSMutableArray <DataSyncInfo *>*dataMap = self.observerData[cacheKey][IDKey];
    for (int i = 0; i < dataMap.count; i++) {
        if (!dataMap[i].object) {
            [dataMap[i].keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSValue *value = [NSValue valueWithNonretainedObject:object];
                [object removeObserver:self forKeyPath:obj];
                [self.contextInfo removeObjectForKey:value];
            }];
            [dataMap removeObjectAtIndex:i];
            if (!dataMap.count) {
                [self.observerData[cacheKey] removeObjectForKey:IDKey];
            }
            if (![self.observerData[cacheKey] count]) {
                [self.observerData removeObjectForKey:cacheKey];
            }
        }
    }
}

- (BOOL)checkDuplicate:(NSMutableArray <DataSyncInfo *>*)array object:(id)object{
    for (DataSyncInfo *model in array) {
        if (model.object == object) {
            return true;
        }
    }
    return false;
}

//observe implementation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSValue *contextKey = [NSValue valueWithNonretainedObject:object];
    NSDictionary *info = self.contextInfo[contextKey];
    NSString *cacheKey = info[@"CacheKey"];
    NSString *IDKey = info[@"IDKey"];
    DataSyncInfo *data = info[@"SyncData"];
    NSArray *bindingPaths = [data.keyPaths allKeysForObject:keyPath];
    if (!self.kvoLock && cacheKey.length && IDKey.length) {
        //遍历所有绑定对象
        if (data.isPenetrate) {
            for (NSString *classKey in self.observerData.allKeys) {
                if ([data.object isKindOfClass:NSClassFromString(classKey)]) {
                    for (DataSyncInfo *model in self.observerData[classKey][IDKey]) {
                        self.kvoLock = true;//prevent recursive lock
                        //遍历绑定对象的所有结点
                        [model.keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            //多个key绑定同个数据源的情况不处理了 减少复杂度
                            if ([bindingPaths containsObject:key]) {
                                [model.object setValue:change[NSKeyValueChangeNewKey] forKeyPath:model.keyPaths[key]];
                            }
                        }];
                        if (model.onChange) {
                            model.onChange(model.object);
                        }
                        self.kvoLock = false;
                    }
                }
            }
        } else {
            for (DataSyncInfo *model in self.observerData[cacheKey][IDKey]) {
                self.kvoLock = true;//prevent recursive lock
                //遍历绑定对象的所有结点
                [model.keyPaths enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    //多个key绑定同个数据源的情况不处理了 减少复杂度
                    if ([bindingPaths containsObject:key]) {
                        [model.object setValue:change[NSKeyValueChangeNewKey] forKeyPath:model.keyPaths[key]];
                    }
                }];
                if (model.onChange) {
                    model.onChange(model.object);
                }
                self.kvoLock = false;
            }
        }
    }
}

#pragma mark - setter & getter
- (NSMutableDictionary *)observerData{
    if (!_observerData) {
        _observerData = @{}.mutableCopy;
    }
    return _observerData;
}

- (NSMutableDictionary *)contextInfo{
    if (!_contextInfo) {
        _contextInfo = @{}.mutableCopy;
    }
    return _contextInfo;
}

@end

//
//  DataSynchronizedManager.m
//  AhaIt
//
//  Created by 呼哈哈 on 2019/8/1.
//  Copyright © 2019 zlee. All rights reserved.
//

#import "DataSynchronizedManager.h"

@interface DataSynchronizedManager ()
@property (nonatomic, strong) NSString *cacheKey;
@property (nonatomic, strong) NSString *IDKey;
@property (nonatomic, strong) NSDictionary *keyPaths;
@property (nonatomic, weak) id object;

@end

@implementation DataSynchronizedManager
{
    void *objPoint;
}


- (void)addDataSynchronizedWith:(id)object keyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    self.IDKey = [object valueForKeyPath:IDPath];;
    self.cacheKey = NSStringFromClass([object class]);
    self.keyPaths = @{keyPath:keyPath};
    [[DataSynchronized sharedInstance] addDataSynchronizedWith:object keyPath:keyPath IDPath:IDPath onChange:onChange];
    self.object = object;
    objPoint = (__bridge void *)(object);
}

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    self.cacheKey = NSStringFromClass(cls);
    self.IDKey = [object valueForKeyPath:IDPath];
    self.keyPaths = keyPaths;
        [[DataSynchronized sharedInstance] bindingDataSynchronizedObject:object toClass:cls keyPaths:keyPaths IDPath:IDPath onChange:onChange];
}

- (void)dealloc{
    [[DataSynchronized sharedInstance] cleanZombieObject:(__bridge id _Nonnull)(objPoint) CacheKey:self.cacheKey IDKey:self.IDKey];
}


@end

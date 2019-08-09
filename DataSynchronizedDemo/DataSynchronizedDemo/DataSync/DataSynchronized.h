//
//  DataSynchronized.h
//  AhaIt
//
//  Created by 呼哈哈 on 2019/7/29.
//  Copyright © 2019 zlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSyncAdd.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataSynchronized : NSObject

+ (instancetype)sharedInstance;

- (void)addDataSynchronizedWith:(id)object
                        keyPath:(NSString *)keyPath
                         IDPath:(NSString *)IDPath
                       onChange:(OnChange)onChange;

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

- (void)cleanDataSyncKVOWithCacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey;
- (void)cleanZombieObject:(id)object CacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey;

@end

NS_ASSUME_NONNULL_END

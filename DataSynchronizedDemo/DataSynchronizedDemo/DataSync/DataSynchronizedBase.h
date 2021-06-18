//
//  DataSynchronizedBase.h
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/7/29.
//  Copyright © 2019 piu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DataSyncInfo.h"

NS_ASSUME_NONNULL_BEGIN
/**
 请勿直接调用该类进行数据绑定，除非你想手动管理内存以及kvo释放
 */
@interface DataSynchronizedBase : NSObject

+ (instancetype)sharedInstance;

- (void)addDataSynchronizedWith:(id)object
                        keyPath:(NSString *)keyPath
                         IDPath:(NSString *)IDPath
                       onChange:(OnChange)onChange;

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

- (void)addDataSynchronizedWith:(id)object
                        keyPath:(NSString *)keyPath
                         IDPath:(NSString *)IDPath
                    isPenetrate:(BOOL)isPenetrate
                       onChange:(OnChange)onChange;

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath isPenetrate:(BOOL)isPenetrate onChange:(OnChange)onChange;


- (void)cleanZombieObject:(id)object CacheKey:(NSString *)cacheKey IDKey:(NSString *)IDKey;

@end

NS_ASSUME_NONNULL_END

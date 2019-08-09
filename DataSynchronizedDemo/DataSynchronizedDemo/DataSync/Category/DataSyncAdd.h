//
//  DataSyncAdd.h
//  AhaIt
//
//  Created by 呼哈哈 on 2019/7/29.
//  Copyright © 2019 zlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSyncModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (DataSynchronized)

/*!
 @method
 @brief 遍历数组对象添加数据绑定
 @param keyPath 进行同步的数据结点
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)addDataSynchronizedKeyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

- (void)bindingDataSynchronizedTo:(Class)cls keyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

- (void)removeDataSynchronized;

@end

@interface NSObject (DataSynchronized)

/*!
 @method
 @brief 为对象添加数据绑定
 @param keyPath 进行同步的数据结点
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)addDataSynchronizedKeyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

- (void)bindingDataSynchronizedTo:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

- (void)removeDataSynchronized;

@end

NS_ASSUME_NONNULL_END

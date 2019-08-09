//
//  DataSynchronizedManager.h
//  AhaIt
//
//  Created by 呼哈哈 on 2019/8/1.
//  Copyright © 2019 zlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSynchronized.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataSynchronizedManager : NSObject

/*!
 @method
 @brief 为不同空间的同类数据对象进行绑定
 @param object 绑定的数据源
 @param keyPath 进行同步的数据结点多个数据节点用,隔开
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)addDataSynchronizedWith:(id)object
                        keyPath:(NSString *)keyPath
                         IDPath:(NSString *)IDPath
                       onChange:(OnChange)onChange;

/*!
 @method
 @brief 为不同空间的不同对象进行绑定
 @param object 被绑定的数据源
 @param cls 绑定的数据源
 @param keyPath 进行同步的数据结点多个数据节点用,隔开
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

/**
 @method
 @brief iOS11以下必须调用移除监听
 */

- (void)removeDataSynchronizedWithObject:(id)object;
@end

NS_ASSUME_NONNULL_END

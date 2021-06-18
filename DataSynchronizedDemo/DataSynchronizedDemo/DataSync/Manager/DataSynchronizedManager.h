//
//  DataSynchronizedManager.h
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/1.
//  Copyright © 2019 piu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSynchronizedBase.h"

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
 @param keyPaths 进行同步的数据结点
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

- (void)addDataSynchronizedWith:(id)object
                        keyPath:(NSString *)keyPath
                         IDPath:(NSString *)IDPath
                    isPenetrate:(BOOL)isPenetrate
                       onChange:(OnChange)onChange;

- (void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath isPenetrate:(BOOL)isPenetrate onChange:(OnChange)onChange;

@end

NS_ASSUME_NONNULL_END

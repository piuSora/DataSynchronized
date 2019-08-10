//
//  DataSyncAdd.h
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/7/29.
//  Copyright © 2019 piu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataSyncInfo.h"
#import "DataSynchronizedManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (DataSynchronized)

/*!
 @method
 @brief 遍历数组对象添加数据绑定（相同Model）
 @param keyPath 进行同步的数据路径,多个逗号隔开,支持多级路径
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)addDataSynchronizedKeyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange;


/*!
 @method
 @brief 遍历数组对象添加数据绑定（不同Model）
 @param cls 被绑定的类
 @param keyPaths 同步的数据路径:key为被绑定对象的路径，value为绑定对象的路径
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)bindingDataSynchronizedTo:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

@end

@interface NSObject (DataSynchronized)

/*!
 @method
 @brief 为对象添加数据绑定
 @param keyPath 进行同步的数据路径,多个逗号隔开,支持多级路径
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)addDataSynchronizedKeyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

/*!
 @method
 @brief 遍历数组对象添加数据绑定（不同Model）
 @param cls 被绑定的类
 @param keyPaths 同步的数据路径:key为被绑定对象的路径，value为绑定对象的路径
 @param IDPath 数据绑定的条件
 @param onChange 数据发生改变的回调
 */
- (void)bindingDataSynchronizedTo:(Class)cls keyPaths:(NSDictionary *)keyPaths IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

@end

NS_ASSUME_NONNULL_END

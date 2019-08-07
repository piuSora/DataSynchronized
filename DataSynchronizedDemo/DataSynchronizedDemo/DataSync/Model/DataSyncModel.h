//
//  DataSyncModel.h
//  AhaIt
//
//  Created by 呼哈哈 on 2019/7/31.
//  Copyright © 2019 zlee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///数据改变触发回调，回传model为发生改变的数据源，回调中修改数据不会触发kvo
typedef void(^_Nullable OnChange)(id model);

@interface DataSyncModel : NSObject

@property (nonatomic, weak) id object;
@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSString *IDPath;
@property (nonatomic, strong) OnChange onChange;

- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange;

@end

NS_ASSUME_NONNULL_END

//
//  MyModel.h
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/5.
//  Copyright © 2019 piu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OtherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyModel : NSObject
@property (nonatomic, strong) NSString *myID;
@property (nonatomic, strong) NSString *myName;
@property (nonatomic, strong) NSString *myInfo;
@property (nonatomic, strong) OtherModel *otherModel;
@property (nonatomic, assign) BOOL isFollow;

- (instancetype)initWithMyID:(NSString *)ID myName:(NSString *)name isFollow:(BOOL)isFollow;

@end

NS_ASSUME_NONNULL_END

//
//  OtherModel.h
//  DataSynchronizedDemo
//
//  Created by 呼哈哈 on 2019/8/6.
//  Copyright © 2019 piu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherModel : NSObject

@property (nonatomic, assign) NSString *otherID;
@property (nonatomic, strong) NSString *otherName;

- (instancetype)initWithID:(NSString *)ID name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

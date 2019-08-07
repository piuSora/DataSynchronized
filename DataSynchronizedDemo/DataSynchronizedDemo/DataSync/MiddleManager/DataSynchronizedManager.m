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

@end

@implementation DataSynchronizedManager

- (void)addDataSynchronizedWith:(id)object keyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    self.IDKey = [object valueForKeyPath:IDPath];;
    self.cacheKey = NSStringFromClass([object class]);
    [[DataSynchronized sharedInstance] addDataSynchronizedWith:object keyPath:keyPath IDPath:IDPath onChange:onChange];
}

-(void)bindingDataSynchronizedObject:(id)object toClass:(Class)cls keyPath:(NSString *)keyPath IDPath:(NSString *)IDPath onChange:(OnChange)onChange{
    self.cacheKey = NSStringFromClass(cls);
    self.IDKey = [object valueForKeyPath:IDPath];
    [[DataSynchronized sharedInstance] bindingDataSynchronizedObject:object toClass:cls keyPath:keyPath IDPath:IDPath onChange:onChange];
}

- (void)dealloc{
    [[DataSynchronized sharedInstance] cleanZombieObjectWithCacheKey:self.cacheKey IDKey:self.IDKey];
}



@end
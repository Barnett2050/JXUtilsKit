//
//  JXSafeMutableDictionary.h
//  Test
//
//  Created by Barnett on 2020/3/28.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 多线程安全的字典，内部使用一个并发队列，使用 dispatch_sync 同步任务进行数据的读取，使用 dispatch_barrier_async进行数据的增删改，性能下降在20%左右
安全取值部分可以参考：https://github.com/Barnett2050/JXCategoryKit 内 NSMutableDictionary 类扩展
*/

@interface JXSafeMutableDictionary : NSObject

@property (nonatomic,readonly) NSMutableDictionary *safeDictionary;

#pragma mark - 初始化
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithObject:(id)object forKey:(id <NSCopying>)key;
+ (instancetype)dictionaryWithDictionary:(NSDictionary<id, id> *)dict;
+ (instancetype)dictionaryWithObjects:(NSArray<id> *)objects forKeys:(NSArray<id <NSCopying>> *)keys;

- (instancetype)initWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithDictionary:(NSDictionary<id, id> *)otherDictionary;
- (instancetype)initWithDictionary:(NSDictionary<id, id> *)otherDictionary copyItems:(BOOL)flag;
- (instancetype)initWithObjects:(NSArray<id> *)objects forKeys:(NSArray<id <NSCopying>> *)keys;

#pragma mark - 取值
@property (nonatomic,readonly) NSUInteger count;
- (nullable id)objectForKey:(id)aKey;
- (NSEnumerator *)keyEnumerator;
@property (readonly, copy,nonatomic) NSArray *allKeys;
- (NSArray *)allKeysForObject:(id)anObject;
@property (readonly, copy,nonatomic) NSArray *allValues;
@property (readonly, copy,nonatomic) NSString *description;
@property (readonly, copy,nonatomic) NSString *descriptionInStringsFileFormat;
- (BOOL)isEqualToDictionary:(NSDictionary<id, id> *)otherDictionary;
- (NSEnumerator *)objectEnumerator;
- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker;

#pragma mark - 增删改
- (void)removeObjectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)setValue:(nullable id)value forKey:(NSString *)key;
- (void)addEntriesFromDictionary:(NSDictionary<id, id> *)otherDictionary;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray<id> *)keyArray;
- (void)setDictionary:(NSDictionary<id, id> *)otherDictionary;
- (void)setObject:(nullable id)obj forKeyedSubscript:(id <NSCopying>)key;

@end

NS_ASSUME_NONNULL_END

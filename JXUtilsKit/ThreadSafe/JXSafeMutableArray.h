//
//  JXSafeMutableArray.h
//  Test
//
//  Created by Barnett on 2020/3/28.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/* 多线程安全的数组，内部使用一个并发队列，使用 dispatch_sync 同步任务进行数据的读取，使用 dispatch_barrier_async进行数据的增删改，性能下降在20%左右
 安全取值部分可以参考：https://github.com/Barnett2050/JXCategoryKit 内 NSMutableArray 类扩展
 */

@interface JXSafeMutableArray : NSObject

@property (nonatomic,readonly) NSMutableArray *safeArray;
@property (readonly, copy) NSString *description;
@property (nullable, nonatomic, readonly) id firstObject;
@property (nullable, nonatomic, readonly) id lastObject;
@property (nonatomic,readonly) NSUInteger count;
#pragma mark - 初始化
+ (instancetype)array;
+ (instancetype)arrayWithObjects:(id)firstObj, ...;
+ (instancetype)arrayWithObject:(id)anObject;
+ (instancetype)arrayWithArray:(NSArray *)array;

- (instancetype)initWithObjects:(id)firstObj, ...;
- (instancetype)initWithArray:(NSArray *)array;
- (instancetype)initWithArray:(NSArray *)array copyItems:(BOOL)flag;

#pragma mark - 取值

- (id)objectAtIndex:(NSUInteger)index;
- (NSArray *)arrayByAddingObject:(id)anObject;
- (NSArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray;
- (NSString *)componentsJoinedByString:(NSString *)separator;
- (BOOL)containsObject:(id)anObject;
- (NSUInteger)indexOfObject:(id)anObject;
- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range;
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject;
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (BOOL)isEqualToArray:(NSArray *)otherArray;
- (NSEnumerator *)objectEnumerator;
- (NSEnumerator *)reverseObjectEnumerator;
- (NSArray *)subarrayWithRange:(NSRange)range;
- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

#pragma mark - 增删改
- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)removeAllObjects;
- (void)removeObject:(id)anObject inRange:(NSRange)range;
- (void)removeObject:(id)anObject;
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsInArray:(NSArray *)otherArray;
- (void)removeObjectsInRange:(NSRange)range;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray;
- (void)setArray:(NSArray *)otherArray;
- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END

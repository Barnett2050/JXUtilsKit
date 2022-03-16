//
//  JXSafeMutableArray.m
//  Test
//
//  Created by Barnett on 2020/3/28.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import "JXSafeMutableArray.h"

@interface JXSafeMutableArray ()

@property (nonatomic,strong) dispatch_queue_t concurrentQueue;
@property (nonatomic,readwrite) NSMutableArray *safeArray;

@end

@implementation JXSafeMutableArray

- (instancetype)init {
    if (self = [super init]) {
        NSString *identifier = [NSString stringWithFormat:@"<JXSafeMutableArray>%p",self];
        self.concurrentQueue = dispatch_queue_create([identifier UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.safeArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithObjects:(id)firstObj, ...
{
    JXSafeMutableArray *model = [self init];
    //   定义一具VA_LIST型的变量，这个变量是指向参数的指针
    if (firstObj) {
        [model.safeArray addObject:firstObj];
        va_list list;
        id tag;
        //   用VA_START宏初始化刚定义的VA_LIST变量
        va_start(list, firstObj);
        // VA_ARG返回可变的参数，VA_ARG的第二个参数是你要返回的参数的类型,如果函数有多个可变参数的，依次调用VA_ARG获取各个参数
        while ((tag = va_arg(list, id))) {
            [model.safeArray addObject:tag];
        }
    }
    return model;
}

- (instancetype)initWithArray:(NSArray *)array
{
    JXSafeMutableArray *model = [self init];
    model.safeArray = [[NSMutableArray alloc] initWithArray:array];
    return model;
}
- (instancetype)initWithArray:(NSArray *)array copyItems:(BOOL)flag
{
    JXSafeMutableArray *model = [self init];
    model.safeArray = [[NSMutableArray alloc] initWithArray:array copyItems:flag];
    return model;
}

+ (instancetype)array
{
    JXSafeMutableArray *model = [[JXSafeMutableArray alloc] init];
    return model;
}

+ (instancetype)arrayWithObjects:(id)firstObj, ...
{
    JXSafeMutableArray *model = [[JXSafeMutableArray alloc] init];
    if (firstObj) {
        [model.safeArray addObject:firstObj];
        va_list list;
        id tag;
        va_start(list, firstObj);
        while ((tag = va_arg(list, id))) {
            [model.safeArray addObject:tag];
        }
        va_end(list);
    }
    return model;
}
+ (instancetype)arrayWithObject:(id)anObject
{
    JXSafeMutableArray *model = [[JXSafeMutableArray alloc] init];
    model.safeArray = [NSMutableArray arrayWithObject:anObject];
    return model;
}
+ (instancetype)arrayWithArray:(NSArray *)array
{
    JXSafeMutableArray *model = [[JXSafeMutableArray alloc] init];
    model.safeArray = [NSMutableArray arrayWithArray:array];
    return model;
}
#pragma mark - 取值
- (NSString *)description
{
    __block NSString *string;
    dispatch_sync(_concurrentQueue, ^{
        string = self.safeArray.description;
    });
    return string;
}
- (id)firstObject
{
    __block id value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeArray firstObject];
    });
    return value;
}
- (id)lastObject
{
    __block id value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeArray lastObject];
    });
    return value;
}
- (NSUInteger)count
{
    __block NSUInteger index;
    dispatch_sync(_concurrentQueue, ^{
        index = [self.safeArray count];
    });
    return index;
}

- (id)objectAtIndex:(NSUInteger)index
{
    __block id value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeArray objectAtIndex:index];
    });
    return value;
}
- (NSArray *)arrayByAddingObject:(id)anObject
{
    __block NSArray *array;
    dispatch_sync(_concurrentQueue, ^{
        array = [self.safeArray arrayByAddingObject:anObject];
    });
    return array;
}
- (NSArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray
{
    __block NSArray *array;
    dispatch_sync(_concurrentQueue, ^{
        array = [self.safeArray arrayByAddingObjectsFromArray:otherArray];
    });
    return array;
}
- (NSString *)componentsJoinedByString:(NSString *)separator
{
    __block NSString *string;
    dispatch_sync(_concurrentQueue, ^{
        string = [self.safeArray componentsJoinedByString:separator];
    });
    return string;
}
- (BOOL)containsObject:(id)anObject
{
    __block BOOL isExist = false;
    dispatch_sync(_concurrentQueue, ^{
        isExist = [self.safeArray containsObject:anObject];
    });
    return isExist;
}

- (NSUInteger)indexOfObject:(id)anObject
{
    __block NSUInteger index;
    dispatch_sync(_concurrentQueue, ^{
        index = [self.safeArray indexOfObject:anObject];
    });
    return index;
}
- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range
{
    __block NSUInteger index;
    dispatch_sync(_concurrentQueue, ^{
        index = [self.safeArray indexOfObject:anObject inRange:range];
    });
    return index;
}
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject
{
    __block NSUInteger index;
    dispatch_sync(_concurrentQueue, ^{
        index = [self.safeArray indexOfObjectIdenticalTo:anObject];
    });
    return index;
}
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range
{
    __block NSUInteger index;
    dispatch_sync(_concurrentQueue, ^{
        index = [self.safeArray indexOfObjectIdenticalTo:anObject inRange:range];
    });
    return index;
}
- (BOOL)isEqualToArray:(NSArray *)otherArray
{
    __block BOOL isEqual = false;
    dispatch_sync(_concurrentQueue, ^{
        isEqual = [self.safeArray isEqualToArray:otherArray];
    });
    return isEqual;
}

- (NSEnumerator *)objectEnumerator
{
    __block NSEnumerator *enumerator;
    dispatch_sync(_concurrentQueue, ^{
        enumerator = [self.safeArray objectEnumerator];
    });
    return enumerator;
}
- (NSEnumerator *)reverseObjectEnumerator
{
    __block NSEnumerator *enumerator;
    dispatch_sync(_concurrentQueue, ^{
        enumerator = [self.safeArray reverseObjectEnumerator];
    });
    return enumerator;
}

- (NSArray *)subarrayWithRange:(NSRange)range
{
    __block NSArray *array;
    dispatch_sync(_concurrentQueue, ^{
        array = [self.safeArray subarrayWithRange:range];
    });
    return array;
}
- (NSArray *)objectsAtIndexes:(NSIndexSet *)indexes
{
    __block NSArray *array;
    dispatch_sync(_concurrentQueue, ^{
        array = [self.safeArray objectsAtIndexes:indexes];
    });
    return array;
}
- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    __block NSArray *array;
    dispatch_sync(_concurrentQueue, ^{
        array = [self.safeArray objectAtIndexedSubscript:idx];
    });
    return array;
}

#pragma mark - 增删改
- (void)addObject:(id)anObject
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray addObject:anObject];
    });
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray insertObject:anObject atIndex:index];
    });
}
- (void)removeLastObject
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeLastObject];
    });
}
- (void)removeObjectAtIndex:(NSUInteger)index
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObjectAtIndex:index];
    });
}
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray replaceObjectAtIndex:index withObject:anObject];
    });
}
- (void)addObjectsFromArray:(NSArray *)otherArray
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray addObjectsFromArray:otherArray];
    });
}
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    });
}
- (void)removeAllObjects
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeAllObjects];
    });
}
- (void)removeObject:(id)anObject inRange:(NSRange)range
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObject:anObject inRange:range];
    });
}
- (void)removeObject:(id)anObject
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObject:anObject];
    });
}
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObjectIdenticalTo:anObject inRange:range];
    });
}
- (void)removeObjectIdenticalTo:(id)anObject
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObjectIdenticalTo:anObject];
    });
}
- (void)removeObjectsInArray:(NSArray *)otherArray
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObjectsInArray:otherArray];
    });
}
- (void)removeObjectsInRange:(NSRange)range
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObjectsInRange:range];
    });
}
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray range:(NSRange)otherRange
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray replaceObjectsInRange:range withObjectsFromArray:otherArray range:otherRange];
    });
}
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray replaceObjectsInRange:range withObjectsFromArray:otherArray];
    });
}
- (void)setArray:(NSArray *)otherArray
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray setArray:otherArray];
    });
}
- (void)insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray insertObjects:objects atIndexes:indexes];
    });
}
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray removeObjectsAtIndexes:indexes];
    });
}
- (void)replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray replaceObjectsAtIndexes:indexes withObjects:objects];
    });
}
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeArray setObject:obj atIndexedSubscript:idx];
    });
}

- (void)dealloc
{
    if (_concurrentQueue) {
        _concurrentQueue = NULL;
    }
    if (_safeArray) {
        _safeArray = nil;
    }
}
@end

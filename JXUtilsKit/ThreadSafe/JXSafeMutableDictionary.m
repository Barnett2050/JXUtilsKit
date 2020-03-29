//
//  JXSafeMutableDictionary.m
//  Test
//
//  Created by Barnett on 2020/3/28.
//  Copyright © 2020 Barnett. All rights reserved.
//

#import "JXSafeMutableDictionary.h"

@interface JXSafeMutableDictionary ()

@property (nonatomic,strong) dispatch_queue_t concurrentQueue;
@property (nonatomic,readwrite) NSMutableDictionary *safeDictionary;

@end

@implementation JXSafeMutableDictionary

- (instancetype)init {
    if (self = [super init]) {
        NSString *identifier = [NSString stringWithFormat:@"<JXSafeMutableDictionary>%p",self];
        self.concurrentQueue = dispatch_queue_create([identifier UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.safeDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)dictionary
{
    JXSafeMutableDictionary *model = [[JXSafeMutableDictionary alloc] init];
    return model;
}
+ (instancetype)dictionaryWithObject:(id)object forKey:(id <NSCopying>)key
{
    JXSafeMutableDictionary *model = [[JXSafeMutableDictionary alloc] init];
    model.safeDictionary = [NSMutableDictionary dictionaryWithObject:object forKey:key];
    return model;
}
+ (instancetype)dictionaryWithDictionary:(NSDictionary<id, id> *)dict
{
    JXSafeMutableDictionary *model = [[JXSafeMutableDictionary alloc] init];
    model.safeDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
    return model;
}
+ (instancetype)dictionaryWithObjects:(NSArray<id> *)objects forKeys:(NSArray<id <NSCopying>> *)keys
{
    JXSafeMutableDictionary *model = [[JXSafeMutableDictionary alloc] init];
    model.safeDictionary = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    return model;
}

- (instancetype)initWithObjectsAndKeys:(id)firstObject, ...
{
    JXSafeMutableDictionary *model = [self init];
    if (firstObject) {
        int num = 1;
        NSString *value = firstObject;
        NSString *key;
        va_list list;
        id tag;
        va_start(list, firstObject);
        while ((tag = va_arg(list, id))) {
            num++;
            if (num % 2 == 0) {
                key = tag;
                [self.safeDictionary setObject:value forKey:key];
            }else
            {
                value = tag;
            }
        }
        va_end(list);
    }
    return model;
}
- (instancetype)initWithDictionary:(NSDictionary<id, id> *)otherDictionary
{
    JXSafeMutableDictionary *model = [self init];
    model.safeDictionary = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary];
    return model;
}
- (instancetype)initWithDictionary:(NSDictionary<id, id> *)otherDictionary copyItems:(BOOL)flag
{
    JXSafeMutableDictionary *model = [self init];
    model.safeDictionary = [[NSMutableDictionary alloc] initWithDictionary:otherDictionary copyItems:flag];
    return model;
}
- (instancetype)initWithObjects:(NSArray<id> *)objects forKeys:(NSArray<id <NSCopying>> *)keys
{
    JXSafeMutableDictionary *model = [self init];
    model.safeDictionary = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
    return model;
}

#pragma mark - 取值
- (NSUInteger)count
{
    __block NSUInteger value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary count];
    });
    return value;
}
- (nullable id)objectForKey:(id)aKey
{
    __block id value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary objectForKey:aKey];
    });
    return value;
}
- (NSEnumerator *)keyEnumerator
{
    __block NSEnumerator *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary keyEnumerator];
    });
    return value;
}
- (NSArray *)allKeys
{
    __block NSArray *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary allKeys];
    });
    return value;
}
- (NSArray *)allKeysForObject:(id)anObject
{
    __block NSArray *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary allKeysForObject:anObject];
    });
    return value;
}
-(NSArray *)allValues
{
    __block NSArray *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary allValues];
    });
    return value;
}
- (NSString *)description
{
    __block NSString *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary description];
    });
    return value;
}
- (NSString *)descriptionInStringsFileFormat
{
    __block NSString *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary descriptionInStringsFileFormat];
    });
    return value;
}
- (BOOL)isEqualToDictionary:(NSDictionary<id,id> *)otherDictionary
{
    __block BOOL value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary isEqualToDictionary:otherDictionary];
    });
    return value;
}
- (NSEnumerator *)objectEnumerator
{
    __block NSEnumerator *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary objectEnumerator];
    });
    return value;
}
- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker
{
    __block NSArray *value;
    dispatch_sync(_concurrentQueue, ^{
        value = [self.safeDictionary objectsForKeys:keys notFoundMarker:marker];
    });
    return value;
}

#pragma mark - 增删改
- (void)removeObjectForKey:(id)aKey
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary removeObjectForKey:aKey];
    });
}
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary setObject:anObject forKey:aKey];
    });
}
- (void)setValue:(nullable id)value forKey:(NSString *)key
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary setValue:value forKey:key];
    });
}
- (void)addEntriesFromDictionary:(NSDictionary<id, id> *)otherDictionary
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary addEntriesFromDictionary:otherDictionary];
    });
}
- (void)removeAllObjects
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary removeAllObjects];
    });
}
- (void)removeObjectsForKeys:(NSArray<id> *)keyArray
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary removeObjectsForKeys:keyArray];
    });
}
- (void)setDictionary:(NSDictionary<id, id> *)otherDictionary
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary setDictionary:otherDictionary];
    });
}
- (void)setObject:(nullable id)obj forKeyedSubscript:(id <NSCopying>)key
{
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.safeDictionary setObject:obj forKeyedSubscript:key];
    });
}

@end

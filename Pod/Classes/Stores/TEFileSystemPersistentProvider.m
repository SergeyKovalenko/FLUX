//
// Created by Dmitry on 08.09.15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "TEFileSystemPersistentProvider.h"
#import "TEBaseState.h"

@interface TEFileSystemPersistentProvider ()

@property (nonatomic, strong) dispatch_queue_t storeQueue;

@end

@implementation TEFileSystemPersistentProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.storeQueue = dispatch_queue_create([self serviceId].UTF8String, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)saveState:(id <NSCoding>)state forStore:(TEBaseStore <TEPersistentStoreProtocol> *)store {
    dispatch_async(self.storeQueue, ^{
        [NSKeyedArchiver archiveRootObject:state toFile:[self pathForStore:store]];
    });
}

- (NSString *)pathForStore:(TEBaseStore <TEPersistentStoreProtocol> *)store {
    NSString *storeName = NSStringFromClass([store class]);
    return [NSString stringWithFormat:@"%@%@.savedstate", NSTemporaryDirectory(), storeName];
}

- (id)stateForStore:(TEBaseStore <TEPersistentStoreProtocol> *)store {
    id object;
    NSString *statePath = [self pathForStore:store];
    @try {
         object = [NSKeyedUnarchiver unarchiveObjectWithFile:statePath];
    }
    @catch (NSException *exception) {
        object = nil;
        [[NSFileManager defaultManager] removeItemAtPath:statePath error:nil];
    }
    return object;
}

- (NSString *)serviceId
{
    return [NSString stringWithFormat:@"%@.%@.%p", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"], NSStringFromClass([self class]), self];
}

@end
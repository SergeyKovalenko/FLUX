//
//  TEBaseStore.h
//  MasterApp
//
//  Created by Alexey Fayzullov on 9/9/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TEBaseState;
@class TEBaseAction;
@protocol TEDomainMiddleware;

typedef TEBaseState* (^TEActionCallback)(id action);

@protocol TEActionRegistry <NSObject>
- (void)onAction:(Class)actionClass callback:(TEActionCallback)callback;
- (TEActionCallback)callbackForAction:(TEBaseAction *)action;
@end

@class TEBaseStore;
typedef TEBaseStore<TEActionRegistry> TEStoreDispatcher;

@interface TEBaseStore : NSObject

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, readonly) TEBaseState *state;

- (void)onAction:(Class)actionClass callback:(TEActionCallback)callback;
- (BOOL)respondsToAction:(TEBaseAction *)action;
- (void)dispatchAction:(TEBaseAction *)action;

- (TEBaseState *)defaultState __attribute__((deprecated));
+ (TEBaseState *)defaultState;

@end

//
//  STTimer.h
//  STTimer
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^STTimerBlock)(void);


@interface STTimer : NSObject

- (id)initWithFireDate:(NSDate *)fireDate block:(STTimerBlock)block;
- (id)initWithFireDate:(NSDate *)fireDate block:(STTimerBlock)block queue:(dispatch_queue_t)queue;
- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval block:(STTimerBlock)block;
- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval block:(STTimerBlock)block queue:(dispatch_queue_t)queue;
- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway block:(STTimerBlock)block;
- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway block:(STTimerBlock)block queue:(dispatch_queue_t)queue;

- (void)invalidate;

@end

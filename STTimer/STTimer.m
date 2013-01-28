//
//  STTimer.m
//  STTimer
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import "STTimer.h"

#if ! (defined(__has_feature) && __has_feature(objc_arc))
# error "STTimer must be compiled with ARC enabled"
#endif


static NSTimeInterval const STTimerIntervalNoRepeat = -DBL_MAX;
static NSTimeInterval const STTimerLeewayDefault = 250 * NSEC_PER_MSEC;


static inline NSComparisonResult STCompareDouble(double a, double b, double e) {
	double d = b - a;
    if (d > e) {
        return NSOrderedAscending;
    }
    if (d < -e) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}


@implementation STTimer {
@private
	dispatch_source_t _source;
	dispatch_block_t _block;
}

- (id)initWithFireDate:(NSDate *)fireDate block:(STTimerBlock)block {
	return [self initWithFireDate:fireDate interval:STTimerIntervalNoRepeat leeway:STTimerLeewayDefault block:block queue:nil];
}

- (id)initWithFireDate:(NSDate *)fireDate block:(STTimerBlock)block queue:(dispatch_queue_t)queue {
	return [self initWithFireDate:fireDate interval:STTimerIntervalNoRepeat leeway:STTimerLeewayDefault block:block queue:queue];
}

- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval block:(STTimerBlock)block {
	return [self initWithFireDate:fireDate interval:interval leeway:STTimerLeewayDefault block:block queue:nil];
}

- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval block:(STTimerBlock)block queue:(dispatch_queue_t)queue {
	return [self initWithFireDate:fireDate interval:interval leeway:STTimerLeewayDefault block:block queue:queue];
}

- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway block:(STTimerBlock)block {
	return [self initWithFireDate:fireDate interval:interval leeway:leeway block:block queue:nil];
}

- (id)initWithFireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval leeway:(NSTimeInterval)leeway block:(STTimerBlock)block queue:(dispatch_queue_t)queue {
	NSParameterAssert(fireDate);

	if ((self = [super init])) {
		BOOL repeats = STCompareDouble(interval, STTimerIntervalNoRepeat, .001) != NSOrderedSame;

		double delay = [fireDate timeIntervalSinceNow];

        dispatch_time_t sourceStart = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
		uint64_t sourceInterval = repeats ? (uint64_t)(interval * NSEC_PER_SEC) : DISPATCH_TIME_FOREVER;
		uint64_t sourceLeeway = (uint64_t)(leeway * NSEC_PER_SEC);

        _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue ?: dispatch_get_main_queue());
        dispatch_source_set_timer(_source, sourceStart, sourceInterval, sourceLeeway);

        _block = [block copy];

        {
            __weak __typeof__(self) wself = self;
            dispatch_source_set_event_handler(_source, ^{
                __strong __typeof__(self) sself = wself;
				if (!sself) {
					return;
				}
				if (!repeats) {
					dispatch_source_cancel(sself->_source);
				}
                STTimerBlock bblock = sself->_block;
                if (bblock) {
                    bblock();
                }
            });
        }

        dispatch_resume(_source);
	}
	return self;
}

- (void)dealloc {
	dispatch_source_cancel(_source);
#if !OS_OBJECT_USE_OBJC_RETAIN_RELEASE
    dispatch_release(_source), _source = NULL;
#endif
}


- (void)invalidate {
	dispatch_source_cancel(_source);
}

@end

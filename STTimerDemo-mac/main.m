//
//  main.m
//  STTimerDemo-mac
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STTimer.h"


int main(__unused int argc, __unused const char * argv[]) {
	@autoreleasepool {
		NSFileHandle *stdoutFH = [NSFileHandle fileHandleWithStandardOutput];
		NSDate * const start = [NSDate dateWithTimeIntervalSinceNow:0];

		// the timer is not deallocated because it doesn't go out of scope before we spin in the runloop
		(void)[[STTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:3] interval:2 block:^{
			NSDate * const now = [NSDate dateWithTimeIntervalSinceNow:0];
			NSString * const output = [NSString stringWithFormat:@"%g\n", [now timeIntervalSinceDate:start]];
			[stdoutFH writeData:[output dataUsingEncoding:NSASCIIStringEncoding]];
		}];

		[[NSRunLoop mainRunLoop] run];
	}
    return 0;
}


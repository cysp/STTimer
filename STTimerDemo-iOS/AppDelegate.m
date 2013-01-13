//
//  AppDelegate.m
//  STTimerDemo-iOS
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Scott Talbot. All rights reserved.
//

#import "AppDelegate.h"

#import "STTimer.h"


@implementation AppDelegate {
@private
	STTimer *_timer;
}

- (void)setWindow:(UIWindow *)window {
	_window = window;

	[_window makeKeyAndVisible];
}

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions {
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor blackColor];

	self.window = window;

    return YES;
}


- (void)applicationDidBecomeActive:(__unused UIApplication *)application {
	NSDate * const start = [NSDate dateWithTimeIntervalSinceNow:0];

	UIWindow * const window = self.window;
	window.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];

	NSFileHandle *stdoutFH = [NSFileHandle fileHandleWithStandardOutput];

	_timer = [[STTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:3] interval:2 block:^{
		NSDate * const now = [NSDate dateWithTimeIntervalSinceNow:0];
		NSString * const output = [NSString stringWithFormat:@"%g\n", [now timeIntervalSinceDate:start]];
		[stdoutFH writeData:[output dataUsingEncoding:NSASCIIStringEncoding]];
	}];
}

@end

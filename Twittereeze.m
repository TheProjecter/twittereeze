//
//  Twittereeze.m
//  Twittereeze
//
//  Created by Sören Kuklau on 16/11/06.
//  Copyright 2006 chucker. All rights reserved.
//

#import "Twittereeze.h"

@implementation Twittereeze
BOOL DTRenameSelector(Class _class, SEL _oldSelector, SEL _newSelector)
{
	Method method = nil;

	// First, look for the methods
	method = class_getInstanceMethod(_class, _oldSelector);
	if (method == nil)
		return NO;
	
	method->method_name = _newSelector;
	return YES;
}

/**
 * A special method called by SIMBL once the application has started and all classes are initialized.
 */
+ (void) load
{
	Twittereeze * twittereeze = [Twittereeze sharedInstance];

	id swizzle_nsap = [NSApplication class];
	DTRenameSelector(swizzle_nsap, @selector(sendEvent:), @selector (_apple_sendEvent:));
	DTRenameSelector(swizzle_nsap, @selector(_twittereeze_sendEvent:), @selector(sendEvent:));

	id swizzle_kvon_ifmc = [NSKVONotifying_IFMainController class];
	DTRenameSelector(swizzle_kvon_ifmc, @selector(showPreferenceWindow:), @selector (_twitterrific_showPreferenceWindow:));
	DTRenameSelector(swizzle_kvon_ifmc, @selector(_twittereeze_showPreferenceWindow:), @selector(showPreferenceWindow:));
}

/**
 * @return the single static instance of the plugin object
 */
+ (Twittereeze *) sharedInstance
{
	static Twittereeze * twittereeze = nil;

	if (twittereeze == nil)
		twittereeze = [[Twittereeze alloc] init];

	return twittereeze;
}
@end

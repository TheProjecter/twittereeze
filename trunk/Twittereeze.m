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
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], @"changeAdiumStatus",
			[NSNumber numberWithBool:YES], @"changeiChatStatus",
			[NSNumber numberWithBool:YES], @"changeSkypeStatus",
			[NSNumber numberWithBool:YES], @"animateNotificationWindow", // currently unused, see below
		nil]];

	// We don't currently use the shared instance, so no need to create or assign it either
	// Twittereeze * twittereeze = [Twittereeze sharedInstance];

	id swizzle_nsap = [NSApplication class];
	DTRenameSelector(swizzle_nsap, @selector(sendEvent:), @selector (_apple_sendEvent:));
	DTRenameSelector(swizzle_nsap, @selector(_twittereeze_sendEvent:), @selector(sendEvent:));

	id swizzle_kvon_ifmc = [NSKVONotifying_IFMainController class];
	DTRenameSelector(swizzle_kvon_ifmc, @selector(showPreferenceWindow:), @selector (_twitterrific_showPreferenceWindow:));
	DTRenameSelector(swizzle_kvon_ifmc, @selector(_twittereeze_showPreferenceWindow:), @selector(showPreferenceWindow:));
	DTRenameSelector(swizzle_kvon_ifmc, @selector(showNotificationWindow:), @selector (_twitterrific_showNotificationWindow:));
	DTRenameSelector(swizzle_kvon_ifmc, @selector(_twittereeze_showNotificationWindow:), @selector(showNotificationWindow:));	
}

/**
 * @return the single static instance of the plugin object
 */
//+ (Twittereeze *) sharedInstance
//{
//	static Twittereeze * twittereeze = nil;
//
//	if (twittereeze == nil)
//		twittereeze = [[Twittereeze alloc] init];
//
//	return twittereeze;
//}

// For the future: a CI ripple effect for the notification window, as requested by 'abb'
// place this so it somehow gets executed right before the notification window is supposed to show up

// Something like below:

//if (animateNotificationWindow) {
//	CIImage * beforeImage = [[CIImage alloc] initWithBitmapImageRep:
//		[notificationWindow bitmapImageRepForCachingDisplayInRect:[notificationWindow frame]]];
//
//	CIFilter * transformFilter = [CIFilter filterWithName:@"CIRippleTransition"];
//	[transformFilter setValue:beforeImage forKey:@"inputImage"];
//
//	CIImage * afterImage = [transformFilter valueForKey:@"outputImage"];
//}
@end

//
//  NSApplication+TwittereezeEventHandling.m
//  Twittereeze
//
//  Created by Sören Kuklau on 19/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "NSApplication+TwittereezeEventHandling.h"
#import "NearExponentialValueTransformer.h"

@implementation NSApplication (TwittereezeEventHandling)
+ (void) load {
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(makeTextFieldFirstResponderAfterWindowUpdate:)
		name:@"NSWindowDidUpdateNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(makeTextFieldFirstResponderAfterTableSelectionChange:)
		name:@"NSTableViewSelectionDidChangeNotification" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//		selector:@selector(notifyChangedDefaults:)
//		name:@"NSUserDefaultsDidChangeNotification" object:nil];

	NearExponentialValueTransformer * nearExponentialValueTransformer = [[[NearExponentialValueTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:nearExponentialValueTransformer forName:@"NearExponentialValueTransformer"];
}

+ (void) makeTextFieldFirstResponderAfterWindowUpdate: (NSNotification *) notification {
	id window;

	if ([[notification object] isKindOfClass:[IFHUDWindow class]]) {
		window = [notification object];

		NSEnumerator * enumerator = [[[window contentView] subviews] objectEnumerator];
		id object;
		id textField = nil;

		while (nil != (object = [enumerator nextObject]))
			if ([object isKindOfClass:[IFHUDTextField class]])
				textField = object;

		if ((textField != nil) && ([window isKeyWindow]) && ([[window firstResponder] class] != [NSTextView class]))
			[window makeFirstResponder:textField];
	}
}

//+ (void) notifyChangedDefaults: (NSNotification *) notification {
//	NSLog(@"%@", [[notification object] valueForKey:@"refreshInterval"]);
//}

+ (void) makeTextFieldFirstResponderAfterTableSelectionChange: (NSNotification *) notification {
	id tableView;

	if ([[notification object] isKindOfClass:[IFHUDTableView class]]) {
		tableView = [notification object];
		id window = [tableView window];

		NSEnumerator * enumerator = [[[[[[tableView superview] superview] superview] superview] subviews] objectEnumerator];
		id object;
		id textField = nil;

		while (nil != (object = [enumerator nextObject]))
			if ([object isKindOfClass:[IFHUDTextField class]])
				textField = object;

		if ((textField != nil) && ([window isKeyWindow]) && ([[window firstResponder] class] != [NSTextView class]))
			[window makeFirstResponder:textField];
	}
}

- (void) _twittereeze_sendEvent: (NSEvent *) event {
	if (([event type] == NSKeyDown) && (([event keyCode] == 36) || ([event keyCode] == 76)))
		[self handleStatusMessage: event];

	[self _apple_sendEvent:event];
}

- (void) handleStatusMessage: (NSEvent *) event {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	BOOL changeAdiumStatus = [defaults boolForKey:@"changeAdiumStatus"];
	BOOL changeiChatStatus = [defaults boolForKey:@"changeiChatStatus"];
	BOOL changeSkypeStatus = [defaults boolForKey:@"changeSkypeStatus"];

	if ((!changeAdiumStatus) && (!changeiChatStatus) && (!changeSkypeStatus))
		return;

	NSEnumerator * enumerator = [[NSApp windows] objectEnumerator];
	id object;
	id notificationWindow = nil;
	id textField = nil;

	while (nil != (object = [enumerator nextObject]))
		if ([object isKindOfClass:[IFHUDWindow class]]) {
			notificationWindow = object;

			enumerator = [[[notificationWindow contentView] subviews] objectEnumerator];

			while (nil != (object = [enumerator nextObject]))
				if ([object isKindOfClass:[IFHUDTextField class]])
					textField = object;
		}

	if (textField == nil)
		return;

	NSMutableString * statusMessage = [[textField stringValue] mutableCopy];

	if ([statusMessage length] <= 0) // ignore empty messages
		return;

	[statusMessage replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, [statusMessage length])];

	enumerator = [[[NSWorkspace sharedWorkspace] launchedApplications] objectEnumerator];

	NSAppleScript * script;

	while (nil != (object = [enumerator nextObject])) {
		if ((changeiChatStatus) && ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"iChat"])) {
			NSLog(@"about to change iChat's status");
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"iChat\" to set status message to \"" stringByAppendingString:statusMessage]
				stringByAppendingString:@"\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
		else if ((changeSkypeStatus) && ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"Skype"])) {
			NSLog(@"about to change Skype's status");
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"Skype\" to send command \"SET PROFILE MOOD_TEXT " stringByAppendingString:statusMessage]
				stringByAppendingString:@"\" script name \"Twittereeze\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
		else if ((changeAdiumStatus) && ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"Adium"])) {
			NSLog(@"about to change Adium's status");
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"Adium\" to set my status message to \"" stringByAppendingString:statusMessage]
				stringByAppendingString:@"\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
	}
}
@end

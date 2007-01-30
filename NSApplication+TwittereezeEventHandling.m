//
//  NSApplication+TwittereezeEventHandling.m
//  Twittereeze
//
//  Created by Sören Kuklau on 19/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "NSApplication+TwittereezeEventHandling.h"
#import "ExponentialValueTransformer.h"

@implementation NSApplication (TwittereezeEventHandling)
+ (void) load {
//	[[NSNotificationCenter defaultCenter] addObserver:self
//		selector:@selector(testWindowKey:)
//		name:@"NSWindowDidBecomeKeyNotification" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//		selector:@selector(testWindowMain:)
//		name:@"NSWindowDidBecomeMainNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(makeTextFieldFirstResponderAfterWindowUpdate:)
		name:@"NSWindowDidUpdateNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(makeTextFieldFirstResponderAfterTableSelectionChange:)
		name:@"NSTableViewSelectionDidChangeNotification" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//		selector:@selector(notifyChangedDefaults:)
//		name:@"NSUserDefaultsDidChangeNotification" object:nil];

	ExponentialValueTransformer * exponentialValueTransformer = [[[ExponentialValueTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:exponentialValueTransformer forName:@"ExponentialValueTransformer"];
}

//+ (void) testWindowKey: (NSNotification *) notification {
//	NSLog(@"key");
//}
//
//+ (void) testWindowMain: (NSNotification *) notification {
//	NSLog(@"main");
//}

+ (void) makeTextFieldFirstResponderAfterWindowUpdate: (NSNotification *) notification {
	id window;

	if ([[notification object] isKindOfClass:[IFHUDWindow class]]) {
		window = [notification object];

		NSEnumerator * enumerator = [[[window contentView] subviews] objectEnumerator];
		id object;
		id textField = nil;
		id selectedTweetTextField = nil;

		while (nil != (object = [enumerator nextObject])) {
			if ([object isKindOfClass:[IFHUDTextField class]] && [object isEditable])
				textField = object;
			if (([object isKindOfClass:[IFHUDBackground class]]) &&
				(! [[[object subviews] objectAtIndex:0] isKindOfClass:[NSScrollView class]])) {
				enumerator = [[object subviews] objectEnumerator];

				while (nil != (object = [enumerator nextObject])) {
//					NSLog(@"%@ %@", object, [object class]);
					if ([object isKindOfClass:[NSTextField class]]) {
//						NSLog(@"got here");
						selectedTweetTextField = object;
						break;
					}
				}
			}
		}

		if ((textField != nil) && ([window isKeyWindow]) && ([[window firstResponder] class] != [NSTextView class]))
			[window makeFirstResponder:textField];

		if (selectedTweetTextField != nil)
			[self _twittereeze_removeEntitiesFromTweetField:selectedTweetTextField];
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
		id selectedTweetTextField = nil;

//		NSLog(@"%@", [[[[[tableView superview] superview] superview] superview] subviews]);

		while (nil != (object = [enumerator nextObject])) {
			if ([object isKindOfClass:[IFHUDTextField class]] && [object isEditable])
				textField = object;
			if (([object isKindOfClass:[IFHUDBackground class]]) &&
				(! [[[object subviews] objectAtIndex:0] isKindOfClass:[NSScrollView class]])) {
				enumerator = [[object subviews] objectEnumerator];

				while (nil != (object = [enumerator nextObject])) {
//					NSLog(@"%@ %@", object, [object class]);
					if ([object isKindOfClass:[NSTextField class]]) {
//						NSLog(@"got here");
						selectedTweetTextField = object;
						break;
					}
				}
			}
		}

		if ((textField != nil) && ([window isKeyWindow]) && ([[window firstResponder] class] != [NSTextView class]))
			[window makeFirstResponder:textField];

		if (selectedTweetTextField != nil)
			[self _twittereeze_removeEntitiesFromTweetField:selectedTweetTextField];
	}
}

- (void) _twittereeze_sendEvent: (NSEvent *) event {
	if (([event type] == NSKeyDown) && (([event keyCode] == 36) || ([event keyCode] == 76)))
		[self handleStatusMessage: event];

	[self _apple_sendEvent:event];
}

+ (void) _twittereeze_removeEntitiesFromTweetField: (NSTextField *) tweetField {
	NSMutableString * editedTweet = [[tweetField stringValue] mutableCopy];

	// NB: [editedTweet length] (and, by extension, the entire argument of range:) /cannot/ be optimized, as it changes each time

	[editedTweet replaceOccurrencesOfString:@"&lt;" withString:@"<" options:0 range:NSMakeRange(0, [editedTweet length])];
	[editedTweet replaceOccurrencesOfString:@"&gt;" withString:@">" options:0 range:NSMakeRange(0, [editedTweet length])];

	[tweetField setStringValue:editedTweet];
}

- (void) handleStatusMessage: (NSEvent *) event {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	BOOL changeAdiumStatus = [defaults boolForKey:@"changeAdiumStatus"];
	BOOL changeiChatStatus = [defaults boolForKey:@"changeiChatStatus"];
	BOOL changeSkypeStatus = [defaults boolForKey:@"changeSkypeStatus"];
	BOOL changeYahooStatus = YES;

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
				if ([object isKindOfClass:[IFHUDTextField class]] && [object isEditable])
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
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"iChat\" to set status message to \"" stringByAppendingString:statusMessage]
				stringByAppendingString:@"\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
		else if ((changeSkypeStatus) && ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"Skype"])) {
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"Skype\" to send command \"SET PROFILE MOOD_TEXT " stringByAppendingString:statusMessage]
				stringByAppendingString:@"\" script name \"Twittereeze\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
		else if ((changeAdiumStatus) && ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"Adium"])) {
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"Adium\" to set my status message to \"" stringByAppendingString:statusMessage]
				stringByAppendingString:@"\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
		else if ((changeYahooStatus) && ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"Yahoo! Messenger"])) {
			NSPasteboard * pasteboard = [NSPasteboard generalPasteboard];
			[pasteboard setString:statusMessage forType:NSStringPboardType];
			NSPerformService(@"Yahoo! Messenger/Set Selection as Status", pasteboard);
		}
	}
}
@end

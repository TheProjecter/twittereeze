//
//  NSApplication+PostNibLoad.m
//  Twittereeze
//
//  Created by Sören Kuklau on 19/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "NSApplication+PostNibLoad.h"
#import "TwittereezePosingMainController.h"


@implementation NSApplication (PostNibLoad)
+ (void) load {
//	NSLog(@"%@", [NSApp delegate]);
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(replaceApplicationDelegate:)
		name:@"NSApplicationDidFinishLaunchingNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(makeTextFieldFirstResponderAfterWindowUpdate:)
		name:@"NSWindowDidUpdateNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
		selector:@selector(makeTextFieldFirstResponderAfterTableSelectionChange:)
		name:@"NSTableViewSelectionDidChangeNotification" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self
//		selector:@selector(logNotifications:) name:nil object:nil];

	// key codes: http://www.prefab.com/player/docs/frontier/a3advancedtopics.html
	// kudos to: http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/

	EventHotKeyRef hotKeyRef;
	EventHotKeyID hotKeyID;
	EventTypeSpec eventType;
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind = kEventHotKeyPressed;

	InstallApplicationEventHandler(&HotKeyHandler, 1, &eventType, NULL, NULL);

	hotKeyID.signature='htk1';
	hotKeyID.id=1;
	RegisterEventHotKey(103, cmdKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);

	hotKeyID.signature='htk2';
	hotKeyID.id=2;
	RegisterEventHotKey(103, cmdKey+shiftKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
}

+ (void) replaceApplicationDelegate: (NSNotification *) notification {
//	[TwittereezePosingMainController poseAsClass:[IFMainController class]];
//	IFMainController * twittereezeMainController = [[IFMainController alloc] init];

//	[foo set
	NSLog(@"%@ %@", [NSApp delegate], [[NSApp delegate] class]);
//	NSLog(@"%@ %@", twittereezeMainController, [twittereezeMainController class]);
//	[[NSApp delegate] showPreferenceWindow:nil];
//	[twittereezeMainController showPreferenceWindow:nil];

//	[IFMainController newMethod];
//	[[NSApp delegate] newMethod];
//	[twittereezeMainController newMethod];

//	[NSApp setDelegate:twittereezeMainController];
//	NSLog(@"%@ %@", [NSApp delegate], [[NSApp delegate] class]);
}

+ (void) logNotifications: (NSNotification *) notification {
	NSLog(@"%@", notification);
}

+ (void) makeTextFieldFirstResponderAfterWindowUpdate: (NSNotification *) notification {
	id window;

	if ([[notification object] isKindOfClass:[IFHUDWindow class]]) {
		window = [notification object];

		NSEnumerator * enumerator = [[[window contentView] subviews] objectEnumerator];
		id object;
		id textField = nil;

		while (object = [enumerator nextObject])
			if ([object isKindOfClass:[IFHUDTextField class]])
				textField = object;

		if ((textField != nil) && ([window isKeyWindow]) && ([[window firstResponder] class] != [NSTextView class]))
			[window makeFirstResponder:textField];
	}
}

+ (void) makeTextFieldFirstResponderAfterTableSelectionChange: (NSNotification *) notification {
	id tableView;

	if ([[notification object] isKindOfClass:[IFHUDTableView class]]) {
		tableView = [notification object];
		id window = [tableView window];

		NSEnumerator * enumerator = [[[[[[tableView superview] superview] superview] superview] subviews] objectEnumerator];
		id object;
		id textField = nil;

		while (object = [enumerator nextObject])
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
	NSEnumerator * enumerator = [[NSApp windows] objectEnumerator];
	id object;
	id notificationWindow = nil;
	id textField = nil;

	while (object = [enumerator nextObject])
		if ([object isKindOfClass:[IFHUDWindow class]]) {
			notificationWindow = object;

			enumerator = [[[notificationWindow contentView] subviews] objectEnumerator];

			while (object = [enumerator nextObject])
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

	while (object = [enumerator nextObject]) {
		if ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"iChat"]) {
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"iChat\" to set status message to \"" stringByAppendingString:statusMessage]
				stringByAppendingString:@"\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
		else if ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"Skype"]) {
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"Skype\" to send command \"SET PROFILE MOOD_TEXT " stringByAppendingString:statusMessage]
				stringByAppendingString:@"\" script name \"Twittereeze\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
		else if ([[object valueForKey:@"NSApplicationName"] isEqualToString:@"Adium"]) {
			script = [[NSAppleScript alloc] initWithSource:
				[[@"tell application \"Adium\" to set my status message to \"" stringByAppendingString:statusMessage]
				stringByAppendingString:@"\""]];
			[script executeAndReturnError:nil];
			[script release];
		}
	}
}

OSStatus HotKeyHandler(EventHandlerCallRef nextHandler, EventRef event, void * userData) {
	EventHotKeyID hkCom;
	GetEventParameter(event, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkCom), NULL, &hkCom);
	int keyID = hkCom.id;

	NSEnumerator * enumerator = [[NSApp windows] objectEnumerator];
	id object;
	id notificationWindow = nil;
	id textField = nil;

	while (object = [enumerator nextObject])
		if ([object isKindOfClass:[IFHUDWindow class]]) {
			notificationWindow = object;

			if ((keyID == 1) && ([notificationWindow isVisible])) // hide if toggle shortcut, and window visible
				[notificationWindow performClose:nil];
			else { // otherwise, open, make frontmost and put focus on text field
				[(IFMainController *)[NSApp delegate] showNotificationWindow:nil];

				NSEnumerator * enumerator = [[[notificationWindow contentView] subviews] objectEnumerator];

				while (object = [enumerator nextObject])
					if ([object isKindOfClass:[IFHUDTextField class]]) {
						textField = object;
						[textField setDelegate:NSApp];
						[NSApp activateIgnoringOtherApps:YES];
						[notificationWindow makeKeyAndOrderFront:[NSApp delegate]];
						[notificationWindow makeFirstResponder:textField];
					}
			}
		}

	return noErr;
}
@end

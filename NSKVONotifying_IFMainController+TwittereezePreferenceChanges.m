//
//  NSKVONotifying_IFMainController+TwittereezePreferenceChanges.m
//  Twittereeze
//
//  Created by Sören Kuklau on 24/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "NSKVONotifying_IFMainController+TwittereezePreferenceChanges.h"

#define TwittereezeBadgeImageViewTag 28832100
//#define TwittereezeCopyrightTextFieldTag 28832101
//#define TwittereezePreferenceSheetContentViewTag 28832102

@implementation NSKVONotifying_IFMainController (TwittereezePreferenceChanges)
- (IBAction) _twittereeze_showPreferenceWindow: (id) sender {
//	NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);

	NSEnumerator * enumerator = [[NSApp windows] objectEnumerator];
	id object;
	id notificationWindow = nil;
	id preferenceSheet = nil;
	id view = nil;

	while (nil != (object = [enumerator nextObject]))
		if ([object isKindOfClass:[IFHUDWindow class]])
			notificationWindow = object;

	[self _twitterrific_showPreferenceWindow:sender];

	if (notificationWindow != nil)
		preferenceSheet = [notificationWindow attachedSheet];

	if (preferenceSheet == nil)
		return;

	view = [preferenceSheet contentView];

	[view setNeedsDisplay:NO];

	// if the badge exists, we've already altered the view
	if ([view viewWithTag:TwittereezeBadgeImageViewTag] != nil)
		return;

	enumerator = [[view subviews] objectEnumerator];

	id twitterrificBannerImageView = nil;
	id refreshPopupButton = nil;

	while (nil != (object = [enumerator nextObject])) {
		NSRect viewFrame = [object frame];

//		if ([object isKindOfClass:[NSTextField class]])
//			NSLog(@"%@ %@ %@", object, [object stringValue], NSStringFromRect([object frame]));

//		NSLog(@"%@ %f", [object class], [object frame].origin.y);

		if (viewFrame.origin.y == 55.0) { // move copyright and version up a little
			viewFrame.origin.y += (11.0 + 8.0);
			[object setFrame:viewFrame];
		}
		else if (viewFrame.origin.y != 13.0) { // move almost everything, except for the bottom buttons, up a lot
			viewFrame.origin.y += (11.0 + 8.0 + 18.0 + 8.0 + 13.0 + 8.0);
			[object setFrame:viewFrame];
		}
		if (([object isKindOfClass:[NSImageView class]]) && (! [object isKindOfClass:[IFClickableImageView class]]))
			twitterrificBannerImageView = object;
		//NSLog(@"%@ %f", [object class], [object frame].origin.y);
		if ([object isKindOfClass:[NSPopUpButton class]] && [object frame].origin.y == 254.0)
			refreshPopupButton = object;
	}

	if (refreshPopupButton != nil)
		[self _twittereeze_substituteRefreshPopupButton:refreshPopupButton withRefreshSliderInView:view];
	[self _twittereeze_addNotifyExternalApplicationCheckboxesToView:view];
	[self _twittereeze_addCopyrightAndVersionTextFieldsToView:view];
//
//		[preferenceSheet setContentView:twitterrificBannerImageView];
//		[preferenceSheet setFrame:[twitterrificBannerImageView frame] display:YES animate:YES];

//		[[preferenceSheet contentView] setTag:TwittereezePreferenceSheetContentViewTag];

//	NSLog(@"%f %f", [preferenceSheet frame].size.height, [[preferenceSheet contentView] frame].size.height);
//	[[preferenceSheet contentView] frame].origin.x=50.0;


//	NSLog(@"%f %f", [preferenceSheet frame].size.height, [[preferenceSheet contentView] frame].size.height);

	NSRect preferenceSheetFrame = [preferenceSheet frame];
	preferenceSheetFrame.size.height += (11.0 + 8.0 + 18.0 + 8.0 + 13.0 + 8.0);
	preferenceSheetFrame.origin.y -= (11.0 + 8.0 + 18.0 + 8.0 + 13.0 + 8.0);
	[preferenceSheet setFrame:preferenceSheetFrame display:YES animate:YES];

	if (twitterrificBannerImageView != nil)
		[self _twittereeze_addBadgeImageToView:view onTopOfBannerImageViewFrame:[twitterrificBannerImageView frame]];

	[view setNeedsDisplay:YES];
}

- (void) _twittereeze_addBadgeImageToView: (NSView *) view onTopOfBannerImageViewFrame: (NSRect) twitterrificBannerImageViewFrame {
	NSImage * twittereezeBadgeImage = [[NSImage alloc] initWithContentsOfFile:
		[[NSBundle bundleForClass:[Twittereeze class]] pathForResource:@"Twittereeze_badge" ofType:@"png"]];
	NSImageView * twittereezeBadgeImageView = [[NSImageView alloc] initWithFrame:twitterrificBannerImageViewFrame];

	[twittereezeBadgeImageView setImage:twittereezeBadgeImage];
	[twittereezeBadgeImageView setTag:TwittereezeBadgeImageViewTag];

	[view addSubview:twittereezeBadgeImageView];
}

- (void) _twittereeze_addNotifyExternalApplicationCheckboxesToView: (NSView *) view {
	NSFont * smallControlFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]];

	// buttom padding, bottom button height, copyright/version fields' heights and paddings
	float buttonY = 13.0 + 28.0 + 14.0 +  11.0 + 8.0 + 11.0 + 8.0;

	// FIXME: y and width aren't proper
	NSTextField * externalApplicationCheckboxesLabel = [[NSTextField alloc] initWithFrame:
		NSMakeRect(17.0, buttonY + 18.0 + 8.0, 180.0, 13.0)];
	NSButton * adiumButton = [[NSButton alloc] initWithFrame:
		NSMakeRect(17.0 + 12.0, buttonY, 60.0, 18.0)];
	NSButton * iChatButton = [[NSButton alloc] initWithFrame:
		NSMakeRect((17.0 + 12.0 + [adiumButton frame].size.width + 8.0), buttonY, 60.0, 18.0)];
	NSButton * skypeButton = [[NSButton alloc] initWithFrame:
		NSMakeRect((17.0 + 12.0 + [adiumButton frame].size.width + 8.0 + [iChatButton frame].size.width + 8.0), buttonY, 60.0, 18.0)];

	[externalApplicationCheckboxesLabel setStringValue:@"If running, change status of:"];
	[adiumButton setTitle:@"Adium"];
	[iChatButton setTitle:@"iChat"];
	[skypeButton setTitle:@"Skype"];

	[externalApplicationCheckboxesLabel setBezeled:NO]; [externalApplicationCheckboxesLabel setBordered:NO];
	[externalApplicationCheckboxesLabel setDrawsBackground:NO];
	[externalApplicationCheckboxesLabel setEditable:NO]; [externalApplicationCheckboxesLabel setEnabled:NO];

	[adiumButton setButtonType:NSSwitchButton];
	[iChatButton setButtonType:NSSwitchButton];
	[skypeButton setButtonType:NSSwitchButton];

	[[externalApplicationCheckboxesLabel cell] setControlSize:NSSmallControlSize];
	[[adiumButton cell] setControlSize:NSSmallControlSize];
	[[iChatButton cell] setControlSize:NSSmallControlSize];
	[[skypeButton cell] setControlSize:NSSmallControlSize];

	[externalApplicationCheckboxesLabel setFont:smallControlFont];
	[adiumButton setFont:smallControlFont]; [iChatButton setFont:smallControlFont]; [skypeButton setFont:smallControlFont];

	[adiumButton bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController]
		withKeyPath:@"values.changeAdiumStatus" options:nil];
	[iChatButton bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController]
		withKeyPath:@"values.changeiChatStatus" options:nil];
	[skypeButton bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController]
		withKeyPath:@"values.changeSkypeStatus" options:nil];

	[view addSubview:externalApplicationCheckboxesLabel];
	[view addSubview:adiumButton]; [view addSubview:iChatButton]; [view addSubview:skypeButton];
}

- (void) _twittereeze_substituteRefreshPopupButton: (NSPopUpButton *) refreshPopupButton withRefreshSliderInView: (NSView *) view {
	// FIXME: doesn't get nor set actual defaults value (bindings? manually?)
	NSSlider * refreshSlider = [[NSSlider alloc] initWithFrame:[refreshPopupButton frame]];
	[[refreshSlider cell] setControlSize:[[refreshPopupButton cell] controlSize]];

	[refreshPopupButton removeFromSuperview]; 
	[view addSubview:refreshSlider];
}

- (void) _twittereeze_addCopyrightAndVersionTextFieldsToView: (NSView *) view {
	NSFont * miniControlFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];
	NSColor * disabledTextColor = [[NSColor blackColor] blendedColorWithFraction:0.85 ofColor:[NSColor whiteColor]];

	NSTextField * copyrightTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(17.0, 55.0, 188.0, 11.0)];
	[copyrightTextField setBezeled:NO]; [copyrightTextField setBordered:NO];
	[copyrightTextField setDrawsBackground:NO];
	[copyrightTextField setTextColor:disabledTextColor];
	[copyrightTextField setEditable:NO]; [copyrightTextField setEnabled:NO];
	[copyrightTextField setFont:miniControlFont];
	[copyrightTextField setStringValue:[@"Twittereeze Copyright " stringByAppendingString:[[NSBundle bundleForClass:[Twittereeze class]]
		localizedStringForKey:@"NSHumanReadableCopyright" value:nil table:@"InfoPlist"]]];
	[view addSubview:copyrightTextField];

	NSTextField * versionTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(207.0, 55.0, 116.0, 11.0)];
	[versionTextField setBezeled:NO]; [versionTextField setBordered:NO];
	[versionTextField setAlignment:NSRightTextAlignment];
	[versionTextField setDrawsBackground:NO];
	[versionTextField setTextColor:disabledTextColor];
	[versionTextField setEditable:NO]; [versionTextField setEnabled:NO];
	[versionTextField setFont:miniControlFont];
	[versionTextField setStringValue:[@"Version " stringByAppendingString:[[[NSBundle bundleForClass:[Twittereeze class]]
		infoDictionary] objectForKey:@"CFBundleVersion"]]];
	[view addSubview:versionTextField];
}
@end

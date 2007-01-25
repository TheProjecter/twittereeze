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
	NSEnumerator * enumerator = [[NSApp windows] objectEnumerator];
	id object;
	id notificationWindow = nil;
	id preferenceSheet = nil;

	while (nil != (object = [enumerator nextObject]))
		if ([object isKindOfClass:[IFHUDWindow class]])
			notificationWindow = object;

	[self _twitterrific_showPreferenceWindow:sender];

	if (notificationWindow != nil)
		preferenceSheet = [notificationWindow attachedSheet];

	if (preferenceSheet == nil)
		return;

	// if the badge exists, we've already altered the view
	if ([[preferenceSheet contentView] viewWithTag:TwittereezeBadgeImageViewTag] != nil)
		return;

	enumerator = [[[preferenceSheet contentView] subviews] objectEnumerator];

	id twitterrificBannerImageView = nil;

	while (nil != (object = [enumerator nextObject])) {
		NSRect viewFrame = [object frame];

		if ([object isKindOfClass:[NSTextField class]])
			NSLog(@"%@ %@ %@", object, [object stringValue], NSStringFromRect([object frame]));


		if (viewFrame.origin.y != 13.0) {
			viewFrame.origin.y += (11.0 + 8.0);
			[object setFrame:viewFrame];
		}
		if (([object isKindOfClass:[NSImageView class]]) && (! [object isKindOfClass:[IFClickableImageView class]]))
			twitterrificBannerImageView = object;
	}

	if (twitterrificBannerImageView != nil) {
		NSImage * twittereezeBadgeImage = [[NSImage alloc] initWithContentsOfFile:
			[[NSBundle bundleForClass:[Twittereeze class]] pathForResource:@"Twittereeze_badge" ofType:@"png"]];
		NSImageView * twittereezeBadgeImageView = [[NSImageView alloc] initWithFrame:[twitterrificBannerImageView frame]];
		[twittereezeBadgeImageView setImage:twittereezeBadgeImage];
		[twittereezeBadgeImageView setTag:TwittereezeBadgeImageViewTag];
		[[preferenceSheet contentView] addSubview:twittereezeBadgeImageView];
//
//		[preferenceSheet setContentView:twitterrificBannerImageView];
//		[preferenceSheet setFrame:[twitterrificBannerImageView frame] display:YES animate:YES];
	}

	NSTextField * copyrightTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(17.0, 55.0, 188.0, 11.0)];
	[copyrightTextField setBezeled:NO]; [copyrightTextField setBordered:NO];
//	[copyrightTextField setAlignment:NSRightTextAlignment];
	[copyrightTextField setDrawsBackground:NO];
	[copyrightTextField setTextColor:[[NSColor blackColor] blendedColorWithFraction:0.75 ofColor:[NSColor whiteColor]]];
	[copyrightTextField setEditable:NO]; [copyrightTextField setEnabled:NO];
	[copyrightTextField setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]]];
	[copyrightTextField setStringValue:[@"Twittereeze Copyright " stringByAppendingString:[[NSBundle bundleForClass:[Twittereeze class]]
		localizedStringForKey:@"NSHumanReadableCopyright" value:nil table:@"InfoPlist"]]];
	[[preferenceSheet contentView] addSubview:copyrightTextField];

	NSTextField * versionTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(207.0, 55.0, 116.0, 11.0)];
	[versionTextField setBezeled:NO]; [versionTextField setBordered:NO];
	[versionTextField setAlignment:NSRightTextAlignment];
	[versionTextField setDrawsBackground:NO];
	[versionTextField setTextColor:[[NSColor blackColor] blendedColorWithFraction:0.75 ofColor:[NSColor whiteColor]]];
	[versionTextField setEditable:NO]; [versionTextField setEnabled:NO];
	[versionTextField setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]]];
	[versionTextField setStringValue:[@"Version " stringByAppendingString:[[[NSBundle bundleForClass:[Twittereeze class]]
		infoDictionary] objectForKey:@"CFBundleVersion"]]];
	[[preferenceSheet contentView] addSubview:versionTextField];

//	NSLog(@"%f %f", [preferenceSheet frame].size.height, [[preferenceSheet contentView] frame].size.height);

	NSRect preferenceSheetFrame = [preferenceSheet frame];
	preferenceSheetFrame.size.height += (11.0 + 8.0);
	preferenceSheetFrame.origin.y -= (11.0 + 8.0);
	[preferenceSheet setFrame:preferenceSheetFrame display:YES animate:YES];
//		[[preferenceSheet contentView] setTag:TwittereezePreferenceSheetContentViewTag];

//	NSLog(@"%f %f", [preferenceSheet frame].size.height, [[preferenceSheet contentView] frame].size.height);
//	[[preferenceSheet contentView] frame].origin.x=50.0;

}
@end

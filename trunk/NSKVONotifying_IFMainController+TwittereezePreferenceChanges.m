//
//  NSKVONotifying_IFMainController+TwittereezePreferenceChanges.m
//  Twittereeze
//
//  Created by Sören Kuklau on 24/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "NSKVONotifying_IFMainController+TwittereezePreferenceChanges.h"

@implementation NSKVONotifying_IFMainController (TwittereezePreferenceChanges)
- (IBAction) _twittereeze_showPreferenceWindow: (id) sender {
	NSEnumerator * enumerator = [[NSApp windows] objectEnumerator];
	id object;
	id notificationWindow = nil;
	id preferenceSheet = nil;

	while (object = [enumerator nextObject])
		if ([object isKindOfClass:[IFHUDWindow class]])
			notificationWindow = object;

	[self _twitterrific_showPreferenceWindow:sender];

	if (notificationWindow != nil)
		preferenceSheet = [notificationWindow attachedSheet];

	enumerator = [[[preferenceSheet contentView] subviews] objectEnumerator];

	id twitterrificBannerImageView = nil;
	while (object = [enumerator nextObject])
		if (([object isKindOfClass:[NSImageView class]]) && (! [object isKindOfClass:[IFClickableImageView class]]))//[[object image] size].width == 340.0))
			twitterrificBannerImageView = object;

	if (twitterrificBannerImageView != nil) {
		NSRect twittereezeBadgeImageFrame = [twitterrificBannerImageView frame];
		NSImage * twittereezeBadgeImage = [[NSImage alloc] initWithContentsOfFile:
			[[NSBundle bundleForClass:[Twittereeze class]] pathForResource:@"Twittereeze_badge" ofType:@"png"]];
		NSImageView * twittereezeBadgeImageView = [[NSImageView alloc] initWithFrame:twittereezeBadgeImageFrame];
		[twittereezeBadgeImageView setImage:twittereezeBadgeImage];
		[[preferenceSheet contentView] addSubview:twittereezeBadgeImageView];
	}
}
@end

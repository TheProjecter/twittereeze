//
//  NSKVONotifying_IFMainController+TwittereezePreferenceChanges.h
//  Twittereeze
//
//  Created by Sören Kuklau on 24/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Twittereeze.h"

@interface IFClickableImageView : NSImageView {}
@end

@interface NSKVONotifying_IFMainController (TwittereezePreferenceChangesPreSwizzle)
- (IBAction) _twitterrific_showPreferenceWindow: (id) sender;
- (IBAction) _twitterrific_showNotificationWindow: (id) sender;
@end

@interface NSKVONotifying_IFMainController (TwittereezePreferenceChanges)
- (IBAction) _twittereeze_showPreferenceWindow: (id) sender;
- (IBAction) _twittereeze_showNotificationWindow: (id) sender;

- (void) _twittereeze_addBadgeImageToView: (NSView *) view onTopOfBannerImageViewFrame: (NSRect) twitterrificBannerImageViewFrame;
- (void) _twittereeze_addNotifyExternalApplicationCheckboxesToView: (NSView *) view;
- (void) _twittereeze_substituteRefreshPopupButton: (NSPopUpButton *) refreshPopupButton withRefreshSliderInView: (NSView *) view;
- (void) _twittereeze_addCopyrightAndVersionTextFieldsToView: (NSView *) view;
@end

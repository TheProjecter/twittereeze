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
@end

@interface NSKVONotifying_IFMainController (TwittereezePreferenceChanges)
- (IBAction) _twittereeze_showPreferenceWindow: (id) sender;
@end
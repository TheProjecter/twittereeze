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
	NSLog(@"before");
	[self _twitterrific_showPreferenceWindow:sender];
	NSLog(@"after");
}
@end

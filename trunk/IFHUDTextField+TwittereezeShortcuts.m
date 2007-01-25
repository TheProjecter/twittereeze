//
//  IFHUDTextField+TwittereezeShortcuts.m
//  Twittereeze
//
//  Created by Sören Kuklau on 21/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "IFHUDTextField+TwittereezeShortcuts.h"

@implementation IFHUDTextField (TwittereezeShortcuts)
- (void) keyUp: (NSEvent *) event {
	unsigned int modifierFlags = [event modifierFlags];
	unsigned short keyCode = [event keyCode];

	if ((! (modifierFlags & NSControlKeyMask) ) && (! (modifierFlags & NSAlternateKeyMask)))
		return;
	if ((keyCode < 125) || (keyCode > 126))
		return;

	NSEnumerator * enumerator = [[[self superview] subviews] objectEnumerator];
	id object;
	IFHUDTableView * tableView = nil;

	while (nil != (object = [enumerator nextObject]))
		if (([object isKindOfClass:[IFHUDBackground class]]) && ([[[[object subviews] objectAtIndex:0] subviews] count] > 0))
			tableView = [[[[[[object subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0];

	if (tableView == nil)
		return;

	if ([tableView numberOfRows] == 0)
		return;

	int row = -1;

	switch (keyCode) {
	case 125: // down arrow key
		if (modifierFlags & NSControlKeyMask)
			// one row lower
			row = ([tableView selectedRow] + 1);
		else if (modifierFlags & NSAlternateKeyMask)
			// very bottom
			row = ([tableView numberOfRows] - 1);
		break;
	case 126: // up arrow key
		if (modifierFlags & NSControlKeyMask)
			// one row higher
			row = ([tableView selectedRow] - 1);
		else if (modifierFlags & NSAlternateKeyMask)
			// very top
			row = 0;
		break;
	}

	if (row != -1)
		[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}
@end

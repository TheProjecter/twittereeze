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
	if (! ([event modifierFlags] & NSControlKeyMask) )
		return;
	if (([event keyCode] < 125) || ([event keyCode] > 126))
		return;

	NSEnumerator * enumerator = [[[self superview] subviews] objectEnumerator];
	id object;
	IFHUDTableView * tableView = nil;

	while (object = [enumerator nextObject])
		if (([object isKindOfClass:[IFHUDBackground class]]) && ([[[[object subviews] objectAtIndex:0] subviews] count] > 0))
			tableView = [[[[[[object subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0];

	if (tableView == nil)
		return;

	if ([tableView numberOfRows] == 0)
		return;

	int row = [tableView selectedRow];

	switch ([event keyCode]) {
	case 125: // down arrow key
		row++; // one row lower
		[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
		break;
	case 126: // up arrow key
		row--; // one row higher
		[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
		break;
	}
}
@end

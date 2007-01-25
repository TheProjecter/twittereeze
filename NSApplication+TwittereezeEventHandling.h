//
//  NSApplication+TwittereezeEventHandling.h
//  Twittereeze
//
//  Created by Sören Kuklau on 19/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

#import "Twittereeze.h"

@interface IFHUDTableView : NSTableView
@end

@interface IFHUDTextField : NSTextField {}
@end

@interface IFHUDBackground : NSView {}
@end

@interface NSApplication (TwittereezeEventHandling)
- (void) _twittereeze_sendEvent: (NSEvent *) event;
- (void) handleStatusMessage: (NSEvent *) event;

OSStatus HotKeyHandler(EventHandlerCallRef nextHandler, EventRef event, void * userData);
@end

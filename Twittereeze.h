//
//  Twittereeze.h
//  Twittereeze
//
//  Created by Sören Kuklau on 16/11/06.
//  Copyright 2006 chucker. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <objc/objc-class.h>

@interface IFMainController : NSObject {
	NSWindow * notificationWindow;
	NSWindow * preferenceWindow;
}

- (BOOL)canHideNotificationWindow;
- (void)toggleWindow;
- (void)showNotificationWindow:(id)fp8;
@end

@interface NSKVONotifying_IFMainController : NSObject {
	NSWindow * notificationWindow;
	NSWindow * preferenceWindow;
}

- (void)toggleWindow;
@end

@interface IFHUDWindow : NSPanel {}
@end

@interface Twittereeze : NSObject {}
+ (Twittereeze *) sharedInstance;
@end

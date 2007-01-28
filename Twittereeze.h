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

@interface IFMainController : NSObject {}
- (void)toggleWindow;
@end

@interface Twittereeze : NSObject {}
+ (Twittereeze *) sharedInstance;
@end

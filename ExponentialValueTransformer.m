//
//  ExponentialValueTransformer.m
//  Twittereeze
//
//  Created by Sören Kuklau on 26/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "ExponentialValueTransformer.h"

@implementation ExponentialValueTransformer
+ (Class) transformedValueClass {
	return [NSNumber class];
}

+ (BOOL) allowsReverseTransformation {
	return YES;
}

- (id) transformedValue: (id) value {
	NSLog(@"%f %f", [value floatValue], log([value floatValue]));
	return [NSNumber numberWithFloat:log([value floatValue])];
}

- (id) reverseTransformedValue: (id) value {
	NSLog(@"%f %f", [value floatValue], exp([value floatValue]));
	return [NSNumber numberWithFloat:exp([value floatValue])];
}
@end

//
//  NearExponentialValueTransformer.m
//  Twittereeze
//
//  Created by Sören Kuklau on 26/01/07.
//  Copyright 2007 chucker. All rights reserved.
//

#import "NearExponentialValueTransformer.h"

@implementation NearExponentialValueTransformer
+ (Class) transformedValueClass {
	return [NSNumber class];
}

+ (BOOL) allowsReverseTransformation {
	return YES;
}

- (id) transformedValue: (id) value {
	return [NSNumber numberWithFloat:log([value floatValue])];
}

- (id) reverseTransformedValue: (id) value {
	return [NSNumber numberWithFloat:exp([value floatValue])];
}
@end

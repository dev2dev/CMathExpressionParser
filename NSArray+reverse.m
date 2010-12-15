//
//  NSArray+reverse.m
//  CMathParser
//
//  Created by Johannes Wolf on 27.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSArray+reverse.h"


@implementation NSMutableArray (reverse)

- (void) reverse {
	NSUInteger i, count = [self count];
	for (i = 0; i < count; i++) {
		NSObject * obj = [self objectAtIndex:i];
		[self removeObject:obj];
		[self insertObject:obj atIndex:0];
	}
}

@end

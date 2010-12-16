//
//  NSArray+reverse.m
//  CMathParser
//
//  Created by Johannes Wolf on 27.09.10.
//  Copyright 2010 beanage. All rights reserved.
//

#import "NSArray+reverse.h"

@implementation NSArray (reverse)

- (NSArray *) reversedArray;
{
	return [[self reverseObjectEnumerator] allObjects];
}

@end


@implementation NSMutableArray (reverse)

- (void) reverse {
	[self setArray: [self reversedArray]];
}

@end

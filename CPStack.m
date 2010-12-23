//
//  CPStack.m
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 13.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import "CPStack.h"
#import "CPToken.h"
#import "NSArray+reverse.h"

@implementation CPStack

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		stack = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[stack release];
	[super dealloc];
}

#pragma mark -
#pragma mark PLACEHOLDER

+ (CPStack *) stack
{
	return [[[CPStack alloc] init] autorelease];
}

#pragma mark -
#pragma mark push / pop

- (void) push:(CPToken *)token
{
	[stack addObject: token];
}

- (CPToken *) pop
{
	id result = nil;
	if ([stack count] != 0) {
		result = [stack lastObject];
		[stack removeLastObject];
	}
	return result;
}

#pragma mark -
#pragma mark last- / tokenAtIndex

- (CPToken *) lastToken
{
	return [stack lastObject];
}

- (CPToken *) tokenAtIndex:(NSInteger)index
{
	return [stack objectAtIndex: index];
}

#pragma mark -
#pragma mark count

- (NSInteger) count
{
	return [stack count];
}

#pragma mark -
#pragma mark description

- (NSString *) description
{
	return [stack description];
}

- (NSArray *) popUpToOperator: (CPOperator) op;
{
	return [self popUpToToken: [CPToken tokenWithOperator: op]];
}

- (NSArray *) popUpToToken: (CPToken *) search;
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	bool found = false;
	while (![self isEmpty]) {
		CPToken *token = [self pop];
		if ([token isEqual: search]) {
			found = true;
			break;
		} else {
			[result addObject: token];
		}
	}
	
	if (!found) {
		[result release];
		result = nil;
	}
	
	return [result autorelease];
}

- (NSArray *) popAll;
{
	NSArray *result = [stack reversedArray];
	[stack removeAllObjects];
	return result;
}

- (BOOL) isEmpty;
{
	return [stack count] == 0;
}

@end

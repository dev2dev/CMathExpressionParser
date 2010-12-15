//
//  CPStack.m
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 13.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import "CPStack.h"
#import "CPToken.h"

@implementation CPStack

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		stack = [[NSMutableArray alloc] init];
		position = 0;
	}
	return self;
}

- (void) dealloc
{
	position = 0;
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
	[stack insertObject:token atIndex:position++];
}

- (CPToken *) pop
{
	return (position > 0) ? [stack objectAtIndex:--position] : nil;
}

#pragma mark -
#pragma mark last- / tokenAtIndex

- (CPToken *) lastToken
{
	return [stack lastObject];
}

- (CPToken *) tokenAtIndex:(NSInteger)index
{
	return [stack objectAtIndex:(index <= position) ? index : position ];
}

#pragma mark -
#pragma mark count / position

- (NSInteger) count
{
	return [stack count];
}

- (NSInteger) position
{
	return position;
}

#pragma mark -
#pragma mark description

- (NSString *) description
{
	return [stack description];
}

@end

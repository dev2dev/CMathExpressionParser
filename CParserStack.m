//
//  CParserStack.m
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserStack.h"


@implementation CParserStack

#pragma mark -
#pragma mark Init / Dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		stackArray = [[NSMutableArray alloc] init];
		position = 0;
	}
	return self;
}

- (void) dealloc
{
	[stackArray release];
	position = 0;
	[super dealloc];
}

+ (CParserStack *) stack
{
	return [[[CParserStack alloc] init] autorelease];
}

#pragma mark -
#pragma mark Push / Pop / TokenAtIndex 

- (void) push:(CParserToken *)token
{
	[stackArray insertObject:token atIndex:position];
	position++;
}

- (CParserToken *) pop
{
	position--;
	if (position >= 0 && position <= [self count]) {
		CParserToken * token = [stackArray objectAtIndex:position];
		return token;
	}
	return nil;
}

- (CParserToken *) tokenAtIndex:(int)index
{
	if (index >= 0 && index <= [self count])
		return [stackArray objectAtIndex:index];
	return nil;
}

- (CParserToken *) lastToken
{
	if (position >= 0 && position <= [self count])
		return [stackArray objectAtIndex:position-1];
	return nil;
}

#pragma mark -
#pragma mark Count / Position

- (int) count
{
	return [stackArray count];
}

- (int) position
{
	return position;
}

#pragma mark -
#pragma mark Description

- (NSString *) description
{
	return [stackArray description];
}

@end

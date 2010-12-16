//
//  CParserVariable.m
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserVariable.h"


@implementation CParserVariable

#pragma mark -
#pragma mark Init / Dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		value = 0.0;
	}
	return self;
}

- (void) dealloc
{
	value = 0.0;
	[super dealloc];
}

+ (CParserVariable *) variable
{
	return [[[CParserVariable alloc] init] autorelease];
}

+ (CParserVariable *) variableWithValue:(double)val
{
	return [[[CParserVariable alloc] initWithValue:val] autorelease];
}

- (id) initWithValue:(double)val
{
	self = [super init];
	if (self != nil) {
		value = val;
	}
	return self;
}

#pragma mark -
#pragma mark Seter / Geter

- (void) setValue:(double)val
{
	value = val;
}

- (double) value
{
	return value;
}

#pragma mark -
#pragma mark Description

- (NSString *) description
{
	return [NSString stringWithFormat:@"Value = %f", value];
}

@end

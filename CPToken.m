//
//  CPToken.m
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 13.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import "CPToken.h"


@implementation CPToken

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setType:CPTokenNull];
		[self setNumberValue:0.0];
		[self setOperatorValue:CPOperatorNull];
		[self setStringValue:nil];
	}
	return self;
}

- (void) dealloc
{
	[self setType:CPTokenNull];
	[self setNumberValue:0.0];
	[self setOperatorValue:CPOperatorNull];
	[self setStringValue:nil];
	[super dealloc];
}

#pragma mark -
#pragma mark initWith*

- (id) initWithNumber:(CPNumber)value
{
	self = [super init];
	if (self != nil) {
		[self setType:CPTokenNumber];
		[self setNumberValue:value];
		[self setOperatorValue:CPOperatorNull];
		[self setStringValue:nil];
	}
	return self;
}

- (id) initWithOperator:(CPOperator)value
{
	self = [super init];
	if (self != nil) {
		[self setType:CPTokenOperator];
		[self setNumberValue:0.0];
		[self setOperatorValue:value];
		[self setStringValue:nil];
	}
	return self;
}

- (id) initWithString:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setType:CPTokenNull];
		[self setNumberValue:0.0];
		[self setOperatorValue:CPOperatorNull];
		[self setStringValue:value];
	}
	return self;
}

#pragma mark -
#pragma mark PLATZHALTER

+ (CPToken *) token
{
	return [[[CPToken alloc] init] autorelease];
}

+ (CPToken *) tokenWithNumber:(CPNumber)value
{
	return [[[CPToken alloc] initWithNumber:value] autorelease];
}

+ (CPToken *) tokenWithOperator:(CPOperator)value
{
	return [[[CPToken alloc] initWithOperator:value] autorelease];
}

+ (CPToken *) tokenWithVariable:(NSString *)value
{
	CPToken *token = [[[CPToken alloc] initWithString:value] autorelease];
	[token setType:CPTokenVariable];
	return token;
}

+ (CPToken *) tokenWithFunction:(NSString *)value
{
	CPToken *token = [[[CPToken alloc] initWithString:value] autorelease];
	[token setType:CPTokenFunction];
	return token;
}

+ (CPToken *) tokenWithType:(CPTokenType)value
{
	CPToken *token = [[[CPToken alloc] init] autorelease];
	[token setType:value];
	return token;
}

#pragma mark -
#pragma mark accessors

- (void) setNumberValue:(CPNumber)value
{
	numberValue = value;
}

- (CPNumber) numberValue
{
	return numberValue;
}

- (void) setOperatorValue:(CPOperator)value
{
	operatorValue = value;
}

- (CPOperator) operatorValue
{
	return operatorValue;
}

- (void) setStringValue:(NSString *)value
{
	if (value != stringValue) {
		[stringValue release];
		stringValue = [value retain];
	}
}

- (NSString *) stringValue
{
	return stringValue;
}

#pragma mark -
#pragma mark setType / type

- (void) setType:(CPTokenType)value
{
	type = value;
}

- (CPTokenType) type
{
	return type;
}

#pragma mark -
#pragma mark description

- (NSString *) description
{
	switch (type) {
		case CPTokenNull:
			return @"null";
			break;
		case CPTokenNumber:
			return [NSString stringWithFormat:@"number: %.4f", numberValue];
			break;
		case CPTokenOperator:
			return [NSString stringWithFormat:@"operator: %d", operatorValue];
			break;
		case CPTokenVariable:
		case CPTokenFunction:
			return [NSString stringWithFormat:@"string: %@", stringValue];
			break;
		case CPTokenArgStop:
			return @"[arg stop]";
			break;
		default:
			return [NSString stringWithFormat:@"type: %d", type];
			break;
	}
}

@end

//
//  CParserToken.m
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserToken.h"

@interface CParserToken ()

@property (readwrite, copy, nonatomic) NSString *name;

@end


@implementation CParserToken

#pragma mark -
#pragma mark Init / Dealloc

- (void) dealloc
{
	[name release]; name = nil;
	
	[super dealloc];
}

+ (CParserToken *) token
{
	return [[[CParserToken alloc] init] autorelease];
}

+ (CParserToken *) tokenWithNumber:(double)value
{
	return [[[CParserToken alloc] initWithNumber:value] autorelease];
}

+ (CParserToken *) tokenWithOperator:(NSString *)value
{
	return [[[CParserToken alloc] initWithOperator:value] autorelease];
}

+ (CParserToken *) tokenWithFunction:(NSString *)value
{
	return [[[CParserToken alloc] initWithFunction:value] autorelease];
}

+ (CParserToken *) tokenWithVariable:(NSString *)value
{
	return [[[CParserToken alloc] initWithVariable:value] autorelease];
}

+ (CParserToken *) tokenWithMacro:(NSString *)value
{
	return [[[CParserToken alloc] initWithMacro:value] autorelease];
}

- (id) initWithNumber:(double)value
{
	self = [super init];
	if (self != nil) {
		[self setNumberValue:value];
	}
	return self;
}

- (id) initWithOperator:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setOperatorValue:value];
	}
	return self;
}

- (id) initWithFunction:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setFunctionValue:value];
	}
	return self;
}
- (id) initWithVariable:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setVariableValue:value];
	}
	return self;
}
- (id) initWithMacro:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setMacroValue:value];
	}
	return self;
}

@synthesize type = tokenType;
@synthesize name;

- (double) numberValue;
{
	NSParameterAssert( CParserTokenNumber == tokenType || CParserTokenVariable == tokenType );
	return numberValue;
}

- (void) setNumberValue: (double)newNumber;
{
	numberValue = newNumber;
	if (CParserTokenNumber != tokenType && CParserTokenVariable != tokenType) {
		tokenType = CParserTokenNumber;
		[self setName: nil];
	}
}

- (NSString *) operatorValue;
{
	NSParameterAssert( CParserTokenOperator == tokenType );
	return [self name];
}

- (void) setOperatorValue: (NSString *)value;
{
	[self setName: value];
	tokenType = CParserTokenOperator;
}

- (NSString *) functionValue;
{
	NSParameterAssert( CParserTokenFunction == tokenType );
	return [self name];
}

- (void) setFunctionValue: (NSString *)value;
{
	[self setName: value];
	tokenType = CParserTokenFunction;
}

- (NSString *) variableValue;
{
	NSParameterAssert( CParserTokenVariable == tokenType );
	return [self name];
}

- (void) setVariableValue: (NSString *)value;
{
	[self setName: value];
	tokenType = CParserTokenVariable;
}

- (NSString *) macroValue;
{
	NSParameterAssert( CParserTokenMacro == tokenType );
	return [self name];
}

- (void) setMacroValue: (NSString *)value;
{
	[self setName: value];
	tokenType = CParserTokenMacro;
}

#pragma mark -
#pragma mark Description

- (NSString *) description
{
	switch (tokenType) {
		case CParserTokenNull:
			return @"NULL";
			break;
		case CParserTokenNumber:
			return [NSString stringWithFormat:@"Number: %f", numberValue];
			break;
		case CParserTokenOperator:
			return [NSString stringWithFormat:@"Operator: %@", [self name]];
			break;
		case CParserTokenFunction:
			return [NSString stringWithFormat:@"Function: %@", [self name]];
			break;
		case CParserTokenVariable:
			return [NSString stringWithFormat:@"Variable: %@", [self name]];
			break;
		case CParserTokenMacro:
			return [NSString stringWithFormat:@"Macro: %@", [self name]];
			break;
		default:
			break;
	}
	return @"NULL";
}


@end

//
//  CParserToken.m
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserToken.h"


@implementation CParserToken

#pragma mark -
#pragma mark Init / Dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		tokenType = CParserTokenNull;
		numberValue = 0.0;
		operatorValue = 0;
		functionValue = [NSString string];
		variableValue = [NSString string];
		macroValue = [NSString string];
	}
	return self;
}

- (void) dealloc
{
	tokenType = CParserTokenNull;
	numberValue = 0;
	operatorValue = 0;
	[functionValue release];
	[variableValue release];
	[macroValue release];
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
		[self setType:CParserTokenNumber];
		[self setNumberValue:value];
		[self setOperatorvalue:[NSString string]];
		[self setFunctionValue:[NSString string]];
		[self setVariableValue:[NSString string]];
		[self setMacroValue:[NSString string]];
	}
	return self;
}

- (id) initWithOperator:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setType:CParserTokenOperator];
		[self setNumberValue:0.0];
		[self setOperatorvalue:value];
		[self setFunctionValue:[NSString string]];
		[self setVariableValue:[NSString string]];
		[self setMacroValue:[NSString string]];
	}
	return self;
}

- (id) initWithFunction:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setType:CParserTokenFunction];
		[self setNumberValue:0.0];
		[self setOperatorvalue:[NSString string]];
		[self setFunctionValue:value];
		[self setVariableValue:[NSString string]];
		[self setMacroValue:[NSString string]];
	}
	return self;
}
- (id) initWithVariable:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setType:CParserTokenVariable];
		[self setNumberValue:0.0];
		[self setOperatorvalue:[NSString string]];
		[self setFunctionValue:[NSString string]];
		[self setVariableValue:value];
		[self setMacroValue:[NSString string]];
	}
	return self;
}
- (id) initWithMacro:(NSString *)value
{
	self = [super init];
	if (self != nil) {
		[self setType:CParserTokenMacro];
		[self setNumberValue:0.0];
		[self setOperatorvalue:[NSString string]];
		[self setFunctionValue:[NSString string]];
		[self setVariableValue:[NSString string]];
		[self setMacroValue:value];
	}
	return self;
}

#pragma mark -
#pragma mark Get Value

- (double) numberValue
{
	return numberValue;
}

- (NSString *) operatorValue
{
	return operatorValue;
}

- (NSString *) functionValue
{
	return functionValue;
}

- (NSString *) variableValue
{
	return variableValue;
}

- (NSString *) macroValue
{
	return macroValue;
}

#pragma mark -
#pragma mark Set Value

- (void) setNumberValue:(double)value
{
	numberValue = value;
}

- (void) setOperatorvalue:(NSString *)value
{
	if (operatorValue != value) {
		[operatorValue release];
		operatorValue = [value retain];
	}
}

- (void) setFunctionValue:(NSString *)value
{
	if (functionValue != value) {
		[functionValue release];
		functionValue = [value retain];
	}
}

- (void) setVariableValue:(NSString *)value
{
	if (variableValue != value) {
		[variableValue release];
		variableValue = [value retain];
	}
}

- (void) setMacroValue:(NSString *)value
{
	if (macroValue != value) {
		[macroValue release];
		macroValue = [value retain];
	}
}

#pragma mark -
#pragma mark Type

- (int) type
{
	return tokenType;
}

- (void) setType:(int)value
{
	tokenType = value;
}

#pragma mark -
#pragma mark Description

- (NSString *) description
{
	switch (tokenType) {
		case 0:
			return @"NULL";
			break;
		case 1:
			return [NSString stringWithFormat:@"Number: %f", numberValue];
			break;
		case 2:
			return [NSString stringWithFormat:@"Operator: %@", operatorValue];
			break;
		case 3:
			return [NSString stringWithFormat:@"Function: %@", functionValue];
			break;
		case 4:
			return [NSString stringWithFormat:@"Variable: %@", variableValue];
			break;
		case 5:
			return [NSString stringWithFormat:@"Macro: %@", macroValue];
			break;
		default:
			break;
	}
	return @"NULL";
}

@end

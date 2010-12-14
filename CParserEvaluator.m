//
//  CParserEvaluator.m
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserEvaluator.h"

#include "CParserMath.c"
#import "NSArray+reverse.h"

@interface CParserEvaluator ()

- (int) operatorArgumentCount:(NSString *)string;
- (BOOL) operatorAssociativity:(NSString *)string;

@end

@implementation CParserEvaluator

#pragma mark -
#pragma mark Init / Dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setVariableDictionary:[NSMutableDictionary dictionary]];
		[self setFunctionDictionary:[NSMutableDictionary dictionary]];
		[self setMacroDictionary:[NSMutableDictionary dictionary]];
	}
	return self;
}

- (void) dealloc
{
	[variableDictionary release];
	[functionDictionary release];
	[macroDictionary release];
	[super dealloc];
}

+ (CParserEvaluator *) evaluator
{
	return [[[CParserEvaluator alloc] init] autorelease];
}

#pragma mark -
#pragma mark Evaluate

- (double) evaluatePostfixArray:(NSArray *)array
{
	NSMutableArray *stack = [NSMutableArray array];
	
	NSUInteger i, count = [array count];
	for (i = 0; i < count; i++) {
		CParserToken * token = [array objectAtIndex:i];
		
		int type = [token type];
		
		if (type == CParserTokenNull) {
			
		}
		if (type == CParserTokenNumber) {
			
			[stack addObject:token];
		}
		if (type == CParserTokenOperator) {
			
			NSString * operator = [token operatorValue];
			double result = 0.0;
			
			if ([stack count] >= [self operatorArgumentCount:[token operatorValue]])
			{
				
				if ([self operatorArgumentCount:[token operatorValue]] == 1) {
					CParserToken *token1 = [stack lastObject];
					
					if ([operator isEqualToString:@"!"]) {
						result = (double)factorial((int)[token1 numberValue]);
					}
					
					[stack removeObject:token1];
					[stack addObject:[CParserToken tokenWithNumber:result]];
					
				} else if ([self operatorArgumentCount:[token operatorValue]] == 2) {
					CParserToken *token1 = [stack objectAtIndex:[stack count]-2];
					CParserToken *token2 = [stack lastObject];
					
					if ([operator isEqualToString:@"="]) {
						if ([token1 type] == CParserTokenVariable) {
							[self setVariable:[CParserVariable variableWithValue:[token2 numberValue]] forKey:[token1 variableValue]];
						} else {
							NSException * exception = [NSException exceptionWithName:@"Syntax Error"
																			  reason:@"Asignment Error"
																			userInfo:nil];
							@throw exception;
						}
					}
					if ([operator isEqualToString:@"+"]) {
						result = ([token1 numberValue] + [token2 numberValue]);
					}
					if ([operator isEqualToString:@"-"]) {
						result = ([token1 numberValue] - [token2 numberValue]);
					}
					if ([operator isEqualToString:@"*"]) {
						result = ([token1 numberValue] * [token2 numberValue]);
					}
					if ([operator isEqualToString:@"/"]) {
						if ([token2 numberValue] == 0) {
							result = INFINITY;
						} else {
							result = ([token1 numberValue] / [token2 numberValue]);
						}
					}
					if ([operator isEqualToString:@"^"]) {
						result = pow([token1 numberValue], [token2 numberValue]);
					}
					if ([operator isEqualToString:@"%"]) {
						result = (lround([token1 numberValue]) % lround([token2 numberValue]));
					}
					
					//special
					
					if ([operator isEqualToString:@"<"]) {//kleiner
						if ([token1 numberValue] < [token2 numberValue])
							result = 1.0;
					}
					if ([operator isEqualToString:@">"]) {//größer
						if ([token1 numberValue] > [token2 numberValue])
							result = 1.0;
					}
					if ([operator isEqualToString:@"&&"]) {//and
						result = ([token1 numberValue] && [token2 numberValue]);
						NSLog(@"%f && %f = %f",[token1 numberValue], [token2 numberValue], result);
					}
					if ([operator isEqualToString:@"||"]) {//or
						result = ([token1 numberValue] || [token2 numberValue]);
						NSLog(@"%f || %f = %f",[token1 numberValue], [token2 numberValue], result);
					}
					if ([operator isEqualToString:@"=="]) {//vergleich
						if ([token1 numberValue] == [token2 numberValue]) {
							result = 1.0;
						} else {
							result = 0.0;
						}

					}
					if ([operator isEqualToString:@"!="]) {//vergleich
						if ([token1 numberValue] != [token2 numberValue])
							result = 1.0;
					}
					if ([operator isEqualToString:@"<="]) {//kleiner gleich
						if ([token1 numberValue] <= [token2 numberValue])
							result = 1.0;
					}
					if ([operator isEqualToString:@">="]) {//groeßer gleich
						if ([token1 numberValue] >= [token2 numberValue])
							result = 1.0;
					}
					
					[stack removeObject:token2];
					[stack removeObject:token1];
					
					[stack addObject:[CParserToken tokenWithNumber:result]];
				}
			} else {
				NSException * exception = [NSException exceptionWithName:@"Syntax Error"
																  reason:@"Operator Argument Error"
																userInfo:nil];
				@throw exception;
			}
			
		}
		if (type == CParserTokenFunction) { // -=FUNCTION=-

			CParserFunction * function = [self functionForKey:[token functionValue]];
			
			double result = 0.0;
			
			if ([stack count] >= [function minArguments]) {
				NSMutableArray * arguments = [NSMutableArray array];
				
				for (int i = 0; i < [function minArguments]; i++)
				{
					[arguments addObject:[stack lastObject]];
					[stack removeObject:[stack lastObject]];
				}
				
				[arguments reverse];
				
				result = [function evaluateWithArguments:arguments];
			} else {
				NSException * exception = [NSException exceptionWithName:@"Syntax Error"
																  reason:@"Function Argument Error"
																userInfo:nil];
				@throw exception;
			}
			
			[stack addObject:[CParserToken tokenWithNumber:result]];
			
		}
		if (type == CParserTokenVariable) { // -=VARIABLE=-

			CParserToken * newToken = [CParserToken tokenWithVariable:[NSString stringWithString:[token variableValue]]];
			[newToken setNumberValue:[[self variableForKey:[token variableValue]] value]];

			[stack addObject:newToken];

		}
		if (type == CParserTokenMacro) { // -=MACRO=-
			
			CParserMacro * macro = [self macroForKey:[token macroValue]];
			
			double result = 0.0;
			
			if ([stack count] >= [macro minArguments]) {
				NSMutableArray * arguments = [NSMutableArray array];
				
				for (int i = 0; i < [macro minArguments]; i++)
				{
					[arguments addObject:[stack lastObject]];
					[stack removeObject:[stack lastObject]];
				}
				
				[arguments reverse];
				
				result = [macro evaluateWithArguments:arguments];
			} else {
				NSException * exception = [NSException exceptionWithName:@"Syntax Error"
																  reason:@"Macro Argument Error"
																userInfo:nil];
				@throw exception;
			}
			
			[stack addObject:[CParserToken tokenWithNumber:result]];
			
		}
		if (type == CParserTokenMatrix) { // -=MATRIX=-
			
			[stack addObject:[CParserToken tokenWithNumber:0.0]];
			
			//FIX
			
		}
	}
	
	return [[stack lastObject] numberValue];
}

#pragma mark -
#pragma mark Seter / Geter

- (void) setVariableDictionary:(NSMutableDictionary *)dict
{
	if (variableDictionary != dict) {
		[variableDictionary release];
		variableDictionary = [dict retain];
	}
}

- (NSMutableDictionary *) variableDictionary
{
	return variableDictionary;
}

- (void) setFunctionDictionary:(NSMutableDictionary *)dict
{
	if (functionDictionary != dict) {
		[functionDictionary release];
		functionDictionary = [dict retain];
	}
}

- (NSMutableDictionary *) functionDictionary
{
	return functionDictionary;
}

- (void) setMacroDictionary:(NSMutableDictionary *)dict
{
	if (macroDictionary != dict) {
		[macroDictionary release];
		macroDictionary = [dict retain];
	}
}

- (NSMutableDictionary *) macroDictionary
{
	return macroDictionary;
}

- (void) setVariable:(CParserVariable *)variable forKey:(NSString *)key
{
	if (variableDictionary) {
		[variableDictionary setObject:variable forKey:key];
	}
}

- (CParserVariable *) variableForKey:(NSString *)key
{
	return [variableDictionary objectForKey:key];
}

- (void) setFunction:(CParserFunction *)func forKey:(NSString *)key
{
	[functionDictionary setObject:func forKey:key];
}

- (CParserFunction *) functionForKey:(NSString *)key
{
	if (functionDictionary) {
		return [functionDictionary objectForKey:key];
	}
	return nil;
}


- (void) setMacro:(CParserMacro *)macro forKey:(NSString *)key
{
	[macroDictionary setObject:macro forKey:key];
}

- (CParserMacro *) macroForKey:(NSString *)key
{
	if (macroDictionary) 
	{
		NSString * newKey = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
		return [macroDictionary objectForKey:newKey];
	}
	return nil;
}

//private

- (BOOL) operatorAssociativity:(NSString *)string
{
	if([string isEqualToString:@"+"] || [string isEqualToString:@"-"] || [string isEqualToString:@"*"] ||
	   [string isEqualToString:@"/"] || [string isEqualToString:@"%"] || [string isEqualToString:@"^"])
		return YES; //left
	if ([string isEqualToString:@"="] || [string isEqualToString:@"!"])
		return NO; //right
	return YES;
}

- (int) operatorArgumentCount:(NSString *)string
{
	if([string isEqualToString:@"+"] || [string isEqualToString:@"-"] || [string isEqualToString:@"*"] ||
	   [string isEqualToString:@"/"] || [string isEqualToString:@"^"] || [string isEqualToString:@"%"] ||
	   [string isEqualToString:@"="] || [string isEqualToString:@"<"] || [string isEqualToString:@">"] ||
	   [string isEqualToString:@"=="] || [string isEqualToString:@"<="] || [string isEqualToString:@">="] ||
	   [string isEqualToString:@"!="]|| [string isEqualToString:@"&&"]|| [string isEqualToString:@"||"])
		return 2;
	if ([string isEqualToString:@"!"])
		return 1;
	return 0;
}

@end

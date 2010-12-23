//
//  CPEvaluator.m
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 14.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#include "CParserMath.h"

#import "CPEvaluator.h"

#import "CPToken.h"
#import "CPTokenizer.h"

#import "CParserFunction.h"
#import "CParserCFunction.h"
#import "NSArray+reverse.h"
#import "CPStack.h"

@interface CPEvaluator ()
- (void) registerStandardFunctions;
- (void) registerConstants;
@end

@implementation CPEvaluator

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self registerStandardFunctions];
		[self registerConstants];
	}
	return self;
}

- (void) dealloc
{
	[self setVariables:nil];
	[self setFunctions:nil];
	[super dealloc];
}

#pragma mark -
#pragma mark PLATZHALTER

+ (CPEvaluator *) evaluator
{
	return [[[CPEvaluator alloc] init] autorelease];
}

#pragma mark -
#pragma mark evaluate postfix array

- (double) evaluatePostfixExpressionArray:(NSArray *)array
{
	
	CPStack *stack = [CPStack stack];
	
	for (CPToken *token in array) {
		CPToken *newToken = [CPToken tokenWithNumber:0.0];
		CPOperator operator = [token operatorValue];
		
		switch ([token type]) {
			case CPTokenNull:
				//
				break;
			case CPTokenNumber:
				[newToken setNumberValue:[token numberValue]];
				break;
			case CPTokenOperator:
				if ([stack count] >= [Operators argumentCount: operator])
				{
					double operants[2];
					
					if ([Operators argumentCount:operator] == 1) {
						operants[0] = [[stack pop] numberValue];
						
						switch (operator) {
							case CPOperatorFactorial:
								[newToken setNumberValue:factorial(operants[0])];
								break;
							case CPOperatorNeg:
								[newToken setNumberValue: -operants[0]];
								break;
							default:
								break;
						}
						
						
					} else if ([Operators argumentCount:operator] == 2) {
						CPToken *second = [stack pop];
						CPToken *first = [stack pop];
						operants[1] = [second numberValue];
						operants[0] = [first numberValue];
						
						switch (operator) {
							case CPOperatorPlus:
								[newToken setNumberValue:operants[0] + operants[1]];
								break;
							case CPOperatorMinus:
								[newToken setNumberValue:operants[0] - operants[1]];
								break;
							case CPOperatorTimes:
								[newToken setNumberValue:operants[0] * operants[1]];
								break;
							case CPOperatorDiv:
								if (operants[1] == 0.0) {
									NSException *exception = [NSException exceptionWithName:@"Divide by 0 Error"
																					 reason:@"Divide by Zero" 
																				   userInfo:nil];
									@throw exception;
								} else
									[newToken setNumberValue:operants[0] / operants[1]];
								break;
							case CPOperatorModulo:
								[newToken setNumberValue:fmod(operants[0], operants[1])];
								break;
							case CPOperatorAssign:
								if ([first type] == CPTokenVariable) {
									[self setVariable:[NSNumber numberWithDouble:operants[1]] forKey:[first stringValue]];
								} else {
									NSException *exception = [NSException exceptionWithName:@"Assignment Error"
																					 reason:@"Left token is not a variable" 
																				   userInfo:nil];
									@throw exception;
								}

								[newToken setNumberValue:operants[1]];
								break;
							case CPOperatorPower:
								[newToken setNumberValue:pow(operants[0], operants[1])];
								break;
							case CPOperatorLT:
								[newToken setNumberValue:operants[0] < operants[1]];
								break;
							case CPOperatorLE:
								[newToken setNumberValue:operants[0] <= operants[1]];
								break;
							case CPOperatorGT:
								[newToken setNumberValue:operants[0] > operants[1]];
								break;
							case CPOperatorGE:
								[newToken setNumberValue:operants[0] >= operants[1]];
								break;
							case CPOperatorNEqual:
								[newToken setNumberValue:operants[0] != operants[1]];
								break;
							case CPOperatorEqual:
								[newToken setNumberValue:operants[0] == operants[1]];
								break;
							case CPOperatorAnd:
								[newToken setNumberValue:operants[0] && operants[1]];
								break;
							case CPOperatorOr:
								[newToken setNumberValue:operants[0] || operants[1]];
								break;
							default:
								[newToken setNumberValue:0.0];
								break;
						}
						
					}
				}
				
				break;
			case CPTokenVariable:
				[newToken setStringValue:[token stringValue]]; //set var name
				[newToken setType:CPTokenVariable]; //set type to var (for assignment)
				[newToken setNumberValue:([variables objectForKey:[token stringValue]] != nil) ? ([[variables objectForKey:[token stringValue]] doubleValue]) : 0.0];
				break;
				
			case CPTokenFunction: {
				CParserFunction *function = [self functionForKey:[token stringValue]];
				NSArray *args = [stack popUpToToken: [CPToken tokenWithType: CPTokenArgStop]];
				if ([args count] < [function minArguments] || [args count] > [function maxArguments]) {
					NSException *exception = [NSException exceptionWithName:CPSyntaxErrorException
																	 reason:@"Function Argument Error"
																   userInfo:nil];
					@throw exception;
				} else {
					[newToken setNumberValue:[function evaluateWithArguments:[args reversedArray]]];
				}
				break;
			}
				
				
			case CPTokenArgStop:
				[newToken setType:CPTokenArgStop];
				
			default:
				break;
		}
		[stack push:newToken];
	}
	
	return [[stack lastToken] numberValue];
}

#pragma mark -
#pragma mark set / get

- (void) setVariables:(NSMutableDictionary *)dict
{
	if (dict != variables) {
		[variables release];
		variables = [dict retain];
	}
}

- (NSDictionary *) variables
{
	return variables;
}

- (void) setFunctions:(NSMutableDictionary *)dict
{
	if (dict != functions) {
		[functions release];
		functions = [dict retain];
	}
}

- (NSDictionary *) functions
{
	return functions;
}

#pragma mark -
#pragma mark add/get variable/functions

- (void) setVariable:(NSNumber *)var forKey:(NSString *)key
{
	if (variables == nil) {
		[self setVariables:[NSMutableDictionary dictionary]];
	}
	
	[variables setObject:var forKey:key];
}

- (NSNumber *) variableForKey:(NSString *)key
{
	return [variables objectForKey:key];
}

- (void) setFunction:(CParserFunction *)var forKey:(NSString *)key
{
	if (functions == nil) {
		[self setFunctions:[NSMutableDictionary dictionary]];
	}
	
	[functions setObject:var forKey:key];
}

- (CParserFunction *) functionForKey:(NSString *)key
{
	return [functions objectForKey:key];
}

- (void) registerStandardFunctions;
{
	[self setFunction: [CParserCFunction unaryFunction: sin] forKey: @"sin"];
	[self setFunction: [CParserCFunction unaryFunction: cos] forKey: @"cos"];
	[self setFunction: [CParserCFunction unaryFunction: tan] forKey: @"tan"];
	[self setFunction: [CParserCFunction unaryFunction: asin] forKey: @"asin"];
	[self setFunction: [CParserCFunction unaryFunction: acos] forKey: @"acos"];
	[self setFunction: [CParserCFunction unaryFunction: atan] forKey: @"atan"];
	[self setFunction: [CParserCFunction unaryFunction: sinh] forKey: @"sinh"];
	[self setFunction: [CParserCFunction unaryFunction: cosh] forKey: @"cosh"];
	[self setFunction: [CParserCFunction unaryFunction: tanh] forKey: @"tanh"];
	[self setFunction: [CParserCFunction unaryFunction: asinh] forKey: @"asinh"];
	[self setFunction: [CParserCFunction unaryFunction: acosh] forKey: @"acohs"];
	[self setFunction: [CParserCFunction unaryFunction: atanh] forKey: @"atanh"];
	[self setFunction: [CParserCFunction unaryFunction: exp] forKey: @"exp"];
	[self setFunction: [CParserCFunction unaryFunction: log] forKey: @"ln"];
	[self setFunction: [CParserCFunction unaryFunction: log10] forKey: @"log"];
	[self setFunction: [CParserCFunction unaryFunction: fabs] forKey: @"abs"];
	[self setFunction: [CParserCFunction binaryFunction: pow] forKey: @"pow"];
}


- (void) registerConstants;
{
	[self setVariable: [NSNumber numberWithDouble: M_PI] forKey: @"PI"];
	[self setVariable: [NSNumber numberWithDouble: M_PI] forKey: @"π"];
	[self setVariable: [NSNumber numberWithDouble: M_E] forKey: @"E"];
}

@end

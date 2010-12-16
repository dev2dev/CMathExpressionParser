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

#import "CParserVariable.h"
#import "CParserFunction.h"


@implementation CPEvaluator

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setVariables:[NSMutableDictionary dictionary]];
		[self setFunctions:[NSMutableDictionary dictionary]];
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
	
	NSMutableArray *stack = [NSMutableArray array];
	
	NSUInteger i, count = [array count];
	for (i = 0; i < count; i++) {
		CPToken *token = [array objectAtIndex:i];
		
		CPToken *newToken = [CPToken token];
		CPOperator operator = [token operatorValue];
		
		switch ([token type]) {
			case CPTokenNull:
				//
				break;
			case CPTokenNumber:
				[newToken setNumberValue:[token numberValue]];
				break;
			case CPTokenOperator:
				if ([stack count] >= [CPTokenizer operatorArgumentCount:operator])
				{
					double operants[2];
					
					if ([CPTokenizer operatorArgumentCount:operator] == 1) {
						operants[0] = [[stack lastObject] numberValue];
						
						switch (operator) {
							case CPOperatorFactorial:
								[newToken setNumberValue:factorial(operants[0])];
								break;
							case CPOperatorNeg:
								[newToken setNumberValue:0.0]; // ?
								break;
							default:
								break;
						}
						
						[stack removeLastObject];
						
					} else if ([CPTokenizer operatorArgumentCount:operator] == 2) {
						operants[1] = [[stack lastObject] numberValue];
						operants[0] = [[stack objectAtIndex:[stack count]-2] numberValue];
						
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
								[newToken setNumberValue:operants[0] / operants[1]];
								break;
							case CPOperatorModulo:
								[newToken setNumberValue:fmod(operants[0], operants[1])];
								break;
							case CPOperatorAssign:
								if ([(CPToken *)[stack objectAtIndex:[stack count]-2] type] == CPTokenVariable) {
									[self setVariable:[CParserVariable variableWithValue:operants[1]] forKey:[[stack objectAtIndex:[stack count]-2] stringValue]];
								} else {
									//Assign Error!
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
							case CPOperatorAND:
								[newToken setNumberValue:operants[0] && operants[1]];
								break;
							case CPOperatorOR:
								[newToken setNumberValue:operants[0] || operants[1]];
								break;
							default:
								[newToken setNumberValue:0.0];
								break;
						}
						
						[stack removeLastObject];
						[stack removeLastObject];
					}
				}
				
				break;
			case CPTokenVariable:
				[newToken setStringValue:[token stringValue]]; //set var name
				[newToken setType:CPTokenVariable]; //set type to var (for assignment)
				[newToken setNumberValue:([variables objectForKey:[token stringValue]] != nil) ? ([(CParserVariable *)[variables objectForKey:[token stringValue]] value]) : 0.0];

			default:
				break;
		}
		
		[stack addObject:newToken];
	}
	
	return [[stack lastObject] numberValue];
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

- (void) setVariable:(CParserVariable *)var forKey:(NSString *)key
{
	[variables setObject:var forKey:key];
}

- (CParserVariable *) variableForKey:(NSString *)key
{
	return (CParserVariable *)[variables objectForKey:key];
}

- (void) setFunction:(CParserFunction *)var forKey:(NSString *)key
{
	[functions setObject:var forKey:key];
}

- (CParserFunction *) functionForKey:(NSString *)key
{
	return (CParserFunction *)[functions objectForKey:key];
}

@end

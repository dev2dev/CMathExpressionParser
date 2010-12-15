//
//  CPEvaluator.m
//  CMathExpressionParser
//
//  Created by Johannes Wolf on 14.12.2010.
//  Copyright 2010 beanage. All rights reserved.
//

#import "CPEvaluator.h"

#import "CPToken.h"
#import "CPTokenizer.h"


@implementation CPEvaluator

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setVariables:nil];
		[self setFunctions:nil];
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
		
		CPOperator operator = [token operatorValue];
		double result = 0.0;
		
		switch ([token type]) {
			case CPTokenNull:
				//
				break;
			case CPTokenNumber:
				result = [token numberValue];
				break;
			case CPTokenOperator:
				if ([stack count] >= [CPTokenizer operatorArgumentCount:operator])
				{
					double operants[2];
					
					if ([CPTokenizer operatorArgumentCount:operator] == 1) {
						operants[0] = [[stack lastObject] numberValue];
						
						switch (operator) {
							case CPOperatorFactorial:
								result = 0.0;
								break;
							case CPOperatorNeg:
								//...
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
								result = operants[0] + operants[1];
								break;
							case CPOperatorMinus:
								result = operants[0] - operants[1];
								break;
							case CPOperatorTimes:
								result = operants[0] * operants[1];
								break;
							case CPOperatorDiv:
								result = operants[0] / operants[1];
								break;
							case CPOperatorModulo:
								result = fmod(operants[0], operants[1]);
								break;
							case CPOperatorAssign:
								//assignment here... later
								result = operants[1];
								break;
							case CPOperatorPower:
								result = pow(operants[0], operants[1]);
								break;
							case CPOperatorLT:
								result = operants[0] < operants[1];
								break;
							case CPOperatorLE:
								result = operants[0] <= operants[1];
								break;
							case CPOperatorGT:
								result = operants[0] > operants[1];
								break;
							case CPOperatorGE:
								result = operants[0] >= operants[1];
								break;
							case CPOperatorNEqual:
								result = operants[0] != operants[1];
								break;
							case CPOperatorEqual:
								result = operants[0] == operants[1];
								break;
							case CPOperatorAND:
								result = operants[0] && operants[1];
								break;
							case CPOperatorOR:
								result = operants[0] || operants[1];
								break;
							default:
								result = 0.0;
								break;
						}
						
						[stack removeLastObject];
						[stack removeLastObject];
					}
				}
				
				break;
			default:
				break;
		}
		
		[stack addObject:[CPToken tokenWithNumber:result]];
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

@end

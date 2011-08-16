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

#import "CParserFunction.h"
#import "CParserCFunction.h"
#import "CParserMacroFunction.h"
#import "NSArray+reverse.h"
#import "CPStack.h"

#include "CParserMath.h"

#define CPMAXRECCOUNT 4096

enum _mode {
	CPModeRead,
	CPModeSkip
};

@interface CPEvaluator ()
- (void) registerStandardFunctions;
- (void) registerConstants;
@end

@implementation CPEvaluator
@synthesize recursionDepth;

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self registerStandardFunctions];
		[self registerConstants];
		[self setRecursionDepth:0];
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
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//if mode = CPModeSkip nothing will be added to the stack until mode = CPModeRead
	NSUInteger mode = CPModeRead; //little hack to impliment blocks
	CPStack *stack = [[CPStack alloc] init];
	
	//rekursionstiefe +1 max: CPMAXRECCOUNT if higher the parser crashes
	recursionDepth +=1 ;
	NSAssert(recursionDepth < CPMAXRECCOUNT, @"Max recursion-count %d reached", CPMAXRECCOUNT);
	
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
									[self setValue:operants[1] forVariable:[first stringValue]];
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
				if (mode==CPModeSkip)
					break;
				
				[newToken setStringValue:[token stringValue]]; //set var name
				[newToken setType:CPTokenVariable]; //set type to var (for assignment)
				[newToken setNumberValue: [self valueForVariable: [token stringValue]]];
				break;
				
			case CPTokenFunction: {
				if (mode==CPModeSkip) //skip, to prevent from fail exceptions
					break;
				
				CParserFunction *function = [self functionForKey:[token stringValue]];
				
				if (nil == function) {
					[NSException raise: CPSyntaxErrorException format: @"Trying to call unknown function '%@'", [token stringValue]];
				}
				if ([function isKindOfClass:[CParserMacroFunction class]])
					[(CParserMacroFunction *)function setMacroEvaluator:self];
				
				NSArray *args = [stack popUpToToken: [CPToken tokenWithType: CPTokenArgStop]];
				if ([args count] < [function minArguments] || [args count] > [function maxArguments]) {
					NSException *exception = [NSException exceptionWithName:CPSyntaxErrorException
																	 reason:[NSString stringWithFormat:@"Function Argument Error (%d)", [args count]]
																   userInfo:nil];
					@throw exception;
				} else {
					[newToken setNumberValue:[function evaluateWithArguments:[args reversedArray]]];
				}
				break;
			}
				
			case CPTokenBlockStart: {
				CPToken *last = [stack pop];
				if ([last numberValue]!=0.0) {
					mode = CPModeRead;
				} else {
					mode = CPModeSkip;
				}
				[newToken setType:CPTokenNull];
				break;
			}
				
			case CPTokenArgStop:
				[newToken setType:CPTokenArgStop]; //dont push to stack, we dont need it anymore
				break;
				
			case CPTokenBlockStop: {
				if (mode==CPModeSkip) {
					mode = CPModeRead;
				}
				[newToken setType:CPTokenNull]; //dont push to stack, we dont need it anymore
				break;
			}
				
			default:
				break;
		}
		
		//add the result to stack if in readmode and 
		if (mode==CPModeRead && [newToken type]!=CPTokenNull)
			[stack push:newToken];
		
	}
	
	//ergebnis als double
	double absRet = [[stack lastToken] numberValue];
	
	//rekursiontiefe -1
	recursionDepth -=1 ;
	
	//speicher aufraeumen
	[stack release];
	[pool drain];
	
	return absRet;
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

- (void) setTempVariables:(NSMutableDictionary *)dict
{
	if (dict != tempVariables) {
		[tempVariables release];
		tempVariables = [dict retain];
	}
}

- (NSDictionary *) tempVariables
{
	return tempVariables;
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

- (void) setValue:(double)var forVariable:(NSString *)key
{
	if (variables == nil) {
		[self setVariables:[NSMutableDictionary dictionary]];
	}
	
	[variables setObject:[NSNumber numberWithDouble: var] forKey:[key lowercaseString]];
}

- (void) setTempValue:(double)value forVariable:(NSString *)key
{
	if (tempVariables == nil) {
		[self setTempVariables:[NSMutableDictionary dictionary]];
	}
	
	[tempVariables setObject:[NSNumber numberWithDouble:value] forKey:[key lowercaseString]];
}

- (void)clearTempVariables
{
	if (tempVariables != nil)
		[tempVariables removeAllObjects];
}

- (double) valueForVariable:(NSString *)key
{
	//1. temp, if not then "normal"
	NSString *_key = [key lowercaseString];
	return ([tempVariables objectForKey:_key]!=nil) ? [[tempVariables objectForKey:_key] doubleValue] : [[variables objectForKey:_key] doubleValue];
}

- (void) setFunction:(CParserFunction *)var forKey:(NSString *)key
{
	if (functions == nil) {
		[self setFunctions:[NSMutableDictionary dictionary]];
	}
	
	[functions setObject:var forKey:[key lowercaseString]];
}

- (CParserFunction *) functionForKey:(NSString *)key
{
	return [functions objectForKey:[key lowercaseString]];
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
	[self setFunction: [CParserCFunction unaryFunction: sqrt] forKey: @"sqrt"];
	[self setFunction: [CParserCFunction binaryFunction: pow] forKey: @"pow"];
	
	[self setFunction: [CParserCFunction unaryFunction: IF] forKey: @"if"];
	[self setFunction: [CParserCFunction unaryFunction: IFNOT] forKey: @"ifnot"];
	
	[self setFunction: [CParserCFunction unaryFunction: debugLog] forKey: @"debuglog"];
}

- (void) registerConstants;
{
	[self setValue: M_PI forVariable: @"PI"];
	[self setValue: M_PI forVariable: @"π"];
	[self setValue: M_E forVariable: @"E"];
}

@end

//
//  CParserFunction.m
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserCFunction.h"

#import "CPToken.h"


@implementation CParserCFunction

#pragma mark -
#pragma mark Init / Dealloc

+ (CParserCFunction *) function
{
	return [[[CParserCFunction alloc] init] autorelease];
}

+ (CParserCFunction *) functionWithMinArguments:(int)args
{
	return [[[CParserCFunction alloc] initWithMinArguments:args] autorelease];
}

+ (CParserFunction *) unaryFunction: (function_1) ptr;
{
	CParserCFunction *func = [self functionWithMinArguments: 1];
	[func setFunction1: ptr];
	return func;
}

+ (CParserFunction *) binaryFunction: (function_2) ptr;
{
	CParserCFunction *func = [self functionWithMinArguments: 2];
	[func setFunction2: ptr];
	return func;
}

- (id) initWithMinArguments:(int)args
{
	self = [super init];
	if (self != nil) {
		[self setMinArguments:args];
	}
	return self;
}

#pragma mark -
#pragma mark Function Seter

@synthesize function0 = functionPtr0;
@synthesize function1 = functionPtr1;
@synthesize function2 = functionPtr2;
@synthesize function3 = functionPtr3;
@synthesize function4 = functionPtr4;
@synthesize function5 = functionPtr5;
@synthesize function6 = functionPtr6;
@synthesize function7 = functionPtr7;
@synthesize function8 = functionPtr8;
@synthesize function9 = functionPtr9;

#pragma mark -
#pragma mark Evaluate

- (double) evaluateWithArguments:(NSArray *)arguments
{
	double result = 0.0;
	double args[9] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
	
	NSUInteger i, count = [arguments count];
	for (i = 0; i < count; i++) {
		CPToken * token = [arguments objectAtIndex:i];
		args[i] = [token numberValue];
	}
	
	switch (minArguments) {
		case 0:
			result = functionPtr0();
			break;
		case 1:
			result = functionPtr1(args[0]);
			break;
		case 2:
			result = functionPtr2(args[0], args[1]);
			break;
		case 3:
			result = functionPtr3(args[0], args[1], args[2]);
			break;
		case 4:
			result = functionPtr4(args[0], args[1], args[2], args[3]);
			break;
		case 5:
			result = functionPtr5(args[0], args[1], args[2], args[3], args[4]);
			break;
		case 6:
			result = functionPtr6(args[0], args[1], args[2], args[3], args[4], args[5]);
			break;
		case 7:
			result = functionPtr7(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
			break;
		case 8:
			result = functionPtr8(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
			break;
		case 9:
			result = functionPtr9(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
			break;
		default:
			result = 0.0;
			break;
	}
	
	return result;
}

@end

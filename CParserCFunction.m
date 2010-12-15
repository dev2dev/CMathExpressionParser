//
//  CParserFunction.m
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserCFunction.h"

#import "CParserToken.h"


@implementation CParserCFunction

#pragma mark -
#pragma mark Init / Dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		functionPtr1 = 0;
		functionPtr2 = 0;
		functionPtr3 = 0;
		functionPtr4 = 0;
		functionPtr5 = 0;
		functionPtr6 = 0;
		functionPtr7 = 0;
		functionPtr8 = 0;
		functionPtr9 = 0;
		minArguments = 0;
		maxArguments = 0;
	}
	return self;
}

- (void) dealloc
{
	functionPtr1 = 0;
	functionPtr2 = 0;
	functionPtr3 = 0;
	functionPtr4 = 0;
	functionPtr5 = 0;
	functionPtr6 = 0;
	functionPtr7 = 0;
	functionPtr8 = 0;
	functionPtr9 = 0;
	minArguments = 0;
	maxArguments = 0;
	[super dealloc];
}

+ (CParserCFunction *) function
{
	return [[[CParserCFunction alloc] init] autorelease];
}

+ (CParserCFunction *) functionWithMinArguments:(int)args
{
	return [[[CParserCFunction alloc] initWithMinArguments:args] autorelease];
}

- (id) initWithMinArguments:(int)args
{
	self = [super init];
	if (self != nil) {
		functionPtr1 = 0;
		functionPtr2 = 0;
		functionPtr3 = 0;
		functionPtr4 = 0;
		functionPtr5 = 0;
		functionPtr6 = 0;
		functionPtr7 = 0;
		functionPtr8 = 0;
		functionPtr9 = 0;
		[self setMinArguments:args];
	}
	return self;
}

#pragma mark -
#pragma mark Seter / Geter







#pragma mark -
#pragma mark Function Seter

- (void) setFunction0:(function_0)func
{
	functionPtr0 = func;
}

- (void) setFunction1:(function_1)func
{
	functionPtr1 = func;
}

- (void) setFunction2:(function_2)func
{
	functionPtr2 = func;
}

- (void) setFunction3:(function_3)func
{
	functionPtr3 = func;
}

- (void) setFunction4:(function_4)func
{
	functionPtr4 = func;
}

- (void) setFunction5:(function_5)func
{
	functionPtr5 = func;
}

- (void) setFunction6:(function_6)func
{
	functionPtr6 = func;
}

- (void) setFunction7:(function_7)func
{
	functionPtr7 = func;
}

- (void) setFunction8:(function_8)func
{
	functionPtr8 = func;
}

- (void) setFunction9:(function_9)func
{
	functionPtr9 = func;
}

#pragma mark -
#pragma mark Evaluate

- (double) evaluateWithArguments:(NSArray *)arguments
{
	double result = 0.0;
	double args[9] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
	
	NSUInteger i, count = [arguments count];
	for (i = 0; i < count; i++) {
		CParserToken * token = [arguments objectAtIndex:i];
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

//
//  CParserMacro.m
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserMacroFunction.h"
#import "CParserEvaluator.h"
#import "CParserConverter.h"
#import "CParserVariable.h"

@implementation CParserMacroFunction

#pragma mark -
#pragma mark Init / Dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setExpression:[NSString string]];
		[self setPostfixExpression:[NSArray array]];
		maxArguments = 0;
		minArguments = 0;
	}
	return self;
}

- (void) dealloc
{
	[macroExpression release];
	[macroPostfixExpression release];
	maxArguments = 0;
	minArguments = 0;
	[super dealloc];
}

+ (CParserMacroFunction *) macro
{
	return [[[CParserMacroFunction alloc] init] autorelease];
}

+ (CParserMacroFunction *) macroWithExpression:(NSString *)expression
{
	return [[[CParserMacroFunction alloc] initWithExpression:expression] autorelease];
}

- (id) initWithExpression:(NSString *)expression
{
	self = [super init];
	if (self != nil) {
		[self setExpression:expression];
		[self setPostfixExpression:[NSArray array]];
		maxArguments = 0;
		minArguments = 0;
	}
	return self;
}

#pragma mark -
#pragma mark Seter / Geter

- (void) setExpression:(NSString *)expression
{
	if (macroExpression != expression) {
		[macroExpression release];
		macroExpression = [expression retain];
	}
}

- (NSString *) expression
{
	return macroExpression;
}

- (void) setPostfixExpression:(NSArray *)expression
{
	if (macroPostfixExpression != expression) {
		[macroPostfixExpression release];
		macroPostfixExpression = [expression retain];
	}
}

- (NSArray *) postfixExpression
{
	return macroPostfixExpression;
}

#pragma mark -
#pragma mark Update Postfix

- (void) updatePostfixExpression
{
	@try {
		CParserConverter * converter = [CParserConverter converter];
		[self setPostfixExpression:[converter convertExpressionFromInfixStringToPostfixArray:macroExpression]];
	}
	@catch (NSException * e) {
		NSLog(@"ERROR: %@", [e reason]);
	}
}

#pragma mark -
#pragma mark Evaluate

- (double) evaluateWithArguments:(NSArray *)arguments
{
	double result = 0.0;
	CParserEvaluator * evaluator = [CParserEvaluator evaluator];
	
	NSUInteger i, count = [arguments count];
	for (i = 0; i < count; i++) {
		CParserToken * token = [arguments objectAtIndex:i];
		[evaluator setVariable:[CParserVariable variableWithValue:[token numberValue]] forKey:[NSString stringWithFormat:@"ARG_%i", i+1]];
	}
	
	[evaluator setVariable:[CParserVariable variableWithValue:count] forKey:[NSString stringWithString:@"ARG_COUNT"]];
	
	@try {
		result = [evaluator evaluatePostfixArray:macroPostfixExpression];
	}
	@catch (NSException * e) {
		NSLog(@"ERROR: %@", [e reason]);
	}
	@finally {
		return result;
	}
		
	return result;
}
	
@end

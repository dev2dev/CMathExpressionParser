//
//  CParserMacro.m
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserMacroFunction.h"
#import "CPEvaluator.h"
#import "CPTokenizer.h"

@interface CParserMacroFunction ()

- (void) updatePostfixExpression;

@end

@implementation CParserMacroFunction

#pragma mark -
#pragma mark Init / Dealloc

- (void) dealloc
{
	[macroExpression release];
	[macroPostfixExpression release];

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
	}
	return self;
}

#pragma mark -
#pragma mark Seter / Geter

@synthesize expression = macroExpression;
@synthesize postfixExpression = macroPostfixExpression;

- (NSArray *) postfixExpression;
{
	if (nil == macroPostfixExpression) {
		[self updatePostfixExpression];
	}
	return macroPostfixExpression;
}

- (void) setExpression: (NSString *)newExpr;
{
	if (macroExpression != newExpr) {
		[macroExpression release];
		macroExpression = [newExpr copy];
		
		[self setPostfixExpression: nil];
	}
}

#pragma mark -
#pragma mark Update Postfix

- (void) updatePostfixExpression
{
	@try {
		CPTokenizer * converter = [CPTokenizer tokenizer];
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
	CPEvaluator * evaluator = [CPEvaluator evaluator];
	
	NSUInteger i, count = [arguments count];
	for (i = 0; i < count; i++) {
		CPToken * token = [arguments objectAtIndex:i];
		[evaluator setValue:[token numberValue] forVariable:[NSString stringWithFormat:@"ARG_%i", i+1]];
	}
	
	[evaluator setValue:count forVariable:[NSString stringWithString:@"ARG_COUNT"]];
	
	@try {
		result = [evaluator evaluatePostfixExpressionArray: [self postfixExpression]];
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

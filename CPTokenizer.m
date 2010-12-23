//
//  CPTokenizer.m
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 beanage. All rights reserved.
//

#import "CPTokenizer.h"
#import "CPStack.h"


@implementation CPTokenizer

NSString * const CPSyntaxErrorException = @"SyntaxError";

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		NSMutableCharacterSet *set = [NSMutableCharacterSet alphanumericCharacterSet];
		[set addCharactersInString: @"_"];
		
		[self setIdentifierSet:set];
	}
	return self;
}

- (void) dealloc
{
	[identifierSet release];
	
	[super dealloc];
}

+ (CPTokenizer *) tokenizer
{
	return [[[CPTokenizer alloc] init] autorelease];
}

#pragma mark -
#pragma mark scan and tokenize

- (CPToken *) readNextTokenFrom: (NSScanner *) scanner;
{
	CPOperator operator = [Operators scan: scanner];
	if (CPOperatorNull != operator) {
		return [CPToken tokenWithOperator: operator];
	}

	double numberValue;
	if ([scanner scanDouble:&numberValue]) {
		return [CPToken tokenWithNumber:numberValue];
	}
	
	NSString * stringValue;
	if ([scanner scanCharactersFromSet:identifierSet intoString:&stringValue]) {
		unichar firstChar = [stringValue characterAtIndex:0];
		if(firstChar >= 'a' && firstChar <= 'z') {
			return [CPToken tokenWithFunction:stringValue];
		} else {
			return [CPToken tokenWithVariable:stringValue];
		}
	}
		
	return nil;
}

- (NSArray *) processCommaOperatorStack: (CPStack *) stack;
{
	NSArray *ops = [stack popUpToOperator: CPOperatorLBrace];
	
	if (nil == ops || [stack isEmpty] || [[stack lastToken] type] != CPTokenFunction) {
		NSException *exception = [NSException exceptionWithName:CPSyntaxErrorException
														 reason:@"function missing" 
													   userInfo:nil];
		@throw exception;
	}
	
	[stack push:[CPToken tokenWithOperator:CPOperatorLBrace]];
	return ops;
}	

- (NSArray *) processRBraceOperatorStack: (CPStack *) stack;
{
	NSArray *ops = [stack popUpToOperator: CPOperatorLBrace];
	if (nil == ops) {
		[NSException raise: CPSyntaxErrorException format: @"Missing '('"];
	}
	
	if (![stack isEmpty] && [[stack lastToken] type] == CPTokenFunction) {
		ops = [ops arrayByAddingObject: [stack pop]];
	}
	
	return ops;
}

- (NSArray *) processDefaultOperator: (CPToken *) token stack: (CPStack *) stack;
{
	NSMutableArray *output = [NSMutableArray array];
	
	CPOperator operator = [token operatorValue];
	while (![stack isEmpty]) {
		const bool leftAssoc = [Operators associativity: operator] == CPOperatorAssocLeft;
		const unsigned priority = [Operators priority: operator];
		const unsigned lastStackPriority = [Operators priority: [[stack lastToken] operatorValue]];
		
		if ((priority < lastStackPriority) || (leftAssoc && priority == lastStackPriority)) {
			[output addObject:[stack pop]];
		} else {
			break;
		}
	}
	
	[stack push:token];
	
	return output;
}

- (NSArray *) processOperatorToken: (CPToken *)token stack: (CPStack *) stack
{
	NSParameterAssert( [token type] == CPTokenOperator );
	
	CPOperator operator = [token operatorValue];
	NSAssert( operator != CPOperatorNull, @"Unexpected NULL operator" );
	
	switch (operator) {
		default:
			return [self processDefaultOperator: token stack: stack];
			
		case CPOperatorComma: 
			return [self processCommaOperatorStack: stack];
			
		case CPOperatorSemicolon:
			return [stack popAll];
			
		case CPOperatorLBrace:
			[stack push:token];
			return nil;
			
		case CPOperatorRBrace:
			return [self processRBraceOperatorStack: stack];
	};
}

- (NSArray *) convertExpressionFromInfixStringToPostfixArray:(NSString *)expression
{	
	CPStack * stack = [CPStack stack];
	NSMutableArray * output = [NSMutableArray array];
	
	NSScanner * scanner = [NSScanner scannerWithString:expression];
	
	while (![scanner isAtEnd]) {
		
		CPToken *nextToken = [self readNextTokenFrom: scanner];
		
		if (nil == nextToken) {
			NSException *exception = [NSException exceptionWithName:CPSyntaxErrorException
															 reason:[NSString stringWithFormat:@"unknown token on position %d", [scanner scanLocation]] 
														   userInfo:nil];
			@throw exception;
		}			
		
		switch ( [nextToken type] ) {
			case CPTokenNumber:
			case CPTokenVariable:
				[output addObject: nextToken];
				break;
				
			case CPTokenFunction:
				[output addObject:[CPToken tokenWithType:CPTokenArgStop]];
				[stack push: nextToken];
				break;
				
			case CPTokenOperator:
				[output addObjectsFromArray: [self processOperatorToken:nextToken stack:stack]];
				break;
		}
	}
	
	[output addObjectsFromArray: [stack popAll]];
	
	return output;	
}

#pragma mark -
#pragma mark set characterset's

- (void) setIdentifierSet:(NSCharacterSet *)set
{
	if (identifierSet != set) {
		[identifierSet release];
		identifierSet = [set copy];
	}
}

@end


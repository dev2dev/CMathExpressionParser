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

#pragma mark -
#pragma mark init / dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setIdentifierSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890"]];
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

- (NSArray *) processOperatorToken: (CPToken *)token stack: (CPStack *) stack
{
	NSMutableArray *output = [NSMutableArray array];
	
	CPOperator operator = [token operatorValue];
	NSAssert( operator != CPOperatorNull, @"Unexpected NULL operator" );
	
	if (operator != CPOperatorLBrace && operator != CPOperatorRBrace && operator != CPOperatorComma && operator != CPOperatorSemicolon) {
		while ([stack position] > 0) {
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
	} else {
		if (operator == CPOperatorComma) {
			NSArray *ops = [stack popUpToOperator: CPOperatorLBrace];
			
			if (nil == ops || [stack position] == 0 || [[stack lastToken] type] != CPTokenFunction) {
				NSException *exception = [NSException exceptionWithName:@"SyntaxError"
																 reason:@"function missing" 
															   userInfo:nil];
				@throw exception;
			}
			
			[output addObjectsFromArray: ops];
			[stack push:[CPToken tokenWithOperator:CPOperatorLBrace]];
		}
		
		if (operator == CPOperatorSemicolon) {
			
			CPOperator temp = [[stack pop] operatorValue];
			
			while (!([stack position] == 0 || (temp == CPOperatorSemicolon))) {
				[output addObject:[CPToken tokenWithOperator:temp]];
				temp = [[stack pop] operatorValue];
			}
			
			if ([stack position] != 0) {
				[output addObject:[CPToken tokenWithOperator:temp]];
			}
			
		}
		if (operator == CPOperatorLBrace) {
			[stack push:token];
		}
		if (operator == CPOperatorRBrace) {
			NSArray *ops = [stack popUpToOperator: CPOperatorLBrace];
			if (nil == ops) {
				[NSException raise: @"SyntaxError" format: @"Missing '('"];
			}
			
			[output addObjectsFromArray: ops];
			
			if ([stack position] != 0 && [[stack lastToken] type] == CPTokenFunction) {
				[output addObject:[stack pop]];
			}
		}
	}
	
	return output;
}

- (NSArray *) convertExpressionFromInfixStringToPostfixArray:(NSString *)expression
{	
	CPStack * stack = [CPStack stack];
	NSMutableArray * output = [NSMutableArray array];
	
	NSScanner * scanner = [NSScanner scannerWithString:expression];
	
	while (![scanner isAtEnd]) {
		
		CPToken *nextToken = [self readNextTokenFrom: scanner];
		
		if (nil == nextToken) {
			NSException *exception = [NSException exceptionWithName:@"SyntaxError"
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
	
	while ([stack position] != 0) {
		[output addObject:[stack pop]];
	}
	
	return output;	
}

#pragma mark -
#pragma mark set characterset's

- (void) setIdentifierSet:(NSCharacterSet *)set
{
	if (identifierSet != set) {
		[identifierSet release];
		identifierSet = [set retain];
	}
}

@end


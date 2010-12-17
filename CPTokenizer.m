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

static void CopyOperatorsToOutput(CPStack *stack, NSMutableArray *output, CPOperator limit ) 
{
	CPOperator temp = [[stack pop] operatorValue];
	
	while (temp != limit) {
		[output addObject:[CPToken tokenWithOperator:temp]];
		temp = [[stack pop] operatorValue];
	}
	
}

- (NSArray *) convertExpressionFromInfixStringToPostfixArray:(NSString *)expression
{	
	CPStack * stack = [CPStack stack];
	NSMutableArray * output = [NSMutableArray array];
	
	NSScanner * scanner = [NSScanner scannerWithString:expression];
	
	//****
	int bracketOpen = 0;
	int bracketClose = 0;
	
	BOOL numberScanned = NO;;
	BOOL stringScanned = NO;
	BOOL operatorScanned = NO;
	BOOL multipleOperators = NO;
	//****
	
	
	//scan
	while (![scanner isAtEnd]) {
		
		numberScanned = NO;
		stringScanned = NO;
		operatorScanned = NO;
		
		//number
		double numberValue;
		if (!multipleOperators && [scanner scanDouble:&numberValue]) {
			[output addObject:[CPToken tokenWithNumber:numberValue]];
			numberScanned = YES;
		}
		
		//string
		NSString * stringValue;
		if (!multipleOperators && [scanner scanCharactersFromSet:identifierSet intoString:&stringValue]) {
			unichar firstChar = [stringValue characterAtIndex:0];
			if(firstChar >= 'a' && firstChar <= 'z')
				[stack push:[CPToken tokenWithFunction:stringValue]];
			else
				[output addObject:[CPToken tokenWithVariable:stringValue]];
			
			stringScanned = YES;
		}
		
		//operator
		CPOperator operator = [Operators scan: scanner];
		if (operator != CPOperatorNull) {
			operatorScanned = YES;
			
			if (operator != CPOperatorLBrace && operator != CPOperatorRBrace && operator != CPOperatorComma && operator != CPOperatorSemicolon) {
				if ([stack position] == 0) {
					[stack push:[CPToken tokenWithOperator:operator]];
				} else {
					while ([stack position] > 0) {
						if (([Operators associativity: operator] && [Operators priority: operator] <= [Operators priority: [[stack lastToken] operatorValue]]) ||
						(![Operators associativity: operator] && [Operators priority: operator] < [Operators priority: [[stack lastToken] operatorValue]])) {
							
							CPOperator temp = [[stack pop] operatorValue];
							[output addObject:[CPToken tokenWithOperator:temp]];
						} else {
							break;
						}
					}
						
					[stack push:[CPToken tokenWithOperator:operator]];
				}
			} else {
				if (operator == CPOperatorComma) {
					if (bracketOpen <= bracketClose) {
						NSException *exception = [NSException exceptionWithName:@"SyntaxError"
																		 reason:@"( missing" 
																	   userInfo:nil];
						@throw exception;
					}
						
					CopyOperatorsToOutput( stack, output, CPOperatorLBrace );
						
					if ([stack position] != 0) {
						CPToken * token = [stack pop];
							
						if ([token type] == CPTokenFunction) {
							[stack push:token];
						} else {
							NSException *exception = [NSException exceptionWithName:@"SyntaxError"
																			 reason:@"function missing" 
																		   userInfo:nil];
							@throw exception;
						}
					} else {
						NSException *exception = [NSException exceptionWithName:@"SyntaxError"
																		 reason:@"function missing" 
																	   userInfo:nil];
						@throw exception;
					}
						
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
					bracketOpen++;
					[stack push:[CPToken tokenWithOperator:operator]];
				}
				if (operator == CPOperatorRBrace) {
					bracketClose++;
					if (bracketOpen < bracketClose) {
						NSException *exception = [NSException exceptionWithName:@"SyntaxError"
																		 reason:@"( missing" 
																	   userInfo:nil];
						@throw exception;
					}
						
					CopyOperatorsToOutput( stack, output, CPOperatorLBrace );
						
					if ([stack position] != 0) {
						CPToken * token = [stack pop];
							
						if ([token type] == CPTokenFunction) {
							[output addObject:token];
							[output addObject:[CPToken tokenWithType:CPTokenArgStop]];
						} else {
							[stack push:token];
						}
					}
				}
			}
		}
		
		//error unknown symbol
		if (!(numberScanned || stringScanned || operatorScanned)/* && !multipleOperators*/) {
			NSException *exception = [NSException exceptionWithName:@"SyntaxError"
															 reason:[NSString stringWithFormat:@"unknown token on position %d", [scanner scanLocation]] 
														   userInfo:nil];
			@throw exception;
		}
	}
	
	if (bracketOpen != bracketClose) {
		NSLog(@"() errror");
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


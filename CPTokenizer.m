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
		[self setOperatorSet:[NSCharacterSet characterSetWithCharactersInString:@"+-*/^!%<>=&|(),;?:"]];
		[self setFunctionSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890"]];
		[self setVariableSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890"]];
	}
	return self;
}

- (void) dealloc
{
	[operatorSet release];
	[functionSet release];
	[variableSet release];
	
	[super dealloc];
}

+ (CPTokenizer *) tokenizer
{
	return [[[CPTokenizer alloc] init] autorelease];
}

#pragma mark -
#pragma mark scan and tokenize

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
		if (!multipleOperators && [scanner scanCharactersFromSet:functionSet intoString:&stringValue]) {
			unichar firstChar = [stringValue characterAtIndex:0];
			if(firstChar >= 'a' && firstChar <= 'z')
				[stack push:[CPToken tokenWithFunction:stringValue]];
			else
				[output addObject:[CPToken tokenWithVariable:stringValue]];
			
			stringScanned = YES;
		}
		
		//operator
		NSString * operatorValue;
		if ([scanner scanCharactersFromSet:operatorSet intoString:&operatorValue]) {

			NSInteger operatorLength = [operatorValue length];
			NSString * _operator = [operatorValue substringWithRange:NSMakeRange(0, operatorLength)];
			
			operatorScanned = YES;
			
			if (operatorLength > 1) {
				while (![self isOperator:_operator]) {
					--operatorLength;
					_operator = [operatorValue substringWithRange:NSMakeRange(0, operatorLength)];
					//if ([self operatorForString:_operator] != CPOperatorMinus) {
						multipleOperators = YES;
					//}
				}
				[scanner setScanLocation:[scanner scanLocation]-([operatorValue length] - [_operator length])];
			} else {
				multipleOperators = NO;
			}
			
			CPOperator operator = [self operatorForString:_operator];
			
			if (operator != CPOperatorLBrace && operator != CPOperatorRBrace && operator != CPOperatorComma && operator != CPOperatorSemicolon) {
				if ([stack position] == 0) {
					[stack push:[CPToken tokenWithOperator:operator]];
				} else {
					while ([stack position] > 0) {
						if (([CPTokenizer operatorAssociativity:operator] && [CPTokenizer operatorPrecedence:operator] <= [CPTokenizer operatorPrecedence:[[stack lastToken] operatorValue]]) ||
						(![CPTokenizer operatorAssociativity:operator] && [CPTokenizer operatorPrecedence:operator] < [CPTokenizer operatorPrecedence:[[stack lastToken] operatorValue]])) {
							
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
						
					CPOperator temp = [[stack pop] operatorValue];
						
					while (temp != CPOperatorLBrace) {
						[output addObject:[CPToken tokenWithOperator:temp]];
						temp = [[stack pop] operatorValue];
					}
						
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
						
					CPOperator temp = [[stack pop] operatorValue];
						
					while (temp != CPOperatorLBrace) {
						[output addObject:[CPToken tokenWithOperator:temp]];
						temp = [[stack pop] operatorValue];
					}
						
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

- (void) setOperatorSet:(NSCharacterSet *)set
{
	if (operatorSet != set) {
		[operatorSet release];
		operatorSet = [set retain];
	}
}

- (void) setFunctionSet:(NSCharacterSet *)set
{
	if (functionSet != set) {
		[functionSet release];
		functionSet = [set retain];
	}
}

- (void) setVariableSet:(NSCharacterSet *)set
{
	if (variableSet != set) {
		[variableSet release];
		variableSet = [set retain];
	}
}

#pragma mark -
#pragma mark public (+)

+ (int) operatorPrecedence:(CPOperator)op
{
	switch (op) {
		case CPOperatorNull:
			return 0;
			break;
		case CPOperatorComma:
			return 1;
			break;
		case CPOperatorAssign:
			return 2;
			break;
		case CPOperatorAND:
		case CPOperatorOR:
			return 3;
			break;
		case CPOperatorEqual:
		case CPOperatorNEqual:
			return 4;
			break;
		case CPOperatorLT:
		case CPOperatorLE:
		case CPOperatorGT:
		case CPOperatorGE:
			return 5;
			break;
		case CPOperatorMinus:
		case CPOperatorPlus:
			return 6;
			break;
		case CPOperatorTimes:
		case CPOperatorDiv:
		case CPOperatorModulo:
			return 7;
			break;
		case CPOperatorNeg:
		case CPOperatorFactorial:
			return 8;
			break;
		case CPOperatorPower:
			return 9;
			break;
		default:
			return 0;
			break;
	}
}

+ (BOOL) operatorAssociativity:(CPOperator)op
{
	switch (op) {
		case CPOperatorNull:
			return NO;
			break;
		case CPOperatorComma:
		case CPOperatorAND:
		case CPOperatorOR:
		case CPOperatorEqual:
		case CPOperatorNEqual:
		case CPOperatorLT:
		case CPOperatorLE:
		case CPOperatorGT:
		case CPOperatorGE:
		case CPOperatorPlus:
		case CPOperatorMinus:
		case CPOperatorNeg:
		case CPOperatorTimes:
		case CPOperatorDiv:
		case CPOperatorModulo:
		case CPOperatorPower:
			return YES; //left to right
		case CPOperatorFactorial:
		case CPOperatorAssign:
			return NO; //right to left
			break;
		default:
			return NO;
			break;
	}
}

+ (int) operatorArgumentCount:(CPOperator)op
{
	switch (op) {
		case CPOperatorNull:
		case CPOperatorComma:
			return 0;
			break;
		case CPOperatorFactorial:
		case CPOperatorNeg:
			return 1;
			break;
		case CPOperatorAND:
		case CPOperatorOR:
		case CPOperatorEqual:
		case CPOperatorNEqual:
		case CPOperatorLT:
		case CPOperatorLE:
		case CPOperatorGT:
		case CPOperatorGE:
		case CPOperatorPlus:
		case CPOperatorMinus:
		case CPOperatorTimes:
		case CPOperatorDiv:
		case CPOperatorModulo:
		case CPOperatorPower:
		case CPOperatorAssign:
			return 2;
			break;
		default:
			return 0;
			break;
	}
}

#pragma mark -
#pragma mark private

- (CPOperator) operatorForString:(NSString *)string
{
	if([string isEqualToString:@"+"])
		return CPOperatorPlus;
	else if([string isEqualToString:@"-"])
		return CPOperatorMinus;
	else if([string isEqualToString:@"*"])
		return CPOperatorTimes;
	else if([string isEqualToString:@"/"])
		return CPOperatorDiv;
	else if([string isEqualToString:@"%"])
		return CPOperatorModulo;
	else if([string isEqualToString:@"="])
		return CPOperatorAssign;
	else if([string isEqualToString:@"("])
		return CPOperatorLBrace;
	else if([string isEqualToString:@")"])
		return CPOperatorRBrace;
	else if([string isEqualToString:@";"])
		return CPOperatorSemicolon;
	else if([string isEqualToString:@","])
		return CPOperatorComma;
	else if([string isEqualToString:@"^"])
		return CPOperatorPower;
	else if([string isEqualToString:@"<"])
		return CPOperatorLT;
	else if([string isEqualToString:@"<="])
		return CPOperatorLE;
	else if([string isEqualToString:@">"])
		return CPOperatorGT;
	else if([string isEqualToString:@">="])
		return CPOperatorGE;
	else if([string isEqualToString:@"!="])
		return CPOperatorNEqual;
	else if([string isEqualToString:@"=="])
		return CPOperatorEqual;
	else if([string isEqualToString:@"!"])
		return CPOperatorFactorial;
	else if([string isEqualToString:@"&&"])
		return CPOperatorAND;
	else if([string isEqualToString:@"||"])
		return CPOperatorOR;
	else 
		return CPOperatorNull;
}

- (BOOL) isOperator:(NSString *)string
{
	//bad code ;D
	if([string isEqualToString:@"+"] || [string isEqualToString:@"-"] || [string isEqualToString:@"*"] ||
	   [string isEqualToString:@"/"] || [string isEqualToString:@"!"] || [string isEqualToString:@"^"] ||
	   [string isEqualToString:@"%"] || [string isEqualToString:@"="] || [string isEqualToString:@"<"] ||
	   [string isEqualToString:@">"] || [string isEqualToString:@"=="] || [string isEqualToString:@"<="] ||
	   [string isEqualToString:@">="] || [string isEqualToString:@"!="]|| [string isEqualToString:@"("]||
	   [string isEqualToString:@")"] || [string isEqualToString:@","] || [string isEqualToString:@"||"] ||
	   [string isEqualToString:@"&&"] || [string isEqualToString:@";"])
		return YES;
	return NO;
}

@end


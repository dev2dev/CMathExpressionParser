//
//  CParserConverter.m
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CParserConverter.h"

@interface CParserConverter ()
- (int) operatorArgumentCount:(NSString *)string;
- (int) operatorPrecedence:(NSString *)string;
- (BOOL) operatorAssociativity:(NSString *)string;
- (BOOL) isOperator:(NSString *)string;
@end

@implementation CParserConverter

#pragma mark -
#pragma mark Init / Dealloc

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self setOperatorSet:[NSCharacterSet characterSetWithCharactersInString:@"%+-*/^!<>=&|(),;"]];
		[self setFunctionSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890@"]];
		[self setVariableSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890@"]];
		[self setMacroSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_1234567890#@"]];
		[self setBlockSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
		
		[self setMacroIdentifier:'#'];
		[self setFunctionArgumentSeperator:','];//not used
	}
	return self;
}

- (void) dealloc
{
	[operatorSet release];
	[functionSet release];
	[variableSet release];
	[macroSet release];
	[blockSet release];
	
	[super dealloc];
}

+ (CParserConverter *) converter
{
	return [[[CParserConverter alloc] init] autorelease];
}

#pragma mark -
#pragma mark Convert

- (void) moveFrom: (CParserStack *) stack upToOperator: (NSString *) op to: (NSMutableArray *) output  
{
	CParserToken * temp = [stack pop];
	
	while (!([temp type] == CParserTokenOperator && [[temp operatorValue] isEqualToString: op])) {
		[output addObject:temp];
		temp = [stack pop];
	}
	
}

- (NSArray *) convertExpressionFromInfixStringToPostfixArray:(NSString *)expression
{	
	CParserStack * stack = [CParserStack stack];
	NSMutableArray * output = [NSMutableArray array];
	
	NSScanner * scanner = [NSScanner scannerWithString:expression];
	
	int bracketOpen = 0;
	int bracketClose = 0;
	
	//scan
	while (![scanner isAtEnd]) {
		
		//number
		double numberValue;
		if ([scanner scanDouble:&numberValue]) {
			[output addObject:[CParserToken tokenWithNumber:numberValue]];
		}
		
		//variable
		NSString * variableValue;
		if ([scanner scanCharactersFromSet:variableSet intoString:&variableValue]) {
			unichar firstCharacter = [variableValue characterAtIndex:0];
			
			if (firstCharacter >= 'A' && firstCharacter <= 'Z') {
				[output addObject:[CParserToken tokenWithVariable:variableValue]];
			} else {
				[scanner setScanLocation:[scanner scanLocation]-[variableValue length]];
			}
		}
		
		//function
		NSString * functionValue;
		if ([scanner scanCharactersFromSet:functionSet intoString:&functionValue]) {
			unichar firstCharacter = [functionValue characterAtIndex:0];
			
			if (firstCharacter >= 'a' && firstCharacter <= 'z') {
				[stack push:[CParserToken tokenWithFunction:functionValue]];
			} else {
				[scanner setScanLocation:[scanner scanLocation]-[functionValue length]];
			}
		}
		
		//macro
		NSString * macroValue;
		if ([scanner scanCharactersFromSet:macroSet intoString:&macroValue]) {
			unichar firstCharacter = [macroValue characterAtIndex:0];
			
			if (firstCharacter == macroIdentifier && [macroValue length] > 1) {
				[stack push:[CParserToken tokenWithMacro:macroValue]];
			} else {
				[scanner setScanLocation:[scanner scanLocation]-[macroValue length]];
			}
		}
		
		//operator
		NSString * operatorValue;
		if ([scanner scanCharactersFromSet:operatorSet intoString:&operatorValue]) {

			int operatorLength = [operatorValue length];
			NSString * operator = [operatorValue substringWithRange:NSMakeRange(0, operatorLength)];
			
			if ([operator length] > 1) {
				while (![self isOperator:operator]) {
					operatorLength--;
					operator = [operatorValue substringWithRange:NSMakeRange(0, operatorLength)];
				}
				[scanner setScanLocation:[scanner scanLocation]-([operatorValue length] - [operator length])];
			}
			
			if (![operator isEqualToString:@"("] && ![operator isEqualToString:@")"] && ![operator isEqualToString:@","] && ![operator isEqualToString:@";"]) {
				if ([stack position] == 0) {
					[stack push:[CParserToken tokenWithOperator:operator]];
				} else {
					while ([stack position] > 0) {
						if (([self operatorAssociativity:operator] && [self operatorPrecedence:operator] <= [self operatorPrecedence:[[stack lastToken] operatorValue]]) ||
							(![self operatorAssociativity:operator] && [self operatorPrecedence:operator] < [self operatorPrecedence:[[stack lastToken] operatorValue]])) {
							
							NSString * temp = [[stack pop] operatorValue];
							[output addObject:[CParserToken tokenWithOperator:temp]];
						} else {
							break;
						}
					}
						
					[stack push:[CParserToken tokenWithOperator:operator]];
				}
			} else {
				if ([operator isEqualToString:@","]) {
					if (bracketOpen <= bracketClose) {
						NSException *exception = [NSException exceptionWithName:@"SyntaxError"
																		 reason:@"( missing" 
																	   userInfo:nil];
						@throw exception;
					}
						
					[self moveFrom: stack upToOperator: @"(" to: output];

						
					if ([stack position] != 0) {
						CParserToken * token = [stack pop];
							
						if ([token type] == CParserTokenFunction || [token type] == CParserTokenMacro) { //3 = function token 5 = macro token
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
						
					[stack push:[CParserToken tokenWithOperator:@"("]];
				}
				if ([operator isEqualToString:@";"]) {

					NSString * temp = [[stack pop] operatorValue];
					
					if ([stack position] == 0) {
						[output addObject:[CParserToken tokenWithOperator:temp]];
					}
					
					while (!([stack position] == 0 || [temp isEqualToString:@";"])) {
						[output addObject:[CParserToken tokenWithOperator:temp]];
						temp = [[stack pop] operatorValue];
					}
					
				}
				if ([operator isEqualToString:@"("]) {
					bracketOpen++;
					[stack push:[CParserToken tokenWithOperator:operator]];
				}
				if ([operator isEqualToString:@")"]) {
					bracketClose++;
					if (bracketOpen < bracketClose) {
						NSException *exception = [NSException exceptionWithName:@"SyntaxError"
																		 reason:@"( missing" 
																	   userInfo:nil];
						@throw exception;
					}
					
					[self moveFrom: stack upToOperator: @"(" to: output];
						
					if ([stack position] != 0) {
						CParserToken * token = [stack pop];
							
						if ([token type] == CParserTokenFunction || [token type] == CParserTokenMacro) { //3 = function token || macro token
							[output addObject:token];
						} else {
							[stack push:token];
						}
					}
				}
			}
		}
	}
	
	if (bracketOpen != bracketClose) {
		NSLog(@"() errro");
	}
	
	while ([stack position] != 0) {
		[output addObject:[stack pop]];
	}
	
	return output;	
}

#pragma mark -
#pragma mark Seter / Geter

@synthesize operatorSet;
@synthesize functionSet;
@synthesize macroSet;
@synthesize variableSet;
@synthesize blockSet;

@synthesize macroIdentifier;
@synthesize functionArgumentSeperator;

#pragma mark -
#pragma mark Private

- (int) operatorPrecedence:(NSString *)string
{
	if ([string isEqualToString:@"="])
		return 0;
	if ([string isEqualToString:@"||"])
		return 1;
	if ([string isEqualToString:@"&&"])
		return 2;
	if ([string isEqualToString:@"=="] || [string isEqualToString:@"!="])
		return 3;
	if ([string isEqualToString:@"<"] || [string isEqualToString:@">"] ||
		[string isEqualToString:@"<="] || [string isEqualToString:@">="])
		return 4;
	if ([string isEqualToString:@"+"] || [string isEqualToString:@"-"])
		return 5;
	if ([string isEqualToString:@"*"] || [string isEqualToString:@"/"] || [string isEqualToString:@"%"])
		return 6;
	if ([string isEqualToString:@"^"])
		return 7;
	if ([string isEqualToString:@"!"])
		return 8;
	return 0;
}

- (BOOL) operatorAssociativity:(NSString *)string
{
	if([string isEqualToString:@"+"] || [string isEqualToString:@"-"] || [string isEqualToString:@"*"] ||
	   [string isEqualToString:@"/"] || [string isEqualToString:@"%"] || [string isEqualToString:@"^"])
		return YES; //left
	if ([string isEqualToString:@"="] || [string isEqualToString:@"!"])
		return NO; //right
	return YES;
}

- (int) operatorArgumentCount:(NSString *)string
{
	if([string isEqualToString:@"+"] || [string isEqualToString:@"-"] || [string isEqualToString:@"*"] ||
	   [string isEqualToString:@"/"] || [string isEqualToString:@"^"] || [string isEqualToString:@"%"] ||
	   [string isEqualToString:@"="] || [string isEqualToString:@"<"] || [string isEqualToString:@">"] ||
	   [string isEqualToString:@"=="] || [string isEqualToString:@"<="] || [string isEqualToString:@">="] ||
	   [string isEqualToString:@"!="]|| [string isEqualToString:@"&&"]|| [string isEqualToString:@"||"])
		return 2;
	if ([string isEqualToString:@"!"])
		return 1;
	return 0;
}

- (BOOL) isOperator:(NSString *)string
{
	if([string isEqualToString:@"+"] || [string isEqualToString:@"-"] || [string isEqualToString:@"*"] ||
	   [string isEqualToString:@"/"] || [string isEqualToString:@"!"] || [string isEqualToString:@"^"] ||
	   [string isEqualToString:@"%"] || [string isEqualToString:@"="] || [string isEqualToString:@"<"] ||
	   [string isEqualToString:@">"] || [string isEqualToString:@"=="] || [string isEqualToString:@"<="] ||
	   [string isEqualToString:@">="] || [string isEqualToString:@"!="]|| [string isEqualToString:@"("]||
	   [string isEqualToString:@")"] || [string isEqualToString:@","] || [string isEqualToString:@"||"] ||
	   [string isEqualToString:@"&&"])
		return YES;
	return NO;
}

@end


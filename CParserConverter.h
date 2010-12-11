//
//  CParserConverter.h
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#if (TARGET_IPHONE_SIMULATOR) || (TARGET_OS_IPHONE) || (TARGET_IPHONE)
#import <Foundation/Foundation.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import "CParserStack.h"
#import "CParserToken.h"


@interface CParserConverter : NSObject {
	
	NSCharacterSet * operatorSet; // operator set must contain BRACKETS (()) & FUNCTION_ARGUMENT_SEPERATOR (,) (line end character ; is supportet by the converter)
	NSCharacterSet * functionSet;
	NSCharacterSet * variableSet;
	NSCharacterSet * macroSet;
	NSCharacterSet * blockSet;
	
	unichar macroIdentifier;
	unichar functionArgumentSeperator;
}

+ (CParserConverter *) converter;

//- (NSString *) convertExpressionFromInfixStringToPostfixString:(NSString *)expression;
- (NSArray *) convertExpressionFromInfixStringToPostfixArray:(NSString *)expression;

- (void) setOperatorSet:(NSCharacterSet *)set;
- (void) setFunctionSet:(NSCharacterSet *)set;
- (void) setVariableSet:(NSCharacterSet *)set;
- (void) setMacroSet:(NSCharacterSet *)set;
- (void) setBlockSet:(NSCharacterSet *)set;

- (void) setMacroIdentifier:(unichar)character;
- (unichar) macroIdentifier;

- (void) setFunctionArgumentSeperator:(unichar)comma;

//private
- (int) operatorArgumentCount:(NSString *)string;
- (int) operatorPrecedence:(NSString *)string;
- (BOOL) operatorAssociativity:(NSString *)string;
- (BOOL) isOperator:(NSString *)string;

@end

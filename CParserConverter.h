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


@property (readwrite, copy, nonatomic) NSCharacterSet *operatorSet;
@property (readwrite, copy, nonatomic) NSCharacterSet *functionSet;
@property (readwrite, copy, nonatomic) NSCharacterSet *variableSet;
@property (readwrite, copy, nonatomic) NSCharacterSet *macroSet;
@property (readwrite, copy, nonatomic) NSCharacterSet *blockSet;

@property (readwrite, assign, nonatomic) unichar macroIdentifier;
@property (readwrite, assign, nonatomic) unichar functionArgumentSeperator;


//private
- (int) operatorArgumentCount:(NSString *)string;
- (int) operatorPrecedence:(NSString *)string;
- (BOOL) operatorAssociativity:(NSString *)string;
- (BOOL) isOperator:(NSString *)string;

@end

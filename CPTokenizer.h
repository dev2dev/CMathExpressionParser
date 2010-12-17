//
//  CPTokenizer.h
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 beanage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CPToken.h"

@interface CPTokenizer : NSObject {
	
	NSCharacterSet * identifierSet;
}

+ (CPTokenizer *) tokenizer;

- (NSArray *) convertExpressionFromInfixStringToPostfixArray:(NSString *)expression;

- (void) setIdentifierSet:(NSCharacterSet *)set;

+ (int) operatorArgumentCount:(CPOperator)op;
+ (int) operatorPrecedence:(CPOperator)op;
+ (BOOL) operatorAssociativity:(CPOperator)op;

//private
- (CPOperator) operatorForString:(NSString *)string;
- (BOOL) isOperator:(NSString *)string;

@end

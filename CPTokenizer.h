//
//  CPTokenizer.h
//  CMathParser
//
//  Created by Johannes Wolf on 16.09.10.
//  Copyright 2010 beanage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CPToken.h"

extern NSString * const CPSyntaxErrorException;

@interface CPTokenizer : NSObject {
	
	NSCharacterSet * identifierSet;
	
	BOOL operatorScanned;
}

+ (CPTokenizer *) tokenizer;

- (NSArray *) convertExpressionFromInfixStringToPostfixArray:(NSString *)expression;

- (void) setIdentifierSet:(NSCharacterSet *)set;

@end

//
//  CParserEvaluator.h
//  CMathParser
//
//  Created by Johannes Wolf on 20.09.10.
//  Copyright 2010 beanage. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CPToken.h"
#import "CPStack.h"

@class CPVariable;
@class CPFunction;

@interface CPEvaluator : NSObject {

	NSMutableDictionary * variableDictionary;
	NSMutableDictionary * functionDictionary;
	NSMutableDictionary * macroDictionary;
	
}

+ (CPEvaluator *) evaluator;

- (double) evaluatePostfixArray:(NSArray *)array;

- (void) setVariableDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *) variableDictionary;
- (void) setFunctionDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *) functionDictionary;
- (void) setMacroDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *) macroDictionary;

/*
- (void) setVariable:(CParserVariable *)variable forKey:(NSString *)key;
- (CParserVariable *) variableForKey:(NSString *)key;

- (void) setFunction:(CParserFunction *)func forKey:(NSString *)key;
- (CParserFunction *) functionForKey:(NSString *)key;
*/

@end
